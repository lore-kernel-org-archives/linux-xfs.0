Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 680E77F67
	for <xfs@oss.sgi.com>; Fri, 31 Jul 2015 03:10:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 411F4304043
	for <xfs@oss.sgi.com>; Fri, 31 Jul 2015 01:10:02 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id xCwU0xpAX13gnIRd (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 31 Jul 2015 01:10:00 -0700 (PDT)
Date: Fri, 31 Jul 2015 10:09:57 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/10] xfsprogs: use <>-style includes in installed headers
Message-ID: <20150731080957.GA22546@lst.de>
References: <1437927209-31354-1-git-send-email-hch@lst.de>
	<1437927209-31354-7-git-send-email-hch@lst.de>
	<20150731025506.GP16638@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150731025506.GP16638@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Nathan Scott <nathans@debian.org>, xfs@oss.sgi.com

On Fri, Jul 31, 2015 at 12:55:06PM +1000, Dave Chinner wrote:
> I made a small change to pull the creation of include/xfs out of
> include/Makefile and up into include/buildrules where it is done
> before running the install-headers rule on each header subdir,
> and that fixes it. i.e:

Thanks, this looks sensible to me.

> Now I've just got to work out which patch is breaking 'make deb'....

"packaging: rework dh_autoreconf invocation for deb builds" is the
culprit..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
