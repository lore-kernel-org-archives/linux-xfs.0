Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D50D37F60
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 17:34:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A8A268F8033
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 15:34:32 -0800 (PST)
Received: from trent.utfs.org (trent.utfs.org [94.185.90.103]) by cuda.sgi.com
	with ESMTP id RJAH0d7PAiBDRKRE for <xfs@oss.sgi.com>;
	Thu, 13 Feb 2014 15:34:31 -0800 (PST)
Date: Thu, 13 Feb 2014 15:34:19 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 3.14.0-rc2: WARNING: at mm/slub.c:1007
In-Reply-To: <20140213222602.GK13997@dastard>
Message-ID: <alpine.DEB.2.19.4.1402131531290.6233@trent.utfs.org>
References: <alpine.DEB.2.19.4.1402131144390.6233@trent.utfs.org>
	<20140213222602.GK13997@dastard>
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

On Fri, 14 Feb 2014 at 09:26, Dave Chinner wrote:
> > after upgrading from 3.13-rc8 to 3.14.0-rc2 on this PowerPC G4 machine, 
> > the WARNING below was printed.
> > 
> > Shortly after, a lockdep warning appeared (possibly related to my 
> > post to the XFS list yesterday[0]).
> 
> Unlikely.

OK, so the "possible irq lock inversion dependency detected" is a lockdep 
regression, as you explained in the xfs-list thread. What about the 
"RECLAIM_FS-safe -> RECLAIM_FS-unsafe lock order detected" warning - I 
haven't seen it again though, only once with 3.14.0-rc2.

Christian.
-- 
BOFH excuse #108:

The air conditioning water supply pipe ruptured over the machine room

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
