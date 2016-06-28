Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 673367CA4
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 08:38:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2E9568F8033
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 06:38:14 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id tAA41R66bOjxqnN8 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 28 Jun 2016 06:38:12 -0700 (PDT)
Date: Tue, 28 Jun 2016 15:38:11 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: iomap infrastructure and multipage writes V5
Message-ID: <20160628133811.GA31283@lst.de>
References: <1464792297-13185-1-git-send-email-hch@lst.de>
	<20160628002649.GI12670@dastard> <20160628132839.GA30892@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160628132839.GA30892@lst.de>
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
Cc: rpeterso@redhat.com, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, Jun 28, 2016 at 03:28:39PM +0200, Christoph Hellwig wrote:
> > generic/224 on my 1p/1GB RAM VM using a 1k lock size filesystem has
> > significantly different behaviour once ENOSPC is hit withi this patchset.
> 
> Works fine on my 1k test setup with 4 CPUs and 2GB RAM.  1 CPU and 1GB
> RAM runs into the OOM killer, although I haven't checked if that was
> the case with the old code as well.  I'll look into this more later
> today or tomorrow.

It was doing fine before my changes - I'm going to investigate what
caused the change in behavior.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
