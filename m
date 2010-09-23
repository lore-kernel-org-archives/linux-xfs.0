Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8NNr9AH154332 for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 18:53:10 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 68ECC1859619
	for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 16:54:03 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	aj3ZIeCa1QFV8HHo for <xfs@oss.sgi.com>;
	Thu, 23 Sep 2010 16:54:03 -0700 (PDT)
Date: Fri, 24 Sep 2010 09:53:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS errors on large Infiniband fileserver setup
Message-ID: <20100923235355.GO2614@dastard>
References: <29252416bd0d9dc973a909e411dbec6a@phys.ethz.ch>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <29252416bd0d9dc973a909e411dbec6a@phys.ethz.ch>
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
To: Christian Herzog <horeizo@phys.ethz.ch>
Cc: isg@phys.ethz.ch, xfs@oss.sgi.com

On Thu, Sep 23, 2010 at 09:22:29AM +0200, Christian Herzog wrote:
> 
> Dear all,
> 
> we (Physics Dept. at ETH Zurich) are trying to set up a large file
> server combo (two disk backends connected to a frontend by
> Infiniband, all running Ubuntu 10.04) and keep getting XFS internal
> error xfs_da_do_buf(2) messages when copying large amounts of data,
> resulting in 'structure needs cleaning' warnings. We have tried a
> lot of different kernels, iSCSI implementations, LVM configurations,
> whatnot, but these errors persist. The setup right now looks like
> this:
> 
> 2 disk backends, each: Quad-Xeon X5550, 12G of RAM, 28T HW
> SATA-RAID6 sliced into 2T chunks by LVM2 and exported via tgt
> 1.0.0-2, Ubuntu 10.04 LTS, connected via Mellanox MHRH19B-XTR
> Infiniband + ISER to
> 
> 1 frontend Octo-Xeon E5520, 12G of RAM, open-iscsi 2.0.871
> initiator, Ubuntu 10.04 LTS. LMV2 stitches together the
> 2T-iSCSI-LUNs and provides a 10T test XFS filesystem

Out of curiousity, why are you using such a complex storage
configuration?

IMO, it is unneccessarily complex - you could easily do this (~30
drives) with a single server with a couple of external SAS JBOD
arrays and SAS RAID controllers. That would give you the same
performance (or better), with many fewer points of failure (both
hardware and software), use less rack space, and probably be
significantly cheaper....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
