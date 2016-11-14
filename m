Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:34819 "EHLO
        mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932979AbcKNQ7Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2016 11:59:16 -0500
Received: by mail-yw0-f180.google.com with SMTP id i145so67864963ywg.2
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2016 08:59:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161114131435.GB37689@bfoster.bfoster>
References: <CA+sGqUv5X4JKQrMoOvVJupL4JadocZCd=AgzwfeR4iWjc_tG7w@mail.gmail.com>
 <20161114131435.GB37689@bfoster.bfoster>
From: John Henderson <jhender982@gmail.com>
Date: Mon, 14 Nov 2016 10:59:15 -0600
Message-ID: <CA+sGqUv5GpcsvD=SE3Z8LsoCLyJtGwCwmHgvNo7JVAnp-3_Q_A@mail.gmail.com>
Subject: Re: Which version of xfs-progs to use on Debian?
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi Brian,

Thanks for your prompt response.  More inline.

On Mon, Nov 14, 2016 at 7:14 AM, Brian Foster <bfoster@redhat.com> wrote:
> On Mon, Nov 14, 2016 at 01:23:50AM -0600, John Henderson wrote:
>> Hi,
>>
>> I'm trying to determine the optimal combination of kernel version and
>> xfs-progs version to use on a Debian Jessie system (for amd64).
>>
>> I've searched this mailing list, and noticed the following exchange:
>>
>>   http://www.spinics.net/lists/xfs/msg36165.html
>>
>> specifically, Dave's response:
>>
>>   "As it is, in future the version of xfsprogs will tell you what
>> kernel has the same feature support. i.e. xfsprogs 4.2.0 has exactly
>> the same code/feature support as kernel 4.2.0. Similarly for
>> xfsprogs/kernel 4.3.0."
>>
>> I'm also aware that prior to xfsprogs 4.2.0, userspace versioning did
>> not match kernel numbering, as noted:
>>
>>   https://git.kernel.org/cgit/fs/xfs/xfsprogs-dev.git/refs/tags
>>   https://www.spinics.net/lists/xfs/msg33984.html
>>
>> So, as I understand the situation, xfsprogs 3.2.x was associated with
>> a lot of different 3.x and 4.y (y<2) kernels.  Further, I want to make
>> sure to take advantage of all the (current and future) reliability
>> improvements of the new xfs v5 on-disk format, which means (from what
>> I follow) that I need at least kernel 3.15 and xfsprogs 3.2.0, as seen
>> here:
>>
>>   https://www.spinics.net/lists/xfs/msg27961.html
>>
>> My main concern focuses on the options currently available in Debian
>> (primarily Jessie + backports).  Here's the matchup of what Debian
>> ships (jessie, jessie-bpo, and stretch):
>>
>>                       linux-kernel     xfs-progs
>> Jessie:               3.16.36          3.2.1
>> Jessie Backports:     4.7.8            4.3.0
>> Stretch:              4.8.5            4.3.0
>>
>> So, at first pass, I could just use native jessie's kernel 3.16.36 and
>> xfsprogs 3.2.1 (and they seem to match well, as they were released
>> together).  However, I actually have to use a more recent kernel
>> anyway for some SkyLake support issues.  So, that takes us to at least
>> kernel 4.7.8.  I note, though, that jessie-backports is *not*
>> packaging xfsprogs 4.7 alongside its kernel (but instead xfsprogs
>> 4.3.0); similar issues exist for the 4.8.5 kernel from stretch.
>>
>
> Others might be able to chime in on this, but that strikes me as a
> packaging issue.

Agree completely.  I very strongly prefer to use 100% default packages within
single repo in Debian (ie, no pulling from Jessie backports).  However, usage
of the workstation in this case requires support of the Skylake CPU, available
only in more modern 4.x series of kernels (Jessie [stable] is still at 3.16.x).
So, that means pulling some kernel like 4.7.x from Jessie backports.  Oh, well.

> My understanding is that the marriage between the
> kernel revision and xfsprogs revision tracking numbers is to help define
> dependencies between the two.

Yes, I was a bit surprised that Debian testing / unstable have non-matched
kernel / xfsprogs as currently packaged (ie, 4.7 & 4.8 kernels, respectively,
with 4.3 xfsprogs).  Debian stable is indeed matched with kernel 3.16.x and
xfsprogs 3.2.1.  I also noted that the most recent (ie, testing / unstable)
xfsprogs uploads to Debian repos appear to be non-maintainer uploads
(NMUs); perhaps, there's something going on with Debian XFS maintainers?

> That said, it might not be a problem for
> you if you aren't using anything notable introduced between 4.3 and 4.7.

Given that crc / finobt are default, I don't plan on using anything
else, but still
am glad to check with the list, here.  Thanks for your input.

>> Assuming I stick to binary packages distributed through the official
>> Debian repos, what's the recommendation of the xfs experts: would I be
>> better off (in terms of reliability) with xfsprogs 3.2.1 or xfsprogs
>> 4.3.0 used with kernel 4.7.8?  As an alternative, would it be even
>> better for me to use xfsprogs 4.7 (via compiling from source, even
>> though I'd rather not)?
>>
>
> v4.7 of xfsprogs is probably best, but IMO, you'll probably be fine with
> the v4.3 in the simple cases (you haven't mentioned whether you're
> planning to use xfsprogs for anything beyond mkfs and possibly repair if
> something goes wrong).

Yes, plan is only to use xfsprogs for mkfs (+ fsck).  If I'm in the situation
where I have to repair anything, perhaps that's the time to look more carefully
at getting (compiling?) xfsprogs that matches kernel specifically.

> Just keep in mind that it is out of date with
> respect to your kernel in the event that you do run into problems down
> the road and may want to update.
>
>> Also, what are current best-practice parameters for 'mkfs.xfs' in
>> order to optimize reliability?  Filesystem size is ~10 TB on top of
>> LUKS-encrypted Software RAID-1 (using enterprise 512e drives).
>>
>> I'd assume, we'd at least want the following:
>>
>>   -m crc=1 finobt=1
>>
>
> Usually it is best to go with defaults. Indeed, crc=1,finobt=1 are both
> defaults and have been for a while now. See commit 566ebd5a ("mkfs:
> default to CRC enabled filesystems") which first appeared in xfsprogs
> v3.2.3. I'm not aware of any special/magic options required for raid1 or
> encryption.

Yep, saw those changes in the defaults in xfs list announcements.  Thanks
for reiterating.

Take care,
John
