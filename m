Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Feb 2008 21:43:18 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1G5hDRt001355
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 21:43:14 -0800
Received: from bob.dscon.sk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A8C76E36C89
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 21:43:38 -0800 (PST)
Received: from bob.dscon.sk (bob.dscon.sk [88.86.113.10]) by cuda.sgi.com with ESMTP id AQP5yjTF50jviAkp for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 21:43:38 -0800 (PST)
Date: Sat, 16 Feb 2008 06:43:49 +0100
Subject: Re: rewrite very slow
Message-ID: <20080216054349.GE4859@bob.dscon.sk>
References: <20080215191636.GC4859@bob.dscon.sk> <47B62FF6.2000903@sandeen.net> <20080216024634.GU155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080216024634.GU155407@sgi.com>
From: xfs@bob.dscon.sk (DS)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hmm, and what cat I do to get it work now?

DS

On Sat, Feb 16, 2008 at 01:46:34PM +1100, David Chinner wrote:
> On Fri, Feb 15, 2008 at 06:36:06PM -0600, Eric Sandeen wrote:
> > DS wrote:
> > > Hello,
> > > 
> > > I need some help to tunning my storage.
> > 
> > ...
> > > TIME 43 sekund
> > 
> > 
> > What kernel?  when I test on my 2.6.23.9-85.fc8 and 2.6.22.5 boxes, I
> > see 2 and 7 seconds for rewrite, respectively.
> > 
> > but granted, on ext3 I get 0 seconds for every run.
> > 
> > Also the difference appears to be O_TRUNC (which the perl script does);
> > if I code it in c:
> > 
> > #include <sys/types.h>
> > #include <sys/stat.h>
> > #include <fcntl.h>
> > 
> > void main(void)
> > {
> >         int i;
> >         int fd;
> >         char file[4];
> > 
> >         for (i = 0; i < 100; i++) {
> >                 sprintf(file, "%d.txt", i);
> >                 fd = open(file, O_CREAT|O_RDWR|O_TRUNC, 0644);
> >                 write(fd, "aaaaaaaaaaaaaaaaaaa\n");
> >                 close(fd);
> >         }
> > }
> > 
> > rewrite is a bit slower w/ O_TRUNC in place, plenty fast w/o it.  Not
> > sure about the xfs/ext3 difference... this is probably a side-effect of
> > flushes xfs put into place on truncate (IIRC?)
> 
> Yup - after a truncate we use flush-on-close semantics if the file
> is closed before pdflush does writeback. yes, it has a measurable
> impact on silly microbenchmarks like this, but nobody even noticed
> it when we introduced this code 2-3 years ago...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
