Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9D9vuqo162808 for <xfs@oss.sgi.com>; Thu, 13 Oct 2011 04:57:56 -0500
Subject: Re: [PATCH 2/5] repair: fix a valgrind reported error on i686
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1318208915-14975-3-git-send-email-david@fromorbit.com>
References: <1318208915-14975-1-git-send-email-david@fromorbit.com>
	<1318208915-14975-3-git-send-email-david@fromorbit.com>
Date: Thu, 13 Oct 2011 04:57:52 -0500
Message-ID: <1318499872.3172.10.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: xfs@oss.sgi.com

On Mon, 2011-10-10 at 12:08 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Fix a potential prefetch read problem due to the first loop
> execution of pf_batch_read potentially not initialising the fsbno
> variable:
> 
> ==10177== Thread 6:
> ==10177== Conditional jump or move depends on uninitialised value(s)
> ==10177==    at 0x8079CAB: pf_batch_read (prefetch.c:408)
> ==10177==    by 0x6A2996D: clone (clone.S:130)
> ==10177==
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
