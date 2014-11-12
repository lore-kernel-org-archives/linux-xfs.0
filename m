Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3A9FF7F3F
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 15:25:18 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 66BFCAC00B
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 13:25:13 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	EgwTp9FssEByGCRo for <xfs@oss.sgi.com>;
	Wed, 12 Nov 2014 13:25:11 -0800 (PST)
Date: Thu, 13 Nov 2014 08:25:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Fwd: multiple processes hanging doing xfs ops -- 3.17.2
Message-ID: <20141112212507.GZ23575@dastard>
References: <5463BB52.3080601@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5463BB52.3080601@tlinx.org>
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
To: L Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Nov 12, 2014 at 11:56:02AM -0800, L Walsh wrote:
> 
> 
> I just upped from 3.16.2 to 3.17.2 this morning, and after about 2 hours
> uptime, got
> several procs hanging in what looks like xfs territory.
....

> Nov 12 04:43:46 Ishtar kernel: [ 5886.496468] INFO: task xfsdump:38317 blocked for more than 120 seconds.
....
> Nov 12 04:43:46 Ishtar kernel: [ 5886.515691]  [<ffffffff8129b935>] xfs_bulkstat+0x165/0x4e0

You ran xfsdump and that triggered one of the bulkstat regressions
in 3.17. The fixes have been queued to the next 3.17.x stable
kernel, so you'll want to hold off running xfsdump or xfs_fsr until
that kernel is released and you upgrade.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
