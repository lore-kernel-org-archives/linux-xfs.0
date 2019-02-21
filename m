Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52034 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726335AbfBUXzK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Feb 2019 18:55:10 -0500
Subject: Re: [LSF/MM TOPIC] More async operations for file systems - async
 discard?
References: <92ab41f7-35bc-0f56-056f-ed88526b8ea4@gmail.com>
 <20190217210948.GB14116@dastard>
 <46540876-c222-0889-ddce-44815dcaad04@gmail.com>
 <20190220234723.GA5999@localhost.localdomain>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <45c27fea-6d74-2adc-fe9d-e314ce4f3672@suse.com>
Date: Thu, 21 Feb 2019 18:55:05 -0500
MIME-Version: 1.0
In-Reply-To: <20190220234723.GA5999@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Keith Busch <keith.busch@intel.com>, Ric Wheeler <ricwheeler@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, lsf-pc@lists.linux-foundation.org, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-block@vger.kernel.org

On 2/20/19 6:47 PM, Keith Busch wrote:
> On Sun, Feb 17, 2019 at 06:42:59PM -0500, Ric Wheeler wrote:
>> I think the variability makes life really miserable for layers above it.
>>
>> Might be worth constructing some tooling that we can use to validate or
>> shame vendors over - testing things like a full device discard, discard of
>> fs block size and big chunks, discard against already discarded, etc.
> 
> With respect to fs block sizes, one thing making discards suck is that
> many high capacity SSDs' physical page sizes are larger than the fs block
> size, and a sub-page discard is worse than doing nothing.
> 
> We've discussed previously about supporting block size larger than
> the system's page size, but it doesn't look like that's gone anywhere.
> Maybe it's worth revisiting since it's really inefficient if you write
> or discard at the smaller granularity.

Isn't this addressing the problem at the wrong layer?  There are other
efficiencies to be gained by larger block sizes, but better discard
behavior is a side effect.  As Dave said, the major file systems already
assemble contiguous extents as large we can can before sending them to
discard.  The lower bound for that is the larger of minimum lengths
passed by the user or provided by the block layer.  We've always been
told "don't worry about what the internal block size is, that only
matters to the FTL."  That's obviously not true, but when devices only
report a 512 byte granularity, we believe them and will issue discard
for the smallest size that makes sense for the file system regardless of
whether it makes sense (internally) for the SSD.  That means 4k for
pretty much anything except btrfs metadata nodes, which are 16k.

So, I don't think changing the file system block size is the right
approach.  It *may* bring benefits, but I think many of the same
benefits can be gained by using the minimum-size option for fstrim and
allowing the discard mount options to accept a minimum size as well.

-Jeff

-- 
Jeff Mahoney
SUSE Labs
