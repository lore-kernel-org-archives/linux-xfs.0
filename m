Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5BM1udK173134 for <xfs@oss.sgi.com>; Thu, 11 Jun 2009 17:01:56 -0500
Received: from router.windsormachine.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 569A62ECA85
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2009 15:02:16 -0700 (PDT)
Received: from router.windsormachine.com (windsormachine.com [216.8.138.2]) by
	cuda.sgi.com with ESMTP id SDYomOGPO9fUip9H for
	<xfs@oss.sgi.com>; Thu, 11 Jun 2009 15:02:16 -0700 (PDT)
Date: Thu, 11 Jun 2009 18:02:15 -0400 (EDT)
From: Mike Dresser <mdresser_l@windsormachine.com>
Subject: Re: Kernel 2.6.30: Memory/XFS leak, OOM killer kills many
 processes
In-Reply-To: <8EE3C044-FB47-46BC-A06F-DA0EF65D8236@sgi.com>
Message-ID: <alpine.DEB.1.10.0906111759470.25044@router.windsormachine.com>
References: <alpine.DEB.2.00.0906111158470.2563@p34.internal.lan>
	<alpine.DEB.2.00.0906111255280.6809@p34.internal.lan>
	<4A313F84.20900@sandeen.net>
	<8EE3C044-FB47-46BC-A06F-DA0EF65D8236@sgi.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Felix Blyakher <felixb@sgi.com>
Cc: xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org


On Thu, 11 Jun 2009, Felix Blyakher wrote:
>  xfs: fix getbmap vs mmap deadlock

Any chance that's related to the issues seen in 
http://bugzilla.kernel.org/show_bug.cgi?id=13375 ?

Seems to be kswapd dying in our case.

Mike

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
