Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q289xYKm007390 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 03:59:34 -0600
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id 7Wl2dpbBUgzJj4WA for
	<xfs@oss.sgi.com>; Thu, 08 Mar 2012 01:59:32 -0800 (PST)
Date: Thu, 8 Mar 2012 09:59:32 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: df bigger than ls?
Message-ID: <20120308095932.GA24187@nsrc.org>
References: <20120307155439.GA23360@nsrc.org>
	<20120307171619.GA23557@nsrc.org> <4F57A32A.5010704@sandeen.net>
	<20120308085035.GA23992@nsrc.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120308085035.GA23992@nsrc.org>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, Mar 08, 2012 at 08:50:35AM +0000, Brian Candler wrote:
> Aha.  This may well be what is screwing up gluster's disk usage on a striped
> volume - I believe XFS is preallocating space which is actually going to end
> up being a hole!

Here is a standalone testcase.

$ for i in {0..19}; do dd if=/dev/zero of=testfile bs=128k count=1 seek=$[$i * 12]; done
$ xfs_bmap testfile
testfile:
	0: [0..255]: 1465133392..1465133647
	1: [256..3071]: hole
	2: [3072..5119]: 1465136464..1465138511
	3: [5120..6143]: hole
	4: [6144..10239]: 1465139536..1465143631
	5: [10240..12287]: hole
	6: [12288..20479]: 1465145680..1465153871
	7: [20480..21503]: hole
	8: [21504..37887]: 1465154896..1465171279
	9: [37888..39935]: hole
	10: [39936..58623]: 1465173328..1465192015

I expected to see: 20 extents of 256 blocks and 19 holes of 2816 blocks.

Regards,

Brian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
