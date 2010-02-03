Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o13Kgk86243532 for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 14:42:46 -0600
Message-ID: <4B69E006.9020807@sandeen.net>
Date: Wed, 03 Feb 2010 14:43:50 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfstests: 219: fix awk filter for duplicate users
References: <1265226844.2848.27.camel@doink1>
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
To: aelder@sgi.com
Cc: xfs@oss.sgi.com

Alex Elder wrote:
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
>  }


+awk: /^#/ { if (seen[$1]) next; seen[$1]++; } } { print; }
+awk:                                          ^ syntax error


but thanks for making me feel better ;)

w/o the extra "}" it works for me.

(incidentally is a line continuation " \ " needed too?  I guess
it works without...)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
