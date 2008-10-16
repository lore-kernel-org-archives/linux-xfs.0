Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Oct 2008 10:39:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9GHdTAK031027
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 10:39:30 -0700
Received: from coco.kroah.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4F33010A8F35
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 10:41:11 -0700 (PDT)
Received: from coco.kroah.org (kroah.org [198.145.64.141]) by cuda.sgi.com with ESMTP id f0t1fwPqJK1EHIoL for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 10:41:11 -0700 (PDT)
Date: Thu, 16 Oct 2008 10:35:29 -0700
From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [PATCH] XFS fix remount rw with unrecognized options
Message-ID: <20081016173529.GA13038@kroah.com>
References: <20081016002926.D912558FA22B@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016002926.D912558FA22B@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tim Shimmin <tes@sgi.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Oct 16, 2008 at 11:29:26AM +1100, Tim Shimmin wrote:
> Resending as I mangled sending the mail from home last time. Sorry.
> 
> Please include the following patch for 2.6.27.1 stable release as
> suggested by Christoph Hellwig and Eric Sandeen.
> It fixes a regression in the recent remount recoding
> where remounting say from ro to rw allows the xfs flags to
> be out of sync with the vfs flags, resulting
> in failures for some programs such as touch (which end up calling xfs_setattr).
> The fix is a very minor and clear.

Is this patch already in Linus's tree?  If so, do you have a git commit
id?

thanks,

greg k-h
