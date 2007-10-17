Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 17 Oct 2007 14:08:51 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9HL8kW5014494
	for <xfs@oss.sgi.com>; Wed, 17 Oct 2007 14:08:47 -0700
Date: Wed, 17 Oct 2007 21:36:58 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] XFS update for 2.6.24-rc1
Message-ID: <20071017203658.GA22073@infradead.org>
References: <20071017110339.D4B3158C38F1@chook.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017110339.D4B3158C38F1@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tim Shimmin <tes@sgi.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

On Wed, Oct 17, 2007 at 09:03:39PM +1000, Tim Shimmin wrote:
> Hi Linus,
> 
> Please pull from the for-linus branch:
>     git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus
> 
> These include changes we have had scheduled for 2.6.24.
> In particular they include Christoph's (hch's) behavior removal patches.

Can you please send my '[PATCH] cleanup fid types mess' to Linus aswell?
I have a stack of 15 patches reworking the nfs exporting code waiting
in -mm to get in in this merge window that depend on this cleanup to
free struct fid for generic useage.

Also getting the makefile cleanup into mainline to reduce spurious difference
would help a lot.
