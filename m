Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q44LN3C5091293 for <xfs@oss.sgi.com>; Fri, 4 May 2012 16:23:03 -0500
Date: Fri, 4 May 2012 16:26:30 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/4] xfstests: Add a require_seppquota function
Message-ID: <20120504212630.GZ16881@sgi.com>
References: <20120221165833.23253.38042.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120221165845.23253.658.sendpatchset@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120221165845.23253.658.sendpatchset@chandra-lucid.austin.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 21, 2012 at 10:58:45AM -0600, Chandra Seetharaman wrote:
> >From 6076480613e3034eab9758903c093a0b24048658 Mon Sep 17 00:00:00 2001
> From: Chandra Seetharaman <sekharan@us.ibm.com>
> Date: Wed, 8 Feb 2012 10:04:49 -0600
> Subject: [PATCH 2/3] Add a require_seppquota function in preparation for testing
>  simultaneous use of pquota and gquota in a filesystem
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> ---
>  common.quota |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/common.quota b/common.quota
> index 9736306..16344ea 100644
> --- a/common.quota
> +++ b/common.quota
> @@ -87,6 +87,15 @@ _require_nobody()
>      [ $? -ne 0 ] && _notrun "group file does not contain nobody/nogroup."
>  }
>  
> +#
> +# checks to see if mkfs supports separate pquota
> +#
> +_require_seppquota()
> +{
> +    mkfs.xfs -o test 2>&1 | grep seppquota > /dev/null
                ^^^^^^^

I have a nit to pick about that... FWICS there is no -o option to mkfs.xfs.
Here -o works fine to get usage only because we have not yet defined a mkfs
option for 'o'.  If we were to do that at a later date... who knows?

There isn't a -h option to print usage either.  It looks like the only way to
print usage so you can grep for seppquota is to do something wrong!  I suggest
that you do this instead:

mkfs.xfs 2>&1 | grep seppquota > /dev/null

I think we can be fairly certain that mkfs.xfs with zero args will always be a
safe way to get usage() to kick off.

Other than that silly nit... this looks fine.

Reviewed-by: Ben Myers <bpm@sgi.com>

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
