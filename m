Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Feb 2008 15:39:36 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m14NdVgI002711
	for <xfs@oss.sgi.com>; Mon, 4 Feb 2008 15:39:32 -0800
Date: Mon, 4 Feb 2008 18:39:46 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH 1/1] XFS: Replace custom AIL linked-list code with
	struct list_head
Message-ID: <20080204233946.GA27110@josefsipek.net>
References: <20080125070800.GH155407@sgi.com> <1202106488-31494-1-git-send-email-jeffpc@josefsipek.net> <20080204205230.GA14084@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204205230.GA14084@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: dgc@sgi.com, xfs@oss.sgi.com

On Mon, Feb 04, 2008 at 03:52:30PM -0500, Christoph Hellwig wrote:
> On Mon, Feb 04, 2008 at 01:28:08AM -0500, Josef 'Jeff' Sipek wrote:
> > Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
> > ---
> > This patch assumes you already have Dave Chinner's patch for
> > xfsidbg_xlogitem and xfsidbg_xaildump is needed.
> > 
> > Changes since V1:
> > 
> > - Pass around a pointer to the AIL, not the struct list_head
> > - Make sure things compile & run with CONFIG_XFS_DEBUG
> 
> Does it work with XFS_TRANS_DEBUG defined aswell?
 
With XFS_TRANS_DEBUG on, other places in XFS don't compile, but this does
and works (xfsqa ran fine).

> > -	lip = xfs_ail_min(&(mp->m_ail.xa_ail));
> > +	lip = xfs_ail_min(&(mp->m_ail));
> 
> Care to remove these useless braces in all the places you touch while you're at it?

Will do.

Josef 'Jeff' Sipek.

-- 
The box said "Windows XP or better required". So I installed Linux.
