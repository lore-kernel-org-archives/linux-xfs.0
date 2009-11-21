Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nALM4PCX062233 for <xfs@oss.sgi.com>; Sat, 21 Nov 2009 16:04:26 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B98E21346254
	for <xfs@oss.sgi.com>; Sat, 21 Nov 2009 14:04:47 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	AOIi0oCJuc4vkXkh for <xfs@oss.sgi.com>;
	Sat, 21 Nov 2009 14:04:47 -0800 (PST)
Date: Sun, 22 Nov 2009 09:04:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: BUG() in end_page_writeback(), stack overflows and system
	speed decrease with XFS over USB
Message-ID: <20091121220444.GF3804@discord.disaster>
References: <200911190957.45957.JuergenUrban@gmx.de>
	<200911210200.13438.JuergenUrban@gmx.de>
	<200911211151.23764@zmi.at>
	<200911211833.20691.JuergenUrban@gmx.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200911211833.20691.JuergenUrban@gmx.de>
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
To: Juergen Urban <JuergenUrban@gmx.de>
Cc: xfs@oss.sgi.com

On Sat, Nov 21, 2009 at 06:33:20PM +0100, Juergen Urban wrote:
> Can someone explain the purpose of the BUG() in end_page_writeback()? Can I 
> remove the line?

A page that is under writeback is supposed to have the PG_writeback
flag set. Hence when writeback is completed (i.e the page is now
clean) we need to clear the PG_writeback bit. The BUG is triggered
if we are ending writeback on a page that does not have PG_writeback
set. IOWs, something is seriously wrong, and could be a memory error
or memory corruption.

> Will XFS also work if I disable all address operations?

No.

> What is the purpose of the address operations?

Reading Documentation/filesystems/vfs.txt might answer your
questions....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
