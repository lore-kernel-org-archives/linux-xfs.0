Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4MDEVPV208783 for <xfs@oss.sgi.com>; Tue, 22 May 2012 08:14:31 -0500
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id DvSjYf61WRPFjXHD for
	<xfs@oss.sgi.com>; Tue, 22 May 2012 06:14:30 -0700 (PDT)
Date: Tue, 22 May 2012 14:14:27 +0100
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Storage server, hung tasks and tracebacks
Message-ID: <20120522131427.GB10660@nsrc.org>
References: <20120502184450.GA2557@nsrc.org>
	<4FA27EF8.6040002@hardwarefreak.com> <20120503204157.GC4387@nsrc.org>
	<4FA3047D.8060908@hardwarefreak.com> <20120504163237.GA6128@nsrc.org>
	<4FA4C321.2070105@hardwarefreak.com> <20120515140237.GA3630@nsrc.org>
	<20120520163506.GA7473@nsrc.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120520163506.GA7473@nsrc.org>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Sun, May 20, 2012 at 05:35:06PM +0100, Brian Candler wrote:
> The main discovery: using ext4 instead of xfs, I cannot get the server to
> lock up - after 36 hours of continuous testing anyway. With xfs and
> everything else identical, it typically locks up within 10 minutes.

I re-ran the test using btrfs (not that I would use it in production, but
just as another comparison).  No lockup after over 24 hours either.

So for now I am converting these boxes to ext4.  I should soon have another
test box with 24 disks that I can reformat as XFS, if something changes and
you'd like me to retest it.

I'd still like to use XFS at some point in the future because this is
running gluster on top, and the gluster people recommend XFS and do most of
their testing with it.

Regards,

Brian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
