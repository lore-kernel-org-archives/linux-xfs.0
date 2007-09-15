Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 15 Sep 2007 11:58:09 -0700 (PDT)
Received: from rv-out-0910.google.com (rv-out-0910.google.com [209.85.198.189])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8FIw24p001275
	for <xfs@oss.sgi.com>; Sat, 15 Sep 2007 11:58:05 -0700
Received: by rv-out-0910.google.com with SMTP id k20so835730rvb
        for <xfs@oss.sgi.com>; Sat, 15 Sep 2007 11:58:04 -0700 (PDT)
Message-ID: <654e62180709151158v454d33b8k864d5bcb8a37f003@mail.gmail.com>
Date: Sat, 15 Sep 2007 11:58:04 -0700
From: "Jordan Mendler" <jmendler@ucla.edu>
Subject: Re: compression
In-Reply-To: <20070915100511.GA8183@p15145560.pureserver.info>
MIME-Version: 1.0
References: <654e62180709111643k4700c2bdibec2a16eb5446e76@mail.gmail.com>
	 <20070915100511.GA8183@p15145560.pureserver.info>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ralf Gross <Ralf-Lists@ralfgross.de>
Cc: xfs@oss.sgi.com

Cool. I will give that a shot. Right now I am just using rsync and
rdiff-backup scripts, but it would be nice to have a frontend in addition to
command line.

Thanks so much,
Jordan

On 9/15/07, Ralf Gross <Ralf-Lists@ralfgross.de> wrote:
>
> Jordan Mendler schrieb:
> >
> > I searched the mailing list archive and could not find an answer. We are
> > currently using XFS on Linux for a 17TB Volume used for backups. We are
> > running out of space, so rather than order another array, I would like
> to
> > try to implement filesystem-level compression. Does XFS support any type
> of
> > compression? If not, are there any other ways to optimize for more space
> > storage? We are doing extensive rsyncs as our method of backups, so
> gzipping
> > on top of the filesystem is not really an option.
>
> A very nice tool for backups is backuppc which stores all backed up
> files in a pool and uses hardlinks to map these files to the real
> backup. There is only one copy of each file in the pool regardless of
> on how may clients this file exist (De-duplication). You can use
> backuppc with tar/rsync/smb and with compression.
>
> Ralf
>


[[HTML alternate version deleted]]
