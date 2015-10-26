Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 404937F7E
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 09:02:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A63D6AC005
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 07:02:11 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XQ0siHzN2fqm1KTi (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 26 Oct 2015 07:02:10 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id D3B3EC0A1603
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 14:02:09 +0000 (UTC)
Date: Mon, 26 Oct 2015 10:02:08 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 0/4] xfs: SGI ACL Fixes
Message-ID: <20151026140207.GC59738@bfoster.bfoster>
References: <CAHc6FU5gS4BA+iTRHo1oHJMVHkLs4aa0eYd5T1ftLC9biRaxrg@mail.gmail.com>
	<20151024125659.GA8095@bfoster.bfoster>
	<CAHc6FU6eVn=KpKvhD2N8hvAgdFQVdBHHS9tUgaVQJf5wnipY=g@mail.gmail.com>
	<20151024152254.GA22232@bfoster.bfoster>
	<CAHc6FU7L15fCusqOONjtB8QQnGVPSW7+KKuENvFxKELmdnqmaA@mail.gmail.com>
	<1445721369-25679-1-git-send-email-agruenba@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1445721369-25679-1-git-send-email-agruenba@redhat.com>
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

On Sat, Oct 24, 2015 at 11:16:05PM +0200, Andreas Gruenbacher wrote:
> Here are some fixes for the trusted.SGI_ACL_* attributes.  This adds some
> more warts and it would be much better to get rid of those unnecessary
> attributes instead; we probably can't though.
> 
> I have tested this manually but haven't run xfstests against that.  Please
> review.
> 

Thanks... I sent some comments on the core patch. Those aside, I'd still
like to see some other opinions on the best way to handle this. I'd
suggest we get some agreement there before getting too far with this.
The options seem to be:

1.) Hide the internal xattrs and disallow setting them. This is probably
the most simple fix, but removes the entries after they had previously
been exposed.

2.) Redirect the internal xattr handlers through the system.posix_acl_*
handlers. This (presumably) simplifies the XFS implementation and
eliminates duplicating some of the VFS acl bits in the fs. This
preserves xattr existence but changes the exposed format to the generic
ACL format. Therefore, it very well could be pointless in favor of
option 1 or 3.

3.) Make the internal xattr handlers work correctly with the format as
exposed today. This is what this series aims to do and requires some of
the additional namespace quirkiness and whatnot by expecting XFS on-disk
format data from userspace.

Thoughts?

Brian

> Thanks,
> Andreas
> 
> Andreas Gruenbacher (4):
>   xfs: Validate the length of on-disk ACLs
>   xfs: SGI ACLs: Fix caching and mode setting
>   xfs: SGI ACLs: Map uid/gid namespaces
>   xfs: SGI ACLs: Prepare for richacls
> 
>  fs/xfs/libxfs/xfs_format.h |   8 +++-
>  fs/xfs/xfs_acl.c           | 115 ++++++++++++++++++++++++++++++++++++++++-----
>  fs/xfs/xfs_acl.h           |   3 ++
>  fs/xfs/xfs_xattr.c         |   9 ++--
>  fs/xfs/xfs_xattr.h         |  28 +++++++++++
>  5 files changed, 147 insertions(+), 16 deletions(-)
>  create mode 100644 fs/xfs/xfs_xattr.h
> 
> -- 
> 2.5.0
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
