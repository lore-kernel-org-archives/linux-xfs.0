Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E34E27F50
	for <xfs@oss.sgi.com>; Sun,  3 Feb 2013 09:39:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D1BF5304039
	for <xfs@oss.sgi.com>; Sun,  3 Feb 2013 07:39:44 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id hckMpo1Fjpi5sscv
	for <xfs@oss.sgi.com>; Sun, 03 Feb 2013 07:39:44 -0800 (PST)
Message-ID: <510E84C0.40601@hardwarefreak.com>
Date: Sun, 03 Feb 2013 09:39:44 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfsdump -OOM triggering 'soft' kernel panic...
References: <510DDE61.6060005@tlinx.org> <510DED3D.702@tlinx.org>
In-Reply-To: <510DED3D.702@tlinx.org>
Reply-To: stan@hardwarefreak.com
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On 2/2/2013 10:53 PM, Linda Walsh wrote:

> Feb  2 06:18:28 Ishtar kernel: [990738.011852] xfsdump: page allocation
> failure: order:4, mode:0xc0d0
> Feb  2 06:18:28 Ishtar kernel: [990738.011856] Pid: 14882, comm: xfsdump
> Tainted: G           O 3.7.1-Isht-Van #1

Your kernel is tainted, albeit by a GPL (or compatible) licensed module.
 Any idea which module?  You may need to reproduce this with a
non-tainted kernel before anyone would run with it.

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
