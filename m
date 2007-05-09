Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 May 2007 09:54:08 -0700 (PDT)
Received: from mail.clusterfs.com (mail.clusterfs.com [206.168.112.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l49Gs4fB021251
	for <xfs@oss.sgi.com>; Wed, 9 May 2007 09:54:05 -0700
Date: Wed, 9 May 2007 09:54:02 -0700
From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and powerpc
Message-ID: <20070509165402.GO6375@schatzie.adilger.int>
References: <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426180332.GA7209@amitarora.in.ibm.com> <20070509160102.GA30745@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070509160102.GA30745@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On May 09, 2007  21:31 +0530, Amit K. Arora wrote:
> 2) For FA_UNALLOCATE mode, should the file system allow unallocation
>    of normal (non-preallocated) blocks (blocks allocated via
>    regular write/truncate operations) also (i.e. work as punch()) ?
>    - Though FA_UNALLOCATE mode is yet to be implemented on ext4, still
>      we need to finalize on the convention here as a general guideline
>      to all the filesystems that implement fallocate.

I would only allow this on FA_ALLOCATE extents.  That means it won't be
possible to do this for filesystems that don't understand unwritten
extents unless there are blocks allocated beyond EOF.

> 3) If above is true, the file size will need to be changed
>    for "unallocation" when block holding the EOF gets unallocated.
>    - If we do not "unallocate" normal (non-preallocated) blocks and we
>      do not change the file size on preallocation, then this is a
>      non-issue.

Not necessarily.  That will just make the file sparse.  If FA_ALLOCATE
does not change the file size, why should FA_UNALLOCATE.

> 4) Should we update mtime & ctime on a successfull allocation/
>    unallocation ?

I would say yes.  If glibc does the fallback fallocate via write() the
mtime/ctime will be updated, so it makes sense to be consistent for
both methods.  Also, it just makes sense from the "this file was modified"
point of view.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
