Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 21 Oct 2007 17:53:13 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9M0r6xl021392
	for <xfs@oss.sgi.com>; Sun, 21 Oct 2007 17:53:09 -0700
Date: Mon, 22 Oct 2007 10:52:58 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: mount: /dev/md0: can't read superblock
Message-ID: <20071022005258.GX995458@sgi.com>
References: <6e0c99d0710201802v2f41577dv38281b936a2389bf@mail.gmail.com> <471BEDCD.3040104@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471BEDCD.3040104@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Greg Martyn <greg.martyn@gmail.com>, xfs@oss.sgi.com

On Sun, Oct 21, 2007 at 07:24:45PM -0500, Eric Sandeen wrote:
> Greg Martyn wrote:
> > Hi all,
> > After running "xfs_fsr -v /home", I got a bunch of error messages
> > saying that certain files (/home/.[three letters that i forgot])
> > couldn't be removed. After that, my system stopped working properly,
> > so I restarted. Now:
> > 
> > [root@localhost ~]# mount /dev/md0 /home/
> > mount: /dev/md0: can't read superblock
> > 
> > uh oh.
> 
> dmesg says it's corrupted.
> 
> You should probably run repair on it.  But being raid, if something went
> wrong w/ the raid, that could make it worse... run xfs_repair -n and see
> what it *would* fix.

xfs_repair does not check everything in the filesystem - some things it
simply rebuilds - like the free space btrees. you want to run xfs_check
to determine if the free space btrees are corrupt on disk or not.... ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
