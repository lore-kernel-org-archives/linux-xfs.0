Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DA0FC7CA1
	for <xfs@oss.sgi.com>; Thu, 29 Sep 2016 15:33:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id ABD18304062
	for <xfs@oss.sgi.com>; Thu, 29 Sep 2016 13:33:28 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id pbDF9nx2jcw5iW94 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 29 Sep 2016 13:33:27 -0700 (PDT)
Date: Thu, 29 Sep 2016 13:33:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: aio completions vs file_accessed race, was: Re: [PATCH 7/8] xfs:
	split direct I/O and DAX path
Message-ID: <20160929203320.GE14092@birch.djwong.org>
References: <1466609236-23801-1-git-send-email-hch@lst.de>
	<1466609236-23801-8-git-send-email-hch@lst.de>
	<20160929025351.GB4901@birch.djwong.org>
	<20160929083824.GA12799@lst.de> <20160929201834.GA5872@lst.de>
	<20160929201849.GB5872@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160929201849.GB5872@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, xfs@oss.sgi.com

On Thu, Sep 29, 2016 at 10:18:49PM +0200, Christoph Hellwig wrote:
> On Thu, Sep 29, 2016 at 10:18:34PM +0200, Christoph Hellwig wrote:
> > Can you try the patch below?  That just moves the file_accessed call
> > before the I/O, similar to how we handle timestamp updates on the write
> > side.  generic_file_read_iter will also need a similar update.
> 
> And now with patch:
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 349f328..6919412 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -270,6 +270,8 @@ xfs_file_dio_aio_read(
>  		return -EINVAL;
>  	}
>  
> +	file_accessed(iocb->ki_filp);
> +
>  	/*
>  	 * Locking is a bit tricky here. If we take an exclusive lock for direct
>  	 * IO, we effectively serialise all new concurrent read IO to this file
> @@ -324,7 +326,6 @@ xfs_file_dio_aio_read(
>  	}
>  	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
>  
> -	file_accessed(iocb->ki_filp);
>  	return ret;
>  }
>  

I noticed that g/323 only breaks when the XFS is on a real disk; on
pmem it works fine with or without the patch.

That said, it makes the crash go away and the patch looks ok, so:
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Tested-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
