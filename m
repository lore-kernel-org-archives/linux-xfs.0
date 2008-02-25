Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Feb 2008 14:48:13 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1PMm7fe006261
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 14:48:09 -0800
Received: from merkurneu.hrz.uni-giessen.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 55F08EBC7BA
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 14:48:34 -0800 (PST)
Received: from merkurneu.hrz.uni-giessen.de (merkurneu.hrz.uni-giessen.de [134.176.2.3]) by cuda.sgi.com with ESMTP id V0M4EeBQOiyGUPhm for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 14:48:34 -0800 (PST)
From: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>
Subject: Re: filesystem corruption in linus tree
Date: Mon, 25 Feb 2008 23:47:49 +0100
References: <03F8FD43-322F-41E3-A7A0-CD4E9AD8B4DE@ap.physik.uni-giessen.de> <op.t611a2kn3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.t611a2kn3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802252347.50576.marc.dietrich@ap.physik.uni-giessen.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs@oss.sgi.com


Hi,

On Monday 25 February 2008 01:36:28 Barry Naujok wrote:
> On Sun, 24 Feb 2008 20:58:26 +1100, Marc Dietrich
>
> <Marc.Dietrich@ap.physik.uni-giessen.de> wrote:
> > Hi,
> >
> > somewhere after the release of 2.6.24 my xfs filesystem got corrupted.
> > Initialy I thought it was only related to the readdir bug.
> > (http://oss.sgi.com/archives/xfs/2008-02/msg00027.html) So I waited for
> > the fix to go into mainline. Yesterday I tried again, but got this error
> > during boot:
>
> [stack trace snipped]
>
> > I seems that the log is corrupted because I can't mount the filesystem
> > anymore (blocks while replaying). Mounting with norecovery option works.
> > I tried to repair the filesystem, but xfs_repair also hangs in "Phase 3
> > - scan and clear agi unlinks lists". Before, Phase 2 reports some
> > "ir_freecount/free.mismatch" lines.
>
> Might have to add this to the FAQ as this is the second time someone has
> reported Phase 3 hanging.
>
> Try running xfs_repair -P to try and get past this problem if you are
> running xfsprogs 2.9.x.

I tried this, but didn't work either and is also not my main problem. The 
problem is, as the subject says, that every time I boot linux the filesystem 
gets corrupted (and unrepairable). 

I will setup a testing partition, do some additional tests (could be a 
miscompilation, I'm using gcc-4.3) and report back. 

> > This happens on a newly created filesystem with xfsprogs 2.6.9 (I also
> > tested 2.5.22). I have a 32bit powermac, so it could be an endian issue.

Thanks

Marc
