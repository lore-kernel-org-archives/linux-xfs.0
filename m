Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 312767F56
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 17:52:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 092A3304059
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 15:52:38 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	f1f8piuPlRz1u3xg for <xfs@oss.sgi.com>;
	Thu, 10 Apr 2014 15:52:37 -0700 (PDT)
Date: Fri, 11 Apr 2014 08:52:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs i_lock vs mmap_sem lockdep trace.
Message-ID: <20140410225234.GF27519@dastard>
References: <20140329223109.GA24098@redhat.com>
	<20140330234335.GB16336@dastard>
	<20140330235717.GO18016@ZenIV.linux.org.uk>
	<20140331004053.GA17603@dastard> <53445EC0.9060707@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53445EC0.9060707@oracle.com>
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
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Dave Jones <davej@redhat.com>, xfs@oss.sgi.com, Al Viro <viro@ZenIV.linux.org.uk>, Linux Kernel <linux-kernel@vger.kernel.org>

On Tue, Apr 08, 2014 at 04:40:32PM -0400, Sasha Levin wrote:
> On 03/30/2014 08:40 PM, Dave Chinner wrote:
> > On Mon, Mar 31, 2014 at 12:57:17AM +0100, Al Viro wrote:
> >> > On Mon, Mar 31, 2014 at 10:43:35AM +1100, Dave Chinner wrote:
> >>> > > filldir on a directory inode vs page fault on regular file. Known
> >>> > > issue, definitely a false positive. We have to change locking
> >>> > > algorithms to avoid such deficiencies of lockdep (a case of "lockdep
> >>> > > considered harmful", perhaps?) so it's not something I'm about to
> >>> > > rush...
> >> > 
> >> > Give i_lock on directories a separate class, as it's been done for i_mutex...
> > Already done that. Commit:
> > 
> > 93a8614 xfs: fix directory inode iolock lockdep false positive
> 
> Hi Dave,
> 
> The commit above introduces a new lockdep issue for me:

Right, it's fixed one class of false positive which uncovers the
next class of false positive. lockdep gives me the shits at times
because every time we make some obviously correct locking change
to the XFS inodes we then spend the next 3-4 kernel releases chasing
down and annotating locks so that lockdep doesn't throw false
positives everywhere.

It's on my queue of things to fix but, quite frankly, lockdep false
positives are low priority to fix right now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
