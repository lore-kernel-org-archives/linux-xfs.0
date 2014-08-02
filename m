Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C1AB57F54
	for <xfs@oss.sgi.com>; Sat,  2 Aug 2014 11:37:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A145A304043
	for <xfs@oss.sgi.com>; Sat,  2 Aug 2014 09:37:10 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 7SwzCDNHx1lWKZGM for <xfs@oss.sgi.com>;
	Sat, 02 Aug 2014 09:37:08 -0700 (PDT)
Message-ID: <53DD13B5.5050000@sandeen.net>
Date: Sat, 02 Aug 2014 11:37:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: avoid double free on xlog_recover_commit_trans error
References: <53DBAE0B.6020000@redhat.com>
In-Reply-To: <53DBAE0B.6020000@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 8/1/14, 10:11 AM, Eric Sandeen wrote:
> xlog_recover_process_data() frees the transaction on
> any error out of the oh_flags switch statement, but
> in the XLOG_COMMIT_TRANS / xlog_recover_commit_trans() case,
> the transaction has already been freed in 
> xlog_recover_commit_trans() before the error is returned.
> 
> Avoid this by only freeing the transaction in
> xlog_recover_commit_trans() if no error will be returned.
> 
> (Coverity spotted this)

Ok, I see that Mark already sent this (thanks Mark, sorry for not
seeing / remembering) and he was scolded for not thinking hard enough
about the problem.  I guess I'm not thinking hard enough either...

Sorry 'bout that.

-Eric

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 981af0f..e634ffd 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3514,9 +3514,11 @@ out:
>  	if (!list_empty(&done_list))
>  		list_splice_init(&done_list, &trans->r_itemq);
>  
> -	xlog_recover_free_trans(trans);
> -
>  	error2 = xfs_buf_delwri_submit(&buffer_list);
> +	/* caller will free trans on error */
> +	if (!error && !error2)
> +		xlog_recover_free_trans(trans);
> +
>  	return error ? error : error2;
>  }
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
