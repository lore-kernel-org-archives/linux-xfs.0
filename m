Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 41F237F54
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 10:23:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 312F7304053
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 08:22:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jY7oSj6Ung9BDrLk (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 24 Oct 2015 08:22:57 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 9D9ABC0BEABC
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 15:22:56 +0000 (UTC)
Date: Sat, 24 Oct 2015 11:22:55 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Inconsistencies with trusted.SGI_ACL_{FILE,DEFAULT}
Message-ID: <20151024152254.GA22232@bfoster.bfoster>
References: <CAHc6FU5gS4BA+iTRHo1oHJMVHkLs4aa0eYd5T1ftLC9biRaxrg@mail.gmail.com>
	<20151024125659.GA8095@bfoster.bfoster>
	<CAHc6FU6eVn=KpKvhD2N8hvAgdFQVdBHHS9tUgaVQJf5wnipY=g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHc6FU6eVn=KpKvhD2N8hvAgdFQVdBHHS9tUgaVQJf5wnipY=g@mail.gmail.com>
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
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: xfs@oss.sgi.com

On Sat, Oct 24, 2015 at 03:58:04PM +0200, Andreas Gruenbacher wrote:
> On Sat, Oct 24, 2015 at 2:57 PM, Brian Foster <bfoster@redhat.com> wrote:
> > On Fri, Oct 23, 2015 at 03:52:54PM +0200, Andreas Gruenbacher wrote:
> >> Hello,
> >>
> >> The usual way of manipulating a file's POSIX ACL is through the
> >> system.posix_acl_{access,default} xattrs. Setting
> >> system.posix_acl_access also sets the permission bits in the file
> >> mode. The acls are cached in inode->i_acl and inode->i_default_acl.
> >>
> >> On XFS, POSIX ACLs are also exposed as trusted.SGI_ACL_{FILE,DEFAULT}
> >> xattrs in a different value format. However, setting these xattrs does
> >> not update inode->i_{,default_}acl, and setting trusted.SGI_ACL_FILE
> >> does not update the file mode; things can get out of sync:
> >>
> >
> > It looks like the posix_acl_* values are virtual xattrs on XFS. They get
> > translated to the SGI_ACL_* names before the acl code calls down into
> > the xattr code. The result is cached into the inode via set_cached_acl()
> > before the call returns.
> 
> The posix_acl_* attributes are handled by the vfs
> posix_acl_*_xattr_handler handlers which talk to the filesystem using
> the get_acl and set_acl inode operations. We would need such handlers
> for SGI_ACL_*, installed before xfs_xattr_trusted_handler in
> xfs_xattr_handlers.
> 

Yes, but the translation all occurs on the XFS side. I'm not following
the last bit... are you suggesting a special xattr handler that uses
"trusted.SGI_FILE" as a prefix? I'm not sure that matters either way so
long as those xattrs are trapped appropriately, but feel free to send a
patch. :)

> > The xattr code doesn't know anything about this so I suspect this is the
> > reason for the inconsistency. A direct xattr update just updates the
> > data on-disk and has no knowledge of the ACLs cached to the inode, the
> > latter of which is probably what is returned after the setxattr.
> >
> >>   $ touch f
> >>   $ setfacl -m u:agruenba:rw f
> >>   $ ls -l f
> >>   -rw-rw-r--+ 1 root root 0 Oct 23 15:04 f
> >>   $ getfattr -m- -d f
> >>   # file: f
> >>   security.selinux="unconfined_u:object_r:user_tmp_t:s0"
> >>   system.posix_acl_access=0sAgAAAAEABgD/////AgAGAOgDAAAEAAQA/////xAABgD/////IAAEAP////8=
> >>   trusted.SGI_ACL_FILE=0sAAAABQAAAAH/////AAYAAAAAAAIAAAPoAAYAAAAAAAT/////AAQAAAAAABD/////AAYAAAAAACD/////AAQAAA==
> >>
> >>   $ chmod 0 f
> >>   $ setfattr -n trusted.SGI_ACL_FILE -v
> >> 0sAAAABQAAAAH/////AAYAAAAAAAIAAAPoAAYAAAAAAAT/////AAQAAAAAABD/////AAYAAAAAACD/////AAQAAA==
> >> f
> >>   $ ls -l f
> >>   ----------+ 1 root root 0 Oct 23 15:04 /var/tmp/f
> >>   $ getfacl f
> >>   # file: f
> >>   # owner: root
> >>   # group: root
> >>   user::---
> >>   user:agruenba:rw-        #effective:---
> >>   group::r--            #effective:---
> >>   mask::---
> >>   other::---
> >>   $ getfattr -m- -d f
> >>   # file: f
> >>   security.selinux="unconfined_u:object_r:user_tmp_t:s0"
> >>   system.posix_acl_access=0sAgAAAAEAAAD/////AgAGAOgDAAAEAAQA/////xAAAAD/////IAAAAP////8=
> >>   trusted.SGI_ACL_FILE=0sAAAABQAAAAH/////AAYAAAAAAAIAAAPoAAYAAAAAAAT/////AAQAAAAAABD/////AAYAAAAAACD/////AAQAAA==
> >>
> >> Here, the file mode and the reported value of system.posix_acl_access
> >> are both wrong; trusted.SGI_ACL_FILE corresponds to what's stored on
> >> disk.
> >>
> >> Access to trusted.* attributes is limited to users capable of
> >> CAP_SYS_ADMIN so ordinary users cannot cause this kind of damage, but
> >> this still deserves fixing.
> >>
> >
> > Not sure there's a real use case for this, but it looks like we could
> > invalidate the cached ACLs if those xattrs are modified directly via the
> > xattr interface.
> 
> POSIX ACLs should not have been exposed twice in the first place, but
> those SGI_ACL_* xattrs have been around for a very long time and we
> cannot get rid of them now. It's likely that some applications will
> back up some or all of an inode's xattrs and later restore them.
> 

I wasn't suggesting to get rid of them.

> > Care to test the (compile tested only) hunk below?
> 
> That won't update the file mode when setting a SGI_ACL_* attribute.
> 

Hmm, perhaps this is not sufficient if the mode has to be updated as
well. I suppose we could try to do that as well in this path, but that
implies verification of the data (already in on-disk format) as well.
There's nothing stopping somebody from doing 'setattr -n
trusted.SGI_FILE_ACCESS -v 0 <file>,' after all. The previous patch
wasn't really intended to address that.

> > An alternative could be to just disallow setting these xattrs directly.
> 
> Probably not because that would cause applications to fail in
> unexpected new ways.
> 

I suppose a backup/restore application might want to set these, but I'm
not aware of any other sane usage given they're in a filesystem specific
format at this point. We'd probably have to take a look at xfsdump, see
how it handles this, then see if there's a clean way to run through
necessary acl bits if we're called via setxattr().

Brian

> Thanks,
> Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
