Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4A2ISRk243329 for <xfs@oss.sgi.com>; Sun, 9 May 2010 21:18:29 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C4936139AFBF
	for <xfs@oss.sgi.com>; Sun,  9 May 2010 19:20:39 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	cwIPGakiJVTvwfFx for <xfs@oss.sgi.com>;
	Sun, 09 May 2010 19:20:39 -0700 (PDT)
Date: Mon, 10 May 2010 12:20:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs and raid5 - "Structure needs cleaning for directory open"
Message-ID: <20100510022033.GB7165@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1743435018.20100510013511@kaneda.iguw.tuwien.ac.at>
	<462402327.20100509210710@kaneda.iguw.tuwien.ac.at>
	<1816344475.20100509204800@kaneda.iguw.tuwien.ac.at>
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
To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com

On Sun, May 09, 2010 at 08:48:00PM +0200, Rainer Fuegenstein wrote:
> 
> today in the morning some daemon processes terminated because of
> errors in the xfs file system on top of a software raid5, consisting
> of 4*1.5TB WD caviar green SATA disks.

Reminds me of a recent(-ish) md/dm readahead cancellation fix - that
would fit the symptoms of (btree corruption showing up under heavy IO
load but no corruption on disk. However, I can't seem to find any
references to it at the moment (can't remember the bug title), but
perhaps your distro doesn't have the fix in it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
