Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A7A1D7F54
	for <xfs@oss.sgi.com>; Thu, 14 May 2015 10:02:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9AED7304032
	for <xfs@oss.sgi.com>; Thu, 14 May 2015 08:02:35 -0700 (PDT)
Received: from mail-qk0-f177.google.com (mail-qk0-f177.google.com
	[209.85.220.177]) by cuda.sgi.com with ESMTP id
	rSFIYSBrJBWnDmuW (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 May 2015 08:02:34 -0700 (PDT)
Received: by qkgx75 with SMTP id x75so51062692qkg.1
	for <xfs@oss.sgi.com>; Thu, 14 May 2015 08:02:33 -0700 (PDT)
Date: Thu, 14 May 2015 11:02:30 -0400
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] percpu_counter: batch size aware
	__percpu_counter_compare()
Message-ID: <20150514150230.GF11388@htj.duckdns.org>
References: <1431474754-15764-1-git-send-email-david@fromorbit.com>
	<1431474754-15764-2-git-send-email-david@fromorbit.com>
	<20150513135919.GS11388@htj.duckdns.org>
	<20150514005553.GD4316@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150514005553.GD4316@dastard>
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
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, May 14, 2015 at 10:55:53AM +1000, Dave Chinner wrote:
> percpu_counter: batch size aware __percpu_counter_compare()
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> XFS uses non-stanard batch sizes for avoiding frequent global
> counter updates on it's allocated inode counters, as they increment
> or decrement in batches of 64 inodes. Hence the standard percpu
> counter batch of 32 means that the counter is effectively a global
> counter. Currently Xfs uses a batch size of 128 so that it doesn't
> take the global lock on every single modification.
> 
> However, Xfs also needs to compare accurately against zero, which
> means we need to use percpu_counter_compare(), and that has a
> hard-coded batch size of 32, and hence will spuriously fail to
> detect when it is supposed to use precise comparisons and hence
> the accounting goes wrong.
> 
> Add __percpu_counter_compare() to take a custom batch size so we can
> use it sanely in XFS and factor percpu_counter_compare() to use it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Please feel free to route the patch however you see fit.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
