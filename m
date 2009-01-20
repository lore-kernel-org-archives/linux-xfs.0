Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0KBTipi007900 for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 05:29:46 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 51793D037CA
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 03:29:43 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 7IgodKUXaMnmRGQg for
	<xfs@oss.sgi.com>; Tue, 20 Jan 2009 03:29:43 -0800 (PST)
Date: Tue, 20 Jan 2009 06:29:10 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [XFS] 2.6.29-rc2: XFS internal error XFS_WANT_CORRUPTED_GOTO
Message-ID: <20090120112910.GA6831@infradead.org>
References: <497468C1.3000001@gmail.com> <4974CA20.6050308@sandeen.net>
	<20090120004611.GA6445@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090120004611.GA6445@disturbed>
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
To: Eric Sandeen <sandeen@sandeen.net>, Jacek Luczak <difrost.kernel@gmail.com>, LKML <linux-kernel@vger.kernel.org>, hch@infradead.org, xfs mailing list <xfs@oss.sgi.com>

On Tue, Jan 20, 2009 at 11:46:11AM +1100, Dave Chinner wrote:
> On Mon, Jan 19, 2009 at 12:44:48PM -0600, Eric Sandeen wrote:
> > Jacek Luczak wrote:
> > > Hi All,
> > > 
> > > I've stepped into XFS issue/bug. Yesterday I've compiled 2.6.29-rc2 and no
> > > didn't found errors. Today I've booted my notebook and XFS bug have occurred.
> > > System reboot didn't helped, same error appeared.
> > > 
> > > Some info:
> > > [1] config: http://pin.if.uz.zgora.pl/~difrost/linux-next/2.6.29-rc2.config
> > > [2] kernel logs:
> > > http://pin.if.uz.zgora.pl/~difrost/linux-next/2.6.29-rc2_XFS-bug.log
> > > [3] most interesting part of log below.
> > 
> > so this happens every mount?  Reproducible is good.  How large is the
> > filesystem (too large to extract elsewhere for analysis...?) (plus I
> > suppose it'll be hard to get to it when you can't even boot....)
> 
> XFS folks, I suspect the common link between all the reports of this
> bug is that they are on 32-bit kernels. I can't reproduce this on
> a 64 bit kernel, and I'm trying to get a 32-bit UML built right now
> to test this theory.

I'm doing about half of my testing on 32 bit x86, and I couldn't
reproduce the detailed receipe  in the kernel.org bugzilla yet.

Just curious:  do you have CONFIG_LBD set?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
