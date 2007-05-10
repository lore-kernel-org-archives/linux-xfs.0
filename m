Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 May 2007 18:00:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4A0xvfB000479
	for <xfs@oss.sgi.com>; Wed, 9 May 2007 17:59:59 -0700
Date: Thu, 10 May 2007 10:59:26 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and powerpc
Message-ID: <20070510005926.GT85884050@sgi.com>
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

On Wed, May 09, 2007 at 09:31:02PM +0530, Amit K. Arora wrote:
> I have the updated patches ready which take care of Andrew's comments.
> Will run some tests and post them soon.
> 
> But, before submitting these patches, I think it will be better to finalize
> on certain things which might be worth some discussion here:
> 
> 1) Should the file size change when preallocation is done beyond EOF ?
>    - Andreas and Chris Wedgwood are in favor of not changing the
>      file size in this case. I also tend to agree with them. Does anyone
>      has an argument in favor of changing the filesize ?
>      If not, I will remove the code which changes the filesize, before I
>      resubmit the concerned ext4 patch.

I think there needs to be both. If we don't have a mechanism to
atomically change the file size with the preallocation, then
applications that use stat() to work out if they need to preallocate
more space will end up racing.

> 2) For FA_UNALLOCATE mode, should the file system allow unallocation
>    of normal (non-preallocated) blocks (blocks allocated via
>    regular write/truncate operations) also (i.e. work as punch()) ?

Yes. That is the current XFS implementation for XFS_IOC_UNRESVSP, and
what i did for FA_UNALLOCATE as well.

>    - Though FA_UNALLOCATE mode is yet to be implemented on ext4, still
>      we need to finalize on the convention here as a general guideline
>      to all the filesystems that implement fallocate.
> 
> 3) If above is true, the file size will need to be changed
>    for "unallocation" when block holding the EOF gets unallocated.

No - we punch a hole. If you want the filesize to change, then
you use ftruncate() to remove the blocks at EOF and change the
file size atomically.

> 4) Should we update mtime & ctime on a successfull allocation/
>    unallocation ?
>    - David Chinner raised this question in following post:
>      http://lkml.org/lkml/2007/4/29/407
>      I think it makes sense to update the [mc]time for a successfull
>      preallocation/unallocation. Does anyone feel otherwise ?
>      It will be interesting to know how XFS behaves currently. Does XFS
>      update [mc]time for preallocation ?

No, XFS does *not* update a/m/ctime on prealloc/punch unless the file size
changes. If the filesize changes, it behaves exactly the same way that
ftruncate() behaves.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
