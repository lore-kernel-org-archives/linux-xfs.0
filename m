Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o58KM8Tj023224 for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 15:22:08 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DC9F011B1CF6
	for <xfs@oss.sgi.com>; Thu, 29 Jul 2010 21:07:34 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	6oG1FOwfY692HiFf for <xfs@oss.sgi.com>;
	Thu, 29 Jul 2010 21:07:34 -0700 (PDT)
Date: Fri, 30 Jul 2010 13:59:55 +1000
From: Nick Piggin <npiggin@kernel.dk>
Subject: Re: XFS hang in xlog_grant_log_space
Message-ID: <20100730035955.GA5271@amd>
References: <20100722190100.GA22269@amd> <20100723135514.GJ32635@dastard>
	<20100727070538.GA2893@amd> <20100727080632.GA4958@amd>
	<20100727113626.GA2884@amd> <20100727133038.GP7362@dastard>
	<20100727145808.GQ7362@dastard> <20100728131744.GS7362@dastard>
	<20100729140546.GB7217@amd> <20100729225658.GM655@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100729225658.GM655@dastard>
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
Cc: Nick Piggin <npiggin@suse.de>, Nick Piggin <npiggin@kernel.dk>, xfs@oss.sgi.com

On Fri, Jul 30, 2010 at 08:56:58AM +1000, Dave Chinner wrote:
> On Fri, Jul 30, 2010 at 12:05:46AM +1000, Nick Piggin wrote:
> > On Wed, Jul 28, 2010 at 11:17:44PM +1000, Dave Chinner wrote:
> > > Something very strange is happening, and to make matters worse I
> > > cannot reproduce it with a debug kernel (ran for 3 hours without
> > > failing). Hence it smells like a race condition somewhere.
> > > 
> > > I've reproduced it without delayed logging, so it is not directly
> > > related to that functionality.
> > > 
> > > I've seen this warning:
> > > 
> > > Filesystem "ram0": inode 0x704680 background reclaim flush failed with 117
> > > 
> > > Which indicates we failed to mark an inode stale when freeing an
> > > inode cluster, but I think I've fixed that and the problem still
> > > shows up. It's posible the last version didn't fix it, but....
> > 
> > I've seen that one a couple of times too. Keeps coming back each
> > time you echo 3 > /proc/sys/vm/drop_caches :)
> 
> Yup - it's an unflushable inode that is pinning the tail of the log,
> hence causing the log space hangs.
> 
> > > Now I've got the ag iterator rotor patch in place as well and
> > > possibly a different version of the cluster free fix to what I
> > > previously tested and it's now been running for almost half an hour.
> > > I can't say yet whether I've fixed the bug of just changed the
> > > timing enough to avoid it. I'll leave this test running over night
> > > and redo individual patch testing tomorrow.
> > 
> > I reproduced it with fs_stress now too. Any patches I could test
> > for you just let me know.
> 
> You should see them in a few minutes ;)

It's certainly not locking up like it used to... Thanks!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
