Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 May 2007 01:18:25 -0700 (PDT)
Received: from ppsw-7.csi.cam.ac.uk (ppsw-7.csi.cam.ac.uk [131.111.8.137])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l428IKfB012099
	for <xfs@oss.sgi.com>; Wed, 2 May 2007 01:18:21 -0700
In-Reply-To: <20070502000654.GK77450368@melbourne.sgi.com>
References: <20070412110550.GM5967@schatzie.adilger.int> <20070416112252.GJ48531920@melbourne.sgi.com> <20070419002139.GK5967@schatzie.adilger.int> <20070419015426.GM48531920@melbourne.sgi.com> <20070430224401.GX5967@schatzie.adilger.int> <20070501042254.GD77450368@melbourne.sgi.com> <1FA8E92B-954D-4624-A089-80D4AA7399FD@cam.ac.uk> <20070502000654.GK77450368@melbourne.sgi.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <8464EA47-03AC-4162-A2D0-683517568640@cam.ac.uk>
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Date: Wed, 2 May 2007 09:16:04 +0100
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org

On 2 May 2007, at 01:06, David Chinner wrote:
> On Tue, May 01, 2007 at 07:37:20PM +0100, Anton Altaparmakov wrote:
>> On 1 May 2007, at 05:22, David Chinner wrote:
>>> On Mon, Apr 30, 2007 at 04:44:01PM -0600, Andreas Dilger wrote:
>>>>  The FIBMAP ioctl is for privileged users
>>>>  only, and I wonder if FIEMAP should be the same, or at least
>>>> disallow
>>>>  mapping files that the user can't access especially with
>>>> FLAG_SYNC and/or
>>>>  FLAG_HSM_READ.
>>>
>>> I see little reason for restricting FI[BE]MAP to privileged users -
>>> anyone should be able to determine if files they have permission to
>>> access are fragmented.
>>
>> Allowing anyone to run FI[BE]MAP creates potential for DOS-ing the
>> machine.  Perhaps for non-privileged users FIEMAP has to be read-
>> only?  As soon as any of the FLAG_* flags come into play you make it
>> privileged.  For example fancy any user being able to fill up your
>> file system by calling FIEMAP with FLAG_HSM_READ on all files
>> recursively?
>
> By that reasoning, users should not be allowed to recall any files
> without root privileges. HSMs don't work that way, though - any user
> is allowed to recall any files they have permission to access either
> by manual command or by trying to read the file daata.
>
> If that runs the filesytem out of space, then the HSM either hasn't
> been configured properly or it's failed to manage the space
> correctly. Either way, that's not the fault of the user for
> recalling their own files.
>
> Hence allowing FIEMAP to be executed by the user does not open up
> any DOS conditions that don't already exist in normal HSM-managed
> filesystem.

Sorry, it was not a great example.  But the point still stands that  
there are/may be created flags that you do not want to allow everyone  
to use.

I completely agree with Andreas that those can simply return -EPERM  
and the rest can be allowed through.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/
