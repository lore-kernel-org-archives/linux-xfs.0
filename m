Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 May 2007 09:01:23 -0700 (PDT)
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l49G1IfB007772
	for <xfs@oss.sgi.com>; Wed, 9 May 2007 09:01:19 -0700
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l49FvoGr002654
	for <xfs@oss.sgi.com>; Wed, 9 May 2007 11:57:50 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l49G1Aa6133268
	for <xfs@oss.sgi.com>; Wed, 9 May 2007 10:01:11 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l49G19kR006076
	for <xfs@oss.sgi.com>; Wed, 9 May 2007 10:01:10 -0600
Date: Wed, 9 May 2007 21:31:02 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and powerpc
Message-ID: <20070509160102.GA30745@amitarora.in.ibm.com>
References: <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426180332.GA7209@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426180332.GA7209@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

I have the updated patches ready which take care of Andrew's comments.
Will run some tests and post them soon.

But, before submitting these patches, I think it will be better to finalize
on certain things which might be worth some discussion here:

1) Should the file size change when preallocation is done beyond EOF ?
   - Andreas and Chris Wedgwood are in favor of not changing the
     file size in this case. I also tend to agree with them. Does anyone
     has an argument in favor of changing the filesize ?
     If not, I will remove the code which changes the filesize, before I
     resubmit the concerned ext4 patch.

2) For FA_UNALLOCATE mode, should the file system allow unallocation
   of normal (non-preallocated) blocks (blocks allocated via
   regular write/truncate operations) also (i.e. work as punch()) ?
   - Though FA_UNALLOCATE mode is yet to be implemented on ext4, still
     we need to finalize on the convention here as a general guideline
     to all the filesystems that implement fallocate.

3) If above is true, the file size will need to be changed
   for "unallocation" when block holding the EOF gets unallocated.
   - If we do not "unallocate" normal (non-preallocated) blocks and we
     do not change the file size on preallocation, then this is a
     non-issue.

4) Should we update mtime & ctime on a successfull allocation/
   unallocation ?
   - David Chinner raised this question in following post:
     http://lkml.org/lkml/2007/4/29/407
     I think it makes sense to update the [mc]time for a successfull
     preallocation/unallocation. Does anyone feel otherwise ?
     It will be interesting to know how XFS behaves currently. Does XFS
     update [mc]time for preallocation ?


--
Regards,
Amit Arora
