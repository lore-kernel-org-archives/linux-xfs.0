Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p53BSHAQ010324 for <xfs@oss.sgi.com>; Fri, 3 Jun 2011 06:28:17 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A52FB1E3C018
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2011 04:28:15 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id A2fHjszgY8dozmnc for <xfs@oss.sgi.com>;
	Fri, 03 Jun 2011 04:28:15 -0700 (PDT)
Date: Fri, 3 Jun 2011 13:27:56 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] xfstests: Improve test 219 to work with different
	filesystems
Message-ID: <20110603112756.GA4789@quack.suse.cz>
References: <1305805675-13753-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1305805675-13753-1-git-send-email-jack@suse.cz>
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
To: xfs@oss.sgi.com
Cc: Jan Kara <jack@suse.cz>

On Thu 19-05-11 13:47:55, Jan Kara wrote:
> Different filesystems account different amount of metadata in quota. Thus it is
> impractical to check for a particular amount of space occupied by a file
> because there is no right value. Change the test to verify whether the amount
> of space is between the expected amount of space and the expected amount +5%.
> The number of files is checked exactly as previously.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  219 |   25 +++++++++++++++++++++++--
>  1 files changed, 23 insertions(+), 2 deletions(-)
> 
>  Dave, does this look better?
  Any reaction on this?

								Honza
> 
> diff --git a/219 b/219
> index 836d703..ad4e64d 100755
> --- a/219
> +++ b/219
> @@ -58,6 +58,23 @@ test_files()
>  	done
>  }
>  
> +check_usage()
> +{
> +	wroteblocks=$1
> +	wrotefiles=$2
> +	read id exceed blocks bsoft bhard inodes isoft ihard
> +	if [ "$blocks" -lt "$wroteblocks" ]; then
> +		echo "Too few blocks used (type=$type)"
> +	# Save 5% for overhead of metadata or different block size
> +	elif [ "$blocks" -gt $((wroteblocks+wroteblocks/20)) ]; then
> +		echo "Too many blocks used (type=$type)"
> +	elif [ "$inodes" != "$wrotefiles" ]; then
> +		echo "Bad number of inodes used (type=$type)"
> +	else
> +		echo "Usage OK (type=$type)"
> +	fi
> +}
> +
>  test_accounting()
>  {
>  	echo "### some controlled buffered, direct and mmapd IO (type=$type)"
> @@ -77,8 +94,12 @@ test_accounting()
>  		$here/src/lstat64 $file | head -3 | _filter_scratch
>  	done
>  
> -	repquota -$type -n $SCRATCH_MNT  | grep -v "^#0" | _filter_scratch |
> -	awk '/^#/ { if (seen[$1]) next; seen[$1]++; } { print; }'
> +	if [ $type == 'u' ]; then
> +		id=$uid
> +	else
> +		id=$gid
> +	fi
> +	repquota -$type -n $SCRATCH_MNT  | grep "^#$id" | check_usage 144 3
>  }
>  
>  # real QA test starts here
> -- 
> 1.7.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
