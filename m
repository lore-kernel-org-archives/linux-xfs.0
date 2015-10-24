Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 38F197F52
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 08:58:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E65EC8F804B
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 06:58:08 -0700 (PDT)
Received: from mail-lf0-f50.google.com (mail-lf0-f50.google.com
	[209.85.215.50]) by cuda.sgi.com with ESMTP id V1ikz80lHPfI0w6z
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 24 Oct 2015 06:58:06 -0700 (PDT)
Received: by lfaz124 with SMTP id z124so109146295lfa.1
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 06:58:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20151024125659.GA8095@bfoster.bfoster>
References: <CAHc6FU5gS4BA+iTRHo1oHJMVHkLs4aa0eYd5T1ftLC9biRaxrg@mail.gmail.com>
	<20151024125659.GA8095@bfoster.bfoster>
Date: Sat, 24 Oct 2015 15:58:04 +0200
Message-ID: <CAHc6FU6eVn=KpKvhD2N8hvAgdFQVdBHHS9tUgaVQJf5wnipY=g@mail.gmail.com>
Subject: Re: Inconsistencies with trusted.SGI_ACL_{FILE,DEFAULT}
From: Andreas Gruenbacher <agruenba@redhat.com>
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
Cc: xfs@oss.sgi.com

On Sat, Oct 24, 2015 at 2:57 PM, Brian Foster <bfoster@redhat.com> wrote:
> On Fri, Oct 23, 2015 at 03:52:54PM +0200, Andreas Gruenbacher wrote:
>> Hello,
>>
>> The usual way of manipulating a file's POSIX ACL is through the
>> system.posix_acl_{access,default} xattrs. Setting
>> system.posix_acl_access also sets the permission bits in the file
>> mode. The acls are cached in inode->i_acl and inode->i_default_acl.
>>
>> On XFS, POSIX ACLs are also exposed as trusted.SGI_ACL_{FILE,DEFAULT}
>> xattrs in a different value format. However, setting these xattrs does
>> not update inode->i_{,default_}acl, and setting trusted.SGI_ACL_FILE
>> does not update the file mode; things can get out of sync:
>>
>
> It looks like the posix_acl_* values are virtual xattrs on XFS. They get
> translated to the SGI_ACL_* names before the acl code calls down into
> the xattr code. The result is cached into the inode via set_cached_acl()
> before the call returns.

The posix_acl_* attributes are handled by the vfs
posix_acl_*_xattr_handler handlers which talk to the filesystem using
the get_acl and set_acl inode operations. We would need such handlers
for SGI_ACL_*, installed before xfs_xattr_trusted_handler in
xfs_xattr_handlers.

> The xattr code doesn't know anything about this so I suspect this is the
> reason for the inconsistency. A direct xattr update just updates the
> data on-disk and has no knowledge of the ACLs cached to the inode, the
> latter of which is probably what is returned after the setxattr.
>
>>   $ touch f
>>   $ setfacl -m u:agruenba:rw f
>>   $ ls -l f
>>   -rw-rw-r--+ 1 root root 0 Oct 23 15:04 f
>>   $ getfattr -m- -d f
>>   # file: f
>>   security.selinux="unconfined_u:object_r:user_tmp_t:s0"
>>   system.posix_acl_access=0sAgAAAAEABgD/////AgAGAOgDAAAEAAQA/////xAABgD/////IAAEAP////8=
>>   trusted.SGI_ACL_FILE=0sAAAABQAAAAH/////AAYAAAAAAAIAAAPoAAYAAAAAAAT/////AAQAAAAAABD/////AAYAAAAAACD/////AAQAAA==
>>
>>   $ chmod 0 f
>>   $ setfattr -n trusted.SGI_ACL_FILE -v
>> 0sAAAABQAAAAH/////AAYAAAAAAAIAAAPoAAYAAAAAAAT/////AAQAAAAAABD/////AAYAAAAAACD/////AAQAAA==
>> f
>>   $ ls -l f
>>   ----------+ 1 root root 0 Oct 23 15:04 /var/tmp/f
>>   $ getfacl f
>>   # file: f
>>   # owner: root
>>   # group: root
>>   user::---
>>   user:agruenba:rw-        #effective:---
>>   group::r--            #effective:---
>>   mask::---
>>   other::---
>>   $ getfattr -m- -d f
>>   # file: f
>>   security.selinux="unconfined_u:object_r:user_tmp_t:s0"
>>   system.posix_acl_access=0sAgAAAAEAAAD/////AgAGAOgDAAAEAAQA/////xAAAAD/////IAAAAP////8=
>>   trusted.SGI_ACL_FILE=0sAAAABQAAAAH/////AAYAAAAAAAIAAAPoAAYAAAAAAAT/////AAQAAAAAABD/////AAYAAAAAACD/////AAQAAA==
>>
>> Here, the file mode and the reported value of system.posix_acl_access
>> are both wrong; trusted.SGI_ACL_FILE corresponds to what's stored on
>> disk.
>>
>> Access to trusted.* attributes is limited to users capable of
>> CAP_SYS_ADMIN so ordinary users cannot cause this kind of damage, but
>> this still deserves fixing.
>>
>
> Not sure there's a real use case for this, but it looks like we could
> invalidate the cached ACLs if those xattrs are modified directly via the
> xattr interface.

POSIX ACLs should not have been exposed twice in the first place, but
those SGI_ACL_* xattrs have been around for a very long time and we
cannot get rid of them now. It's likely that some applications will
back up some or all of an inode's xattrs and later restore them.

> Care to test the (compile tested only) hunk below?

That won't update the file mode when setting a SGI_ACL_* attribute.

> An alternative could be to just disallow setting these xattrs directly.

Probably not because that would cause applications to fail in
unexpected new ways.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
