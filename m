Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 21 Oct 2007 16:28:00 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9LNRqsI010243
	for <xfs@oss.sgi.com>; Sun, 21 Oct 2007 16:27:55 -0700
Date: Mon, 22 Oct 2007 09:27:43 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: mount: /dev/md0: can't read superblock
Message-ID: <20071021232743.GU995458@sgi.com>
References: <6e0c99d0710201802v2f41577dv38281b936a2389bf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e0c99d0710201802v2f41577dv38281b936a2389bf@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Greg Martyn <greg.martyn@gmail.com>
Cc: xfs@oss.sgi.com

On Sat, Oct 20, 2007 at 09:02:14PM -0400, Greg Martyn wrote:
> Hi all,
> After running "xfs_fsr -v /home", I got a bunch of error messages
> saying that certain files (/home/.[three letters that i forgot])
> couldn't be removed. After that, my system stopped working properly,
> so I restarted. Now:

A corrupted freespace btree, by the look of it.

What errors occurred you syslog when the system started playing
up? I/O errors? Corruption errors?

xfs_repair will probably be the only thing you can do here to correct
the problem....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
