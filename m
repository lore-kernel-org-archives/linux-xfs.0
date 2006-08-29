Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Aug 2006 21:17:20 -0700 (PDT)
Received: from smtp114.sbc.mail.mud.yahoo.com (smtp114.sbc.mail.mud.yahoo.com [68.142.198.213])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7T4HADW028689
	for <xfs@oss.sgi.com>; Mon, 28 Aug 2006 21:17:11 -0700
Date: Mon, 28 Aug 2006 21:16:35 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: accidently deleted files from directory
Message-ID: <20060829041635.GA3166@tuatara.stupidest.org>
References: <44f384c5.270c085b.5896.ffff9b29@mx.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44f384c5.270c085b.5896.ffff9b29@mx.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: gert wohlgemuth <wohlgemuth@ucdavis.edu>
Cc: xfs@oss.sgi.com

On Mon, Aug 28, 2006 at 05:05:30PM -0700, gert wohlgemuth wrote:

> On the weekend it happens that I accidentally deleted 1 TB of data
> (rm -rdf /mnt/lcq). We have no backup of the data (internal reasons
> of the university...) and it would be nice to get the data somehow
> back.

ouch

> after I did a cat /dev/sda1 | less I could see that some data are still
> exist and are not overwritten. So I think "all" what I have todo is some how
> get the journal back.

that won't suffice, the metadata showing where all the files are is
likely gone

> Is there anyway or is all hope lost?

if you know what the data looks like heuristically scan for it and try
to glue the fragments back together...
