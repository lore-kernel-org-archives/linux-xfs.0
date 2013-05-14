Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 201E17CBF
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 19:45:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ABB07AC001
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 17:45:24 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	tGc9aOSYgfqSYe3k for <xfs@oss.sgi.com>;
	Mon, 13 May 2013 17:45:22 -0700 (PDT)
Date: Tue, 14 May 2013 10:45:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.27-based kernel failing xfstests xfs/182
Message-ID: <20130514004521.GP32675@dastard>
References: <519176E7.8070204@genband.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <519176E7.8070204@genband.com>
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
To: Chris Friesen <chris.friesen@genband.com>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, xfs@oss.sgi.com

On Mon, May 13, 2013 at 05:27:35PM -0600, Chris Friesen wrote:
> 
> Hi,
> 
> I'm working on an embedded system running a 2.6.27-based kernel.
> 
> I'm digging into some intermittent xfs corruption issues.  Yes, I
> realize the right answer is probably to upgrade, but for the usual
> embedded reasons that's tricky.
> 
> I'm seeing test xfs/182 fail with 40 or so files showing messages like:
> 
> file /opt/xfstest2/960 has incorrect size - sync failed
> 
> In our case the xfs filesystems used for testing are on top of lvm,
> which is in turn on top of two SAS drives in RAID1.
> 
> Any suggestions on where I should start looking?  I'm looking at the
> "do_sync() and XFSQA test 182 failures...." thread on the mailing
> list from 2008, can someone point me to the commit that eventually
> resulted from that?

I doubt anyone can pinpoint a fix for you. I'd suggest that you find
the kernel release where the test starts passing, and the work
backwards from there...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
