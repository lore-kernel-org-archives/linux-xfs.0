Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Dec 2006 13:28:12 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kB5LS0aG009034
	for <xfs@oss.sgi.com>; Tue, 5 Dec 2006 13:28:02 -0800
Date: Wed, 6 Dec 2006 08:26:49 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: mkfs.xfs questions
Message-ID: <20061205212649.GV44411608@melbourne.sgi.com>
References: <20061129174553.e0ef3465.jasmin@pacifica.ch> <Pine.LNX.4.64.0612010410530.3735@sheep.housecafe.de> <20061201183034.GA20595@teal.hq.k1024.org> <Pine.LNX.4.64.0612012349020.3735@sheep.housecafe.de> <20061202111546.GA18661@teal.hq.k1024.org> <Pine.LNX.4.64.0612051741520.22257@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0612051741520.22257@sheep.housecafe.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Kujau <christian@nerdbynature.de>
Cc: Iustin Pop <iusty@k1024.org>, xfs@oss.sgi.com, jasmin@pacifica.ch

On Tue, Dec 05, 2006 at 05:46:15PM +0000, Christian Kujau wrote:
> On Sat, 2 Dec 2006, Iustin Pop wrote:
> >Hmm, I am pretty sure that it makes a difference, but only from personal
> >experience, not from benchmarks. A while ago, mkfs.xfs used to make <8M
> >logs even for big filesystems[0]. Nowadays it chooses a more sane value.
> 
> I could not stand my own curiosity, so here it is: 
> http://nerdbynature.de/wp/?cat=4

One line summary:

"The results however are a bit boring and I for one have no reason to tweak
these options for a desktop machine."

For that data set size you tested. However you might find a
difference if your tests actually write the data back to disk
because a lot of the tests are running out of cache.

> I think I'll repeat the benchmarks with bigger test sizes. The 
> testscript can easily be adjusted to test more options/values.

I think you need to to have any hope of demonstrating a
difference in performance from the mkfs/mount options.

Typically, you need to be writing/reading files at least 2x the
size of memory and create/delete a fileset of at least 1,000,000
files to really determine differences in performance from
these parameters...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
