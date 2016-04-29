Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1CAE07CA1
	for <xfs@oss.sgi.com>; Fri, 29 Apr 2016 00:36:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C7DBA8F8035
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2016 22:36:15 -0700 (PDT)
Received: from neil.brown.name (neil.brown.name [103.29.64.221]) by
	cuda.sgi.com with ESMTP id teWCxJ4T1sjtxIA7 (version=TLSv1.2
	cipher=DHE-RSA-AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 28 Apr 2016 22:36:12 -0700 (PDT)
From: NeilBrown <mr@neil.brown.name>
Date: Fri, 29 Apr 2016 15:35:42 +1000
Subject: Re: [PATCH 0/2] scop GFP_NOFS api
In-Reply-To: <1461671772-1269-1-git-send-email-mhocko@kernel.org>
References: <1461671772-1269-1-git-send-email-mhocko@kernel.org>
Message-ID: <8737q5ugcx.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6446930236698820219=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-ntfs-dev@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, logfs@logfs.org, cluster-devel@redhat.com, Chris Mason <clm@fb.com>, linux-mtd@lists.infradead.org, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com, ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-afs@lists.infradead.org

--===============6446930236698820219==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain

On Tue, Apr 26 2016, Michal Hocko wrote:

> Hi,
> we have discussed this topic at LSF/MM this year. There was a general
> interest in the scope GFP_NOFS allocation context among some FS
> developers. For those who are not aware of the discussion or the issue
> I am trying to sort out (or at least start in that direction) please
> have a look at patch 1 which adds memalloc_nofs_{save,restore} api
> which basically copies what we have for the scope GFP_NOIO allocation
> context. I haven't converted any of the FS myself because that is way
> beyond my area of expertise but I would be happy to help with further
> changes on the MM front as well as in some more generic code paths.
>
> Dave had an idea on how to further improve the reclaim context to be
> less all-or-nothing wrt. GFP_NOFS. In short he was suggesting an opaque
> and FS specific cookie set in the FS allocation context and consumed
> by the FS reclaim context to allow doing some provably save actions
> that would be skipped due to GFP_NOFS normally.  I like this idea and
> I believe we can go that direction regardless of the approach taken here.
> Many filesystems simply need to cleanup their NOFS usage first before
> diving into a more complex changes.>

This strikes me as over-engineering to work around an unnecessarily
burdensome interface.... but without details it is hard to be certain.

Exactly what things happen in "FS reclaim context" which may, or may
not, be safe depending on the specific FS allocation context?  Do they
need to happen at all?

My research suggests that for most filesystems the only thing that
happens in reclaim context that is at all troublesome is the final
'evict()' on an inode.  This needs to flush out dirty pages and sync the
inode to storage.  Some time ago we moved most dirty-page writeout out
of the reclaim context and into kswapd.  I think this was an excellent
advance in simplicity.
If we could similarly move evict() into kswapd (and I believe we can)
then most file systems would do nothing in reclaim context that
interferes with allocation context.

The exceptions include:
 - nfs and any filesystem using fscache can block for up to 1 second
   in ->releasepage().  They used to block waiting for some IO, but that
   caused deadlocks and wasn't really needed.  I left the timeout because
   it seemed likely that some throttling would help.  I suspect that a
   careful analysis will show that there is sufficient throttling
   elsewhere.

 - xfs_qm_shrink_scan is nearly unique among shrinkers in that it waits
   for IO so it can free some quotainfo things.  If it could be changed
   to just schedule the IO without waiting for it then I think this
   would be safe to be called in any FS allocation context.  It already
   uses a 'trylock' in xfs_dqlock_nowait() to avoid deadlocking
   if the lock is held.

I think you/we would end up with a much simpler system if instead of
focussing on the places where GFP_NOFS is used, we focus on places where
__GFP_FS is tested, and try to remove them.  If we get rid of enough of
them the remainder could just use __GFP_IO.

> The patch 2 is a debugging aid which warns about explicit allocation
> requests from the scope context. This is should help to reduce the
> direct usage of the NOFS flags to bare minimum in favor of the scope
> API. It is not aimed to be merged upstream. I would hope Andrew took it
> into mmotm tree to give it linux-next exposure and allow developers to
> do further cleanups.  There is a new kernel command line parameter which
> has to be used for the debugging to be enabled.
>
> I think the GFP_NOIO should be seeing the same clean up.

I think you are suggesting that use of GFP_NOIO should (largely) be
deprecated in favour of memalloc_noio_save().  I think I agree.
Could we go a step further and deprecate GFP_ATOMIC in favour of some
in_atomic() test?  Maybe that is going too far.

Thanks,
NeilBrown

>
> Any feedback is highly appreciated.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXIvKuAAoJEDnsnt1WYoG5yYcQALVBjDFPD7k40UTzmu/EpZtF
q5uzTpP8A/Uhy4k8kJnHF9JhXwHlKXxKiFSTavyZqxE8LjmJwZOyB3hdg5boVQ1C
43ZKUpSd2i8BwIBZ1Ld37W9UEtT1owibqaY9KyOxetBk8wsZQoXks7XLQ+i8SMp1
lGQJwbykXBPfLzlBTV02QstA++bpwdFqFyxL9DTtYF8e9BbhC3iwFS2t/dwj17Uo
3WNu8OaXzYvf71uYTs2khlrKx3PQvKuUBLG30XGy1Lk/SF+lYlGtnrT0+wyWpSlR
gzU7KXJjF1Mw7snb/JncOARDJJvHC3IUaaJy9GG8cLBY6j9sPAnoAGeKEtEXeSUC
B2CUXkPS3n1Ejr0r5WhrLl8jO5oMIV6vZ/kDRFhEQt/gj0H5Zv0heQtp/DkgtFox
mvBUH7cf2sqb9gabXGcm+5M9/yyqU1NzNR+8f+QCm2PrX9kzYKNExYc7Yx23KpWc
BzT6Nzf62/nkhDHOzD50MMFFf5jWS0jWDS4uHx4KiG1JvKjRL6MW5GG1qNxQ+D8a
kuzPKy/mMh7uppGOV4gxCdOQ04zyWfabzzcU5jM9WJeaXeZoDb6mOTJ6NSueUTBf
nd3LnYoXc9LVTr4q9C4IerVNsjU2ZNTE/Nw2Sb+RLqEEBh5QpOITGYITS0aPK9fT
AHBilQxky11eQicGLpS3
=gouN
-----END PGP SIGNATURE-----
--=-=-=--


--===============6446930236698820219==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6446930236698820219==--
