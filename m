Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3D4C37CA2
	for <xfs@oss.sgi.com>; Fri, 29 Jan 2016 16:20:26 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1C339304043
	for <xfs@oss.sgi.com>; Fri, 29 Jan 2016 14:20:22 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	JbhU8kwM1Hi9CuGn for <xfs@oss.sgi.com>;
	Fri, 29 Jan 2016 14:20:20 -0800 (PST)
Date: Sat, 30 Jan 2016 09:20:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: introduce per-inode DAX enablement
Message-ID: <20160129222006.GJ20456@dastard>
References: <1451886892-15548-1-git-send-email-david@fromorbit.com>
	<1451886892-15548-4-git-send-email-david@fromorbit.com>
	<CAA9_cmdAYzf3DpjPRZWikNgmJT_sdDACXa_znz6j0oqmmRdLOA@mail.gmail.com>
	<20160121215820.GA6033@dastard>
	<CAPcyv4iXg6pD4p2MTFA3hwUc6eTK=Lpw1nDuchAs1ZQWS05MtA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4iXg6pD4p2MTFA3hwUc6eTK=Lpw1nDuchAs1ZQWS05MtA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <willy@linux.intel.com>, ext4@vger.kernel.org, XFS Developers <xfs@oss.sgi.com>

On Thu, Jan 21, 2016 at 02:53:06PM -0800, Dan Williams wrote:
> On Thu, Jan 21, 2016 at 1:58 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Jan 21, 2016 at 08:37:11AM -0800, Dan Williams wrote:
> >> On Sun, Jan 3, 2016 at 9:54 PM, Dave Chinner <david@fromorbit.com> wrote:
> > i.e. I've already got a couple of fixes we need to add to this - the
> > DAX flag is only valid on CRC enabled filesystems,
> 
> I assume for torn-write protection?  The CRC limitation makes sense,
> but we theoretically could get the same effect by using a separate
> logdev that does not tear writes, right?

No, it requires the CRC enabled format because there isn't any
flag space left in the v2 inode and so we need v3 inodes to store
the flag.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
