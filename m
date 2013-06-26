Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6B41D7F58
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 16:30:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 562BE304043
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 14:30:30 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id gqRG3mFo2Apk5CFo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Jun 2013 14:30:28 -0700 (PDT)
Date: Wed, 26 Jun 2013 17:30:17 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: Re: [PATCH v2 RFC] userns: Convert xfs to use kuid/kgid where
	appropriate
Message-ID: <20130626173017.5100327a@oracle.com>
In-Reply-To: <20130626020924.GD29376@dastard>
References: <20130619110948.0bfafa2b@oracle.com>
	<20130620001341.GM29338@dastard>
	<20130620095410.1917d235@oracle.com>
	<20130620220311.GT29376@dastard>
	<20130621111420.5592707e@oracle.com>
	<20130624003316.GH29376@dastard>
	<20130624091035.6274800f@oracle.com>
	<20130626020924.GD29376@dastard>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, "Eric W. Biederman" <ebiederm@gmail.com>, xfs@oss.sgi.com

On Wed, 26 Jun 2013 12:09:24 +1000
Dave Chinner <david@fromorbit.com> wrote:

> On Mon, Jun 24, 2013 at 09:10:35AM -0400, Dwight Engen wrote:
> > Hi Dave, all. Here is a v2 patch that I believe addresses the
> > previous comments, but I expect there to be more :) I think there
> > are a few more issues to sort out before this is ready, and I want
> > to add some tests to xfstests also.
> > 
> > I added permission checks for eofblocks in the ioctl code, but
> > I don't think they are enough. Just because an unprivileged
> > caller is in a group doesn't mean he can write to a file of that
> > group, and I don't know how we can check for that till we get the
> > inode in hand. Brian, if you or anyone else could comment on how
> > this should work for the regular user and write() ENOSPC cases
> > that'd be great.
> > 
> > The xfs code now uses inode->i_uid where possible instead of di_uid.
> > The remaining uses of di_uid are where the inode is being setup,
> > conversion to/from disk endianess, in dealing with quotas, and
> > bulkstat.
> 
> Hi Dwight,
> 
> I haven't looked at the code in detail, I'll just mention that I
> agree with Brain that we need to split this up into more patches.
> The conversions are subtle and easy to misunderstand, so small
> patches are good.  I'd say at minimum separate patches are needed
> for:
> 
> 	- permissions check on eof blocks
> 	- splitting eof blocks structure (I made comments on that to
> 	  Brain's posted patch)
> 	- introduce XFS conversion helpers
> 	- implement VFS-XFS boundary conversion using helpers
> 	- XFS ioctl conversions (maybe multiple patches)
> 	- final patch to modify kconfig once everything is done

Sure, I'll split it up and integrate the comments from the other
(eof blocks) thread as well.
 
> > We do need to decide on the di_uid that comes back from bulkstat.
> > Right now it is returning on disk (== init_user_ns) uids. It looks
> > to me like xfsrestore is using the normal vfs routines (chown,
> > fchown, lchown) when restoring so that won't line up if the
> > xfsrestore is run in !init_user_ns.
> 
> Right. This is a major problem because there's no guarantee that you
> are running restore in the same namespace as dump was run in. If you
> take the dump in the init_user_ns, then you can't restore it from
> inside the namespace container, and vice versa.

Yep. In thinking just a bit about this, assuming we did convert the
ids that came back from bulkstat, how is this much different than today
where you take a backup on one machine and try to restore it on
another? It seems like today the onus is on the user to ensure the uids
will align correctly. AFAICS tar --numeric-owner would have the same
issue, and it looks like man xfsrestore is getting at a similar
thing in the Quotas section.

> > We could possibly convert to userns values
> > before returning them from the kernel, but I doubt that will work
> > well with the xfs quotas.
> 
> Well, quotas are already converted to/from userns specific values
> before they get to XFS. Including project quotas, which I think at
> this point is wrong. We have no test cases for it, though, so I
> can't validate that it actually works as it is supposed to and that
> we don't break it inadvertantly in the future.
> 
> [ I'm still waiting on Eric to provide any information or scripts
> for how he tested this all worked when he did the conversions.... ]
> 
> > Should we just require that callers of bulkstat
> > be in init_user_ns? Thoughts?
> 
> This is one of the reasons why I want Eric to give us some idea of
> how this is supposed to work - exactly how is backup and restore
> supposed to be managed on a shared filesystem that is segmented up
> into multiple namespace containers? We can talk about the
> implementation all we like, but none of us have a clue to the policy
> decisions that users will make that we need to support. Until we
> have a clear idea on what policies we are supposed to be supporting,
> the implementation will be ambiguous and compromised.
> 
> e.g. If users are responsible for it, then bulkstat needs to filter
> based on the current namespace. If management is responsible (i.e.
> init_user_ns does backup/restore of ns-specific subtrees), then
> bulkstat cannot filter and needs to reject calls from outside the
> init_user_ns().

Maybe we can have bulkstat always filter based on if the caller
kuid_has_mapping(current_user_ns(), inode->i_uid)? That way a caller
from init_user_ns can see them all, but callers from inside a userns
will get a subset of inodes returned?

This doesn't solve the save from one uesrns, restore from a different
one use case, not sure if that was the scenario you were getting at. To
allow for this use case I guess we could have an "id offset" argument
for xfsrestore that gets applied before chown() but that seems icky.

> But if we have to allow both configurations - which I think we have to
> because both cases are valid choices for a hosting provider to give
> users - then how are we supposed to implement/handle this?
> 
> The same goes for the file handle interfaces - it's perfectly valid
> for a user to run a userspace NFS server (e.g. ganesha) inside a
> namespace container, but that will allow that process to provide
> unchecked remote access to the entire underlying filesystem, not
> just the namespace being exported. i.e. fs/export.c needs to be made
> namespace aware in some way so that there is a kernel wide policy
> for handle to file translations in namespace containers....

I haven't looked at the handle stuff, I'll take a look and get
familiarized.

> ---
> 
> FWIW, one comment on the wrappers now that I've quickly browsed the
> code:
> 
> > @@ -68,14 +68,15 @@ xfs_acl_from_disk(
> >  
> >  		switch (acl_e->e_tag) {
> >  		case ACL_USER:
> > +			acl_e->e_uid =
> > xfs_kuid_from_disk(be32_to_cpu(ace->ae_id));
> > +			break;
> >  		case ACL_GROUP:
> > -			acl_e->e_id = be32_to_cpu(ace->ae_id);
> > +			acl_e->e_gid =
> > xfs_kgid_from_disk(be32_to_cpu(ace->ae_id));
> 
> I know I suggested it, but I have to say, that does look a little
> weird. Normally the to/from disk routines do endian conversion
> internally, so perhaps the conversion routines coul dbe better
> named.
> 
> These:
> 
> 	acl_e->e_uid = xfs_uid_to_kuid(be32_to_cpu(ace->ae_id));
> 	acl_e->e_gid = xfs_gid_to_kgid(be32_to_cpu(ace->ae_id));
> 
> I think read a whole lot better, and the endian conversion now makes
> sense as that's converting the on-disk value first...
> 
> > @@ -101,7 +102,18 @@ xfs_acl_to_disk(struct xfs_acl *aclp, const
> > struct posix_acl *acl) acl_e = &acl->a_entries[i];
> >  
> >  		ace->ae_tag = cpu_to_be32(acl_e->e_tag);
> > -		ace->ae_id = cpu_to_be32(acl_e->e_id);
> > +		switch(acl_e->e_tag) {
> > +		case ACL_USER:
> > +			ace->ae_id =
> > cpu_to_be32(xfs_kuid_to_disk(acl_e->e_uid));
> > +			break;
> > +		case ACL_GROUP:
> > +			ace->ae_id =
> > cpu_to_be32(xfs_kgid_to_disk(acl_e->e_gid));
> 
> and:
> 			ace->ae_id =
> cpu_to_be32(xfs_kuid_to_uid(acl_e->e_uid)); ace->ae_id =
> cpu_to_be32(xfs_kgid_to_gid(acl_e->e_uid));
> 
> Sorry for asking you to redo this - sometimes an idea I have doesn't
> quite work out the first time :/

Heh, no problem, I agree these names are even better. Makes me wonder
if the return type of xfs_k[ug]id_to_[ug]id should be [ug]id_t instead
of __uint32_t? I'll use these new names in a split out v3 series to
follow. Thanks.

> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
