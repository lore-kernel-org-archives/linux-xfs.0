Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 May 2007 14:23:42 -0700 (PDT)
Received: from waste.org (waste.org [66.93.16.53])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4ALNcfB008822
	for <xfs@oss.sgi.com>; Thu, 10 May 2007 14:23:39 -0700
Date: Thu, 10 May 2007 16:23:23 -0500
From: Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an nlink problem?
Message-ID: <20070510212323.GS11115@waste.org>
References: <4642389E.4080804@goop.org> <20070509231643.GM85884050@sgi.com> <4642598E.3000607@goop.org> <20070510000119.GO85884050@sgi.com> <46426194.3040403@goop.org> <20070510004918.GS85884050@sgi.com> <46426D31.8070000@goop.org> <20070510012609.GU85884050@sgi.com> <46433049.4020003@goop.org> <20070510211348.GC86004887@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510211348.GC86004887@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, michal.k.k.piotrowski@gmail.com

On Fri, May 11, 2007 at 07:13:48AM +1000, David Chinner wrote:
> On Thu, May 10, 2007 at 07:46:33AM -0700, Jeremy Fitzhardinge wrote:
> > David Chinner wrote:
> > > On Wed, May 09, 2007 at 05:54:09PM -0700, Jeremy Fitzhardinge wrote:
> > >   
> > >> David Chinner wrote:
> > >>     
> > >>> Suspend-resume, eh?
> > >>>
> > >>> There's an immediate suspect. Can you test this specifically for us?
> > >>> i.e. download a known good file set, do some stuff, suspend, resume,
> > >>> then check the files? If it doesn't show up the first time, can
> > >>> you do it a few times just to rule it out?
> > >>>       
> > >> Well, I've been doing suspend-resume with xfs for a while without
> > >> problems; the problems seem to be recent and easily repeatable.  Which
> > >> just means that it could be a new suspend-resume problem, of course.
> > >>     
> > >
> > > Ok. I'm just trying to find a relatively simple test case for the
> > > problem - seeing as you seem to be able to reliably reproduce this
> > > we should be able to work out the trigger...
> > >   
> > 
> > OK, I was able to reproduce it reliably with a script with did basically:
> > 
> >     for i in `seq 20`; do
> >     	hg clone -U --pull a b-$i
> >     	hg verify b-$i		# always OK
> >     	umount /home
> >     	sleep 5
> >     	mount /home
> >     	hg verify b-$i		# often found truncated files
> >     done
> >       
> > 
> > No suspend/resumes involved.  The trees are linux kernel ones, so fairly
> > large, but small enough to fit entirely in core.  My script also
> > captured xfs_bmap before/after output for files which had tended to be
> > corrupted in the past, but unfortunately none of them got corrupted in
> > these tests.  But I do have all the trees lying around to extract more
> > detail for if you like.
> 
> Ok, so most of the of the integrity errors are processed by an
> error like this:
> 
> drivers/scsi/sata_sil24.c index contains -98 extra bytes
> unpacking file drivers/scsi/sata_sil24.c 5715cdfceaca: Error -5 while decompressing data
> 
> That's an -EIO and not a normal error to report. Are there any
> errors in dmesg or syslog corresponding to this?
> 
> The errors tend to imply problems decompressing and patching files,
> not that truncates are occurring once the files have been patched.
> Can you check that what is being pulled from the repository is correct
> before it gets uncompressed?

Notice that verify gets run twice. Before unmount, it's fine, after
remount, it's not.

That message saying that the file contains -98 extra bytes is
Mercurial detecting the truncation before if tries to read and decompress the
truncated bit.

-- 
Mathematics is the supreme nostalgia of our time.
