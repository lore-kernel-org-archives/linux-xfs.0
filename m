Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BE5C47F3F
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 17:31:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8126D8F8040
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 15:31:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 43b4qEWJSvPXsB2H for
	<xfs@oss.sgi.com>; Mon, 18 Mar 2013 15:31:36 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2IMVaw1001168
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 18:31:36 -0400
Received: from laptop.bfoster (vpn-52-184.rdu2.redhat.com [10.10.52.184])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r2IMVZNJ024370
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 18:31:35 -0400
Message-ID: <51479537.7010905@redhat.com>
Date: Mon, 18 Mar 2013 18:29:11 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: reduce bb_numrecs in bno/cnt btrees when log
	consumes all agf space
References: <1363642689-17718-1-git-send-email-bfoster@redhat.com>
In-Reply-To: <1363642689-17718-1-git-send-email-bfoster@redhat.com>
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
To: xfs@oss.sgi.com

On 03/18/2013 05:38 PM, Brian Foster wrote:
> The mkfs code currently creates a single free space extent record
> for each of the bno and cnt btrees in each AG. The start block of
> the record is pushed forward on the AG that hosts an internal log.
> If the log happens to consume all available space in the AG, the
> start block becomes equal to sb->sb_agblocks and thus invalid.
> This causes xfs_repair to complain.
> 
> For example, the following sequence:
> 
> 	mkfs.xfs -d file,name=./fs.img,size=50g,agsize=16m
> 	xfs_repair ./fs.img
> 
> ... produces the following xfs_repair output:
> 
> 	Phase 1 - find and verify superblock...
> 	Phase 2 - using internal log
>         	- scan filesystem freespace and inode maps...
> 	invalid start block 4096 in record 0 of bno btree block 1600/1
> 	invalid start block 4096 in record 0 of cnt btree block 1600/2
>         	- found root inode chunk
> 	...
> 
> xfs_repair appears to correct the numrecs value such that subsequent
> checks are successful. The sequence above is pulled from xfstests
> 

For some reason my commit log got munged here. :/ This should say this
was "pulled from xfstests #250, which fails due to this behavior." I'll
send out a v2 with at least a new commit log when this gets some review...

Brian

> Modify mkfs.xfs such that we check the block count value of the
> free space record for the log AG after the log is accounted for. If
> no space is left for the record, reset the record count to 0.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  mkfs/xfs_mkfs.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index c84448e..c4ae15b 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2594,6 +2594,9 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
>  		}
>  		arec->ar_blockcount = cpu_to_be32(agsize - 
>  					be32_to_cpu(arec->ar_startblock));
> +		if (!arec->ar_blockcount)
> +			block->bb_numrecs = cpu_to_be16(0);
> +
>  		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
>  
>  		/*
> @@ -2627,6 +2630,9 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
>  		}
>  		arec->ar_blockcount = cpu_to_be32(agsize - 
>  					be32_to_cpu(arec->ar_startblock));
> +		if (!arec->ar_blockcount)
> +			block->bb_numrecs = cpu_to_be16(0);
> +
>  		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
>  
>  		/*
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
