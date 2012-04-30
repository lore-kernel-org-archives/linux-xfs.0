Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3UN4bdX046459 for <xfs@oss.sgi.com>; Mon, 30 Apr 2012 18:04:37 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	d95FTtw82iIecAZJ for <xfs@oss.sgi.com>;
	Mon, 30 Apr 2012 16:04:35 -0700 (PDT)
Date: Tue, 1 May 2012 09:04:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/37] xfs: current 3.4 patch queue
Message-ID: <20120430230433.GM7015@dastard>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<20120428021546.GI16881@sgi.com> <20120429001439.GN9541@dastard>
	<20120430144423.GN16881@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120430144423.GN16881@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Apr 30, 2012 at 09:44:23AM -0500, Ben Myers wrote:
> On Sun, Apr 29, 2012 at 10:14:39AM +1000, Dave Chinner wrote:
> > On Fri, Apr 27, 2012 at 09:15:46PM -0500, Ben Myers wrote:
> > > I'm also testing this patch set them without Jan's work, since I'm not sure when
> > > it will be pulled in.  Here's the latest:
> > > 
> > > case login: [ 2934.077472] BUG: unable to handle kernel paging request at ffffc900036a8010
> > > [ 2934.078452] IP: [<ffffffffa009a790>] xlog_get_lowest_lsn+0x30/0x80 [xfs]
> > > [ 2934.078452] PGD 12b029067 PUD 12b02a067 PMD 378f5067 PTE 0
> > > [ 2934.078452] Oops: 0000 [#1] SMP
> > > [ 2934.078452] CPU 1
> > > [ 2934.078452] Modules linked in: xfs(O) exportfs e1000e [last unloaded: xfs]
> > > [ 2934.078452]
> > > [ 2934.078452] Pid: 9031, comm: kworker/1:15 Tainted: G           O 3.4.0-rc2+ #3 SGI.COM AltixXE310/X7DGT-INF
> > 
> > What out-of-tree module do you have loaded that tainted the kernel?
> > The ethernet driver?
> 
> I tend to build xfs out of tree and then 'insmod ./xfs.ko'.

Ok, do you rmmod the xfs.ko module and insert new ones, or just
reboot whenever you have a new module for testing? I'm assuming that
you are unloading and reloading based on the "[last unloaded: xfs]"
above. That has always made me nervous about memory corruption
intorudced by a previous module affecting the running of a current
module....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
