Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 31 Jul 2008 17:10:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7109nSr029850
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2008 17:09:50 -0700
Received: from ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 18CB3EE9AA9
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2008 17:11:02 -0700 (PDT)
Received: from ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by cuda.sgi.com with ESMTP id DRJ4rY1j2ZckIm0J for <xfs@oss.sgi.com>; Thu, 31 Jul 2008 17:11:02 -0700 (PDT)
Received: from [192.168.3.11] (Athena [192.168.3.11])
	by ishtar.tlinx.org (8.14.1/8.12.10/SuSE Linux 0.7) with ESMTP id m710B1gq030954
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2008 17:11:01 -0700
Message-ID: <48925495.7040804@tlinx.org>
Date: Thu, 31 Jul 2008 17:11:01 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Question about extended attributes...
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

my man page says extended xfs attributes can have 256-byte names
with up to 64K of data.

Is there a limit on the number of extended attributes max data size or 
name size?

I.e. could I have 1000 attributes with 64K of data each?

Is there a strong reason why the file and data sizes were limited to 
256/64K?
Would they be hard to 'generalize' to max-path-segment-len/max-filelen?

Only reason I wonder is wondering what file systems besides apple's 
"HPFS"(?) and
MS's NTFS, that allow alternate data-streams of arbitrary length.  I'm 
not sure about
the maximums on HPFS and NTFS, but I haven't _read_ of any notable 
limits (I'm sure
there are some, but it _seems_ you can store alternate file versions in 
different data-streams
on NTFS, for example...  I.e. could use it as a revision system, 
theoretically -- to save
older versions of the file with the right software -- but with XFS, it 
wouldn't be so
general case with a 64K data limit -- wouldn't be a show-stopper if one 
could 'link'
multiple data-segments, but am just curious about the limitations (not 
that I'm planning
on implementing a version control system using data-forks...it was just 
an example! :-)).

linda
