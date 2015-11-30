Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BA66C29DF5
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 15:51:32 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9C5FB8F8033
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 13:51:29 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Tjfxos907ygwGRlY for <xfs@oss.sgi.com>;
	Mon, 30 Nov 2015 13:51:26 -0800 (PST)
Date: Tue, 1 Dec 2015 08:51:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS corruptions
Message-ID: <20151130215112.GM26718@dastard>
References: <558408F298C8CE4C89D93BD56AB474E8018617B2B3@EXBE1IS02.omnifone.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <558408F298C8CE4C89D93BD56AB474E8018617B2B3@EXBE1IS02.omnifone.com>
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
To: Sandeep Patel <spatel@omnifone.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Nov 30, 2015 at 04:51:57PM +0000, Sandeep Patel wrote:
> Hi,
> 
> We have multiple 22 disk raid 6 arrays using LSI 9280-24i4e raid
> cards, all using enterprise grade drives. The array is setup with
> physical drive cache disabled and mounted using inode64 with
> nobarriers option in Oracle Linux Server release 6.6, kernel
> version 3.8.13-55.1.5.el6uek.x86_64. We are suffering from
> corruptions with xfs_repair unable to permanently fix the the
> issues. Output of dmesg from the latest corruption.
> 
> Pid: 5319, comm: glusterfsd Not tainted 3.8.13-55.1.5.el6uek.x86_64 #2

FYI, we cannot really support vendor enterprise on the upstream lists
because the code base is so different from vanilla/upstream kernels.
I same exactly the same thing for bugs reported on RHEL/CentOS
kernels, and for SLES kernels - only the vendor can properly support
their own franken-kernels...

Hence I'd suggest that you report the problem to your Oracle support
contact so they can walk you through the process of finding the
problem....

[ Darrick is really going to thank me for saying this. ]

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
