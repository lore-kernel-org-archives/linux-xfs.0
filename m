Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4JJ8MiP148669 for <xfs@oss.sgi.com>; Wed, 19 May 2010 14:08:22 -0500
Received: from petole.demisel.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 96C01129A05F
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 12:11:47 -0700 (PDT)
Received: from petole.demisel.net (petole.demisel.net [88.174.118.95]) by
	cuda.sgi.com with ESMTP id Z0SRF4x4ASndl6tu for
	<xfs@oss.sgi.com>; Wed, 19 May 2010 12:11:47 -0700 (PDT)
Subject: Re: noatime,nodiratime?
References: <4BF3F212.5030600@hardwarefreak.com>
	<87mxvveqyq.fsf@petole.demisel.net>
	<4BF42725.8060903@hardwarefreak.com>
	<20100519182434.GB6264@infradead.org>
From: Nicolas KOWALSKI <niko@petole.demisel.net>
Date: Wed, 19 May 2010 21:10:37 +0200
In-Reply-To: <20100519182434.GB6264@infradead.org>
Message-ID: <87iq6jemhe.fsf@petole.demisel.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Christoph Hellwig <hch@infradead.org> writes:
> On Wed, May 19, 2010 at 01:00:05PM -0500, Stan Hoeppner wrote:
>> Yes, the defaults for each parameter are in your mount man page.
>> logbsize=256K is higher than the default, which is 32K for any system with
>> over 32MB RAM.  logbufs=8 will be the default if your blocksize is 64K.  If
>> your blocksize is 4K you'll get logbufs=2 by default.  This is all in the
>> XFS section of man mount.
>
> But it's not actually true anymore for a long time.  XFS is always using
> 8 32k log buffers these days.  I'll prepare an update for the mount man
> page to correct this.

Ok, Thanks for the reminder and update.

-- 
Nicolas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
