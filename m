Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AEA317F37
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 14:00:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3FED2AC002
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 12:00:49 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id A1WqIEHuFKF6Qi83 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 26 Oct 2015 12:00:48 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id B03368E362
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 19:00:47 +0000 (UTC)
Date: Mon, 26 Oct 2015 15:00:45 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/4] xfs: SGI ACLs: Fix caching and mode setting
Message-ID: <20151026190045.GE59738@bfoster.bfoster>
References: <1445721369-25679-1-git-send-email-agruenba@redhat.com>
	<1445721369-25679-3-git-send-email-agruenba@redhat.com>
	<20151026140202.GB59738@bfoster.bfoster>
	<CAHc6FU5a-20aTceoKKZNmk=v+WQt+xLtSGZPo4yXN7Uq9ZDWOA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHc6FU5a-20aTceoKKZNmk=v+WQt+xLtSGZPo4yXN7Uq9ZDWOA@mail.gmail.com>
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

On Mon, Oct 26, 2015 at 04:39:20PM +0100, Andreas Gruenbacher wrote:
> On Mon, Oct 26, 2015 at 3:02 PM, Brian Foster <bfoster@redhat.com> wrote:
> > Finally, another random thought... another way to approach this whole
> > thing might be just to redirect the SGI_FILE_* xattr calls to the
> > system.posix_acl_* calls.
> 
> You mean silently changing the binary format of those attributes?
> That's the worst thing we could possibly do.
> 

It would change an implicit error/failure to an explicit one.
Regardless, I realized this particular approach is kind of pointless
anyways (as noted in my other mail).

Note that I'm not necessarily against what we're doing here, it might
very well be required. I'm just trying to step back and understand the
big picture before we go and put a band-aid on the immediate problem and
call it solved. To me, the ideal overall situation is that this
attribute is hidden and anybody that cares about ACLs can get/set them
through the appropriate ACL interface (the system.posix_acl_* xattrs).
The question is whether we can get anywhere close to that without
breaking things.

> > The SGI_FILE_* xattr data changes along with the required conversions
> > and whatnot, but then at least we expose data in a more generic format.
> 
> I really doubt that we can get rid of those attributes.
> 

The problem seems to boil down to the fact that the by-handle operations
(ATTRLIST_BY_HANDLE) don't include the system.posix_acl_* attributes,
and thus these aren't tracked by applications that use that interface
(such as xfsdump). I was hoping that whatever might have looked at the
SGI_ACL_* attrs would also have seen the posix_acl_* attr and thus we
could potentially get away with something like ignoring SGI_ACL_
operations (rather than failing them) without losing any information,
but that does not appear to be the case.

It still might be worth considering drawing a line in the sand (for
example, v5 filesystems or later) to deprecate the SGI_ACL_* xattrs. For
example:

- Fix the by-handle ATTR mechanisms to include the system.posix_acl_*
  xattrs.
- Hide the SGI_ACL_* xattrs from xattr lists.
- Add the SGI_ACL_* setxattr() validation as we're doing here for
  backwards compatibility, but include a deprecation log message warning
  in favor of using the above.
- At some point in the future, disallow the ability to get/set the
  SGI_ACL_* xattrs.

This also assumes there isn't some other reason we have SGI_ACL_*
exposed that I'm not aware of, which could certainly be the case.

Brian

> The patches in this queue don't "change" the format of those
> attributes, they only fix them for use in UID/GID  namespaces where
> they are currently broken. Validation when setting those xattrs could
> be removed, allowing sysadmins to set acls which the kernel and
> xfs_repair would reject; it seems rather pointless though.
> 
> Thanks,
> Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
