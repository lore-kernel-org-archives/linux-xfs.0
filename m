Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7BNi9Rl169518
	for <linux-xfs@oss.sgi.com>; Wed, 11 Aug 2010 18:44:09 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1E1154AD3CD
	for <linux-xfs@oss.sgi.com>; Wed, 11 Aug 2010 16:44:32 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	FOQTEyL8CCQtgPsF for <linux-xfs@oss.sgi.com>;
	Wed, 11 Aug 2010 16:44:32 -0700 (PDT)
Date: Thu, 12 Aug 2010 09:44:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: observed significant performance improvement using "delaylog"
	in a real-world application
Message-ID: <20100811234420.GA10429@dastard>
References: <i3rt4t$46c$1@dough.gmane.org> <201008111003.36890@zmi.at>
	<i3trg6$eps$1@dough.gmane.org> <201008111428.31196@zmi.at>
	<i3ul1b$d3b$1@dough.gmane.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <i3ul1b$d3b$1@dough.gmane.org>
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
To: Peter Niemayer <niemayer@isg.de>
Cc: linux-xfs@oss.sgi.com

On Wed, Aug 11, 2010 at 07:01:31PM +0200, Peter Niemayer wrote:
> On 08/11/2010 02:28 PM, Michael Monnerie wrote:
> >Thank you. Are those files located within one dir or do you use a hash
> >structure like squid cache does?
> 
> There's only a shallow hierarchy (for functional, not for distribution
> reasons), so the relevant directories have thousands of files in them.
> 
> I think after the "ext2"-age no serious file system ever had
> a real problem dealing with lots of files in one directory -
> or do you have contradicting information?

Define "lots of files". :)

>From my numbers, ext3/4 still fall way behind XFS and btrfs when it
comes to handling directories with tens of thousands of entries or
larger. Especially on cold-cache random lookups.

XFS also has quite sophisticated internal directory readahead, so
under the cold cache directory performance of XFS is far better than
ext3/4 can acheive, even for relatively small directories. IIRC this
difference in directory lookup performance was one of the prime
reasons kernel.org switched from ext3 to XFS a couple of years
back...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
