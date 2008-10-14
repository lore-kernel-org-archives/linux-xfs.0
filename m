Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 13 Oct 2008 19:04:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9E24G8s008288
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 19:04:16 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 257504EFF5C
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 19:05:58 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id FA8ehbuPDe1pDAAI for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 19:05:58 -0700 (PDT)
Date: Tue, 14 Oct 2008 13:05:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: TAKE 988255 - fix instant oops with tracing enabled
Message-ID: <20081014020556.GH10716@disturbed>
References: <20081014011747.AC14E58FA1E9@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081014011747.AC14E58FA1E9@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 14, 2008 at 12:17:47PM +1100, Lachlan McIlroy wrote:
> fix instant oops with tracing enabled
> 
> We can only read inode->i_count if the inode is actually there and not
> a NULL pointer.  This was introduced in one of the recent sync patches.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

BTW, this now means that other pending patches won't apply cleanly....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
