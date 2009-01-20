Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0K9cpnK001537 for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 03:38:53 -0600
Received: from mail-fx0-f32.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6F166A0637
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 01:38:49 -0800 (PST)
Received: from mail-fx0-f32.google.com (mail-fx0-f32.google.com
	[209.85.220.32]) by cuda.sgi.com with ESMTP id r5vQg1aN3vCxAQW0
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 01:38:49 -0800 (PST)
Received: by fxm13 with SMTP id 13so759373fxm.20
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 01:38:48 -0800 (PST)
Message-ID: <497598BF.9080704@gmail.com>
Date: Tue, 20 Jan 2009 10:26:23 +0100
From: Jacek Luczak <difrost.kernel@gmail.com>
MIME-Version: 1.0
Subject: Re: [XFS] 2.6.29-rc2: XFS internal error XFS_WANT_CORRUPTED_GOTO
References: <497468C1.3000001@gmail.com> <4974CA20.6050308@sandeen.net>
	<20090120004611.GA6445@disturbed>
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

Dave Chinner pisze:
> On Mon, Jan 19, 2009 at 12:44:48PM -0600, Eric Sandeen wrote:
>> Jacek Luczak wrote:
>>> Hi All,
>>>
>>> I've stepped into XFS issue/bug. Yesterday I've compiled 2.6.29-rc2 and no
>>> didn't found errors. Today I've booted my notebook and XFS bug have occurred.
>>> System reboot didn't helped, same error appeared.
>>>
>>> Some info:
>>> [1] config: http://pin.if.uz.zgora.pl/~difrost/linux-next/2.6.29-rc2.config
>>> [2] kernel logs:
>>> http://pin.if.uz.zgora.pl/~difrost/linux-next/2.6.29-rc2_XFS-bug.log
>>> [3] most interesting part of log below.
>> so this happens every mount?  Reproducible is good.  How large is the
>> filesystem (too large to extract elsewhere for analysis...?) (plus I
>> suppose it'll be hard to get to it when you can't even boot....)
> 
> XFS folks, I suspect the common link between all the reports of this
> bug is that they are on 32-bit kernels. I can't reproduce this on
> a 64 bit kernel, and I'm trying to get a 32-bit UML built right now
> to test this theory.
> 

Yep, 32-bits here. I've googled a while looking for some answer and it looks
like it has happen before in various kernel version (no report regarding 2.6.29
AFAIR).

-Jacek

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
