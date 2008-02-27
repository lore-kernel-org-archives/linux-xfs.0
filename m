Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Feb 2008 16:55:43 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1R0tUta017615
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2008 16:55:33 -0800
Date: Wed, 27 Feb 2008 11:55:46 +1100
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: [PATCH] kill t_sema member of struct xfs_trans
Message-ID: <20080227005546.GA77525841@sgi.com>
References: <20080207082724.GA14119@lst.de> <20080226175758.GA13162@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226175758.GA13162@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

* Christoph Hellwig <hch@lst.de> [2008-02-26 18:57:58 +0100]:

> On Thu, Feb 07, 2008 at 09:27:24AM +0100, Christoph Hellwig wrote:
> > It's completely unused so we might aswell kill it.  Note that there is
> > another t_sema in struct xlog_ticket, which is used and actually an sv_t
> > despite the name.  That one is left untouched by this patch.
> 
> Ping?

This seems to be already applied in our dev tree, I'm trying to track down how/when/by-who, appart from that I'm all for pushing it.

Cheers,
-- 
Niv
