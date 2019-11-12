Return-Path: <SRS0=Awhw=ZE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2976C43331
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 21:11:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79F9421925
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 21:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbfKLVL6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 16:11:58 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:38437 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726912AbfKLVL5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 16:11:57 -0500
Received: from dread.disaster.area (pa49-180-67-183.pa.nsw.optusnet.com.au [49.180.67.183])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E9E403A0522;
        Wed, 13 Nov 2019 08:11:53 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iUdS5-00076l-2I; Wed, 13 Nov 2019 08:11:53 +1100
Date:   Wed, 13 Nov 2019 08:11:53 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [RFC][PATCH] xfs: extended timestamp range
Message-ID: <20191112211153.GO4614@dread.disaster.area>
References: <20191111213630.14680-1-amir73il@gmail.com>
 <20191111223508.GS6219@magnolia>
 <CAOQ4uxgC8Gz+uyCaV_Prw=uUVNtwv0j7US8sbkfoTphC4Z6b6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxgC8Gz+uyCaV_Prw=uUVNtwv0j7US8sbkfoTphC4Z6b6A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=3wLbm4YUAFX2xaPZIabsgw==:117 a=3wLbm4YUAFX2xaPZIabsgw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=MeAgGD-zjQ4A:10
        a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8 a=-loqZRfduSDZo-UfadwA:9
        a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 12, 2019 at 06:00:19AM +0200, Amir Goldstein wrote:
> On Tue, Nov 12, 2019 at 12:35 AM Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> >
> > On Mon, Nov 11, 2019 at 11:36:30PM +0200, Amir Goldstein wrote:
> > > Use similar on-disk encoding for timestamps as ext4 to push back
> > > the y2038 deadline to 2446.
> > >
> > > The encoding uses the 2 free MSB in 32bit nsec field to extend the
> > > seconds field storage size to 34bit.
> > >
> > > Those 2 bits should be zero on existing xfs inodes, so the extended
> > > timestamp range feature is declared read-only compatible with old
> > > on-disk format.
> >
> > What do you think about making the timestamp field a uint64_t counting
> > nanoseconds since Dec 14 09:15:53 UTC 1901 (a.k.a. the minimum datetime
> > we support with the existing encoding scheme)?  Instead of using the
> > upper 2 bits of the nsec field for an epoch encoding, which ext4 screwed
> > up years ago and has not fully fixed?
> 
> The advantage of the ext4 scheme is that it is more backward compatible.

Darrick an I had a long discussion about this on #xfs a few weeks
ago (22nd october). 

Discussion went like this:

 <djwong>   btw, dchinner, were one to try to solve the y2038 problem on xfs, how would one do it?
 <djwong>   1) write tests to make sure we can store/retrieve the extreme ends of the existing timestamps; then
 <djwong>   2) use empty di_pad bytes to extend each timestamp field width; then
 <djwong>   3) figure out what the values of the extra byte are (epochs moving forward from the unix epoch; and we don't care about supporting dates before 1900); then
 <djwong>   4) expand test to cover new intervals?
 <dchinner> djwong: pretty much      
 <dchinner> the epoch extending patch I originally proposed is here: https://lore.kernel.org/linux-xfs/20140602002822.GQ14410@dastard/
 <djwong>   also it occurred to me that one could use the top two bits of the nsec fields to make it a 10-bit extension of the seconds fields
 <dchinner> I've probably got a more recent version somewhere in a stack somewhere around here
 <dchinner> didn't ext4 use part of the nsec field like that?
 <djwong>   yeah, they have 34 bit dates now
 <dchinner> ISTR it's got some horrifically complex encoding of the timestamp
 <djwong>   yes, it does
 <djwong>   they did epochs rolling forward from the current one
 <dchinner> we could just do the 34 bit second time in a sane way
 <dchinner> because all the timestamps are contiguous on disk
 <dchinner> i.e. if a SB flag is set, the timestamp on disk is an opaque 64 bit field
 <dchinner> upper 30 bits are the nsec field, lower 34 bits are the seconds field
 <dchinner> similar to how we encode BMBT extent records
 <dchinner> always unsigned, so we don't support dates before 1970 at all....
 <djwong>   hmm, with that scheme (uint t_sec:34; uint t_nsec: 30;} I guess that gets us to the year 2514
 <djwong>   and provided nobody cares about pre-1970 dates or the ability to store negative t_nsec
 <dchinner> djwong: if XFS is still in use in 2514, then I'm not going to care about it :)
 <djwong>   [narrator] But what Dave doesn't know is that the three XFS maintainers will be uploaded into the Cloud in 2046 to maintain XFS in perpetuity.... :D
 <dchinner> The current Dave doesn't care about that :)
 <djwong>   hmm even if we did {signed int t_sec:34;} that would still get us to 2242
 <dchinner> djwong: I just don't see the point of having signed timestamps
 <djwong>   admittedly, we don't need timestamps dating back to the 1700s
 <djwong>   but then, what if we set the new epoch to 1993?
 <djwong>   (or, heck, 2000?)
 <djwong>   i mean, i guess it doesn't matter if we have dates going to 2514 or 2544
 <dchinner> what, have an on-disk epoch that is different to the unix epoch?
 <djwong>   yes :D
 <djwong>   "In the year 2525, if XFS is still alive..." ♪♪
 <dchinner> then we definitely have unsigned timestamps on disk
 <dchinner> set the epoch to ~1900, and we handle the legacy negative 32-bit int timestamp range as well.
 <djwong>   that could also work
 <djwong>   I don't anticipate being around in 2444

Basically, we've both looked at what ext4 has done and don't want to
do that - it's an awful, complex hack and it's had quite a few bugs
in it since it was introduced that went a long time before being
noticed.

> I would like to have an upgrade procedure that is simple and I don't like
> the idea of having two completely different time encodings in the code
> (and on disk) if I can help it.

Backwards comaptible in-place upgrades are largely a myth: we don't
allow changes to the on-disk format without feature bits that limit
what old kernels can do with new formats. In this case it requires
an incompat bit because the moment an upper bit in the ns field is
set then the timestamps go bad on old kernels. Hence it's not a
compatible change and filesytems with this format cannot be mounted
on kernels that don't support it.

So, an in-place upgrade process is a one-way operation - once you
start converting and have >2038 dates, there is no going back
without an offline admin operation. That means there's no real need
to try to retain the old format at all. IOWs, for in-place upgrade,
all we need is an inode flag to indicate what format the timestamp
is in once the superblock incompat flag is set. Eventually the SB
flag becomes the mkfs default, and then eventually it becomes the
only supported format. This is what we've done before for things
like NLINK, ATTR2, etc.

> IIUC, you are implying that the ext4 scheme is more prone to human
> programming errors? that should be addressed with proper unit testing
> IMO and besides, we can learn from ext4 past bugs (not sure that my
> implementation did), so those could be listed also in the pros column.

We're not implying anything - there's been several actual bugs in
the encoding scheme that weren't noticed or fixed for quite a long
time. What we've learnt from this is that complexity in timestamp
encoding only leads to bugs, so given the choice we should really do
something simpler.

> One thing I wasn't certain about is that it seems that xfs (and xfs_repair)
> allows for negative nsec value. Not sure if that is intentional and why.
> I suppose it is an oversight? That is something that xfs_repair would
> need to check and fix before upgrade if we do go with the epoch bits.

It's not an oversight - it's somethign the on-disk format allowed.
Who knows if it ever got used (or how it got used), but it's
somethign we can only fix by changing the on-disk format (as you can
see from the discussion above).

IOWs, we pretty much decided on a new 64 bit encoding format using a
epoch of 1900 and a unsigned 64bit nanosecond counter to get us a
range of almost 600 years from year 1900-2500. It's simple, easy to
encode/decode, and very easy to validate. It's also trivially easy
to do in-place upgrades with an inode flag....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
