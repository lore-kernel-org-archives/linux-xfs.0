Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oATC6nKg156112 for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 06:06:50 -0600
Received: from casper.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2BD6513F80B3
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 04:08:30 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id CBEyzdME7FJjH6Qe for
	<xfs@oss.sgi.com>; Mon, 29 Nov 2010 04:08:30 -0800 (PST)
Subject: Re: [PATCH 1/3] lib: percpu counter add unless less than functionality
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1290991002-18680-2-git-send-email-david@fromorbit.com>
References: <1290991002-18680-1-git-send-email-david@fromorbit.com>
	<1290991002-18680-2-git-send-email-david@fromorbit.com>
Date: Mon, 29 Nov 2010 13:08:50 +0100
Message-ID: <1291032530.32004.26.camel@laptop>
Mime-Version: 1.0
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
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, 2010-11-29 at 11:36 +1100, Dave Chinner wrote:
> +int percpu_counter_add_unless_lt(struct percpu_counter *fbc, s64 amount,
> +                                                       s64 threshold);

It might make sense to implement that as;

  __percpu_counter_add_unless_lt(struct percpu_counter *fbc,
				 s64 amount,
				 s64 threshold,
				 s32 batch);

That way its consistent with the __percpu_counter_add() implementation
where you can also specify the batch value.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
