Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 May 2008 00:25:27 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4G7PCQd030941
	for <xfs@oss.sgi.com>; Fri, 16 May 2008 00:25:15 -0700
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <20080515141121.GA14198@infradead.org>
Subject: Re: [PATCH 3/4] XFS: Return case-insensitive match for dentry cache
References: <20080513075749.477238845@chook.melbourne.sgi.com> <20080513080152.911303131@chook.melbourne.sgi.com> <20080513085724.GC21919@infradead.org> <op.ua4wa7t03jf8g2@pc-bnaujok.melbourne.sgi.com> <20080515045700.GA4328@infradead.org> <op.ua6ji4r93jf8g2@pc-bnaujok.melbourne.sgi.com> <DCB15FFF-F942-47BD-B8FB-38AADC24B9D6@cam.ac.uk> <20080515141121.GA14198@infradead.org>
Message-Id: <7C3356E7-7985-4B0D-B29E-3357464ED787@cam.ac.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Fri, 16 May 2008 08:25:55 +0100
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>

Hi,

On 15 May 2008, at 15:11, Christoph Hellwig wrote:
> On Thu, May 15, 2008 at 02:43:44PM +0100, Anton Altaparmakov wrote:
>> Yes, and you can get the performance back if you allow negative  
>> dentries to
>> be created.  You just have to make sure that every time a directory  
>> entry
>> is created in directory X, all negative dentries which are children  
>> of
>> directory X are thrown away.
>
> We might even be able to optimize this a little by calling d_compare  
> on
> each alias to see if it hashes down to the same one down in the fs.


Perhaps, although I am not convinced that wouldn't be worse than just  
throwing them all away.  For example think of a very active directory  
with thousands of negative dentries in it.  A create comes in and we  
either throw away thousands of entries or we perform a case  
insensitive comparison thousands of times and discard only a few  
entries.  I am concerned that the "thousands of case insensitive  
comparisons" would actually be very costly and far outweigh the cost  
of throwing all negative dentries away and letting them be created  
again if they are requested again.

At lest in NTFS the case insensitive comparison is very expensive as  
it involves converting both the UTF8 strings into little endian 2-byte  
fixed width Unicode, and then for each Unicode character of each of  
the strings being compared, individually performing a look up in the  
128kiB large Unicode upcase table and then the two upcased characters  
are compared and if they match we move to the next character.

Doing that a thousand times would be way more expensive then simply  
throwing all negative dentries away I would think.

In the end it probably depends on the usage scenario as to what will  
be more efficient and perhaps on the file system as well so it may be  
worth allowing the file system to decide whether to try and do  
comparisons or to simply throw all the negative dentries away.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/
