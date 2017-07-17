Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48364 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751300AbdGQOsV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Jul 2017 10:48:21 -0400
Date: Mon, 17 Jul 2017 10:48:16 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Parent pointers
Message-ID: <20170717144813.GA56739@bfoster.bfoster>
References: <59680165.9020201@oracle.com>
 <20170714085016.4j2yeyihezmb6nkp@eorzea.usersys.redhat.com>
 <817aafad-6b64-3700-6752-c63d7e5cdde7@sandeen.net>
 <59690307.9090407@oracle.com>
 <5d8fa5a7-110a-520f-9b13-b10627950bd3@sandeen.net>
 <20170714190740.GA43494@bfoster.bfoster>
 <20170714224658.GB4224@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170714224658.GB4224@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Allison Henderson <allison.henderson@oracle.com>, cmaiolino@redhat.com, linux-xfs@vger.kernel.org

On Fri, Jul 14, 2017 at 03:46:58PM -0700, Darrick J. Wong wrote:
> On Fri, Jul 14, 2017 at 03:07:41PM -0400, Brian Foster wrote:
> > On Fri, Jul 14, 2017 at 01:46:27PM -0500, Eric Sandeen wrote:
> > > On 07/14/2017 12:44 PM, Allison Henderson wrote:
> > > > On 7/14/2017 7:04 AM, Eric Sandeen wrote:
> > > >>
> > > >>
> > > >> On 07/14/2017 03:50 AM, Carlos Maiolino wrote:
> > > >>> Hi,
> > > >>>
> > > >>> On Thu, Jul 13, 2017 at 04:25:25PM -0700, Allison Henderson wrote:
> > > >>>> Hi all,
> > > >>>>
> > > >>>> I've been doing some digging on adding parent pointers to xfs and wanted to
> > > >>>> send a note to folks here to get peoples opinions on it.
> > > >>>
> > > >>> Are you talking about parent pointers in the BTrees?
> > > >>>
> > > >>
> > > >> No, see [RFC 00/17] RFC parent inode pointers. for example, from long
> > > >> ago.
> > > >>
> > > >> "Parent inode support allow XFS to quickly derive a file name and
> > > >> path from the mount point. This can aid in directory/path policies
> > > >> and can help relocate items during filesystem shrink."
> > > >>
> > > >> It has a long and ... difficult history.
> > > >>
> > > >> -Eric
> 
> Woot, time to dive in. :)
> 
> > > > Right, so to expand on Eric's answer, it looks like Dave and Brian
> > > > had been working on some improvements based on that set, but it's
> > > > not quite finished yet.  The idea is that we add an extended
> > > > attribute to keep track of the parents inode and generation, and
> 
> Well, a lot of attributes, in the case of multiply hardlinked files.
> One concern I have is that since a file can be hardlinked 2^32 times and
> path components have a maximum length of 255 bytes, we'll have to be
> careful about not overflowing di_anextents as a part of making a
> potentially huge attribute tree.
> 
> > > > also the child entries offset, and filename. So in this solution
> > > > the EA is name={parent inode #, parent inode generation, dirent
> > > > offset}, value={dirent filename}.
> 
> This (the disk format) is probably the most important part to get
> settled.  FWIW, I've recaptured three of the previous discussions of
> parent pointers -- Lachlan McIlroy's code dump in 2009[1], Mark
> Tinguely's 2013 attempt[2] and 2014 attempt[3] at discussing patches.
> For those of you following along at home, the gmane link mentioned in
> [3] is the link at [1].
> 
> [1] http://oss.sgi.com/archives/xfs/2009-01/msg01068.html
> [2] http://oss.sgi.com/archives/xfs/2013-04/msg00214.html
> [3] https://www.spinics.net/lists/xfs/msg25175.html
> 
> The latest round of parent pointer patches is (I think) in the form of
> an off-list patchset that Brian (and now Allison) are cleaning up for
> reposting, which hopefully happens soon because I feel rather ill at
> ease discussing off-list code that lacks S-o-b's.
> 
> Anyway, the current proposal is to create a new xattr namespace
> (ATTR_PARENT) and to fill it with (parent_ino, parent_gen,
> dirent_offset) => (dirent name) attributes:
> 
> struct xfs_parent_name_rec {
> 	__be64	p_ino;
> 	__be32	p_gen;
> 	__be32	p_diroffset;
> };
> 
> p_diroffset is really a directory datapointer, not a raw byte offset.
> 
> We also have an incore data structure of:
> 
> struct xfs_parent_name_irec {
> 	__uint64_t	p_ino;
> 	__uint32_t	p_gen;
> 	__uint32_t	p_diroffset;
> 	const char	*p_name;
> 	__uint32_t	p_namelen;
> };
> 
> I think p_ino ought to be xfs_ino_t and not uint64_t, and p_diroffset
> ought to be xfs_dir2_dataptr_t instead of uint32_t.
> 
> > > > My goal at the moment is just to get it compiling again and finish
> > > > out some of the sub routines that maintain it.  It looks like it
> > > > hasn't had much attention in a while, so I wanted to let people
> > > > know the direction I'm planning to move in before I get too far
> > > > in.
> 
> <nod>
> 
> > > If you're forward-porting that 17-patch set from Mark, I'd suggest
> > > first reading Dave's response to it - IIRC it amounted to a firm
> > > NAK.  it also highlights the complexity of this undertaking, and may
> > > explain why nobody has gotten it done (yet) :)
> > > 
> > 
> > The patches that came from me (to Allison) were last sent to me directly
> > from Dave. I know he had some objections to the original design, but my
> > understanding was that he had incorporated fixes for those issues in his
> > modifications to Mark's original series (such as the xattr format and
> 
> From what I can tell, he seems to have taken Mark's patches to pass dir
> offsets back from the dirent manipulation functions and then started
> writing a simple implementation of stuffing the attrs into the attr
> tree.
> 
> > whatnot), but the series wasn't completely done yet in terms of
> > supporting all possible directory operations. (It's probably a good idea
> > to review that old thread anyways just to confirm, unless Dave catches
> > this and is able to chime in one way or the other.)
> 
> (Or jump in the fray out once he's back from sabbatical.)
> 
> > I basically just forwarded ported Dave's patches to more recent kernels
> > and added a couple minor fixes as I had combed through the existing
> > code. I never really got to adding anything of substance before Allison
> > volunteered to take over the series.
> > 
> > FWIW, I think there was some mention of porting some of the operations
> > over to the deferred ops infrastructure, but it's not clear to me off
> > the top of my head how important (or appropriate) that is.
> 
> Most of the users of xfs_trans_roll seem to be buried in the xattr code.
> For example, _attr_set can end up rolling a transaction after converting
> an attr fork from short format to leaf format before retrying the attr
> add operation, but we don't use log redo items (er, defer_ops items) to
> make sure log recovery will restart the attr add operation if we crash
> before the final _trans_commit after calling _attr_{leaf,node}_addname.
> 
> In the case of a regular xattr set operation this wouldn't have been a
> big deal because the fsetxattr call wouldn't have returned, so all the
> user could possibly see is an inode with a perhaps unnecessarily large
> xattr fork.  Now that we need to set xattrs in the same transaction
> chain as a directory operation, it becomes very important that log
> recovery gain the ability to resume an xattr add operation no matter
> where the log stopped.  Creating a directory can become this longwinded
> pile of updates:
> 

Ok, thanks for the summary. So we have some transaction ordering down in
the xattr code that might no longer be sufficient to provide atomicity
in the context of parent pointers (via directory operations). I see that
the current patch series increases the transaction size to accommodate
parent pointers, but that doesn't help us deal with those situations
where the transaction is rolled into a new one.

> - Allocate directory block, map into data fork, chain rmap update, add
>   directory entry, chain pptr update;
> - Add rmap entry for new directory block (more chaining to fix
>   freelist), finish first rmap update;
> - Allocate xattr block for short->leaf conversion, map into attr fork,
>   chain rmap update; chain xattr add operation;
> - Add rmap entry for new xattr block (more chaining to fix freelist),
>   finish second rmap update;
> - Add xattr entry to file, finish xattr add operation;
> - Finish pptr update.
> 
> Basically, I think someone's going to have to go audit all the uses of
> xfs_trans_roll in the attr code to figure out which operations need redo
> items, and how to cram everything toegether into a single xfs_defer_ops,
> rather than sprinkling them around the attr code like we do now, because
> redo items cannot be deferred from one defer_ops to another.
> 

Indeed. I wonder whether we may have other options here as well, such as
a higher level reordering/refactoring or allocation of necessary blocks
in the directory code. I.e., I'm handwaving here, but perhaps following
a model similar to how inode chunks are allocated in a separate
transaction or directory operations are allowed in situations where an
allocation is not (to limit deferring to where it is only necessary, for
example). This would all be easier to reason about (IMO) with a
functionally complete RFC series, though.

Brian

> > It's something to keep in mind, in any event. IIRC there were also
> > missing Signed-off-by's required for some of Mark's original patches.
> 
> That's also a problem; unless someone can get Mark to supply them, we
> probably have to get someone to rewrite them.  At a bare minimum I think
> we explicitly have to pass back a xfs_dir2_dataptr_t, not a bare
> uint32_t.
> 
> > IMO, the best next step might be to just finish off the implementation
> > as-is such that we could have a fairly functional RFC to put on the
> > list and hash out whether there are in fact any remaining design
> > hurdles, but others might have a different opinion on that. :)
> 
> Agreed.
> 
> > Brian
> > 
> > > -Eric
> > >  
> > > > Allison
> > > >>
> > > >>>> I got in touch
> > > >>>> with Brian Foster not too long ago and he had some code partially done from
> > > >>>> about a year or so ago (looks like it has patches from Dave Chinner and Mark
> > > >>>> Tinguely as well).  So I am hoping to be able to use what we have so far to
> > > >>>> create something updated and finished out.  I am still pretty new to the xfs
> > > >>>> code, so at the moment I am still just going through old discussion threads,
> > > >>>> and reviewing the patches.  But for the most part I just wanted to see what
> > > >>>> people thought and get everyone on board with the idea.  Suggestions and
> > > >>>> feedback are much appreciated. Thank you!!
> > > >>>>
> > > >>>
> > > >>> It will be better if you can describe in more details if you have any specific
> > > >>> goal with this, and/or what kind of improvement you expect to have with it,
> > > >>> adding something new without a reason, is usually not well received.
> > > >>>
> > > >>> Cheers
> > > >>>
> > > >> -- 
> > > >> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > >> the body of a message to majordomo@vger.kernel.org
> > > >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > >>
> > > > -- 
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
