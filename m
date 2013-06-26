Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B0A547F5E
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 17:44:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2F695AC004
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 15:44:15 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	oxa3Hl7snykejNhP for <xfs@oss.sgi.com>;
	Wed, 26 Jun 2013 15:44:12 -0700 (PDT)
Date: Thu, 27 Jun 2013 08:44:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 RFC] userns: Convert xfs to use kuid/kgid where
	appropriate
Message-ID: <20130626224410.GB28426@dastard>
References: <20130619110948.0bfafa2b@oracle.com>
	<20130620001341.GM29338@dastard>
	<20130620095410.1917d235@oracle.com>
	<20130620220311.GT29376@dastard>
	<20130621111420.5592707e@oracle.com>
	<20130624003316.GH29376@dastard>
	<20130624091035.6274800f@oracle.com>
	<20130626020924.GD29376@dastard>
	<20130626173017.5100327a@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130626173017.5100327a@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dwight Engen <dwight.engen@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, "Eric W. Biederman" <ebiederm@gmail.com>, xfs@oss.sgi.com

On Wed, Jun 26, 2013 at 05:30:17PM -0400, Dwight Engen wrote:
> On Wed, 26 Jun 2013 12:09:24 +1000
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Mon, Jun 24, 2013 at 09:10:35AM -0400, Dwight Engen wrote:
> > > Hi Dave, all. Here is a v2 patch that I believe addresses the
> > > previous comments, but I expect there to be more :) I think there
> > > are a few more issues to sort out before this is ready, and I want
> > > to add some tests to xfstests also.
> > > 
> > > I added permission checks for eofblocks in the ioctl code, but
> > > I don't think they are enough. Just because an unprivileged
> > > caller is in a group doesn't mean he can write to a file of that
> > > group, and I don't know how we can check for that till we get the
> > > inode in hand. Brian, if you or anyone else could comment on how
> > > this should work for the regular user and write() ENOSPC cases
> > > that'd be great.
> > > 
> > > The xfs code now uses inode->i_uid where possible instead of di_uid.
> > > The remaining uses of di_uid are where the inode is being setup,
> > > conversion to/from disk endianess, in dealing with quotas, and
> > > bulkstat.
> > 
> > Hi Dwight,
> > 
> > I haven't looked at the code in detail, I'll just mention that I
> > agree with Brain that we need to split this up into more patches.
> > The conversions are subtle and easy to misunderstand, so small
> > patches are good.  I'd say at minimum separate patches are needed
> > for:
> > 
> > 	- permissions check on eof blocks
> > 	- splitting eof blocks structure (I made comments on that to
> > 	  Brain's posted patch)
> > 	- introduce XFS conversion helpers
> > 	- implement VFS-XFS boundary conversion using helpers
> > 	- XFS ioctl conversions (maybe multiple patches)
> > 	- final patch to modify kconfig once everything is done
> 
> Sure, I'll split it up and integrate the comments from the other
> (eof blocks) thread as well.
>  
> > > We do need to decide on the di_uid that comes back from bulkstat.
> > > Right now it is returning on disk (== init_user_ns) uids. It looks
> > > to me like xfsrestore is using the normal vfs routines (chown,
> > > fchown, lchown) when restoring so that won't line up if the
> > > xfsrestore is run in !init_user_ns.
> > 
> > Right. This is a major problem because there's no guarantee that you
> > are running restore in the same namespace as dump was run in. If you
> > take the dump in the init_user_ns, then you can't restore it from
> > inside the namespace container, and vice versa.
> 
> Yep. In thinking just a bit about this, assuming we did convert the
> ids that came back from bulkstat, how is this much different than today
> where you take a backup on one machine and try to restore it on
> another?

Yes, it's similar, but subtly different. One machine to another is
dumping from one filesystem and restoring to another. They are
physically separate. Thi case is dump/restore from/to the *same*
filesystem, just with a different namespace filter in place...

> It seems like today the onus is on the user to ensure the uids
> will align correctly. AFAICS tar --numeric-owner would have the same
> issue, and it looks like man xfsrestore is getting at a similar
> thing in the Quotas section.

Right, but we are restoring to the same filesystem, just in a
different namespace....

Hence the question of *policy* here. It's completely undefined -
we've been given no guidance on how this stuff is supposed to
behave, and there is no documentation to refer to that tells us what
should happen. Until we have a definitive "it should behave like X"
statement from an expert (like Eric), we don't have a solid basis
for implementing one behaviour or the other (or allowing both). This
forms part of the user ABI, so I want to know we're doing the right
thing for the right reasons before fixing it in stone...

> > > Should we just require that callers of bulkstat
> > > be in init_user_ns? Thoughts?
> > 
> > This is one of the reasons why I want Eric to give us some idea of
> > how this is supposed to work - exactly how is backup and restore
> > supposed to be managed on a shared filesystem that is segmented up
> > into multiple namespace containers? We can talk about the
> > implementation all we like, but none of us have a clue to the policy
> > decisions that users will make that we need to support. Until we
> > have a clear idea on what policies we are supposed to be supporting,
> > the implementation will be ambiguous and compromised.
> > 
> > e.g. If users are responsible for it, then bulkstat needs to filter
> > based on the current namespace. If management is responsible (i.e.
> > init_user_ns does backup/restore of ns-specific subtrees), then
> > bulkstat cannot filter and needs to reject calls from outside the
> > init_user_ns().
> 
> Maybe we can have bulkstat always filter based on if the caller
> kuid_has_mapping(current_user_ns(), inode->i_uid)? That way a caller
> from init_user_ns can see them all, but callers from inside a userns
> will get a subset of inodes returned?

We could do that, though it means bulkstat is going to be a *lot
slower* when called from within a user namespace environment. A
namespace might only have a few thousand files for backup, yet the
underlying filesystem might have tens of millions of inodes in it.
The bulkstat call now has to walk all of the inodes just to find the
few thousand that match the filter. And multiply that by the number
of namespaces all doing backups at 3am in the morning and you start
to get an idea of the scope of the problem....


> This doesn't solve the save from one uesrns, restore from a different
> one use case, not sure if that was the scenario you were getting at. To
> allow for this use case I guess we could have an "id offset" argument
> for xfsrestore that gets applied before chown() but that seems icky.

And it means that xfsrestore has to be made aware of namespaces,
which is something I'd prefer not to have to do.

....

> > cpu_to_be32(xfs_kuid_to_uid(acl_e->e_uid)); ace->ae_id =
> > cpu_to_be32(xfs_kgid_to_gid(acl_e->e_uid));
> > 
> > Sorry for asking you to redo this - sometimes an idea I have doesn't
> > quite work out the first time :/
> 
> Heh, no problem, I agree these names are even better. Makes me wonder
> if the return type of xfs_k[ug]id_to_[ug]id should be [ug]id_t instead
> of __uint32_t? I'll use these new names in a split out v3 series to
> follow. Thanks.

The type in the struct xfs_icdinode is __uint32_t, so I think it
should match that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
