Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D9C5C7F37
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 18:38:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CADAC304053
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 16:38:05 -0700 (PDT)
Received: from mail-lf0-f52.google.com (mail-lf0-f52.google.com
	[209.85.215.52]) by cuda.sgi.com with ESMTP id UGbXLGA2xBvgC12W
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 Oct 2015 16:38:03 -0700 (PDT)
Received: by lfaz124 with SMTP id z124so180391902lfa.1
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 16:38:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20151027223724.GM19199@dastard>
References: <1445721369-25679-1-git-send-email-agruenba@redhat.com>
	<1445721369-25679-4-git-send-email-agruenba@redhat.com>
	<20151026214651.GJ8773@dastard>
	<CAHc6FU7YbdmH+S0HZUg1cL++NM4FXFot=GLBr1_6HPhJSP+dvA@mail.gmail.com>
	<20151027195502.GN8773@dastard>
	<CAHc6FU4+z_1EqJHHpv7yPgO_s6k2gpcmq_zBofYyudAtK-bFyg@mail.gmail.com>
	<20151027223724.GM19199@dastard>
Date: Wed, 28 Oct 2015 00:38:01 +0100
Message-ID: <CAHc6FU53uCqG26_2T5UyKsmQ6C45OnE99Mzs0_auntV2_O=uYQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] xfs: SGI ACLs: Map uid/gid namespaces
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
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Tue, Oct 27, 2015 at 11:37 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Oct 27, 2015 at 10:10:26PM +0100, Andreas Gruenbacher wrote:
>> On Tue, Oct 27, 2015 at 8:55 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Tue, Oct 27, 2015 at 04:55:22PM +0100, Andreas Gruenbacher wrote:
>> > But now that I've thought about this a bit more, I don't think that
>> > the changes you've made are correct - we shouldn't be doing uid/gid
>> > namespace conversion in disk formating functions. That is, the
>> > conversion of user/group types should be done at the incoming layers
>> > (i.e. at VFS/ioctl layers), not deep in the guts of the XFS code.
>>
>> There are two kinds of code paths where we need to convert between the
>> SGI_ACL and the kernel's in-memory representation (struct posix_acl
>> *): one is in the get_acl and set_acl iops, converting to/from the
>> actual on-disk attrbutes, and the actual IDs stay the same. The other
>> is in the get and set SGI_ACL xattr handlers which are invoked from
>> the getxattr and setxattr iops. The conversion there is to/from the
>> user-facing SGI_ACL xattrs, and ID mappings may be in effect.
>
> And then we have the ioctls XFS_IOC_ATTRLIST_BY_HANDLE and
> XFS_IOC_ATTRMULTI_BY_HANDLE which can directly access the ACL xattrs
> without even going through the the getxattr and setxattr iops. They
> go direct to xfs_attr_get/xfs_attr_set() and set/return the xattrs
> with *exactly* what the caller/on-disk xattr provides.
>
> IOWs, you've only addressed one possible vector for direct access to
> the SGI_ACL xattrs....

Ah, I've missed those ioctls.

>> The VFS doesn't know anything about the SGI_ACL attributes, so XFS
>> will have to do the ID mappings itself. We could convert the IDS
>> in-place in separate pre- / post-passes over the xattr value and leave
>> xfs_acl_from_disk and xfs_acl_to_disk alone. That's what the VFS does
>> for POSIX ACLs. The problem there is that the setxattr iop and set
>> xattr handler give us a const void * value; we cannot modify it
>> without casting const away. Hence the additional namespace parameter
>> to xfs_acl_from_disk and xfs_acl_to_disk instead.
>
> Yes, I read your patches - you take a low level disk formating
> function and make it also work as a high level conversion function
> through a different interface that has no higher level conversion
> interface. i.e. you're changing the user visible behaviour of
> writing a specific xattr.
>
> But I think it's also wrong: users are not supposed to manipulate
> SGI_ACL_FILE/SGI_ACL_DEFAULT xattrs directly.  Just because root can
> see them doesn't mean users should be touching them - users should
> be using the kernel posix ACL interface/namespace to modify their
> ACLs.
>
> OTOH, xfsdump/restore require direct, unfiltered access to set
> uid/gid/mode/xattrs exactly as they are found.

Huh?

First, do we even agree that setting the SGI_ACL attributes, through
whatever interface, must not leave inode->i_acl or inode->i_default
stale?

Second, the system.posix_acl_access and trusted.SGI_ACL_FILE
attributes both contain the Access ACL, which by definition also
contains the file mode permission bits. When any of those two
attributes is set, what sense would it make to not also set the file
mode permission bits --- and to allow them to become inconsistent with
the Acess ACL? Certainly none in the xfsdump/restore case because in
the dump, the mode and Access ACL will agree, anyway.

> Changing that behaviour like your change does will break xfsdump/restore

I would be most surprised.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
