Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 93AF229DF8
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 11:17:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 579A4304053
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 09:17:43 -0700 (PDT)
Received: from na3sys009aog104.obsmtp.com (na3sys009aog104.obsmtp.com
	[74.125.149.73]) by cuda.sgi.com with SMTP id 5AWXxYFW8wm2eXGl
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 11 Jun 2013 09:17:41 -0700 (PDT)
Received: by mail-ob0-f174.google.com with SMTP id wd20so12048185obb.33
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 09:17:41 -0700 (PDT)
Date: Tue, 11 Jun 2013 11:17:35 -0500
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: Re: 3.10-rc4 stalls during mmap writes
Message-ID: <20130611161735.GA3955@sbohrermbp13-local.rgmadvisors.com>
References: <20130607193712.GD2995@sbohrermbp13-local.rgmadvisors.com>
	<20130609033744.GA29376@dastard>
	<20130610184559.GA3594@sbohrermbp13-local.rgmadvisors.com>
	<20130610205315.GB29376@dastard>
MIME-Version: 1.0
In-Reply-To: <20130610205315.GB29376@dastard>
Content-Disposition: inline
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
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jun 11, 2013 at 06:53:15AM +1000, Dave Chinner wrote:
> On Mon, Jun 10, 2013 at 01:45:59PM -0500, Shawn Bohrer wrote:
> > On Sun, Jun 09, 2013 at 01:37:44PM +1000, Dave Chinner wrote:
> > > On Fri, Jun 07, 2013 at 02:37:12PM -0500, Shawn Bohrer wrote:
> > So to summarize it appears that most of the time was spent with
> > kworker/4:0 blocking in xfs_buf_lock() and kworker/2:1H, which is woken
> > up by a softirq, is the one that calls xfs_buf_unlock().  Assuming I'm
> > not missing some important intermediate steps does this provide any
> > more information about what resource I'm actually waiting for?  Does
> > this point to any changes that happened after 3.4?  Are there any tips
> > that could help minimize these contentions?
> 
> The only difference between this and 3.4 is the allocation workqueue
> thread. That, however, won't be introducing second long delays. What
> you are seeing here is simply a the latency of waiting for
> background metadata IO to complete during an allocation which has
> the ilock held....

Again thank you for your analysis Dave.  I've taken a step back to
look at the big picture and that allowed me to identify what _has_
changed between 3.4 and 3.10.  What changed is the behavior of
vm.dirty_expire_centisecs.  Honestly, the previous behavior never made
any sense to me and I'm not entirely sure the current behavior does
either.

In the workload I've been debugging we append data to many small files
using mmap.  The writes are small and the total data rate is very low
thus for most files it may take several minutes to fill a page.
Having low-latency writes are important, but as you know stalls are
always possible.  One way to reduce the probability of a stall is to
reduce the frequency of writeback, and adjusting
vm.dirty_expire_centisecs and/or vm.dirty_writeback_centisecs should
allow us to do that.

On kernels 3.4 and older we chose to increase
vm.dirty_expire_centisecs to 30000 since we can comfortably loose 5
minutes of data in the event of a system failure and we believed this
would cause a fairly consistent low data rate as every
vm.dirty_writeback_centisecs (5s) it would writeback all dirty pages
that were vm.dirty_expire_centisecs (5min) old.  On old kernels that
isn't exactly what happened.  Instead every 5 minutes there would be a
burst of writeback and a slow trickle at all other times.  This also
reduced the total amount of data written back since the same dirty
page wasn't written back every 30 seconds.  This also virtually
eliminated the stalls we saw so it was left alone.

On 3.10 vm.dirty_expire_centisecs=30000 no longer does the same thing.
Honestly I'm not sure what it does, but the result is a fairly
consistent high data rate being written back to disk.  The fact that
is consistent might lead me to believe that it writes back all pages
that are vm.dirty_expire_centisecs old every
vm.dirty_writeback_centisecs, but the data rate is far too high for
that to be true.  It appears that I can effectively get the same old
behavior by setting vm.dirty_writeback_centisecs=30000.

--
Shawn

-- 

---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
