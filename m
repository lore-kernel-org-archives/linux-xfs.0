Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Sep 2007 20:05:51 -0700 (PDT)
Received: from rv-out-0910.google.com (rv-out-0910.google.com [209.85.198.187])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8C35k4p009925
	for <xfs@oss.sgi.com>; Tue, 11 Sep 2007 20:05:47 -0700
Received: by rv-out-0910.google.com with SMTP id k20so61152rvb
        for <xfs@oss.sgi.com>; Tue, 11 Sep 2007 20:05:48 -0700 (PDT)
Message-ID: <654e62180709112005l6b70b0f2s423bda10a950fcfd@mail.gmail.com>
Date: Tue, 11 Sep 2007 20:05:48 -0700
From: "Jordan Mendler" <jmendler@ucla.edu>
Subject: Re: compression
In-Reply-To: <46E74368.5090503@sandeen.net>
MIME-Version: 1.0
References: <654e62180709111643k4700c2bdibec2a16eb5446e76@mail.gmail.com>
	 <46E74368.5090503@sandeen.net>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Do you know if there any plans to implement compression any time in the
somewhat near future?

Thanks, Jordan

On 9/11/07, Eric Sandeen <sandeen@sandeen.net> wrote:
>
> Jordan Mendler wrote:
> > Hi all,
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
> >
> > Thanks so much,
> > Jordan
> >
>
> No native compression in xfs... and it's not got a lot of space
> overhead, to start with.
>
> If you're keeping multiple copies of things via complete nightly rsync
> backups, there are mechanisms that just symlink files which haven't
> changed... Or, have you looked into incremental backups via xfsdump?
> Dunno if any of that helps, or if you've already thought of such
> things.  :)
>
> -Eric
>


[[HTML alternate version deleted]]
