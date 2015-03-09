Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 53A8E7F4E
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 13:49:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C7FCAAC001
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 11:49:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id p4iLvxC7dxd3UHi4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 09 Mar 2015 11:49:28 -0700 (PDT)
Date: Mon, 9 Mar 2015 15:49:18 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 3/4] xfs_db: show nlink fields for di_version == 3, too
Message-ID: <20150309184918.GD18016@hades.maiolino.org>
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

I'm not sure why we differentiate inode versions here, to print the nlink, I
probably have never seen a filesystem with di_version == 1 (feeling young :)

Why does it needs to be tested? I don't think di_version 1 didn't have nlink
field, but if it did, and if this is the only difference, in this subject, I
don't see a problem in having it tested with >= 2. But, if there could be more
than only this difference, maybe some kind of helper function, or even a macro
to make this test, taking into account the di_version.

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

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
