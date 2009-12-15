Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBFGqa4E245619 for <xfs@oss.sgi.com>; Tue, 15 Dec 2009 10:52:36 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 14D3119845BA
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2009 08:53:14 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 4BME9Zq02skqwgiA for
	<xfs@oss.sgi.com>; Tue, 15 Dec 2009 08:53:14 -0800 (PST)
Message-ID: <4B27BF03.6090602@sandeen.net>
Date: Tue, 15 Dec 2009 10:53:23 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Disappointing performance of copy (MD raid + XFS)
References: <4B204334.1000605@shiftmail.org> <4B207620.3060605@sandeen.net>	
	<4B21A34C.9090100@shiftmail.org>
	<20091211032610.GH30608@discord.disaster>
	<1260895872.7209.46.camel@localhost>
In-Reply-To: <1260895872.7209.46.camel@localhost>
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
To: Kasper Sandberg <postmaster@metanurb.dk>
Cc: Gabor Gombas <gombasg@sztaki.hu>, xfs@oss.sgi.com, linux-raid <linux-raid@vger.kernel.org>, =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>, Asdo <asdo@shiftmail.org>

Kasper Sandberg wrote:
> On Fri, 2009-12-11 at 14:26 +1100, Dave Chinner wrote:
>> On Fri, Dec 11, 2009 at 02:41:32AM +0100, Asdo wrote:
>>> I have checked the other problem I had which I was mentioning, that I  
> <snip>
>>> Also with noalign and rotorstep at 255 the stripe_cache_size stays  
>>> usually in the lower half (below 16000 out of 32000) while with defaults  
>>> it's stuck for most of the time at the maximum and processes are stuck  
>>> sleeping in MD locks for this reason.
>> That really does sound like a misaligned filesystem - the stripe
>> cache will grow larger the more RMW cycles that need to be
>> performed...
> Sorry to interrupt, I would very much like to see if my array/xfs is
> properly aligned and all that stuff which has been mentioned inhere,
> could any of you please post the things required to check? filesystem is
> straight on md raid6, debian lenny.
> 
> 
> <snip>
> 

use xfs_info on your mountpoint, and compare the stripe unit and width
to what md tells you.  xfs_info stripe unit/width output is in fs blocks
units.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
