Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f65.google.com ([209.85.161.65]:35301 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728233AbeK3BNO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Nov 2018 20:13:14 -0500
MIME-Version: 1.0
References: <1540858969-75803-1-git-send-email-bo.liu@linux.alibaba.com>
 <20181127114249.GH16301@quack2.suse.cz> <20181128201122.r4sec265cnlxgj2x@US-160370MP2.local>
 <20181129085238.GD31087@quack2.suse.cz> <20181129120253.GR6311@dastard> <20181129130002.GM31087@quack2.suse.cz>
In-Reply-To: <20181129130002.GM31087@quack2.suse.cz>
From: Zhengping Zhou <johnzzpcrystal@gmail.com>
Date: Thu, 29 Nov 2018 22:07:44 +0800
Message-ID: <CALXdtC7R=J3EdBgUeY5QzTEcPwUVvWdiDprMnV-aO3BZX-3rdg@mail.gmail.com>
Subject: Re: [PATCH RFC] Ext4: fix deadlock on dirty pages between fault and writeback
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: jack@suse.cz
Cc: david@fromorbit.com, bo.liu@linux.alibaba.com, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

in kenrel 4.20-rc1 , function shrink_page_list=EF=BC=9A

1227         if (PageWriteback(page)) {
1228             /* Case 1 above */
1229             if (current_is_kswapd() &&
1230                 PageReclaim(page) &&
1231                 test_bit(PGDAT_WRITEBACK, &pgdat->flags)) {
1232                 nr_immediate++;
1233                 goto activate_locked;
1234
1235             /* Case 2 above */
1236             } else if (sane_reclaim(sc) ||
1237                 !PageReclaim(page) || !may_enter_fs) {
1238                 /*
1239                  * This is slightly racy - end_page_writeback()
1240                  * might have just cleared PageReclaim, then
1241                  * setting PageReclaim here end up interpreted
1242                  * as PageReadahead - but that does not matter
1243                  * enough to care.  What we do want is for this
1244                  * page to have PageReclaim set next time memcg
1245                  * reclaim reaches the tests above, so it will
1246                  * then wait_on_page_writeback() to avoid OOM;
1247                  * and it's also appropriate in global reclaim.
1248                  */
1249                 SetPageReclaim(page);
1250                 nr_writeback++;
1251                 goto activate_locked;
1252
1253             /* Case 3 above */
1254             } else {
1255                 unlock_page(page);
1256                 wait_on_page_writeback(page);
1257                 /* then go back and try same page again */
1258                 list_add_tail(&page->lru, page_list);
1259                 continue;
1260             }
1261         }


What's your kernel version ? Seems we won't  wait_page_writeback with
holding page lock in latest kernel version.


Jan Kara <jack@suse.cz> =E4=BA=8E2018=E5=B9=B411=E6=9C=8829=E6=97=A5=E5=91=
=A8=E5=9B=9B =E4=B8=8B=E5=8D=889:01=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu 29-11-18 23:02:53, Dave Chinner wrote:
> > On Thu, Nov 29, 2018 at 09:52:38AM +0100, Jan Kara wrote:
> > > On Wed 28-11-18 12:11:23, Liu Bo wrote:
> > > > On Tue, Nov 27, 2018 at 12:42:49PM +0100, Jan Kara wrote:
> > > > > CCed fsdevel since this may be interesting to other filesystem de=
velopers
> > > > > as well.
> > > > >
> > > > > On Tue 30-10-18 08:22:49, Liu Bo wrote:
> > > > > > mpage_prepare_extent_to_map() tries to build up a large bio to =
stuff down
> > > > > > the pipe.  But if it needs to wait for a page lock, it needs to=
 make sure
> > > > > > and send down any pending writes so we don't deadlock with anyo=
ne who has
> > > > > > the page lock and is waiting for writeback of things inside the=
 bio.
> > > > >
> > > > > Thanks for report! I agree the current code has a deadlock possib=
ility you
> > > > > describe. But I think the problem reaches a bit further than what=
 your
> > > > > patch fixes.  The problem is with pages that are unlocked but hav=
e
> > > > > PageWriteback set.  Page reclaim may end up waiting for these pag=
es and
> > > > > thus any memory allocation with __GFP_FS set can block on these. =
So in our
> > > > > current setting page writeback must not block on anything that ca=
n be held
> > > > > while doing memory allocation with __GFP_FS set. Page lock is jus=
t one of
> > > > > these possibilities, wait_on_page_writeback() in
> > > > > mpage_prepare_extent_to_map() is another suspect and there mat be=
 more. Or
> > > > > to say it differently, if there's lock A and GFP_KERNEL allocatio=
n can
> > > > > happen under lock A, then A cannot be taken by the writeback path=
. This is
> > > > > actually pretty subtle deadlock possibility and our current lockd=
ep
> > > > > instrumentation isn't going to catch this.
> > > > >
> > > >
> > > > Thanks for the nice summary, it's true that a lock A held in both
> > > > writeback path and memory reclaim can end up with deadlock.
> > > >
> > > > Fortunately, by far there're only deadlock reports of page's lock b=
it
> > > > and writeback bit in both ext4 and btrfs[1].  I think
> > > > wait_on_page_writeback() would be OK as it's been protected by page
> > > > lock.
> > > >
> > > > [1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux=
.git/commit/?id=3D01d658f2ca3c85c1ffb20b306e30d16197000ce7
> > >
> > > Yes, but that may just mean that the other deadlocks are just harder =
to
> > > hit...
> > >
> > > > > So I see two ways how to fix this properly:
> > > > >
> > > > > 1) Change ext4 code to always submit the bio once we have a full =
page
> > > > > prepared for writing. This may be relatively simple but has a hig=
her CPU
> > > > > overhead for bio allocation & freeing (actual IO won't really dif=
fer since
> > > > > the plugging code should take care of merging the submitted bios)=
. XFS
> > > > > seems to be doing this.
> > > >
> > > > Seems that that's the safest way to do it, but as you said there's
> > > > some tradeoff.
> > > >
> > > > (Just took a look at xfs's writepages, xfs also did the page
> > > > collection if there're adjacent pages in xfs_add_to_ioend(), and si=
nce
> > > > xfs_vm_writepages() is using the generic helper write_cache_pages()
> > > > which calls lock_page() as well, it's still possible to run into th=
e
> > > > above kind of deadlock.)
> > >
> > > Originally I thought XFS doesn't have this problem but now when I loo=
k
> > > again, you are right that their ioend may accumulate more pages to wr=
ite
> > > and so they are prone to the same deadlock ext4 is. Added XFS list to=
 CC.
> >
> > I don't think XFS has a problem here, because the deadlock is
> > dependent on holding a lock that writeback might take and then doing
> > a GFP_KERNEL allocation. I don't think we do that anywhere in XFS -
> > the only lock that is of concern here is the ip->i_ilock, and I
> > think we always do GFP_NOFS allocations inside that lock.
> >
> > As it is, this sort of lock vs reclaim inversion should be caught by
> > lockdep - allocations and reclaim contexts are recorded by lockdep
> > we get reports if we do lock A - alloc and then do reclaim - lock A.
> > We've always had problems with false positives from lockdep for
> > these situations where common XFS code can be called from GFP_KERNEL
> > valid contexts as well as reclaim or GFP_NOFS-only contexts, but I
> > don't recall ever seeing such a report for the writeback path....
>
> I think for A =3D=3D page lock, XFS may have the problem (and lockdep won=
't
> notice because it does not track page locks). There are some parts of
> kernel which do GFP_KERNEL allocations under page lock - pte_alloc_one() =
is
> one such function which allocates page tables with GFP_KERNEL and gets
> called with the faulted page locked. And I believe there are others.
>
> So direct reclaim from pte_alloc_one() can wait for writeback on page B
> while holding lock on page A. And if B is just prepared (added to bio,
> under writeback, unlocked) but not submitted in xfs_writepages() and we
> block on lock_page(A), we have a deadlock.
>
> Generally deadlocks like these will be invisible to lockdep because it do=
es
> not track either PageWriteback or PageLocked as a dependency.
>
> > > > > 2) Change the code to unlock the page only when we submit the bio=
.
> >
> > > > This sounds doable but not good IMO, the concern is that page locks
> > > > can be held for too long, or if we do 2), submitting one bio per pa=
ge
> > > > in 1) is also needed.
> > >
> > > Hum, you're right that page lock hold times may increase noticeably a=
nd
> > > that's not very good. Ideally we'd need a way to submit whatever we h=
ave
> > > prepared when we are going to sleep but there's no easy way to do tha=
t.
> >
> > XFS unlocks the page after it has been added to the bio and marked
> > as under writeback, not when the bio is submitted. i.e.
> >
> > writepage w/ locked page dirty
> > lock ilock
> > <mapping, allocation>
> > unlock ilock
> > bio_add_page
> > clear_page_dirty_for_io
> > set_page_writeback
> > unlock_page
> > .....
> > <gather more dirty pages into bio>
> > .....
> > <bio is full or discontiguous page to be written>
> > submit_bio()
>
> Yes, ext4 works the same way. But thanks for confirmation.
>
> > If we switch away which holding a partially built bio, the only page
> > we have locked is the one we are currently trying to add to the bio.
> > Lock ordering prevents deadlocks on that one page, and all other
> > pages in the bio being built are marked as under writeback and are
> > not locked. Hence anything that wants to modify a page held in the
> > bio will block waiting for page writeback to clear, not the page
> > lock.
>
> Yes, and the blocking on writeback of such page in direct reclaim is
> exactly one link in the deadlock chain...
>
>                                                                 Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
