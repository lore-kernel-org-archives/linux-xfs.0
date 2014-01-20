Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 98E497F72
	for <xfs@oss.sgi.com>; Sun, 19 Jan 2014 20:25:22 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1E8C4AC005
	for <xfs@oss.sgi.com>; Sun, 19 Jan 2014 18:25:21 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	BYFDKmTLvWOsDbBL for <xfs@oss.sgi.com>;
	Sun, 19 Jan 2014 18:25:19 -0800 (PST)
Date: Mon, 20 Jan 2014 13:25:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/5] xfstests: don't suggest to run full diff when
	DIFF_LENGTH is 0
Message-ID: <20140120022514.GH18112@dastard>
References: <cover.1389891730.git.dsterba@suse.cz>
	<49b0cf305ade3444c3dcf3fbabb5e1e5e720c16d.1389891730.git.dsterba@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49b0cf305ade3444c3dcf3fbabb5e1e5e720c16d.1389891730.git.dsterba@suse.cz>
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
To: David Sterba <dsterba@suse.cz>
Cc: xfs@oss.sgi.com

On Thu, Jan 16, 2014 at 06:07:13PM +0100, David Sterba wrote:
> If DIFF_LENGTH is set to 0, the full output is available and the message
> does not make sense.
> 
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>  check | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/check b/check
> index 9e4275b1fa37..d578e49b78d4 100755
> --- a/check
> +++ b/check
> @@ -510,11 +510,11 @@ do
>  				cat
>  			else
>  				head -n "$DIFF_LENGTH"
> +				echo "..."
> +				echo "(Run '$diff $seq.out $seqres.out.bad'"
> +					" to see the entire diff)"

You're missing a trailing "\" there. Even simple patches need
testing. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
