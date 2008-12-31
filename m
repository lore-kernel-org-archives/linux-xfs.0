Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBVFUrLN011432 for <xfs@oss.sgi.com>; Wed, 31 Dec 2008 09:30:55 -0600
Received: from baerbel.szm.maschinenbau.tu-darmstadt.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 816A155610
	for <xfs@oss.sgi.com>; Wed, 31 Dec 2008 07:30:52 -0800 (PST)
Received: from baerbel.szm.maschinenbau.tu-darmstadt.de
	(baerbel.szm.maschinenbau.tu-darmstadt.de [130.83.48.97]) by
	cuda.sgi.com with ESMTP id uVYc0SxJ2A4q5uZO for
	<xfs@oss.sgi.com>; Wed, 31 Dec 2008 07:30:52 -0800 (PST)
Received: from baerbel.szm.maschinenbau.tu-darmstadt.de (localhost [127.0.0.1])
	by baerbel.szm.maschinenbau.tu-darmstadt.de (8.13.8/8.13.8) with ESMTP
	id mBVFUpOp018832
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <xfs@oss.sgi.com>; Wed, 31 Dec 2008 16:30:51 +0100
Received: (from tacke@localhost)
	by baerbel.szm.maschinenbau.tu-darmstadt.de (8.13.8/8.13.8/Submit) id
	mBVFUoFd018831 for xfs@oss.sgi.com; Wed, 31 Dec 2008 16:30:50 +0100
Date: Wed, 31 Dec 2008 16:30:50 +0100
From: Elrond <elrond+xfs.oss.sgi.com@samba-tng.org>
Subject: Re: xfsaild wakeups
Message-ID: <20081231153050.GA18736@memak.tu-darmstadt.de>
References: <20081229232915.GA6724@memak.tu-darmstadt.de>
	<20081230233522.GB10725@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081230233522.GB10725@disturbed>
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
To: xfs@oss.sgi.com


Hi Dave,

On Wed, Dec 31, 2008 at 10:35:22AM +1100, Dave Chinner wrote:
> On Tue, Dec 30, 2008 at 12:29:15AM +0100, Elrond wrote:
> > 
> > Hi,
> > 
> > The major issue of xfsaild wakeups was analyzed in
> > February. (see
> > http://oss.sgi.com/archives/xfs/2008-02/msg00169.html ).
> > 
> > A small issue persists. We're now at 1 wakeup per second
> > and mounted filesystem. I have three xfs on my box and the
> > number wants to grow. xfsaild is on place two of my
> > powertop wakeup list. Sometimes place one.
> > 
> > Is anyone working on reducing this to zero for an idle fs?
> 
> It's on the list of things to do given that 2.6.29 will have
> the fix for the bug that the periodic wakeup is catching.

So the xfs part is mostly prepared and when 2.6.29 has the
base fix, xfs will follow soon?

Great!


Greetings


    Elrond

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
