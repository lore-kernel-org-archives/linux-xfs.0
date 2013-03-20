Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BAF997F3F
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 09:31:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9A044304039
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 07:31:02 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id anyDIMdFAnCWjXHI for <xfs@oss.sgi.com>;
	Wed, 20 Mar 2013 07:31:01 -0700 (PDT)
Message-ID: <5149C824.8070300@sandeen.net>
Date: Wed, 20 Mar 2013 09:31:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH v2] Count journal size in test 289
References: <1363776648-14061-1-git-send-email-jack@suse.cz>
In-Reply-To: <1363776648-14061-1-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

On 3/20/13 5:50 AM, Jan Kara wrote:
> Test 289 ignored the fact that historically journal is not accounted as
> fs overhead in ext3. For larger filesystems it is hidden in 1% tolerance
> but for filesystems smaller than 12G the test fails. So make the
> counting precise to work everywhere.
> 
> CC: Eric Sandeen <sandeen@sandeen.net>
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks fine, thanks.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>


p.s. - sorry, didn't catch this the first time:

_filter_size_to_bytes won't work for lowercase units, which might
be nice.  How about:

> +	case $suffix in
> +		k|K) mul=1024 ;;
> +		m|M) mul=$((1024*1024)) ;;
> +		g|G) mul=$((1024*1024*1024)) ;;
> +		t|T) mul=$((1024*1024*1024*1024)) ;;
> +	esac

SGI guys - maybe could do that as a small fix-up on commit.  Otherwise, if anyone
ever needs lower case they could just add it at the same time, so no big deal.

-Eric

> ---
>  289           |   16 ++++++++++++----
>  common.filter |   15 +++++++++++++++
>  2 files changed, 27 insertions(+), 4 deletions(-)
> 
> diff --git a/289 b/289
> index b057c20..eb5c63b 100755
> --- a/289
> +++ b/289
> @@ -59,10 +59,18 @@ TOTAL_BLOCKS=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
>  FREE_BLOCKS=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
>  		| awk '/Free blocks:/{print $3}'`
>  
> -# nb: kernels today don't count journal blocks  as overhead, but should.
> -# For most filesystems this will still be within tolerance.
> -# Overhead is all the blocks (already) used by the fs itself:
> -OVERHEAD=$(($TOTAL_BLOCKS-$FREE_BLOCKS))
> +# ext3 doesn't count journal blocks as overhead, ext4 does.
> +if [ $FSTYP = "ext3" ]; then
> +	JOURNAL_SIZE=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
> +		| awk '/Journal size:/{print $3}' | _filter_size_to_bytes`
> +	BLOCK_SIZE=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
> +		| awk '/Block size:/{print $3}'`
> +	JOURNAL_BLOCKS=$(($JOURNAL_SIZE/$BLOCK_SIZE))
> +else
> +	JOURNAL_BLOCKS=0
> +fi
> +
> +OVERHEAD=$(($TOTAL_BLOCKS-$FREE_BLOCKS-$JOURNAL_BLOCKS))
>  
>  #  bsddf|minixdf
>  #         Set the behaviour  for  the  statfs  system  call.  The  minixdf
> diff --git a/common.filter b/common.filter
> index f0f6076..fcd7589 100644
> --- a/common.filter
> +++ b/common.filter
> @@ -229,5 +229,20 @@ _filter_spaces()
>         sed -e 's/ [ ]*/ /g'
>  }
>  
> +# Convert string read from stdin like 128K to bytes and print it to stdout
> +_filter_size_to_bytes()
> +{
> +	read size
> +	suffix=${size:${#size}-1}
> +	mul=1
> +	case $suffix in
> +		K) mul=1024 ;;
> +		M) mul=$((1024*1024)) ;;
> +		G) mul=$((1024*1024*1024)) ;;
> +		T) mul=$((1024*1024*1024*1024)) ;;
> +	esac
> +	echo $((${size:0:${#size}-1}*$mul))
> +}
> +
>  # make sure this script returns success
>  /bin/true
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
