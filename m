Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBTLlKBh131643 for <xfs@oss.sgi.com>; Wed, 29 Dec 2010 15:47:20 -0600
Subject: Re: [PATCH 1/5] percpu_counter: fix test in
	__percpu_counter_add_unless_lt()
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1293656188.1961.470.camel@doink>
References: <1293076575.2408.425.camel@doink>
	<20101223060652.GE18264@dastard>  <1293656188.1961.470.camel@doink>
Date: Wed, 29 Dec 2010 15:49:20 -0600
Message-ID: <1293659360.1961.474.camel@doink>
Mime-Version: 1.0
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
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Wed, 2010-12-29 at 14:56 -0600, Alex Elder wrote:
>         if (new_count >= threshold) {
>                 ret = new_count > threshold;
>                 fbc->count = fbc_count + amount;
>         } 
>         spin_unlock(&fbc->lock);
> 
>         return ret;
> } 

I obviously didn't test the code I sent, but
you get what I mean...  Here is the way one of
the lines above should look:
                fbc->count = fbc->count + amount;

Or even better:
                fbc->count += amount;

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
