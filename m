Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7B1237F50
	for <xfs@oss.sgi.com>; Wed, 20 Nov 2013 23:42:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 017FCAC00D
	for <xfs@oss.sgi.com>; Wed, 20 Nov 2013 21:42:47 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id J2TC5Ny0aCiGNaez (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Nov 2013 21:42:47 -0800 (PST)
Message-ID: <528D9D4F.5090003@oracle.com>
Date: Thu, 21 Nov 2013 13:42:39 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: growfs overruns AGFL buffer on V4 filesystems
References: <1385008866-22256-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1385008866-22256-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 11/21 2013 12:41, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This loop in xfs_growfs_data_private() is incorrect for V4
> superblocks filesystems:
> 
> 		for (bucket = 0; bucket < XFS_AGFL_SIZE(mp); bucket++)
> 			agfl->agfl_bno[bucket] = cpu_to_be32(NULLAGBLOCK);
> 
> For V4 filesystems, we don't have a agfl header structure, and so
> XFS_AGFL_SIZE() returns an entire sector's worth of entries, which
> we then index from an offset into the sector. Hence: buffer overrun.
> 
> This problem was introduced in 3.10 by commit 77c95bba ("xfs: add
> CRC checks to the AGFL") which changed the AGFL structure but failed
> to update the growfs code to handle the different structures.
> 
> Fix it by using the correct offset into the buffer for both V4 and
> V5 filesystems.
This is a problem I'm able to understand.

Reviewed-by: Jie Liu <jeff.liu@oracle.com>

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
