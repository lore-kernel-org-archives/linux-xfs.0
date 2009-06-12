Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5C9uk1p199227 for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 04:56:47 -0500
Message-ID: <4A32266F.8080607@dermichi.com>
Date: Fri, 12 Jun 2009 11:57:03 +0200
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: Kernel 2.6.30: Memory/XFS leak, OOM killer kills many processes
References: <alpine.DEB.2.00.0906111158470.2563@p34.internal.lan>	<alpine.DEB.2.00.0906111255280.6809@p34.internal.lan>	<4A313F84.20900@sandeen.net>	<96F5FBF8-17B6-4AA9-BAB4-377AF596692C@sgi.com>
	<alpine.DEB.2.00.0906120420080.26259@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.0906120420080.26259@p34.internal.lan>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi!
> 
> So just goto line ~6086 and add the kmem_free(out); above the return error.
> 
> Status:
> This patch fixes the problem, thanks!
> 
Applied here too & fixes the problem. Wow, the fix was provided in <3 hours, kudos to open source.

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
