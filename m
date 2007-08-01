Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 31 Jul 2007 18:33:06 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l711X1bm010037
	for <xfs@oss.sgi.com>; Tue, 31 Jul 2007 18:33:03 -0700
Message-ID: <46AFE2CB.6080102@agami.com>
Date: Tue, 31 Jul 2007 18:32:59 -0700
From: "William J. Earl" <earl@agami.com>
MIME-Version: 1.0
Subject: Re: RFC: log record CRC validation
References: <20070725092445.GT12413810@sgi.com> <46A7226D.8080906@sgi.com> <46A8DF7E.4090006@agami.com> <20070726233129.GM12413810@sgi.com> <46AAA340.60208@agami.com> <20070731053048.GP31489@sgi.com>
In-Reply-To: <20070731053048.GP31489@sgi.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, Michael Nishimoto <miken@agami.com>, markgw@sgi.com

David Chinner wrote:
> On Fri, Jul 27, 2007 at 07:00:32PM -0700, William J. Earl wrote:
>   
>> David Chinner wrote:
>>     
>>> ...
>>> The size of high-end filesystems are now at the same order of
>>> magnitude as the bit error rate of the storage hardware. e.g. 1PB =
>>> 10^16 bits. The bit error rate of high end FC drives? 1 in 10^16
>>> bits.  For "enterprise" SATA drives? 1 in 10^15 bits. For desktop
>>> SATA drives it's 1 in 10^14 bits (i.e. 1 in 10TB).
>>>       
>>       First, note that the claimed bit error rates are rates of 
>> reported bad blocks, not rates of silent data corruption.   The latter, 
>> while not quoted, are far lower.
>>     
>
> Ok, fair enough, but in the absense of numbers and the fact that
> real world MTBF numbers are lower than what mfg's quote I'm
> always going to assume that this is the ballpark.
>
>   
        The real world MTBF numbers are worse for people who use drives 
outside their specified parameters (as at Google) and better, at least 
in the first few years, for drives which are used inside their 
parameters, as far as I have seen at Agami and my previous company.   
Drive MTBF does not relate, however to data corruption, except in the 
case of a failed RAID reconstruction, and even then the error is 
reported.  
> ...
>
> IMO, continuing down this same "the block device is perfect" path is
> a "head in the sand" approach.  By ignoring the fact that errors can
> and do occur, we're screwing ourselves when something does actually
> go wrong because we haven't put in place the mechanisms to detect
> errors because we've assumed they will never happen.
>
> We've spent 15 years so far trying to work out what has gone wrong
> in XFS by adding more and more reactive debug into the code without
> an eye to a robust solution. We add a chunk of code here to detect
> that problem, a chunk of code there to detect this problem, and so
> on. It's just not good enough anymore.
>
> Like good security, filesystem integrity is not provided by a single
> mechanism. "Defense in depth" is what we are aiming to provide here
> and to do that you have to assume that errors can propagate through
> every interface into the filesystem.
>
>
>   
          I understand your argument, but why not simply strengthen the 
block layer, even you do it with an optional XFS-based checksum scheme 
on all blocks?   That way, you would not wind up detecting metadata 
corruption and silently ignoring file data corruption   For example, 
suppose you stole one block in N (where you might choose N according to 
the RAID data stripe size, when running over MD), and used it as a 
checksum block (storing (N-1)*K subblock checksums)?    This in effect 
would require either RAID full-stripe read-modify-write or at least an 
extra block read-modify-write for a real block write, but it would give 
you complete metadata and data integrity checking.   This could be an 
XFS feature or a new MD feature ("checksum" layer).  

         This would clearly be somewhat expensive for random writes, 
much like RAID 6, and also expensive for random reads, unless the N were 
equal to the RAID block size, but, as with the NetApp and Tandem 
software checksums, it would assure that a high level of data integrity.   

      If the RAID block size were moderately large, say 64 KB, then you 
could take one 4 KB block in 16 and pay only about 6% of the total 
space.   With modern disks, the extra sequential transfers (even if you 
have to read 64 KB to get 4 KB) would not be that significant, since 
rotational latency is the largest cost, not the actual data transfer.   
You would also use more main memory, since you would prefer to buffer at 
least the 4 KB checksum block associated with any 4 KB data blocks from 
the RAID block.  The extra memory would be between 6% and 100%, 
depending on how much locality there is in block accesses.   This in 
turn would cause more disk accesses, due to the cache holding fewer real 
data blocks.



[[HTML alternate version deleted]]
