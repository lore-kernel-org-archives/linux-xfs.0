Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 May 2007 01:31:39 -0700 (PDT)
Received: from ppsw-7.csi.cam.ac.uk (ppsw-7.csi.cam.ac.uk [131.111.8.137])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l428VZfB015273
	for <xfs@oss.sgi.com>; Wed, 2 May 2007 01:31:36 -0700
In-Reply-To: <03C89173-3AD1-421F-B7A0-64C999BD9DAB@cam.ac.uk>
References: <20070412110550.GM5967@schatzie.adilger.int> <20070416112252.GJ48531920@melbourne.sgi.com> <20070419002139.GK5967@schatzie.adilger.int> <20070419015426.GM48531920@melbourne.sgi.com> <20070430224401.GX5967@schatzie.adilger.int> <20070501042254.GD77450368@melbourne.sgi.com> <20070501223040.GL5722@schatzie.adilger.int> <03C89173-3AD1-421F-B7A0-64C999BD9DAB@cam.ac.uk>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <69B76939-CAAD-4F43-BE9F-6C3CA3ECCF5E@cam.ac.uk>
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Date: Wed, 2 May 2007 09:30:17 +0100
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andreas Dilger <adilger@clusterfs.com>
Cc: David Chinner <dgc@sgi.com>, linux-ext4@vger.kernel.org, Linux Filesystems <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>

On 2 May 2007, at 09:23, Anton Altaparmakov wrote:
> On 1 May 2007, at 23:30, Andreas Dilger wrote:
>
>> On May 01, 2007  14:22 +1000, David Chinner wrote:
>>> On Mon, Apr 30, 2007 at 04:44:01PM -0600, Andreas Dilger wrote:
>>>> Hmm, I'd thought "offline" would migrate to EXTENT_UNKNOWN, but  
>>>> I didn't
>>>
>>> I disagree - why would you want to indicate the state is unknown  
>>> when we know
>>> very well that it is offline?
>>
>> If you don't like "UNKNOWN", what about "UNMAPPED"?  I just want a
>> catch-all flag that indicates "this extent contains data but there is
>> nothing sensible to be returned for the extent mapping."
>
> I like UNMAPPED.  I even use it in NTFS internally for extents maps  
> that have not been read into memory yet.  (-:

Oops, I use NOT_MAPPED in NTFS rather than UNMAPPED but I still like  
UNMAPPED, too.  (-:

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/
