Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Sep 2006 15:48:32 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8QMmJaG016192
	for <xfs@oss.sgi.com>; Tue, 26 Sep 2006 15:48:20 -0700
Received: from smtp114.sbc.mail.mud.yahoo.com (smtp114.sbc.mail.mud.yahoo.com [68.142.198.213])
	by cuda.sgi.com (Spam Firewall) with SMTP id C1AAAD118FE7
	for <xfs@oss.sgi.com>; Tue, 26 Sep 2006 15:47:40 -0700 (PDT)
Date: Tue, 26 Sep 2006 15:40:53 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: LVM and XFS cannot set blocksize on block device
Message-ID: <20060926224053.GA31542@tuatara.stupidest.org>
References: <45185424.2030707@tulane.edu> <20060926001737.GA10224@tuatara.stupidest.org> <45193204.3030500@tulane.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45193204.3030500@tulane.edu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Rene Salmon <rsalmon@tulane.edu>
Cc: xfs@oss.sgi.com

On Tue, Sep 26, 2006 at 08:58:28AM -0500, Rene Salmon wrote:

> Thanks for the reply. The "-s size=4096" helped I was able to create
> the file system, then mount it and use it.  I did however get a
> warning still about "cannot set blocksize on block device".

I don't know much about the LVM code, my guess is that
ioctl(... ,BLKBSZSET, ...) is failing, strace would confirm this.

> Everything seems to be working but I am a bit worried about the
> warning message.  Following is the message.  Any ideas if it is safe
> to ignore this or any way to get rid of it?

What does:

  blockdev --getbsz /dev/vg_u00/lv_u00

say?


If mkfs.xfs is trying to set a blocksize that already matches the
underlying device, it woudn't be hard to silence the warning by doing
a check before unconditionally setting it, though I don't know that
it's worth it.
