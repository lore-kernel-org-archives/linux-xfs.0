Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 May 2008 06:37:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4FDb2LY028977
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 06:37:09 -0700
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <20080515043546.GA22054@infradead.org>
Subject: Re: VFS case-insenstive dcache code (was Re: [PATCH 0/4] XFS: ASCII case-insensitivity support)
References: <20080514075244.738514733@chook.melbourne.sgi.com> <20080514084344.GA4333@infradead.org> <op.ua57wpji3jf8g2@pc-bnaujok.melbourne.sgi.com> <20080515043546.GA22054@infradead.org>
Message-Id: <CC175332-A5E6-4075-9596-5D351A5C874B@cam.ac.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Thu, 15 May 2008 14:37:45 +0100
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

Hi,

On 15 May 2008, at 05:35, Christoph Hellwig wrote:
> On Thu, May 15, 2008 at 11:03:51AM +1000, Barry Naujok wrote:
>> On Wed, 14 May 2008 18:43:44 +1000, Christoph Hellwig <hch@infradead.org 
>> >
>> wrote:
>>
>>> All patches looks good to me, but please add a comment describing  
>>> the
>>> conditional d_reash in the create case.
>>
>> I'm separating the "return name" patch into two patches: one for  
>> the dcache
>> code which Anton wrote and one with the XFS specific code.
>>
>> So, how does one apply the Signed-off line and copyright for the  
>> dcache
>> code (below - possibly mangled)?
>
> In this from it should be From: and Signed-off-by: you as you factored
> it out of the ntfs code.  Just mention it's originally Anton's ntfs
> code in the description.  Of course getting Anton to sign off on it
> and prepare a patch to use it in ntfs would be even better.

You can certainly add SOB:

Signed-off-by: Anton Altaparmakov <aia21@cantab.net> to the patch.  It  
looks good to me.

Once Linus has applied this I will try and get NTFS switched to using  
the new function.  I have got a few other patches that need applying  
for NTFS anyway so I will roll them all up in one go into the NTFS git  
tree and get Linus to apply them...

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/
