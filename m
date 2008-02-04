Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Feb 2008 12:52:19 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m14KqA5n025655
	for <xfs@oss.sgi.com>; Mon, 4 Feb 2008 12:52:13 -0800
Date: Mon, 4 Feb 2008 15:52:30 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/1] XFS: Replace custom AIL linked-list code with
	struct list_head
Message-ID: <20080204205230.GA14084@lst.de>
References: <20080125070800.GH155407@sgi.com> <1202106488-31494-1-git-send-email-jeffpc@josefsipek.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202106488-31494-1-git-send-email-jeffpc@josefsipek.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: dgc@sgi.com, xfs@oss.sgi.com, hch@infradead.org

On Mon, Feb 04, 2008 at 01:28:08AM -0500, Josef 'Jeff' Sipek wrote:
> Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
> ---
> This patch assumes you already have Dave Chinner's patch for
> xfsidbg_xlogitem and xfsidbg_xaildump is needed.
> 
> Changes since V1:
> 
> - Pass around a pointer to the AIL, not the struct list_head
> - Make sure things compile & run with CONFIG_XFS_DEBUG

Does it work with XFS_TRANS_DEBUG defined aswell?

> -	lip = xfs_ail_min(&(mp->m_ail.xa_ail));
> +	lip = xfs_ail_min(&(mp->m_ail));

Care to remove these useless braces in all the places you touch while you're at it?
