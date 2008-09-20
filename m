Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 19 Sep 2008 23:33:24 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8K6XEGx004758
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 23:33:16 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F06AD939D06
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 23:34:46 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id FPGH8cPrx9oyWKtt for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 23:34:46 -0700 (PDT)
Date: Sat, 20 Sep 2008 16:34:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/8] XFS: Add ail pointer into log items
Message-ID: <20080920063443.GO5811@disturbed>
References: <1221317877-8333-1-git-send-email-david@fromorbit.com> <1221317877-8333-8-git-send-email-david@fromorbit.com> <20080919092820.GG11443@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080919092820.GG11443@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Sep 19, 2008 at 05:28:20AM -0400, Christoph Hellwig wrote:
> On Sun, Sep 14, 2008 at 12:57:56AM +1000, Dave Chinner wrote:
> > Add an xfs_ail pointer to log items so that the log items can
> > reference the AIL directly during callbacks without needed a
> > struct xfs_mount.
> 
> Does it matter? I'd be a nice cleanup if you managed to get rid of
> li_mountp, but without that I don't quite see the point.

I haven't gone as far as removing the li_mountp yet - my intention
is to do so, but I haven't written all the patches to do it yet.

The way the li_mountp is used in some subsystems was very indirect
in some cases (e.g. in the quota code) so I wanted to look a little
more at it before deciding the best way to remove as much
indirection as possible in those cases instead of adding more. It
may be that adding xfs_mount pointers into some other structures is
needed to clean this up totally...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
