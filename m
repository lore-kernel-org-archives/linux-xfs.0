Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3QKodVA182140 for <xfs@oss.sgi.com>; Tue, 26 Apr 2011 15:50:39 -0500
Received: from mail.perches.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 19EDB15320CB
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2011 13:54:10 -0700 (PDT)
Received: from mail.perches.com (mail.perches.com [173.55.12.10]) by
	cuda.sgi.com with ESMTP id mSUQ1nF9Dy5GrQvV for
	<xfs@oss.sgi.com>; Tue, 26 Apr 2011 13:54:10 -0700 (PDT)
Subject: Re: [PATCH] xfs: Remove duplicate XFS from xfs_alert_tag, neatening
From: Joe Perches <joe@perches.com>
In-Reply-To: <1303850805.2080.164.camel@doink>
References: <59d707d5d1bc37ef3a08fdd23c8e1fe72fa55fbb.1303419931.git.joe@perches.com>
	<1303850805.2080.164.camel@doink>
Date: Tue, 26 Apr 2011 13:54:08 -0700
Message-ID: <1303851248.24299.60.camel@Joe-Laptop>
Mime-Version: 1.0
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
To: aelder@sgi.com
Cc: xfs@oss.sgi.com

On Tue, 2011-04-26 at 15:46 -0500, Alex Elder wrote:
> On Thu, 2011-04-21 at 14:08 -0700, Joe Perches wrote:
> > The xfs_printk in xfs_alert_tag doesn't need an XFS: prefix
> > as it's added by xfs_printk.
> > Add format checking to the non-debug inline function xfs_debug.
> > Miscellaneous function prototype argument alignment.
[]
> I'll highlight the fact that this was the last caller of
> xfs_printk().  As such I think it should just be eliminated,
> and make the use of xfs_info() or xfs_debug() mandatory.
> They are clean, easy, and have meaningful enough names
> that this should be fine.  (What do others think?)

I only wanted to point out the unnecessary "XFS:" duplication.
Taking out xfs_printk would save some text & data.
Do what you think appropriate.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
