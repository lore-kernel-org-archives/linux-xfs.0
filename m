Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Jul 2006 03:36:30 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6HAa2DW020958
	for <linux-xfs@oss.sgi.com>; Mon, 17 Jul 2006 03:36:14 -0700
Message-ID: <44BB592E.1040400@melbourne.sgi.com>
Date: Mon, 17 Jul 2006 19:32:30 +1000
From: David Chatterton <chatz@melbourne.sgi.com>
Reply-To: chatz@melbourne.sgi.com
MIME-Version: 1.0
Subject: Re: file system defragmentation
References: <4f52331f050826001612f8e323@mail.gmail.com> <20050826101131.GA24544@ii.uib.no> <4f52331f0508260848782f240a@mail.gmail.com> <43128F82.4010004@tlinx.org> <4312913F.6040205@coremetrics.com> <43311567.3060208@tlinx.org> <5356806.post@talk.nabble.com>
In-Reply-To: <5356806.post@talk.nabble.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Cosmo Nova <cs_mcc98@hotmail.com>
Cc: linux-xfs@oss.sgi.com



Cosmo Nova wrote:
> Hi, you mentioned delayed allocation. What is the size of the buffer holding
> the data, before they're actually written to disk? How can it tackle growing
> files?

I'll leave the details for Nathan/Dave...

> 
> If I have a DVR system of 16 channels. They keep writing data to the disk in
> pieces of video files. I read some spec of xfs. Apart from extend-based
> allocation, there're allocaiton groups in xfs. I would like to ask, does
> XFS's allocation groups work similar as JFS's, which would lock an
> allocation group for individual file write? How does the allocation group in
> XFS work? And how would it help the fragmentation problem?
> 

Locking down an allocation group is part of what a new "filestream"
mount option will provide. This feature is already in use at a
number of IRIX sites with media apps (mainly in conjunction with CXFS
since you have more writers in a clustered filesystem and more need to
lock down contiguous space), and is coming to Linux XFS soon.

The best way to tackle fragementation with streaming data is to
preallocate space for the files. This allows the allocator to
try to find the space you require using as large contiguous chunks
as it can find. See xfsctl(3).

David

-- 
David Chatterton                   Phone: +61 3 9963 1934
XFS Engineering Manager            Mobile: +61 409 154 121
SGI Australia          http://www.sgi.com/products/storage
