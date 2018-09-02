Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55624 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbeIBWJX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 2 Sep 2018 18:09:23 -0400
Subject: Re: [PATCH, RFC] xfs: re-enable FIBMAP on reflink; disable for swap
References: <2eb759e5-2faa-67fd-5c16-c1d8edc42d02@redhat.com>
 <20180830162545.GA26816@lst.de>
 <dbe27763-2e69-6e3a-f769-2528eda54940@redhat.com>
 <20180830163614.GA27069@lst.de>
 <65e818f2-885d-50a4-0d4a-7700c703c2af@sandeen.net>
 <20180830180204.GC2853@bfoster> <20180830182849.GA4359@magnolia>
 <20180831062813.GA7280@lst.de> <20180831123639.GA39825@bfoster>
 <20180902140858.ssl7dxtnbl7sw2ig@odin.usersys.redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2c0a6636-356e-fbc8-4c9d-89039e263e00@sandeen.net>
Date: Sun, 2 Sep 2018 12:52:47 -0500
MIME-Version: 1.0
In-Reply-To: <20180902140858.ssl7dxtnbl7sw2ig@odin.usersys.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 9/2/18 9:08 AM, Carlos Maiolino wrote:
> Hi Folks,
> 
> On Fri, Aug 31, 2018 at 08:36:40AM -0400, Brian Foster wrote:
>> On Fri, Aug 31, 2018 at 08:28:13AM +0200, Christoph Hellwig wrote:
>>> On Thu, Aug 30, 2018 at 11:28:49AM -0700, Darrick J. Wong wrote:
>>>> I prefer to have FIBMAP return errors to *cough* encourage people to use
>>>> FIEMAP.  If code are going to abuse the FI[BE]MAP interface they could
>>>> at least abuse the one that gives it enough context to avoid fs
>>>> corruption.  (A proper fs driver would be preferable, though very
>>>> difficult).
>>>
>>> I think Carlos was looking into implementing the FIBMAP ioctl
>>> using ->fiemap.  In that case we could return sensible errors,
>>> and centralize policy in a single place..
>>>
>>
>> So basically ioctl_fibmap() either prioritizes ->fiemap() or looks for
>> some special combination of (fiemap && !bmap) to translate the call..
>>
>>>> Granted, grub's blocklist code doesn't seem to check for shared blocks
>>>> when it writes grubenv.... yuck, though TBH I don't have the eye budget
>>>> to spend on digging through grub2.  Frankly I think FIBMAP comes verrry
>>>> close to "this API is unfixably stupid and shouldn't be enabled for new
>>>> use cases and should go away some day".
>>>
>>> .. and that policy should be: always return an error for the slightest
>>> unusual file layout (shared, encrypted, inline, etc).
>>
>> ... and then return some error if the associate extent is in some state
>> that cannot be described by fibmap..? That sounds like a nice option to
>> me. Carlos..?
>>
> 
> Yes, I've been working on using FIEMAP interface to handle FIBMAP, it was mostly
> working, although it needed some extra tweaks due the fact different
> filesystems return different blocks inside an extent, when a single block query
> is made on FIEMAP.
> 
> I mean, if you query for a single block which is in the middle of an extent,
> ext4 returns the address of the specific block inside the extent, while xfs
> (using iomap fiemap infra), returns the address of the first block in the
> extent.

IMHO, with hindsight, FIEMAP really kind of sucks.  The call is a pain to
set up, and the results are a pain to interpret.

Preparing a patch for zipl to use FIEMAP, I realized what a truly crappy and
cumbersome interface it is, particularly if you just want to map a small
handful of blocks.

I doubt it'd fly, but I'm half tempted to propose a new block-at-at-time
FIBMAP2 that doesn't overflow 32 bits, uses flags similar to FIEMAP to control
behavior and return mapped block state, and can return proper errors.

FIEMAP is great that it can efficiently map contiguous extents and all, but
it's so cumbersome to use.  (ISTR that both xfsprogs' and e2fsprogs' use of
FIEMAP had /multiple/ followon commits fixing the original implementation
in filefrag and xfs_io.)

-Eric
