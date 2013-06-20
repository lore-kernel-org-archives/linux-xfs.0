Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B42807F37
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 12:39:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 529C8AC003
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 10:39:05 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 2JylotAxmbmI64uf (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 20 Jun 2013 10:38:58 -0700 (PDT)
Date: Thu, 20 Jun 2013 13:39:03 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: Re: [PATCH] userns: Convert xfs to use kuid/kgid where appropriate
Message-ID: <20130620133903.5193d3ee@oracle.com>
In-Reply-To: <51C31F48.9070503@redhat.com>
References: <20130619110948.0bfafa2b@oracle.com>
	<20130620001341.GM29338@dastard>
	<20130620095410.1917d235@oracle.com> <51C31F48.9070503@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@gmail.com>, xfs@oss.sgi.com

On Thu, 20 Jun 2013 11:27:04 -0400
Brian Foster <bfoster@redhat.com> wrote:

> On 06/20/2013 09:54 AM, Dwight Engen wrote:
> > On Thu, 20 Jun 2013 10:13:41 +1000
> > Dave Chinner <david@fromorbit.com> wrote:
> > 
> >> On Wed, Jun 19, 2013 at 11:09:48AM -0400, Dwight Engen wrote:
> >>> Use uint32 from init_user_ns for xfs internal uid/gid
> >>> representation in acl, xfs_icdinode. Conversion of kuid/gid is
> >>> done at the vfs boundary, other user visible xfs specific
> >>> interfaces (bulkstat, eofblocks filter) expect uint32
> >>> init_user_ns uid/gid values.
> >>
> >> It's minimal, but I'm not sure it's complete. I'll comment on that
> >> in response to Eric's comments...
> >>
> >>> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> >> ....
> >>> --- a/fs/xfs/xfs_fs.h
> >>> +++ b/fs/xfs/xfs_fs.h
> >>> @@ -347,8 +347,8 @@ typedef struct xfs_error_injection {
> >>>  struct xfs_eofblocks {
> >>>  	__u32		eof_version;
> >>>  	__u32		eof_flags;
> >>> -	uid_t		eof_uid;
> >>> -	gid_t		eof_gid;
> >>> +	__u32		eof_uid;
> >>> +	__u32		eof_gid;
> >>>  	prid_t		eof_prid;
> >>>  	__u32		pad32;
> >>>  	__u64		eof_min_file_size;
> >>
> >> The patch doesn't do namespace conversion of these uid/gids, but
> >> I'm not sure it should...
> > 
> > The ids are only advisory, if the caller doesn't specify
> > XFS_EOF_FLAGS_?ID blocks from any inode in the fs can be reclaimed
> > regardless of id. Because of this, I think at a minimum we should
> > change XFS_IOC_FREE_EOFBLOCKS to require capable(CAP_SYS_ADMIN),
> > which somewhat implies init_user_ns based ids.
> > 
> > To make this really userns aware, I think we could:
> >   - leave the fields as uid_t
> >   - make XFS_IOC_FREE_EOFBLOCKS require nsown_capable(CAP_SYS_ADMIN)
> >   - check kuid_has_mapping(current_user_ns()) for each
> >     inode. This would be a change in behavior when called
> >     from !init_user_ns, limiting the scope of inodes the ioctl could
> >     affect.
> >   - change xfs_inode_match_id() to use uid_eq(VFS_I(ip)->i_uid,
> >     make_kuid(current_user_ns(), eofb->eof_uid))
> > 
> > Does that sound reasonable?
> > 
> 
> Hi Dwight,
> 
> If I understand correctly, the proposition is to turn
> XFS_EOF_FREE_EOFBLOCKS into administrator only functionality and run
> ns conversions on the inode uid/gid and associated eofb values for
> the ID filtering functionality.

Hi Brian, yeah that was the proposal :) I think there are really two
issues here. One is that the uid_t/gid_t may come from a userns so we
should be aware of that. Currently the ids passed in are used for
*filtering* so a malicious user can't do anything more than they
already can by not passing ids at all, but we should fix this so only
the intended files are affected. Second is that currently the ioctl
allows an unprivileged user to affect another user (as Eric pointed
out):

> I am little dubious about XFS_IOC_FREE_EOFBLOCKS allowing any
> user to affect any other user.  Your changes just seem to make
> it guaranteed that when called from a user namespace the wrong
> user will be affected.

I don't think the nsown_capability() I proposed is enough to take care
of this. Do you agree that if the caller is going to affect other
users, they should be CAP_SYS_ADMIN (or maybe CAP_FOWNER) in
init_user_ns?

> The latter sounds reasonable to me, though I'm not so sure about the
> CAP_SYS_ADMIN bit. For example, I think we'd expect a regular user to
> be able to run an eofblocks scan against files covered under his
> quota.
>
> Perhaps the right thing to do here is to restrict global (and project
> quota?) scans to CAP_SYS_ADMIN and uid/gid based scans to processes
> with the appropriate permissions (i.e., CAP_SYS_ADMIN, matching
> uid/gid or CAP_FOWNER). Thoughts?

That sounds good to me. Maybe for a regular user the appropriate
permission check (at the top of xfs_inode_free_eofblocks()) could be
something like:

	if (!capable(CAP_SYS_ADMIN) &&
	    !uid_eq(VFS_I(ip)->i_uid, current_fsuid()) &&
	    !in_group_p(VFS_I(ip)->i_gid))
		return 0;

This has the drawback that the caller won't know if they supplied a
uid/gid in eofblocks that won't actually get cleared, so maybe we
want to validate a uid/gid in eofblocks after its copy_from_user()ed
in instead? Also, I'm not sure if this is the same as "under his quota"
and how it plays with project quotas.

> Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
