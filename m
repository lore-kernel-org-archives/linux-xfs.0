Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A35077F37
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 16:10:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 464A5AC003
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 14:10:31 -0700 (PDT)
Received: from mail-lb0-f179.google.com (mail-lb0-f179.google.com
	[209.85.217.179]) by cuda.sgi.com with ESMTP id
	jJxoJFZiWYBN601Q (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 27 Oct 2015 14:10:28 -0700 (PDT)
Received: by lbbes7 with SMTP id es7so73390761lbb.2
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 14:10:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20151027195502.GN8773@dastard>
References: <1445721369-25679-1-git-send-email-agruenba@redhat.com>
	<1445721369-25679-4-git-send-email-agruenba@redhat.com>
	<20151026214651.GJ8773@dastard>
	<CAHc6FU7YbdmH+S0HZUg1cL++NM4FXFot=GLBr1_6HPhJSP+dvA@mail.gmail.com>
	<20151027195502.GN8773@dastard>
Date: Tue, 27 Oct 2015 22:10:26 +0100
Message-ID: <CAHc6FU4+z_1EqJHHpv7yPgO_s6k2gpcmq_zBofYyudAtK-bFyg@mail.gmail.com>
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

On Tue, Oct 27, 2015 at 8:55 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Oct 27, 2015 at 04:55:22PM +0100, Andreas Gruenbacher wrote:
>> On Mon, Oct 26, 2015 at 10:46 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Sat, Oct 24, 2015 at 11:16:08PM +0200, Andreas Gruenbacher wrote:
>> >> @@ -71,10 +72,10 @@ xfs_acl_from_disk(
>> >>
>> >>               switch (acl_e->e_tag) {
>> >>               case ACL_USER:
>> >> -                     acl_e->e_uid = xfs_uid_to_kuid(be32_to_cpu(ace->ae_id));
>> >> +                     acl_e->e_uid = make_kuid(ns, be32_to_cpu(ace->ae_id));
>> >
>> > Please don't replace the xfs wrappers with the horribly named
>> > generic functions. Pass the namespace to xfs_uid_to_kuid(), and
>> > modify them, please. That way people who don't deal with namespaces
>> > every day can tell exactly what format conversion is taking place
>> > just by reading the code...
>>
>> We would effectively end up with:
>>
>>   #define xfs_kuid_to_uid from_kuid
>>   #define xfs_kgid_to_gid from_kgid
>>   #define xfs_uid_to_kuid make_kuid
>>   #define xfs_gid_to_kgid make_kgid
>
> No, you'd just add the namespace pointer to the static inline
> functions we already have, and add a comment stating when the caller
> should pass the init_ns vs user_ns.

Yep, same result though.

> But now that I've thought about this a bit more, I don't think that
> the changes you've made are correct - we shouldn't be doing uid/gid
> namespace conversion in disk formating functions. That is, the
> conversion of user/group types should be done at the incoming layers
> (i.e. at VFS/ioctl layers), not deep in the guts of the XFS code.

There are two kinds of code paths where we need to convert between the
SGI_ACL and the kernel's in-memory representation (struct posix_acl
*): one is in the get_acl and set_acl iops, converting to/from the
actual on-disk attrbutes, and the actual IDs stay the same. The other
is in the get and set SGI_ACL xattr handlers which are invoked from
the getxattr and setxattr iops. The conversion there is to/from the
user-facing SGI_ACL xattrs, and ID mappings may be in effect.

The VFS doesn't know anything about the SGI_ACL attributes, so XFS
will have to do the ID mappings itself. We could convert the IDS
in-place in separate pre- / post-passes over the xattr value and leave
xfs_acl_from_disk and xfs_acl_to_disk alone. That's what the VFS does
for POSIX ACLs. The problem there is that the setxattr iop and set
xattr handler give us a const void * value; we cannot modify it
without casting const away. Hence the additional namespace parameter
to xfs_acl_from_disk and xfs_acl_to_disk instead.

Only converting the IDs in place without going through the get_acl and
set_acl iops would not work very well because then the i_acl,
i_default_acl, and the permissions in i_mode wouldn't be updated
appropriately.

> i.e. the disk formating functions should be passed uids/gids that
> are already mapped to the init namespace, because there is no
> guarantee that the formatting occurs in the same user context as the
> syscall (e.g. low level disk formatting work gets deferred to a work
> queue).

There very well is a guarantee that the getxattr and setxattr
operations and thus the get and set xattr handler ops occur in the
appropriate context. The actual on-disk format conversions happen to
and from init_user_ns and they are effectively type casts.

>> Are you sure you really want that?
>
> Why do you think we added the wrappers in the first place? It was
> because the ns maintainer refused to follow standard, self
> documenting type conversion naming conventions of <type>_to_<type>
> so we added them ourselves. The user namespace code is horrible
> enough without adding confusing type change functions everywhere...

Well, so far these functions were at least hiding the &init_user_ns
part, they didn't just introduce XFS specific names for generic
things. It would be sad if every subsystem introduced their own names
when they don't like the generic ones.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
