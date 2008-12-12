Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBCM2oQO018449 for <xfs@oss.sgi.com>; Fri, 12 Dec 2008 16:02:52 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F34A1726F
	for <xfs@oss.sgi.com>; Fri, 12 Dec 2008 14:02:49 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	DHpIFmBQ3lPL5FSC for <xfs@oss.sgi.com>;
	Fri, 12 Dec 2008 14:02:49 -0800 (PST)
Date: Sat, 13 Dec 2008 09:02:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: possible circular locking dependency detected
Message-ID: <20081212220243.GB22525@disturbed>
References: <20081206132023.GA21235@localhost>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081206132023.GA21235@localhost>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Chinner <dgc@sgi.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Sat, Dec 06, 2008 at 09:20:24PM +0800, Wu Fengguang wrote:
> Hi Dave,
> 
> I got this warning while accessing xfs on usb storage.
> Is this a real problem?

False positive. I haven't had time to add and test the lockdep
annotation Peter created last week to allow us to avoid this,
but hopefully that will make it go away.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
