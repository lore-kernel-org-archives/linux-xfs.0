Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 31 Aug 2006 04:25:45 -0700 (PDT)
Received: from kernel.dk (brick.kernel.dk [62.242.22.158])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7VBPKDW007792
	for <xfs@oss.sgi.com>; Thu, 31 Aug 2006 04:25:22 -0700
Date: Thu, 31 Aug 2006 11:24:41 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: vmsplice can't work well
Message-ID: <20060831092440.GC5528@kernel.dk>
References: <44F4440F.1090300@gmail.com> <20060829140542.GN12257@kernel.dk> <44F5CC08.8010205@mnsu.edu> <20060830174815.GF7331@kernel.dk> <44F5D3C6.1010108@mnsu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44F5D3C6.1010108@mnsu.edu>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Jeffrey E. Hundstad" <jeffrey.hundstad@mnsu.edu>
Cc: xfs@oss.sgi.com, nathans@sgi.com

XFS list,

On Wed, Aug 30 2006, Jeffrey E. Hundstad wrote:
> Jens Axboe wrote:
> >On Wed, Aug 30 2006, Jeffrey E. Hundstad wrote:
> >  
> >>I tried your splie-git...tar.gz file and tried the splice-cp.  It 
> >>produced files that are the right length... but the files only contain 
> >>nulls.  Here's the straces:
> >>    
> >
> >Works for me as well. Could be an fs issue, how large was the README and
> >what filesystem did you use?
> >
> >  
> The file was 1130 bytes (it was the README in that directory.)  The 
> filesystem is XFS.
> 

I can reproduce this quite easily, doing:

nelson:~ # splice-cp sda.blktrace.0 foo

nelson:~ # md5sum sda.blktrace.0 foo
4754070ae77091468c830ea23b125d68  sda.blktrace.0
efdc7b9d00692fdfe91a691277209267  foo

'foo' contains only zeroes. Doing the same on ext3 yields the correct
results, foo contains the right data. I'm testing on
2.16.18-rc5-current, Jeffrey used 2.6.17.x latest.

-- 
Jens Axboe
