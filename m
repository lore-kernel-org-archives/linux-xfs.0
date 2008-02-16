Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Feb 2008 21:07:29 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1G57Hw1032508
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 21:07:18 -0800
Received: from rv-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 17A0FE36B18
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 21:07:42 -0800 (PST)
Received: from rv-out-0910.google.com (rv-out-0910.google.com [209.85.198.187]) by cuda.sgi.com with ESMTP id 1IHnTHutEqBCBf1p for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 21:07:42 -0800 (PST)
Received: by rv-out-0910.google.com with SMTP id k20so576545rvb.32
        for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 21:07:41 -0800 (PST)
Message-ID: <e03b90ae0802152101t2bfa4644kcca5d6329239f9ff@mail.gmail.com>
Date: Fri, 15 Feb 2008 21:01:10 -0800
From: "Jeff Breidenbach" <jeff@jab.org>
Subject: tuning, many small files, small blocksize
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I'm testing xfs for use in storing 100 million+ small files
(roughly 4 to 10KB each) and some directories will contain
tens of thousands of files. There will be a lot of random
reading, and also some random writing, and very little
deletion. The underlying disks use linux software RAID-1
manged by mdadm with 5X redundancy. E.g. 5 drives that
completely mirror each other.

I am setting up the xfs partition now, and have only played
with blocksize so far. 512 byte blocks are most space efficient,
1024 byte blocks cost 3.3% additional space, and 4096 byte
blocks cost 22.3% additional space. I do not know of a good
way to benchmark filesystem speed; iozone -s 5 did not provide
meaningful results due to poor timing quantization.

My questions are:

a) Should I just go with the 512 byte blocksize or is that going to be
bad for some performance reason? Going to 1024 is no problem,
but I'd prefer not to waste 20% of the partition capacity by using 4096.

b) Are there any other mkfs.xfs paramters that I should play with.

Thanks for any response; I did do quite some searching for
recommended turning parameters, but did not find definitive answers.
The general consensus was xfs does pretty good tuning itself, but
almost none of the published benchmarks or recommendation go with
small blocksizes and I want to make sure I'm not about to do something
totally stupid. Like quadruple the number of seeks on the disk.
