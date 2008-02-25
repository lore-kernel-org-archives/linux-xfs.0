Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Feb 2008 00:09:14 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1P898wg000967
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 00:09:10 -0800
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 80F40EA7D5C
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 00:09:36 -0800 (PST)
Received: from mx2.suse.de (ns2.suse.de [195.135.220.15]) by cuda.sgi.com with ESMTP id oIxo7GGPw8TmiO63 for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 00:09:36 -0800 (PST)
From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [PATCH, RFC] use generic ACL code
Date: Mon, 25 Feb 2008 09:09:30 +0100
References: <20080207083222.GA14317@lst.de>
In-Reply-To: <20080207083222.GA14317@lst.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802250909.31170.agruen@suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Thursday 07 February 2008 09:32:22 Christoph Hellwig wrote:
> This also introduces the same ACL caching all other Linux filesystems do
> by adding pointers to the acl and default acl in struct xfs_inode.
> It'll probably need some benchmarking to find out whether bloating the
> inode is worth it.

I guess it all depends on the workload.

> It should be possible to use the generic code without this caching by
> revamping the code a little, although no other filesystem currently does
> that.

The options for doing that would be (a) basically what xfs does now, i.e., 
perform the permission checks directly in the on-disk data, or (b) construct 
struct posix_acl objects temporarily for each access. Option (b) doesn't look 
very appealing to me.

> +		 * XXX(hch): the tag is 32 bits on disk and 16 bits in core.
> +		 *		Any special handling required??
> +		 */
> +		acl_e->e_tag = be32_to_cpu(ace->ae_tag);
> +		acl_e->e_perm = be16_to_cpu(ace->ae_perm);

I would check for zero upper bits on disk.


Thanks,
Andreas
