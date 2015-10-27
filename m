Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 17C547F37
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 14:55:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9D53DAC003
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 12:55:08 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	GcXoWEA03Hpk1fHN for <xfs@oss.sgi.com>;
	Tue, 27 Oct 2015 12:55:04 -0700 (PDT)
Date: Wed, 28 Oct 2015 06:55:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] xfs: SGI ACLs: Map uid/gid namespaces
Message-ID: <20151027195502.GN8773@dastard>
References: <1445721369-25679-1-git-send-email-agruenba@redhat.com>
	<1445721369-25679-4-git-send-email-agruenba@redhat.com>
	<20151026214651.GJ8773@dastard>
	<CAHc6FU7YbdmH+S0HZUg1cL++NM4FXFot=GLBr1_6HPhJSP+dvA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHc6FU7YbdmH+S0HZUg1cL++NM4FXFot=GLBr1_6HPhJSP+dvA@mail.gmail.com>
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
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Tue, Oct 27, 2015 at 04:55:22PM +0100, Andreas Gruenbacher wrote:
> On Mon, Oct 26, 2015 at 10:46 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Sat, Oct 24, 2015 at 11:16:08PM +0200, Andreas Gruenbacher wrote:
> >> @@ -71,10 +72,10 @@ xfs_acl_from_disk(
> >>
> >>               switch (acl_e->e_tag) {
> >>               case ACL_USER:
> >> -                     acl_e->e_uid = xfs_uid_to_kuid(be32_to_cpu(ace->ae_id));
> >> +                     acl_e->e_uid = make_kuid(ns, be32_to_cpu(ace->ae_id));
> >
> > Please don't replace the xfs wrappers with the horribly named
> > generic functions. Pass the namespace to xfs_uid_to_kuid(), and
> > modify them, please. That way people who don't deal with namespaces
> > every day can tell exactly what format conversion is taking place
> > just by reading the code...
> 
> We would effectively end up with:
> 
>   #define xfs_kuid_to_uid from_kuid
>   #define xfs_kgid_to_gid from_kgid
>   #define xfs_uid_to_kuid make_kuid
>   #define xfs_gid_to_kgid make_kgid

No, you'd just add the namespace pointer to the static inline
functions we already have, and add a comment stating when the caller
should pass the init_ns vs user_ns.

But now that I've thought about this a bit more, I don't think that
the changes you've made are correct - we shouldn't be doing uid/gid
namespace conversion in disk formating functions. That is, the
conversion of user/group types should be done at the incoming layers
(i.e. at VFS/ioctl layers), not deep in the guts of the XFS code.

i.e. the disk formating functions should be passed uids/gids that
are already mapped to the init namespace, because there is no
guarantee that the formatting occurs in the same user context as the
syscall (e.g. low level disk formatting work gets deferred to a work
queue).

> Are you sure you really want that?

Why do you think we added the wrappers in the first place? It was
because the ns maintainer refused to follow standard, self
documenting type conversion naming conventions of <type>_to_<type>
so we added them ourselves. The user namespace code is horrible
enough without adding confusing type change functions everywhere...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
