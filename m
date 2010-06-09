Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o59L8ShX032601 for <xfs@oss.sgi.com>; Wed, 9 Jun 2010 16:08:28 -0500
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AFE071591985
	for <xfs@oss.sgi.com>; Wed,  9 Jun 2010 14:14:03 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org
	[140.211.169.13]) by cuda.sgi.com with ESMTP id
	lvualAShKuyTzayy for <xfs@oss.sgi.com>;
	Wed, 09 Jun 2010 14:14:03 -0700 (PDT)
Date: Wed, 9 Jun 2010 14:10:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] xfs: remove nr_to_write writeback windup.
Message-Id: <20100609141026.977baebf.akpm@linux-foundation.org>
In-Reply-To: <1276043840-1946-3-git-send-email-david@fromorbit.com>
References: <1276043840-1946-1-git-send-email-david@fromorbit.com>
	<1276043840-1946-3-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, stable@kernel.org, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed,  9 Jun 2010 10:37:19 +1000
Dave Chinner <david@fromorbit.com> wrote:

> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that the background flush code has been fixed, we shouldn't need to
> silently multiply the wbc->nr_to_write to get good writeback. Remove
> that code.
> 

And anyone who merges [1/3] will want to merge this.  Otherwise they
might suffer adverse effects ;)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
