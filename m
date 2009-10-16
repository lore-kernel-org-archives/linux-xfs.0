Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9GCZW22099281 for <xfs@oss.sgi.com>; Fri, 16 Oct 2009 07:35:32 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BE10C17971D3
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2009 05:37:03 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id IQWC6me64dgWbXVx for
	<xfs@oss.sgi.com>; Fri, 16 Oct 2009 05:37:03 -0700 (PDT)
Date: Fri, 16 Oct 2009 08:37:03 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: 2.6.31: xfs or md/raid1 bug in 2.6.31?
Message-ID: <alpine.DEB.2.00.0910160832290.31450@p34.internal.lan>
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
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Alan Piszcz <ap@solarrain.com>

Hi all,

Does anyone recall if there was a serious xfs bug in 2.6.31?

I saw xfsbufd/pdflush etc locked up and local file system access hung 
whenever I tried to write a file to the filesystem, I ran a sysrq-t but 
could not capture the output nor did I see anything obvious.

System runs a md/raid1+xfs.

Upgraded to 2.6.31.4, will have to see if it happens again.

Was curious though if anyone recalled problems with this kernel 
release/combination?

Thanks,

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
