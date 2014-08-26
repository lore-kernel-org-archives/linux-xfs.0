Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B63C47F3F
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2014 07:41:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 437BCAC001
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2014 05:41:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id g6edWQN5ioFBzd6w (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 26 Aug 2014 05:41:00 -0700 (PDT)
Date: Tue, 26 Aug 2014 08:40:55 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC, PATCH 0/4] xfs: clean up xlog_recover_process_data
Message-ID: <20140826124055.GA52815@bfoster.bfoster>
References: <1409016101-9511-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1409016101-9511-1-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Tue, Aug 26, 2014 at 11:21:37AM +1000, Dave Chinner wrote:
> Hi folks,
> 
> The log recovery use-after-free that Brian posted a patch for has
> had several previous attempts sent and none have completed review.
> So let's put this one to bed for good.
> 
> This patch set addresses the previous review feedback for fixing
> this problem. It factors xlog_recover_process_data() to make it
> cleaner and isolate the context of the transaction recvoery
> structure that is causing problems. It fixes a leak of the structure
> in an error condition that I noticed while factoring, as well as the
> double free that Brian and others have identified and tried to fix
> in the past. It then re-arranges the recovery item management code
> to put it all in one place, rather than in 3 separate parts of the
> file separated by several hundred lines of unrelated code.
> 
> Comments?
> 

This looks pretty good to me. I like the cleanups and it fixes the
problem. A few minor comments/questions to follow.

Brian

> -Dave.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
