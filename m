Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Jul 2006 01:00:14 -0700 (PDT)
Received: from talk.nabble.com (www.nabble.com [72.21.53.35])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6I802DW009575
	for <linux-xfs@oss.sgi.com>; Tue, 18 Jul 2006 01:00:03 -0700
Received: from [72.21.53.38] (helo=jubjub.nabble.com)
	by talk.nabble.com with esmtp (Exim 4.50)
	id 1G2kUV-00065A-8K
	for linux-xfs@oss.sgi.com; Tue, 18 Jul 2006 00:59:39 -0700
Message-ID: <5374022.post@talk.nabble.com>
Date: Tue, 18 Jul 2006 00:59:39 -0700 (PDT)
From: Cosmo Nova <cs_mcc98@hotmail.com>
Subject: Re: file system defragmentation
In-Reply-To: <20060717141917.GY2114946@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
References: <4f52331f050826001612f8e323@mail.gmail.com> <20050826101131.GA24544@ii.uib.no> <4f52331f0508260848782f240a@mail.gmail.com> <43128F82.4010004@tlinx.org> <4312913F.6040205@coremetrics.com> <43311567.3060208@tlinx.org> <5356806.post@talk.nabble.com> <20060717141917.GY2114946@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com


Hi, can I summarize by saying that, XFS still partition the volume into
different allocation groups, but there is NO locking. Two files may write in
the same allocation group and introduce fragments?
What is the maximum and typical number of allocation groups please? I can't
find the numbers in the source code...

And for the buffer, Is preallocation the same as delayed allocation? page
cache, as I remember belongs to Linux VFS. What are the memory / disk
requirement and sizing for the cache please? If a file space allocation is
delayed, what is the upper bound of the delayed size? Can files of MBs, GBs
being delayed allocate, and multiple channels/threads files all store in
memory?? How XFS's allocation works (with number please if possible) to help
tackle fragmentation?

Thankyou!
-- 
View this message in context: http://www.nabble.com/file-system-defragmentation-tf255485.html#a5374022
Sent from the Xfs - General forum at Nabble.com.
