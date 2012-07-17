Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6H70AU6054401 for <xfs@oss.sgi.com>; Tue, 17 Jul 2012 02:00:12 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	JDpNeSdt6M5hpT9P (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Jul 2012 00:00:04 -0700 (PDT)
Date: Tue, 17 Jul 2012 03:00:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3] xfs: re-enable xfsaild idle mode and fix associated
	races
Message-ID: <20120717065959.GA29748@infradead.org>
References: <1340880776-45730-1-git-send-email-bfoster@redhat.com>
	<20120702070502.GA25568@infradead.org>
	<20120702082952.GR19223@dastard> <4FF1A74C.1070003@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FF1A74C.1070003@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 02, 2012 at 09:51:08AM -0400, Brian Foster wrote:
> Right... if we wanted to move this back into xfsaild_push(), the only
> way I can see doing that correctly is to move the task state logic down
> into that function as well, at which point the idle logic is now spread
> across two functions. :/
> 
> Considering this patch introduces an independent check for the idle
> logic from the timeout logic (i.e., we use xfs_ail_min() now instead of
> the general scan state of xfsaild_push()), I personally find the
> separation of idle from timeout to be a bit more clear, but of course
> I'll try to implement whatever is most agreeable...

Let's take the patch as-is for 3.6 as we have enough other work in that
area queued.  We can clean it up later if needed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
