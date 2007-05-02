Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 May 2007 02:57:55 -0700 (PDT)
Received: from ppsw-7.csi.cam.ac.uk (ppsw-7.csi.cam.ac.uk [131.111.8.137])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l429vnfB007855
	for <xfs@oss.sgi.com>; Wed, 2 May 2007 02:57:52 -0700
In-Reply-To: <20070502094851.GX77450368@melbourne.sgi.com>
References: <20070412110550.GM5967@schatzie.adilger.int> <20070416112252.GJ48531920@melbourne.sgi.com> <20070419002139.GK5967@schatzie.adilger.int> <20070419015426.GM48531920@melbourne.sgi.com> <20070430224401.GX5967@schatzie.adilger.int> <20070501042254.GD77450368@melbourne.sgi.com> <20070501223040.GL5722@schatzie.adilger.int> <03C89173-3AD1-421F-B7A0-64C999BD9DAB@cam.ac.uk> <20070502094851.GX77450368@melbourne.sgi.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <C9137760-611F-4676-810C-5AD08B8D39CF@cam.ac.uk>
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Date: Wed, 2 May 2007 10:56:03 +0100
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Andreas Dilger <adilger@clusterfs.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org

On 2 May 2007, at 10:48, David Chinner wrote:
> On Wed, May 02, 2007 at 09:23:38AM +0100, Anton Altaparmakov wrote:
>> On a different issue, do you think it would be worth adding an option
>> flags like FIEMAP_DONT_RELOCATE or something similar that would be a
>> compulsory flag and if set the FS is not allowed to move the file
>> around/change the block allocation of the file.
>
> We already have an inode flag in XFS to say this - the defrag
> tool checks it and ignores the file if it is set.

That is great for XFS but you control the metadata.  NTFS, HFS, etc  
are cases where we cannot add such a flag because we cannot modify  
the metadata format (ok we could in some kludgy manner like storing  
an EA with an inode to say "com.linux.ntfs.immutable" or something  
but I would rather not if I can avoid it).

>> Or alternatively a flag like FIEMAP_MAKE_DIRECT or something to tell
>> the FS we want to access the actual raw blocks so the FS can make
>> sure the data is on block aligned boundaries and if the FS does not
>> support this (e.g. ZFS or a compressed or encrypted NTFS file) then
>> it can return -ENOTSUP.
>>
>> Perhaps this is totally the wrong interface and such a "prepare file
>> for direct access" API should be a different ioctl() or syscall or
>> whatever.  It just seems very simple and appropriate to combine it
>> here as people who use FIEMAP are at least sometimes going to be
>> wanting to access those blocks directly as well and it feels right to
>> be able to communicate this to the FS in the same call, kind of like
>> an "open intent" of "I want to use the data directly on disk"...
>
> I think this is wrong interface for this. Sure, use it to get the
> mappings (that's what it's for) but what you do with the mappings
> after that is not part of FIEMAP....

Thanks for the comments.  I am not sure it is a good idea either,  
just thought it would be worth discussing in case people thought it a  
good idea.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/
