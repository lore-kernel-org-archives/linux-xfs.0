Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Feb 2008 18:46:31 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1G2kNnT023329
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 18:46:27 -0800
Date: Sat, 16 Feb 2008 13:46:34 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: rewrite very slow
Message-ID: <20080216024634.GU155407@sgi.com>
References: <20080215191636.GC4859@bob.dscon.sk> <47B62FF6.2000903@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B62FF6.2000903@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: DS <xfs@bob.dscon.sk>, xfs@oss.sgi.com

On Fri, Feb 15, 2008 at 06:36:06PM -0600, Eric Sandeen wrote:
> DS wrote:
> > Hello,
> > 
> > I need some help to tunning my storage.
> 
> ...
> > TIME 43 sekund
> 
> 
> What kernel?  when I test on my 2.6.23.9-85.fc8 and 2.6.22.5 boxes, I
> see 2 and 7 seconds for rewrite, respectively.
> 
> but granted, on ext3 I get 0 seconds for every run.
> 
> Also the difference appears to be O_TRUNC (which the perl script does);
> if I code it in c:
> 
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <fcntl.h>
> 
> void main(void)
> {
>         int i;
>         int fd;
>         char file[4];
> 
>         for (i = 0; i < 100; i++) {
>                 sprintf(file, "%d.txt", i);
>                 fd = open(file, O_CREAT|O_RDWR|O_TRUNC, 0644);
>                 write(fd, "aaaaaaaaaaaaaaaaaaa\n");
>                 close(fd);
>         }
> }
> 
> rewrite is a bit slower w/ O_TRUNC in place, plenty fast w/o it.  Not
> sure about the xfs/ext3 difference... this is probably a side-effect of
> flushes xfs put into place on truncate (IIRC?)

Yup - after a truncate we use flush-on-close semantics if the file
is closed before pdflush does writeback. yes, it has a measurable
impact on silly microbenchmarks like this, but nobody even noticed
it when we introduced this code 2-3 years ago...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
