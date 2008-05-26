Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 May 2008 22:37:24 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4Q5bHRx013054
	for <xfs@oss.sgi.com>; Sun, 25 May 2008 22:37:17 -0700
Date: Mon, 26 May 2008 07:37:59 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] use generic_*xattr routines
Message-ID: <20080526053759.GA17825@lst.de>
References: <20080430112217.GB16966@lst.de> <20080521081656.GA2638@lst.de> <48365486.3060503@sgi.com> <20080523054848.GA29507@lst.de> <483A15CE.9060409@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483A15CE.9060409@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, May 26, 2008 at 11:43:42AM +1000, Timothy Shimmin wrote:
> I guess this is done to some extent by the put_listent() callback.
> Though, the context structure is probably a bit overused in different
> ways.
> The callback was also used for searching (for parent-ptr code) as well
> as for list formatting.
> I presume we are preserving the valuelen list format to keep the API
> for xfs_attrlist_by_handle used by xfsdump and probably for dmf.

Yes, the idea is to change the put_listen callback for work more like
filldir.  Thas is:

 - the callback is supplied by the xfs_attr_list caller, not set based
   on options
 - there will be an opaque object supplied to xfs_attr_list that is to
   be used by put_listent so that we don't have to pass down
   implementation-specific arguments directly.

I'd also like to move the attrlist_cursor_kern_t into this callback
opaque context because it doesn't make sense for the normal xattr API,
but I'll have to see if that's actually feasible.
