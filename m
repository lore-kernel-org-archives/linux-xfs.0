Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Aug 2006 22:39:31 -0700 (PDT)
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7T5dEDW005171
	for <xfs@oss.sgi.com>; Mon, 28 Aug 2006 22:39:20 -0700
Received: by py-out-1112.google.com with SMTP id x31so2492119pye
        for <xfs@oss.sgi.com>; Mon, 28 Aug 2006 22:38:42 -0700 (PDT)
From: "gert wohlgemuth" <wohlgemuth@ucdavis.edu>
Subject: RE: accidently deleted files from directory
Date: Mon, 28 Aug 2006 21:28:46 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <20060829041635.GA3166@tuatara.stupidest.org>
Message-ID: <44f3c278.059fc255.3075.3597@mx.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Chris Wedgwood' <cw@f00f.org>
Cc: xfs@oss.sgi.com

Thx,

I thought so that the data are gone and it's to much to glue it, cause all
binary data.

So time to step back to ext2, here at least I can restore the data in the
worst case.

...not that it ever happens again...

g.


-----Original Message-----
From: Chris Wedgwood [mailto:cw@f00f.org] 
Sent: Monday, August 28, 2006 9:17 PM
To: gert wohlgemuth
Cc: xfs@oss.sgi.com
Subject: Re: accidently deleted files from directory

On Mon, Aug 28, 2006 at 05:05:30PM -0700, gert wohlgemuth wrote:

> On the weekend it happens that I accidentally deleted 1 TB of data
> (rm -rdf /mnt/lcq). We have no backup of the data (internal reasons
> of the university...) and it would be nice to get the data somehow
> back.

ouch

> after I did a cat /dev/sda1 | less I could see that some data are still
> exist and are not overwritten. So I think "all" what I have todo is some
how
> get the journal back.

that won't suffice, the metadata showing where all the files are is
likely gone

> Is there anyway or is all hope lost?

if you know what the data looks like heuristically scan for it and try
to glue the fragments back together...
