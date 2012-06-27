Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5R2736n161515 for <xfs@oss.sgi.com>; Tue, 26 Jun 2012 21:07:03 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6F433mD2dB6jHvIR for
	<xfs@oss.sgi.com>; Tue, 26 Jun 2012 19:07:02 -0700 (PDT)
Message-ID: <4FEA6AA4.1@redhat.com>
Date: Tue, 26 Jun 2012 22:06:28 -0400
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: mkfs.xfs states log stripe unit is too large
References: <D3F781FA-CEB0-4896-9441-772A9E533354@2012.bluespice.org>
	<20120623234445.GZ19223@dastard> <4FE67970.2030008@sandeen.net>
	<4FE710B7.5010704@hardwarefreak.com>
	<d71834a062ffd666ab53a4695eb643e9@muaddib.hro.localnet>
	<20120626023059.GC19223@dastard>
In-Reply-To: <20120626023059.GC19223@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: =?ISO-8859-1?Q?Ingo_J=FCrgensmann?= <ij@2012.bluespice.org>, xfs@oss.sgi.com

On 6/25/12 10:30 PM, Dave Chinner wrote:

...

> Without the warning, nobody would have noticed this. I think the
> warning has value - even if it is just to indicate MD now uses a
> bad default value for common workloads..

Fair enough.

log stripe unit (524288 bytes) is too large (maximum is 256KiB)
log stripe unit adjusted to 32KiB

It just tweaked me a little to complain about something the user didn't specify, but thinking about it from the perspective of letting the user know that the _device_ has a stripe unit larger than xfs can handle makes sense.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
