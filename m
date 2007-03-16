Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 Mar 2007 08:15:31 -0700 (PDT)
Received: from donner.stsci.edu (donner.stsci.edu [130.167.251.65])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2GFFM6p030986
	for <xfs@oss.sgi.com>; Fri, 16 Mar 2007 08:15:24 -0700
Message-ID: <45FAB480.908@stsci.edu>
Date: Fri, 16 Mar 2007 11:15:12 -0400
From: Thomas Walker <walker@stsci.edu>
MIME-Version: 1.0
Subject: Re: Should xfs_repair take this long?
References: <45F92D8C.3090708@stsci.edu> <20070315150422.7bc5d178@harpe.intellique.com> <45F952F2.6000008@stsci.edu> <20070315231031.GP6095633@melbourne.sgi.com>
In-Reply-To: <20070315231031.GP6095633@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com


     I see in other posts that "parted" is sometimes a culprit in these 
problems.  Indeed, in my case I did use "parted" to create a gpt 
partition table on these xfs volumes and I was asked my parted to use 
the secondary signature.

--- snip ---

i also remember something about parted (maybe...) finding a backup gpt
signature at the end of a disk, and "helpfully" copying it over the
front end if so.  This was a bug.  sgi guys do you remember?
    

But for this one has to invoke parted, and commit the operations done,
am I right?
  

if I recall, even invoking parted could do this.
--- snip ---

 

   So maybe I got bit the same way.  parted may be overwritten something 
at the head of the volume.  Is there any way to repair the super block 
though?  It seems that everyone agrees xfs can't do anything until it 
has a super block somewhere and I don't seem to have one.  If there's no 
way to repair, then what about recovery?  I see mention of possibly 
doing an xfs dump to another disk, reformat the original volume, and 
then xfs restore back.  Is there any online procedure for how to do that 
if it applies to me here?

   Thomas Walker

David Chinner wrote:

>On Thu, Mar 15, 2007 at 10:06:42AM -0400, Thomas Walker wrote:
>  
>
>>    The terminal shows a lot of "." dots running across the screen 
>>quickly, and every few hours it says this;
>>
>>
>>.....................................................found candidate 
>>secondary superblock...
>>unable to verify superblock, continuing...
>>found candidate secondary superblock...
>>unable to verify superblock, continuing...
>>    
>>
>
>The primary superblock is not good, and it's trying to find a valid
>secondary superblock. Doesn't sound promising so far - reapir can't
>start until a valid superblok is found....
>
>
>  
>
