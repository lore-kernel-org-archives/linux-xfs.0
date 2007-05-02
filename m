Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 May 2007 01:25:15 -0700 (PDT)
Received: from ppsw-7.csi.cam.ac.uk (ppsw-7.csi.cam.ac.uk [131.111.8.137])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l428P7fB013738
	for <xfs@oss.sgi.com>; Wed, 2 May 2007 01:25:08 -0700
In-Reply-To: <20070501223040.GL5722@schatzie.adilger.int>
References: <20070412110550.GM5967@schatzie.adilger.int> <20070416112252.GJ48531920@melbourne.sgi.com> <20070419002139.GK5967@schatzie.adilger.int> <20070419015426.GM48531920@melbourne.sgi.com> <20070430224401.GX5967@schatzie.adilger.int> <20070501042254.GD77450368@melbourne.sgi.com> <20070501223040.GL5722@schatzie.adilger.int>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <03C89173-3AD1-421F-B7A0-64C999BD9DAB@cam.ac.uk>
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Date: Wed, 2 May 2007 09:23:38 +0100
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andreas Dilger <adilger@clusterfs.com>
Cc: David Chinner <dgc@sgi.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org

On 1 May 2007, at 23:30, Andreas Dilger wrote:

> On May 01, 2007  14:22 +1000, David Chinner wrote:
>> On Mon, Apr 30, 2007 at 04:44:01PM -0600, Andreas Dilger wrote:
>>> Hmm, I'd thought "offline" would migrate to EXTENT_UNKNOWN, but I  
>>> didn't
>>
>> I disagree - why would you want to indicate the state is unknown  
>> when we know
>> very well that it is offline?
>
> If you don't like "UNKNOWN", what about "UNMAPPED"?  I just want a
> catch-all flag that indicates "this extent contains data but there is
> nothing sensible to be returned for the extent mapping."

I like UNMAPPED.  I even use it in NTFS internally for extents maps  
that have not been read into memory yet.  (-:

On a different issue, do you think it would be worth adding an option  
flags like FIEMAP_DONT_RELOCATE or something similar that would be a  
compulsory flag and if set the FS is not allowed to move the file  
around/change the block allocation of the file.

My thinking is that the extent map is not terribly useful if the FS  
goes and relocates the file to somewhere else just after you have  
done the ioctl.  For example HFS on OSX automatically defragments  
files whilst it is running...  Linux file systems may one day do  
similar things.

Or alternatively a flag like FIEMAP_MAKE_DIRECT or something to tell  
the FS we want to access the actual raw blocks so the FS can make  
sure the data is on block aligned boundaries and if the FS does not  
support this (e.g. ZFS or a compressed or encrypted NTFS file) then  
it can return -ENOTSUP.

Perhaps this is totally the wrong interface and such a "prepare file  
for direct access" API should be a different ioctl() or syscall or  
whatever.  It just seems very simple and appropriate to combine it  
here as people who use FIEMAP are at least sometimes going to be  
wanting to access those blocks directly as well and it feels right to  
be able to communicate this to the FS in the same call, kind of like  
an "open intent" of "I want to use the data directly on disk"...

What do you think?

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/
