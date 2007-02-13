Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 Feb 2007 03:08:15 -0800 (PST)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1DB80m7010887
	for <linux-xfs@oss.sgi.com>; Tue, 13 Feb 2007 03:08:02 -0800
Subject: Re: mkfs and mount tips?
References: <Pine.LNX.4.64.0702130430030.8199@p34.internal.lan>
	<20070213103533.C89F519311@mail.edu.haifa.ac.il>
From: Andi Kleen <andi@firstfloor.org>
Date: 13 Feb 2007 12:57:36 +0100
In-Reply-To: <20070213103533.C89F519311@mail.edu.haifa.ac.il>
Message-ID: <p73mz3igthr.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Leon Kolchinsky <leonk@construct.haifa.ac.il>
Cc: 'Justin Piszcz' <jpiszcz@lucidpixels.com>, linux-xfs@oss.sgi.com

"Leon Kolchinsky" <leonk@construct.haifa.ac.il> writes:
> 
> What about "osyncisdsync" mount option, can someone recommend this based on
> its own experience?

Not sync metadata on O_SYNC writes.

That's also dangerous -- might cause data corruption after crash. It is mostly
a hack if you know your programs very well, but can't change them
to use O_DSYNC when they only need that.

Also his other options basically all just use more memory. If you
have a P90 you're likely low on memory for modern standards and 
shouldn't use them.

-Andi
