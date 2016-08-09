Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 08FC27CA2
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 16:49:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 81460AC002
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 14:49:15 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	9F946TSam1B3er3V for <xfs@oss.sgi.com>;
	Tue, 09 Aug 2016 14:49:12 -0700 (PDT)
Date: Wed, 10 Aug 2016 07:49:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH xfsprogs] libxcmd: link against used libs
Message-ID: <20160809214910.GI19025@dastard>
References: <20160809144343.2228-1-vapier@gentoo.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160809144343.2228-1-vapier@gentoo.org>
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
To: Mike Frysinger <vapier@gentoo.org>
Cc: xfs@oss.sgi.com

On Tue, Aug 09, 2016 at 10:43:43PM +0800, Mike Frysinger wrote:
> Since this lib uses symbols from libxfs (platform_findsizes) and many
> symbols from libblkid, link against both.  Otherwise, the resulting
> shared lib has missing symbols which makes linking against annoying.

libxcmd is an internal library, linked directly into the xfsprogs
binaries. It is never shipped or used outside xfsprogs, so what is
trying to use libxcmd as a shared library that doesn't also link
against libblkid or libxfs?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
