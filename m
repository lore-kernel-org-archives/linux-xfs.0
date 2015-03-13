Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6258C7F54
	for <xfs@oss.sgi.com>; Fri, 13 Mar 2015 08:20:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E4107AC004
	for <xfs@oss.sgi.com>; Fri, 13 Mar 2015 06:20:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9RdRQNsSIm0ouLGW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Mar 2015 06:20:21 -0700 (PDT)
Date: Fri, 13 Mar 2015 09:20:18 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/4] xfs_db: show nlink fields for di_version == 3, too
Message-ID: <20150313132018.GB2678@laptop.bfoster>
References: <54F77199.8030708@redhat.com>
 <54F7727F.8090808@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54F7727F.8090808@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Mar 04, 2015 at 03:00:47PM -0600, Eric Sandeen wrote:
> Printing inodes with di_version == 3 skips the nlink
> fields, because they are only printed if di_version == 2.
> This was intended to separate them from di_version == 1,
> but it mistakenly excluded di_version == 3, which also contains
> these fields.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Not sure; is >= 2 ok, or should it be == 2 || == 3?
> Choose your poison, I guess.
> 

Seems fine to me. I think it's better to only have to worry about this
code if something related to these fields changes rather than every time
a version update occurs.

Reviewed-by: Brian Foster <bfoster@redhat.com>

> diff --git a/db/inode.c b/db/inode.c
> index 982acb7..c26e1a0 100644
> --- a/db/inode.c
> +++ b/db/inode.c
> @@ -369,7 +369,7 @@ inode_core_nlinkv2_count(
>  	ASSERT(startoff == 0);
>  	ASSERT(obj == iocur_top->data);
>  	dic = obj;
> -	return dic->di_version == 2;
> +	return dic->di_version >= 2;
>  }
>  
>  static int
> @@ -382,7 +382,7 @@ inode_core_onlink_count(
>  	ASSERT(startoff == 0);
>  	ASSERT(obj == iocur_top->data);
>  	dic = obj;
> -	return dic->di_version == 2;
> +	return dic->di_version >= 2;
>  }
>  
>  static int
> @@ -395,7 +395,7 @@ inode_core_projid_count(
>  	ASSERT(startoff == 0);
>  	ASSERT(obj == iocur_top->data);
>  	dic = obj;
> -	return dic->di_version == 2;
> +	return dic->di_version >= 2;
>  }
>  
>  static int
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
