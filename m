Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA8GWR47006476 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 10:32:27 -0600
Date: Thu, 8 Nov 2012 10:34:26 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/6] xfs: fixes for 3.7-rc3
Message-ID: <20121108163426.GM9783@sgi.com>
References: <1351816724-3000-1-git-send-email-david@fromorbit.com>
	<20121107205621.GH6434@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121107205621.GH6434@dastard>
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

Hi Dave,

On Thu, Nov 08, 2012 at 07:56:21AM +1100, Dave Chinner wrote:
> On Fri, Nov 02, 2012 at 11:38:38AM +1100, Dave Chinner wrote:
> > Here are my current outstanding fixes that are candidates for 3.7.
> > Patches 2 and 3 are the initial fixes from the verifier series (real
> > bugs) and the other are regressions that I've recently fixed. Some
> > need to be sent back to stable kernels as well and are tagged as
> > such.
> 
> Hi Ben,
> 
> What's the status with these? It's been almost a week since I posted
> them, and apart from patch 5, they are all good to go to Linus. IMO,
> patch 5 is also good to go as well, but I don't mind if that is not
> sent immediately as that one is not as critical as the others.
> 
> I'm particularly concerned because of the bug that patch 6 fixes -
> it's a real corruption bug that users are hitting we need to get it
> upstream and back into the stable kernels ASAP. But this patch
> hasn't even been committed to the dev tree yet...
> 
> Can you please get these upstream ASAP? If you don't have the time
> to do it today, let me know so I can send the patches straight to
> Linus and get them to the upstream and stable trees that way....

I pulled these in yesterday.  I'll send the pull request this afternoon.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
