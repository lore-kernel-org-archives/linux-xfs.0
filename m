Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 760C27F51
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 16:10:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E2A22AC003
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 14:10:47 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id keFJ7EIaGaj91H05
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 14:10:46 -0800 (PST)
Message-ID: <530A71E3.9060107@hardwarefreak.com>
Date: Sun, 23 Feb 2014 16:10:43 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: gentoo linux, kernel 3.10.31 mount options bug?
References: <9963a76fbd006355c9ffd79f341c9971@zbfmail.de>
In-Reply-To: <9963a76fbd006355c9ffd79f341c9971@zbfmail.de>
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
To: weber@zbfmail.de, Xfs <xfs@oss.sgi.com>

On 2/23/2014 3:37 AM, Marko Weber|8000 wrote:
...
> linux /bzImage-3.10.31 root=/dev/md2 elevator=cfq clocksource=hpet
                                       ^^^^^^^^^^^^

cfq tends to defeat much of the parallelism in XFS, decreasing
throughput substantially.  This is documented in the XFS FAQ and has
been discussed here many times in the past.  It has been recommended for
a few years now that XFS not be used with the cfq elevator.  Use
deadline with md arrays on plain HBAs and noop on SSDs or any device
with [F|B]BWC, i.e. RAID HBA or SAN controller.

If you're using cfq to allow shaping of per process IO with control
groups, simply using cfq alone may slow down XFS throughput to the point
that you don't need to bother with control group optimizations.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
