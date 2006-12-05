Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Dec 2006 11:39:14 -0800 (PST)
Received: from astra.simleu.ro (astra.simleu.ro [80.97.18.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB5Jd4aG020686
	for <xfs@oss.sgi.com>; Tue, 5 Dec 2006 11:39:06 -0800
Date: Tue, 5 Dec 2006 19:44:56 +0100
From: Iustin Pop <iusty@k1024.org>
Subject: Re: mkfs.xfs questions
Message-ID: <20061205184456.GA12989@teal.hq.k1024.org>
References: <20061129174553.e0ef3465.jasmin@pacifica.ch> <Pine.LNX.4.64.0612010410530.3735@sheep.housecafe.de> <20061201183034.GA20595@teal.hq.k1024.org> <Pine.LNX.4.64.0612012349020.3735@sheep.housecafe.de> <20061202111546.GA18661@teal.hq.k1024.org> <Pine.LNX.4.64.0612051741520.22257@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0612051741520.22257@sheep.housecafe.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Kujau <christian@nerdbynature.de>
Cc: xfs@oss.sgi.com, jasmin@pacifica.ch

On Tue, Dec 05, 2006 at 05:46:15PM +0000, Christian Kujau wrote:
> On Sat, 2 Dec 2006, Iustin Pop wrote:
> >Hmm, I am pretty sure that it makes a difference, but only from personal
> >experience, not from benchmarks. A while ago, mkfs.xfs used to make <8M
> >logs even for big filesystems[0]. Nowadays it chooses a more sane value.
> 
> I could not stand my own curiosity, so here it is: 
> http://nerdbynature.de/wp/?cat=4
> 
> I think I'll repeat the benchmarks with bigger test sizes. The 
> testscript can easily be adjusted to test more options/values.

Hmm, I see tests with 32M logs and 64M logs. Try running the file
creation/deletion test also with 4M, 8M, 16M, and then I'll think there
will be a difference.

Iustin
