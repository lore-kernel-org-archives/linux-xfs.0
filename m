Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DC48F29DF5
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 16:04:32 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7CD75AC007
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 14:04:32 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id hYNjU5wATMsQrbir (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 30 Nov 2015 14:04:30 -0800 (PST)
Date: Mon, 30 Nov 2015 14:04:23 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: XFS corruptions
Message-ID: <20151130220423.GA16277@birch.djwong.org>
References: <558408F298C8CE4C89D93BD56AB474E8018617B2B3@EXBE1IS02.omnifone.com>
	<20151130215112.GM26718@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151130215112.GM26718@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Sandeep Patel <spatel@omnifone.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Dec 01, 2015 at 08:51:12AM +1100, Dave Chinner wrote:
> On Mon, Nov 30, 2015 at 04:51:57PM +0000, Sandeep Patel wrote:
> > Hi,
> > 
> > We have multiple 22 disk raid 6 arrays using LSI 9280-24i4e raid
> > cards, all using enterprise grade drives. The array is setup with
> > physical drive cache disabled and mounted using inode64 with
> > nobarriers option in Oracle Linux Server release 6.6, kernel
> > version 3.8.13-55.1.5.el6uek.x86_64. We are suffering from
> > corruptions with xfs_repair unable to permanently fix the the
> > issues. Output of dmesg from the latest corruption.
> > 
> > Pid: 5319, comm: glusterfsd Not tainted 3.8.13-55.1.5.el6uek.x86_64 #2
> 
> FYI, we cannot really support vendor enterprise on the upstream lists
> because the code base is so different from vanilla/upstream kernels.
> I same exactly the same thing for bugs reported on RHEL/CentOS
> kernels, and for SLES kernels - only the vendor can properly support
> their own franken-kernels...
>
> Hence I'd suggest that you report the problem to your Oracle support
> contact so they can walk you through the process of finding the
> problem....
> 
> [ Darrick is really going to thank me for saying this. ]

Probably what I'd have written anyway. :)

Oracle support might just tell you to upgrade the kernel whatever the
latest is.  3.8.13-55 is pretty far back AFAIK.

(Is not a support engineer, nor do I play one on TV.)

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
