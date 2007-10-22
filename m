Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 21 Oct 2007 20:47:38 -0700 (PDT)
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.179])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9M3lXpv004396
	for <xfs@oss.sgi.com>; Sun, 21 Oct 2007 20:47:34 -0700
Received: by py-out-1112.google.com with SMTP id u77so2301826pyb
        for <xfs@oss.sgi.com>; Sun, 21 Oct 2007 20:47:35 -0700 (PDT)
Message-ID: <6e0c99d0710212047r684d90d5wc6c0a009e0568edd@mail.gmail.com>
Date: Sun, 21 Oct 2007 23:47:35 -0400
From: "Greg Martyn" <greg.martyn@gmail.com>
Subject: Re: mount: /dev/md0: can't read superblock
In-Reply-To: <20071022005258.GX995458@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6e0c99d0710201802v2f41577dv38281b936a2389bf@mail.gmail.com>
	 <471BEDCD.3040104@sandeen.net> <20071022005258.GX995458@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Thank you Eric and David. xfs_repair repaired the filesystem. I forgot
to save the output of xfs_fsr (in case you were curious about what
went wrong), but everything seems to be working fine again.

I just won't be defragging again any time soon ;-)

Thanks,
greg

On 10/21/07, David Chinner <dgc@sgi.com> wrote:
> On Sun, Oct 21, 2007 at 07:24:45PM -0500, Eric Sandeen wrote:
> > Greg Martyn wrote:
> > > Hi all,
> > > After running "xfs_fsr -v /home", I got a bunch of error messages
> > > saying that certain files (/home/.[three letters that i forgot])
> > > couldn't be removed. After that, my system stopped working properly,
> > > so I restarted. Now:
> > >
> > > [root@localhost ~]# mount /dev/md0 /home/
> > > mount: /dev/md0: can't read superblock
> > >
> > > uh oh.
> >
> > dmesg says it's corrupted.
> >
> > You should probably run repair on it.  But being raid, if something went
> > wrong w/ the raid, that could make it worse... run xfs_repair -n and see
> > what it *would* fix.
>
> xfs_repair does not check everything in the filesystem - some things it
> simply rebuilds - like the free space btrees. you want to run xfs_check
> to determine if the free space btrees are corrupt on disk or not.... ;)
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
>
