Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0K0kPC5002385 for <xfs@oss.sgi.com>; Mon, 19 Jan 2009 18:46:25 -0600
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A51789FC88
	for <xfs@oss.sgi.com>; Mon, 19 Jan 2009 16:46:18 -0800 (PST)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net
	[203.16.214.57]) by cuda.sgi.com with ESMTP id kXILt9pVYAEGcSbx
	for <xfs@oss.sgi.com>; Mon, 19 Jan 2009 16:46:18 -0800 (PST)
Date: Tue, 20 Jan 2009 11:46:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [XFS] 2.6.29-rc2: XFS internal error XFS_WANT_CORRUPTED_GOTO
Message-ID: <20090120004611.GA6445@disturbed>
References: <497468C1.3000001@gmail.com> <4974CA20.6050308@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4974CA20.6050308@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: hch@infradead.org, Jacek Luczak <difrost.kernel@gmail.com>, LKML <linux-kernel@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>

On Mon, Jan 19, 2009 at 12:44:48PM -0600, Eric Sandeen wrote:
> Jacek Luczak wrote:
> > Hi All,
> > 
> > I've stepped into XFS issue/bug. Yesterday I've compiled 2.6.29-rc2 and no
> > didn't found errors. Today I've booted my notebook and XFS bug have occurred.
> > System reboot didn't helped, same error appeared.
> > 
> > Some info:
> > [1] config: http://pin.if.uz.zgora.pl/~difrost/linux-next/2.6.29-rc2.config
> > [2] kernel logs:
> > http://pin.if.uz.zgora.pl/~difrost/linux-next/2.6.29-rc2_XFS-bug.log
> > [3] most interesting part of log below.
> 
> so this happens every mount?  Reproducible is good.  How large is the
> filesystem (too large to extract elsewhere for analysis...?) (plus I
> suppose it'll be hard to get to it when you can't even boot....)

XFS folks, I suspect the common link between all the reports of this
bug is that they are on 32-bit kernels. I can't reproduce this on
a 64 bit kernel, and I'm trying to get a 32-bit UML built right now
to test this theory.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
