Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 13 Sep 2007 12:40:07 -0700 (PDT)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8DJdw4p003042
	for <xfs@oss.sgi.com>; Thu, 13 Sep 2007 12:40:03 -0700
Received: by wa-out-1112.google.com with SMTP id k22so773944waf
        for <xfs@oss.sgi.com>; Thu, 13 Sep 2007 12:39:57 -0700 (PDT)
Message-ID: <cc7060690709131239u76c8c5fdrf0fd729f16910042@mail.gmail.com>
Date: Fri, 14 Sep 2007 01:09:56 +0530
From: "Bhagi rathi" <jahnu77@gmail.com>
Subject: Re: compression
In-Reply-To: <20070912174216.GA5521@filer.fsl.cs.sunysb.edu>
MIME-Version: 1.0
References: <654e62180709111643k4700c2bdibec2a16eb5446e76@mail.gmail.com>
	 <20070912174216.GA5521@filer.fsl.cs.sunysb.edu>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Cc: Jordan Mendler <jmendler@ucla.edu>, xfs@oss.sgi.com

Using open source rsync seems to be smart enough to identify files which
haven't
been modified and use hard-link instead of copying the file. I am not sure
that rsync
used here is smart enough to identify the same file which haven't been
modified.

If hard-linking is already done, I believe that there is lot of duplication
of data in the same
file. It looks that open source rsync doesn't eliminate duplication of data
that
was already existing in older backup. It copies it again. Compressing the
data
for the same file across various backup snapshots can be very powerful and
my guess is that it can definitely free more that 30% of your space. Note
that
this is not file-system wide compression, it is compression of the same file
existing in various back-ups. Restore gets affected, but should be easy to
tweak
given that it can free lot of space.

-Cheers,
 Saradhi.

On 9/12/07, Josef Sipek <jsipek@fsl.cs.sunysb.edu> wrote:
>
> On Tue, Sep 11, 2007 at 04:43:20PM -0700, Jordan Mendler wrote:
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
>
> Implementation-wise, one major thing to keep in mind is that offsets into
> the uncompressed copies of files in memory need to be mapped to the
> compressed ones. This is rather painful if you want to do things right
> (supporting writing as well as reading from files).
>
> As Eric mentioned, you may want to try to eliminate copies of identical
> files with symlinks or even hardlinks (just make sure your backup sw is
> smart enough to break links when necessary).
>
> Josef 'Jeff' Sipek.
>
> --
> The reasonable man adapts himself to the world; the unreasonable one
> persists in trying to adapt the world to himself. Therefore all progress
> depends on the unreasonable man.
>                 - George Bernard Shaw
>
>
>


[[HTML alternate version deleted]]
