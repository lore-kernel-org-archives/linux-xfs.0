Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0R87799030135 for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 02:07:08 -0600
Received: from pastinake.doctronic.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F2125BC651
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 00:06:23 -0800 (PST)
Received: from pastinake.doctronic.de (pastinake.doctronic.de [217.6.226.210])
	by cuda.sgi.com with ESMTP id Zwq1vfS5B6rpJJHH for
	<xfs@oss.sgi.com>; Tue, 27 Jan 2009 00:06:23 -0800 (PST)
Received: from ZWERG.DOCTRONIC.LOCAL (zwerg.doctronic.de [192.168.4.131])
	by pastinake.doctronic.de (8.13.1/8.13.1) with ESMTP id n0R7ANMH027579
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 08:10:23 +0100
Received: from co by ZWERG.DOCTRONIC.LOCAL with local (Exim 4.63)
	(envelope-from <oberscheid@doctronic.de>) id 1LRi5X-0004LU-CU
	for xfs@oss.sgi.com; Tue, 27 Jan 2009 08:10:23 +0100
Date: Tue, 27 Jan 2009 08:10:23 +0100
From: Carsten Oberscheid <oberscheid@doctronic.de>
Subject: Re: Strange fragmentation in nearly empty filesystem
Message-ID: <20090127071023.GA16511@doctronic.de>
References: <20090123102130.GB8012@doctronic.de>
	<20090124003329.GE32390@disturbed>
	<20090126075724.GA1753@doctronic.de> <497E02CD.2020000@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <497E02CD.2020000@sandeen.net>
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

On Mon, Jan 26, 2009 at 12:37:01PM -0600, Eric Sandeen wrote:
> 
> It's possible that vmware changed too, I suppose.  If it's leaving holes
> now, you won't get back to one extent.

Point taken.

> How hard would it be to boot a kernel from a year ago, with your current
> vmware, and see how that goes - it might be an interesting test.

Indeed. Unfortunately, since this is my office desktop PC, I'm quite
reluctant to fiddle around with it too much. But perhaps I find an
older live CD to try this with.

> I'd try to sort out the 2 moving parts you have, vmware & kernel.  See
> which one seems to have affected this behavior the most; downgrade one
> of the 2 pieces, and see how it behaves.

Sounds perfectly reasonable.

So I understand that there are no known issues with XFS that might
explain this long term fragmentation behaviour, and that there are no
magic XFS options to improve it.

I'll see what tests I can do and report back about the findings.

Thank you & best regards


Carsten Oberscheid

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
