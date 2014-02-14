Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4522A7F69
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 19:22:13 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C3351AC00C
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 17:22:09 -0800 (PST)
Received: from trent.utfs.org (trent.utfs.org [94.185.90.103]) by cuda.sgi.com
	with ESMTP id wQDB2u5XqP5O3AhZ for <xfs@oss.sgi.com>;
	Thu, 13 Feb 2014 17:22:08 -0800 (PST)
Date: Thu, 13 Feb 2014 17:22:06 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 3.14.0-rc2: WARNING: at mm/slub.c:1007
In-Reply-To: <20140214011453.GP13997@dastard>
Message-ID: <alpine.DEB.2.19.4.1402131721190.6233@trent.utfs.org>
References: <alpine.DEB.2.19.4.1402131144390.6233@trent.utfs.org>
	<20140213222602.GK13997@dastard>
	<alpine.DEB.2.19.4.1402131531290.6233@trent.utfs.org>
	<20140214011453.GP13997@dastard>
MIME-Version: 1.0
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
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Fri, 14 Feb 2014 at 12:14, Dave Chinner wrote:
> > OK, so the "possible irq lock inversion dependency detected" is a lockdep 
> > regression, as you explained in the xfs-list thread. What about the 
> > "RECLAIM_FS-safe -> RECLAIM_FS-unsafe lock order detected" warning - I 
> > haven't seen it again though, only once with 3.14.0-rc2.
> 
> That was also an i_lock/mmapsem issue, so it's likely to be the same
> root cause. I'm testing a fix for it at the moment.

Understood. Thanks for looking into this.

Christian.
-- 
BOFH excuse #129:

The ring needs another token

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
