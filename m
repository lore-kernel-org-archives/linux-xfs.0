Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 May 2007 11:38:27 -0700 (PDT)
Received: from ppsw-9.csi.cam.ac.uk (ppsw-9.csi.cam.ac.uk [131.111.8.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l41IcLfB004929
	for <xfs@oss.sgi.com>; Tue, 1 May 2007 11:38:23 -0700
In-Reply-To: <20070501042254.GD77450368@melbourne.sgi.com>
References: <20070412110550.GM5967@schatzie.adilger.int> <20070416112252.GJ48531920@melbourne.sgi.com> <20070419002139.GK5967@schatzie.adilger.int> <20070419015426.GM48531920@melbourne.sgi.com> <20070430224401.GX5967@schatzie.adilger.int> <20070501042254.GD77450368@melbourne.sgi.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <1FA8E92B-954D-4624-A089-80D4AA7399FD@cam.ac.uk>
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Date: Tue, 1 May 2007 19:37:20 +0100
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org

On 1 May 2007, at 05:22, David Chinner wrote:
> On Mon, Apr 30, 2007 at 04:44:01PM -0600, Andreas Dilger wrote:
>>   The FIBMAP ioctl is for privileged users
>>   only, and I wonder if FIEMAP should be the same, or at least  
>> disallow
>>   mapping files that the user can't access especially with  
>> FLAG_SYNC and/or
>>   FLAG_HSM_READ.
>
> I see little reason for restricting FI[BE]MAP to privileged users -
> anyone should be able to determine if files they have permission to
> access are fragmented.

Allowing anyone to run FI[BE]MAP creates potential for DOS-ing the  
machine.  Perhaps for non-privileged users FIEMAP has to be read- 
only?  As soon as any of the FLAG_* flags come into play you make it  
privileged.  For example fancy any user being able to fill up your  
file system by calling FIEMAP with FLAG_HSM_READ on all files  
recursively?  This should certainly not be simply dismissed as a non- 
issue without thinking about it first...

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/
