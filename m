Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 436AD7F3F
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 17:39:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2C2E78F8050
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 15:39:04 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	9iTA55jO6ECZmTsP for <xfs@oss.sgi.com>;
	Mon, 16 Sep 2013 15:39:00 -0700 (PDT)
Date: Tue, 17 Sep 2013 08:38:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs: update version for 3.2.0-alpha1
Message-ID: <20130916223855.GF19103@dastard>
References: <20130916205637.GD1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130916205637.GD1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: rjohnston@sgi.com, sandeen@sandeen.net, xfs@oss.sgi.com

On Mon, Sep 16, 2013 at 03:56:37PM -0500, Ben Myers wrote:
> xfsprogs: update version for 3.2.0-alpha1

I'd say this is a major feature and infrastructure
update across the entire xfsprogs package, and in that case a
PKG_MAJOR bump is warranted, not PKG_MINOR.

i.e. We're shooting for a 4.0 release, not 3.2...

> 
> Update the VERSION and doc/CHANGES file for alpha release, 3.2.0-alpha1
> 
> Signed-off-by: Ben Myers <bpm@sgi.com>
> Reviewed-by: Rich Johnston <rjohnston@sgi.com>
> 
> ---
>  VERSION      |    4 ++--
>  configure.ac |    2 +-
>  doc/CHANGES  |    4 ++++
>  3 files changed, 7 insertions(+), 3 deletions(-)
> 
> Index: b/VERSION
> ===================================================================
> --- a/VERSION	2013-09-16 15:50:29.544368912 -0500
> +++ b/VERSION	2013-09-16 15:50:37.993732514 -0500
> @@ -2,6 +2,6 @@
>  # This file is used by configure to get version information
>  #
>  PKG_MAJOR=3
> -PKG_MINOR=1
> -PKG_REVISION=11
> +PKG_MINOR=2
> +PKG_REVISION=0-alpha1

To make it easy for packaging, 3.99.0 would probably fit better with
various distro package naming/numbering schemes...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
