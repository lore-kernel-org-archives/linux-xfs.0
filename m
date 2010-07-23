Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6N6DKIh185783 for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 01:13:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7E78A1B8EEA1
	for <xfs@oss.sgi.com>; Thu, 22 Jul 2010 23:16:22 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id sYzNS2cyXIjZxjoW for
	<xfs@oss.sgi.com>; Thu, 22 Jul 2010 23:16:22 -0700 (PDT)
Date: Fri, 23 Jul 2010 02:16:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfsprogs: CFLAGS not passed in
Message-ID: <20100723061607.GA423@infradead.org>
References: <201007220821.44314@zmi.at>
 <20100722222900.GB32635@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100722222900.GB32635@dastard>
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
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

On Fri, Jul 23, 2010 at 08:29:00AM +1000, Dave Chinner wrote:
> The OPTIMIZER compile options are still included here, so there's
> potential conflict just by dumbly initialising CFLAGS....

Given that gcc always takes the latests of a set of conflicting option
just aqdding the flags from configure last should fix it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
