Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8GKsChr016033
	for <linux-xfs@oss.sgi.com>; Thu, 16 Sep 2010 15:54:12 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2EDFD7CE28
	for <linux-xfs@oss.sgi.com>; Thu, 16 Sep 2010 13:55:01 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id HUkHMwP6v20TfDLI for
	<linux-xfs@oss.sgi.com>; Thu, 16 Sep 2010 13:55:01 -0700 (PDT)
Message-ID: <4C928424.1020409@sandeen.net>
Date: Thu, 16 Sep 2010 15:55:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: System partially unusable after power loss...
References: <i6ttq6$41d$1@dough.gmane.org>
In-Reply-To: <i6ttq6$41d$1@dough.gmane.org>
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
To: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Cc: linux-xfs@oss.sgi.com

Manuel Reimer wrote:
> Hello,
> 
> Kernel is 2.6.27.7.
> 
> My Problem started as I got called, that login from KDM is not longer
> possible. In fact, the KDE login is possible, but soon after entering
> the password, a "kbuildsycoca" hangs and takes 100% CPU. Shortly before
> this happened, power was abruptly lost.
> 
> I rebooted to a live CD. As, for some reason, xfs_check was broken on
> that live CD (something with "db" in it was missing), I directly ran

xfs_check is a shell script that invokes xfs_db

> xfs_repair on the broken hard drive and it found some zero byte files

better to run xfs_repair -n rather than xfs_check anyway ...

> and two files with ELF header, which may be (a part of) library files, I
> don't know, as the name wasn't restored.

Having the xfs_repair output would be helpful.

> Is it possible to find out what exactly happened to cause this system to
> be unusable? For me it seems like those restored ELF files are
> something, needed by KDE to start up properly. Why did library files get
> destroyed, the user, using this PC, isn't able to write to? Doesn't this
> mean, they don't get into a write cache and even a power loss can't
> destroy them?

Was there a system software update just prior to the power loss?

Did your storage support IO barriers (i.e. was it lvm or md)?

Buffered data is always lost on a power loss, but I'm not sure
why you should see problems with system files unless they had
just been written out (and not synced).

-Eric

> Yours
> 
> Manuel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
