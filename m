Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p53FPigo018182 for <xfs@oss.sgi.com>; Fri, 3 Jun 2011 10:25:44 -0500
Subject: Re: [PATCH] xfstests: Improve test 219 to work with different
	filesystems
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1305805675-13753-1-git-send-email-jack@suse.cz>
References: <1305805675-13753-1-git-send-email-jack@suse.cz>
Date: Fri, 3 Jun 2011 10:25:40 -0500
Message-ID: <1307114740.2886.26.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

On Thu, 2011-05-19 at 13:47 +0200, Jan Kara wrote:
> Different filesystems account different amount of metadata in quota. Thus it is
> impractical to check for a particular amount of space occupied by a file
> because there is no right value. Change the test to verify whether the amount
> of space is between the expected amount of space and the expected amount +5%.
> The number of files is checked exactly as previously.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

I don't know enough about the differences
between filesystem quota reporting.  Perhaps
that's something whose definition should be
better formalized across filesystem types.
In any case I don't outright object to
allowing the 5% variability.

I do have questions/comments about your change,
however.

> ---
>  219 |   25 +++++++++++++++++++++++--
>  1 files changed, 23 insertions(+), 2 deletions(-)
> 
>  Dave, does this look better?
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

Why did you delete this awk line?

> +	if [ $type == 'u' ]; then
> +		id=$uid
> +	else
> +		id=$gid
> +	fi

This (above) seems to be doing a better job of selecting what
we're interested in seeing rather than filtering out anything
owned by root.  Is that what you're doing here?  Does doing
this also eliminate duplicate entries (which I think can occur
when multiple user names share the same UID, for example)?

Regardless, this hunk has nothing to do with the 5% slop
that's the stated purpose of this patch.  It really ought
to have been done as separate (earlier) patch.  Maybe this
isn't a big deal for xfstests but in XFS we try to be more
disciplined about that.

> +	repquota -$type -n $SCRATCH_MNT  | grep "^#$id" | check_usage 144 3
>  }
>  
>  # real QA test starts here



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
