Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F17C27F52
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 11:55:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DA62330406B
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 09:55:18 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ywSen5nhKBBECGMt for <xfs@oss.sgi.com>;
	Fri, 27 Sep 2013 09:55:15 -0700 (PDT)
Message-ID: <5245B86F.3030309@sandeen.net>
Date: Fri, 27 Sep 2013 11:55:11 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix memory leak in xlog_recover_add_to_trans
References: <20130927140104.515578025@sgi.com>
In-Reply-To: <20130927140104.515578025@sgi.com>
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
To: tinguely@sgi.com
Cc: xfs@oss.sgi.com

On 9/27/13 9:00 AM, tinguely@sgi.com wrote:
> Free the memory in error path of xlog_recover_add_to_trans().
> Normally this memory is freed in recovery pass2, but is leaked
> in the error path.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>

For this local leak & the fix,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Since this gets called in a loop from xlog_recover_process_data(),
I'm wondering what happens to previously-allocated items, if we
return an error and never get to pass2?

(I could be off base, haven't really followed it through, but
it seems like they might leak).

Thanks,
-Eric

> ---
> Found by Coverity (134683) in userspace, same patch applies there
> also.
>  fs/xfs/xfs_log_recover.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: b/fs/xfs/xfs_log_recover.c
> ===================================================================
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1585,6 +1585,7 @@ xlog_recover_add_to_trans(
>  		"bad number of regions (%d) in inode log format",
>  				  in_f->ilf_size);
>  			ASSERT(0);
> +			free(ptr);
>  			return XFS_ERROR(EIO);
>  		}
>  
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
