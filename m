Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 588597CBF
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 16:57:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BC784AC009
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 14:57:43 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ZIzINHW4MQi0wK2g for <xfs@oss.sgi.com>;
	Tue, 26 Feb 2013 14:57:42 -0800 (PST)
Date: Wed, 27 Feb 2013 09:57:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: use native definition of O_DIRECT flag
Message-ID: <20130226225718.GW5551@dastard>
References: <20130226210322.GB5275@wallace>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130226210322.GB5275@wallace>
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
To: Eric Whitney <enwlinux@gmail.com>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Tue, Feb 26, 2013 at 04:03:22PM -0500, Eric Whitney wrote:
> The definition of O_DIRECT in src/trunc.c causes xfstest 125 to fail
> when run on a Pandaboard.  On ARM, the value used (0x040000) is
> O_DIRECTORY rather than O_DIRECT as it is on x86.  Prefer the platform's
> native definition of O_DIRECT supplied by fcntl.h if available.  Also,
> fix a couple of error messages to properly reflect their context.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
