Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 01 Jun 2008 18:58:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m521wMjs017814
	for <xfs@oss.sgi.com>; Sun, 1 Jun 2008 18:58:23 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5DA2912BB839
	for <xfs@oss.sgi.com>; Sun,  1 Jun 2008 18:59:14 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id 2XWhVBzrG6kwWuqE for <xfs@oss.sgi.com>; Sun, 01 Jun 2008 18:59:14 -0700 (PDT)
Date: Mon, 2 Jun 2008 11:58:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/2] On-demand Filesystem Initialisation
Message-ID: <20080602015831.GB2428@disturbed>
References: <1212331915-22856-1-git-send-email-tspink@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212331915-22856-1-git-send-email-tspink@gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tom Spink <tspink@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Sun, Jun 01, 2008 at 03:51:53PM +0100, Tom Spink wrote:
> 
> (resend to include CCs)

What cc's? Still no xfs cc on it. I added it to this reply....

> This (short) patch series is another RFC for the patch that introduces on-demand
> filesystem initialisation.  In addition to the original infrastructure
> implementation (with clean-ups), it changes XFS to use this new infrastructure.
> 
> I wrote a toy filesystem (testfs) to simulate scheduling/allocation delays and
> to torture the mount/unmount cycles.  I didn't manage to deadlock the system
> in my tests.  XFS also works as expected aswell, in that the global threads
> are not created until an XFS filesystem is mounted for the first time.  When the
> last XFS filesystem is unmounted, the threads go away.
> 
> Please let me know what you think!

Why even bother? This is why we have /modular/ kernels - if you're
not using XFS then don't load it and you won't see those pesky
threads. That'll save on a bunch of memory as well because the xfs
module ain't small (>480k on i386)....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
