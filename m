Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o29BatFe135455 for <xfs@oss.sgi.com>; Tue, 9 Mar 2010 05:36:56 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 00D7F22746F
	for <xfs@oss.sgi.com>; Tue,  9 Mar 2010 03:38:25 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	zSczBE2WFywLJTHH for <xfs@oss.sgi.com>;
	Tue, 09 Mar 2010 03:38:25 -0800 (PST)
Date: Tue, 9 Mar 2010 22:38:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hang during xfs_fsr run
Message-ID: <20100309113821.GM28189@discord.disaster>
References: <4B8FA2CD.6010904@dermichi.com>
	<20100304131511.GH14317@discord.disaster>
	<20100304134641.GA26871@infradead.org>
	<4B8FC1B7.3070505@dermichi.com>
	<20100304222611.GK14317@discord.disaster>
	<4B92C71C.5010003@dermichi.com>
	<20100308000601.GF28189@discord.disaster>
	<4B94EADD.2080108@dermichi.com> <4B953D3F.3090002@sandeen.net>
	<4B96118C.6080906@dermichi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B96118C.6080906@dermichi.com>
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
To: Michael Weissenbacher <mw@dermichi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Tue, Mar 09, 2010 at 10:14:52AM +0100, Michael Weissenbacher wrote:
>> Odds are you'll still oops, just earlier.  Send anything interesting
>> you see in the dmesg if/when it happens...
> Oops is attached. This time the system kept working but hat a constant  
> load of >2.0 after the incident. So i rebooted it afterwards.

Not an oops - it's an assertion fail which causes a deliberate trap
for debugging.


> Mar  8 22:53:54 email kernel: [52982.051367] Assertion failed: ip->i_delayed_blks == 0, file: fs/xfs/xfs_bmap.c, line: 5657

That's not what I expected to see. Are you running out of space on
your filesystem?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
