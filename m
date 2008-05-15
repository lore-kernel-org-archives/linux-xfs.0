Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 May 2008 06:43:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4FDh4W3029565
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 06:43:07 -0700
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <op.ua6ji4r93jf8g2@pc-bnaujok.melbourne.sgi.com>
Subject: Re: [PATCH 3/4] XFS: Return case-insensitive match for dentry cache
References: <20080513075749.477238845@chook.melbourne.sgi.com> <20080513080152.911303131@chook.melbourne.sgi.com> <20080513085724.GC21919@infradead.org> <op.ua4wa7t03jf8g2@pc-bnaujok.melbourne.sgi.com> <20080515045700.GA4328@infradead.org> <op.ua6ji4r93jf8g2@pc-bnaujok.melbourne.sgi.com>
Message-Id: <DCB15FFF-F942-47BD-B8FB-38AADC24B9D6@cam.ac.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Thu, 15 May 2008 14:43:44 +0100
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>

Hi,

On 15 May 2008, at 06:14, Barry Naujok wrote:
> On Thu, 15 May 2008 14:57:00 +1000, Christoph Hellwig <hch@infradead.org 
> > wrote:
>> On Wed, May 14, 2008 at 05:55:45PM +1000, Barry Naujok wrote:
>>> Not quite sure if this is the right test, but I did 1000 creates on
>>> a brand new filesystem with and without ci on my SATA drive, both
>>> sustained almost 600 creates per second.
>>>
>>> I believe creates would be the worst case scenario for not adding
>>> negative dentries?
>>
>> No, negative dentries shouldn't have any effect on that.  negative
>> entries help to optimize away lookups.  E.g. thing of the PATH  
>> variable
>> and say your shell is not in the first directory listed there.   
>> Having
>> a negative dentry for it means that you don't have to do a lookup in
>> the first directories everytime someone wants to use the shell.
>
> Ah, that makes more sense. I did a test of a million lookups to a
> non-existant file in a short-form directory (dual 1.6G opteron):
>
> CI = 4.6s
> non-CI = 3.7s
>
> And a directory with 10000 files:
>
> CI = 10.3s
> non-CI = 3.9s


Yes, and you can get the performance back if you allow negative  
dentries to be created.  You just have to make sure that every time a  
directory entry is created in directory X, all negative dentries which  
are children of directory X are thrown away.

Failure to do so will result in lookups returning ENOENT even though a  
file now exists that matches case insensitively.  This happens because  
the VFS will find the negative dentry and return ENOENT without  
calling the file system lookup method thus the file system does not  
get a chance to discover the new matching directory entry...

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/
