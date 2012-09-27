Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8R0IrkW013496 for <xfs@oss.sgi.com>; Wed, 26 Sep 2012 19:18:53 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	6RZxczEXzay2YTOS for <xfs@oss.sgi.com>;
	Wed, 26 Sep 2012 17:20:11 -0700 (PDT)
Date: Thu, 27 Sep 2012 10:19:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] xfstests: add fio requirement V2
Message-ID: <20120927001959.GE15236@dastard>
References: <1348496601-32637-1-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1348496601-32637-1-git-send-email-dmonakhov@openvz.org>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, hch@lst.de, xfs@oss.sgi.com

On Mon, Sep 24, 2012 at 06:23:16PM +0400, Dmitry Monakhov wrote:
> FIO is very flexible io generator, i would call it IO swiss knife.
> Currently we have tonns of hardcoded application which reproduces
> some predefined scenario. This approach has obvious dissadvantages
> 1) Lack of flexability: one written it is hard to modify it in future
> 2) Code base is large, many routines written again and again
> 
> At the same time add new fio based tast is just add simle INI file.
> This greatly simplify code review. I do beleve that some day we will
> replace most of hardcoded io binaries with fio.
> 
> One who is planning to run $FIO_PROG should first check that system
> contains appropriate version which is able to handle jobfile
> for example:  _require_fio 286-job.fio
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
