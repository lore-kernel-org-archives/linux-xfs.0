Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B8D787F47
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 10:39:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 318C0AC001
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 08:39:24 -0700 (PDT)
Received: from mail-lf0-f52.google.com (mail-lf0-f52.google.com
	[209.85.215.52]) by cuda.sgi.com with ESMTP id XLiddyd2UUGQg0pq
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 26 Oct 2015 08:39:21 -0700 (PDT)
Received: by lfbn126 with SMTP id n126so118405661lfb.2
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 08:39:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20151026140202.GB59738@bfoster.bfoster>
References: <1445721369-25679-1-git-send-email-agruenba@redhat.com>
	<1445721369-25679-3-git-send-email-agruenba@redhat.com>
	<20151026140202.GB59738@bfoster.bfoster>
Date: Mon, 26 Oct 2015 16:39:20 +0100
Message-ID: <CAHc6FU5a-20aTceoKKZNmk=v+WQt+xLtSGZPo4yXN7Uq9ZDWOA@mail.gmail.com>
Subject: Re: [PATCH 2/4] xfs: SGI ACLs: Fix caching and mode setting
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

On Mon, Oct 26, 2015 at 3:02 PM, Brian Foster <bfoster@redhat.com> wrote:
> Finally, another random thought... another way to approach this whole
> thing might be just to redirect the SGI_FILE_* xattr calls to the
> system.posix_acl_* calls.

You mean silently changing the binary format of those attributes?
That's the worst thing we could possibly do.

> The SGI_FILE_* xattr data changes along with the required conversions
> and whatnot, but then at least we expose data in a more generic format.

I really doubt that we can get rid of those attributes.

The patches in this queue don't "change" the format of those
attributes, they only fix them for use in UID/GID  namespaces where
they are currently broken. Validation when setting those xattrs could
be removed, allowing sysadmins to set acls which the kernel and
xfs_repair would reject; it seems rather pointless though.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
