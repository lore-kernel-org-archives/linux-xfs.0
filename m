Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Dec 2006 14:29:16 -0800 (PST)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB5MT7aG015152
	for <xfs@oss.sgi.com>; Tue, 5 Dec 2006 14:29:08 -0800
Date: Tue, 5 Dec 2006 22:28:18 +0000 (GMT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: mkfs.xfs questions
In-Reply-To: <20061205212649.GV44411608@melbourne.sgi.com>
Message-ID: <Pine.LNX.4.64.0612052219440.22257@sheep.housecafe.de>
References: <20061129174553.e0ef3465.jasmin@pacifica.ch>
 <Pine.LNX.4.64.0612010410530.3735@sheep.housecafe.de>
 <20061201183034.GA20595@teal.hq.k1024.org> <Pine.LNX.4.64.0612012349020.3735@sheep.housecafe.de>
 <20061202111546.GA18661@teal.hq.k1024.org> <Pine.LNX.4.64.0612051741520.22257@sheep.housecafe.de>
 <20061205212649.GV44411608@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Iustin Pop <iusty@k1024.org>, xfs@oss.sgi.com

On Wed, 6 Dec 2006, David Chinner wrote:
> For that data set size you tested. However you might find a
> difference if your tests actually write the data back to disk
> because a lot of the tests are running out of cache.

Ha, thanks for reminding me!
Now I remember why all my other tests were done with 2GB of data, having 
1GB of RAM ;)

> Typically, you need to be writing/reading files at least 2x the
> size of memory

I started a test with 4GB of data (bonnie++ -s 4096m) an hour ago...

> and create/delete a fileset of at least 1,000,000
> files to really determine differences in performance from

hm, that would be 'bonnie++ -n 1000' instead of the "-n 100" I'm testing 
right now.

Thanks for the hints, David! If you/someone know any 
better/closer-to-real-usage benchmarks, please let me know. I'm testing 
with bonnie++ because it I don't know any better. is iozone any 
good? is tiobench still worth to try?

Christian.
-- 
BOFH excuse #208:

Your mail is being routed through Germany ... and they're censoring us.
