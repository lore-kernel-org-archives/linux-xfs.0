Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0ALHRKa049088 for <xfs@oss.sgi.com>; Sun, 10 Jan 2010 15:17:29 -0600
Date: Sun, 10 Jan 2010 16:18:21 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfstests: 219: ignore duplicates reported by repquota
Message-ID: <20100110211821.GA28166@infradead.org>
References: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6942@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6942@cf--amer001e--3.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Sun, Jan 10, 2010 at 01:26:32PM -0600, Alex Elder wrote:
> (Re-sending; I misaddressed it the first time.)
> 
> Arrange to ignore duplicate entries reported by the repquota command.
> This can happen if an id is used more than once (such as when two user
> names are assigned the same uid).
> 
> Do this here by simply dropping any reported entries whose id number
> has already been seen in the output.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>
> 
> ---
>  219 |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: b/219
> ===================================================================
> --- a/219
> +++ b/219
> @@ -85,7 +85,8 @@ test_accounting()
>  		$here/src/lstat64 $file | head -3 | filter_scratch
>  	done
>  
> -	repquota -$type -s -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch
> +	repquota -$type -s -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch |
> +	awk '/^#/ { if (! seen[$1]) { seen[$1]++; next; } } { print }'

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
