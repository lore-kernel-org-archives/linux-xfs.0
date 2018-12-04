Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:34229 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbeLDMNa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Dec 2018 07:13:30 -0500
MIME-version: 1.0
Content-type: text/plain; charset="utf-8"; format="flowed"
Subject: Re: [PATCH] fs/xfs: Add support for passing write life-time hint
 with log
From: Kanchan Joshi <joshi.k@samsung.com>
Message-id: <be079d8c-f9d0-f01e-a184-36cf53d16abf@samsung.com>
Date: Tue, 04 Dec 2018 17:41:26 +0530
In-reply-to: <20181203200909.GD6311@dastard>
Content-language: en-US
Content-transfer-encoding: 8bit
References: <CGME20181203131558epcas2p14b6b38cb67d4915b1ba782e11ce7ffe6@epcas2p1.samsung.com>
        <1543842769-6363-1-git-send-email-joshi.k@samsung.com>
        <f3d25c5b-6a96-397c-d947-370867401a83@applied-asynchrony.com>
        <20181203163457.GW8125@magnolia> <20181203200909.GD6311@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>, linux-xfs@vger.kernel.org, jooyoung.hwang@samsung.com, chur.lee@samsung.com, prakash.v@samsung.com

I expect log to have lifetime as "SHORT" in general. Log is bound to be 
overwritten, as XFS continues performing transaction. So it is not good 
idea to place it (inside SSD) with some other meta/data that is more 
stable (or less stable, for that matter).
By assigning a distinct write-hint (SHORT, or anything else than NONE) 
to log, this problem of mixing is solved.

Keeping a mount option seemed to offer more flexibility to 
admin/system-designers. Assuming a single large SSD, hosting two XFS 
volumes - one catering to fsync-heavy workloads, while another one with 
reduced frequency of log writes. In that situation, one would not want 
to mix the writes of two logs and instead prefer to configure one log as 
"SHORT" and another one as "MEDIUM or EXTREME".

Also, this way (through mount option) seemed more in sync with how rest 
of the kernel currently deals with streams/write-hints. In order to be 
useful, write-hints need to be converted to specific stream numbers. For 
NVMe SSDs, this is done by nvme-core module, but only if it is loaded 
with "streams=1" option. F2FS has mount option for passing write-hints. 
Default behavior is passing no write-hint.

To summarize, I have listed three schemes below. Please let me know 
which one sounds more acceptable for patch -
1. [Current proposal] Keep write-hint (NONE) as default, and make it 
overridable through mount option.
2. Keep immutable write-hint (say SHORT). Provide no mount option.
3. Keep write-hint (SHORT) as default, and make it overridable through 
mount option.

Thanks,
On Tuesday 04 December 2018 01:39 AM, Dave Chinner wrote:
> On Mon, Dec 03, 2018 at 08:34:57AM -0800, Darrick J. Wong wrote:
>> On Mon, Dec 03, 2018 at 04:48:12PM +0100, Holger Hoffstätte wrote:
>>> On 12/3/18 2:12 PM, Kanchan Joshi wrote:
>>>> Log gets updated in a circular fashion, and that makes life-time
>>>> of log-data different from other types of meta/user-data.
>>>> By passing a write life-time hint with log, GC efficiency of multi-stream SSD
>>>> gets improved, leading to endurance/performance benefits.
>>>> It is described in greater detail (along with results) in this "FAST 2018"
>>>> paper -
>>>> https://www.usenix.org/conference/fast18/presentation/rho
>>>> This patch introduces new mount option "logwritehint" to pass write hint
>>>> with XFS log.
>>>
>>> Is there any downside to passing the hints unconditionally?
>>
>> Why wouldn't we always pass LIFE_EXTREME?  Do people have setups where,
>> say, hint <= LIFE_MEDIUM gets a disk but anything longer than that gets
>> a big slow stone tablet, which is not where we'd want the metadata log?
>>
>> For that matter, should we be passing write hints for other fs metadata?
>> Fixed AG headers never move, should they be LIFE_whateverthelogis ?  How
>> about space and file metadata, which aren't fixed to certain locations?
> 
> I started looking at this recently because of the problems that were
> being had with the XFS allocator interleaving short term and long
> term data for certain applications. Part of this was getting the
> userspace hints plumbed through to the inode, which then canbe used
> by the allocator to make high level placement decisions (e.g. AG
> level) and then the hint gets plumbed through to the user data bios
> as well.
> 
> Metadata is largely static, even the dynamic metadata, because we
> overwrite in place and it doesn't move about all that much in common
> workloads. So it was just looking at treating all the metadata as
> the same, given that there are only 4 or 5 hint levels available.
> 
>>> Introducing a new mount option which depends on the internals of
>>> an SSD seems .. unlikely to gain many friends.
>>> Otherwise a great idea. :)
>>
>> Likewise, I'm not wild about adding mount options or passing raw
>> integers via mount(8) command line:
>>
>> mount /dev/fd0 /mnt -o logwritehint=3 # ???
> 
> No mount option, please. Fix the log and metadata as "always
> overwritten in place" write type hints, let user data be specified
> by the dynamic per-inode hinting interface we already have.
> 
> Cheers,
> 
> Dave.
> 
