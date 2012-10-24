Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9OKtm6w054990 for <xfs@oss.sgi.com>; Wed, 24 Oct 2012 15:55:48 -0500
Received: from mail-vb0-f53.google.com (mail-vb0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id UTN1DIUI1vrFoL3w
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 24 Oct 2012 13:57:33 -0700 (PDT)
Received: by mail-vb0-f53.google.com with SMTP id fc21so1082400vbb.26
	for <xfs@oss.sgi.com>; Wed, 24 Oct 2012 13:57:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120925094013.GI9189@infradead.org>
References: <143becf0f8266fbc8025ec97c8f44476d8fcafc5.1348203015.git.rprabhu@wnohang.net>
	<20120925094013.GI9189@infradead.org>
Date: Thu, 25 Oct 2012 02:27:31 +0530
Message-ID: <CAEtq3tNGSatvn2XGXg=O+OQGPPMVGhDcFN9szBoSZtRQ8XggmA@mail.gmail.com>
Subject: Re: [PATCH v6] Stop periodic syncing if filesystem is already
	shutdown.
From: Raghavendra Prabhu <raghu.prabhu13@gmail.com>
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
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, Raghavendra D Prabhu <rprabhu@wnohang.net>

Thank you. Are there any comments on this patch or has is it been acked?

On Tue, Sep 25, 2012 at 3:10 PM, Christoph Hellwig <hch@infradead.org> wrote:
> Looks good, but one thing I'd love here is to actually print a useful
> error for the typical EIO case, as the "error 5 occured" message just
> confuses the heck out of people.  What it means is that we got an
> EIO error from the block device, and that's what we should print.
>
> Probably worth doing in a separate patch, so:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
