Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o13KogGQ243761 for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 14:50:42 -0600
Date: Wed, 3 Feb 2010 15:51:51 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstests: 219: fix awk filter for duplicate users
Message-ID: <20100203205151.GA11337@infradead.org>
References: <1265226844.2848.27.camel@doink1>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1265226844.2848.27.camel@doink1>
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

On Wed, Feb 03, 2010 at 01:54:04PM -0600, Alex Elder wrote:
> The filter I added for removing duplicate users from the
> output of repquota didn't do the job very well.  This
> fixes that, making it so the first time a user is seen
> its line is printed, not thereafter.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>
> 
> ---
>  219 |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/219
> ===================================================================
> --- a/219
> +++ b/219
> @@ -86,7 +86,7 @@ test_accounting()
>         done
> 
>         repquota -$type -s -n $SCRATCH_MNT  | grep -v "^#0" |
> filter_scratch |
> -       awk '/^#/ { if (! seen[$1]) { seen[$1]++; next; } } { print }'
> +       awk '/^#/ { if (seen[$1]) next; seen[$1]++; } } { print; }'

The patch seems whitespace damages, and there's a "}" too many in
the added line.  After fixing that up 219 passes again for me.

So more or less:


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
