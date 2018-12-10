Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:23265 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbeLJPSB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Dec 2018 10:18:01 -0500
MIME-version: 1.0
Content-type: text/plain; charset="utf-8"; format="flowed"
Subject: Re: [PATCH] fs/xfs: Add support for passing write life-time hint
 with log
From: Kanchan Joshi <joshi.k@samsung.com>
Message-id: <1a88a071-3dc5-c5d1-e075-1125f92fd78f@samsung.com>
Date: Mon, 10 Dec 2018 20:45:46 +0530
In-reply-to: <20181204220901.GP6311@dastard>
Content-language: en-US
Content-transfer-encoding: 8bit
References: <CGME20181203131558epcas2p14b6b38cb67d4915b1ba782e11ce7ffe6@epcas2p1.samsung.com>
        <1543842769-6363-1-git-send-email-joshi.k@samsung.com>
        <f3d25c5b-6a96-397c-d947-370867401a83@applied-asynchrony.com>
        <20181203163457.GW8125@magnolia> <20181203200909.GD6311@dastard>
        <be079d8c-f9d0-f01e-a184-36cf53d16abf@samsung.com>
        <20181204220901.GP6311@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>, linux-xfs@vger.kernel.org, jooyoung.hwang@samsung.com, chur.lee@samsung.com, prakash.v@samsung.com

Write life-time hint is not a feature in itself, it's an abstraction 
built over a SSD feature "stream". And this abstraction is more rigid 
than the feature, in terms of defining life-time buckets. Feature-wise, 
it is sufficient to assign two stream numbers X and Y to isolate one 
data from other (and to reap the benefits). While abstraction compels us 
to debate on relative hotness-level between these two types of data. 
Deciding relative hotness gets trickier as data-types increase, and 
worse, it may not bring any goodness. If aim of the change is to get 
goodness from SSD, we should consider lifetime from SSD's point-of-view. 
And that is based on "overwrites".

Please refer figure 1 in this paper -
https://www.usenix.org/system/files/conference/fast18/fast18-rho.pdf
If a block is not overwritten by Host, it stays valid inside SSD; If it 
gets overwritten, it becomes invalid and creates a hole. No holes are 
good. All holes are also good. Intermixing of _few_ holes with _few_ 
valid blocks is bad.
Due to the way log is written, it stays valid (i.e. no overwrites) until 
roll-over. After roll-over, it starts getting overwritten.If volume is 
meta-light, log will stay valid for long. If volume is meta-heavy, 
log-writes will start creating holes (invalid data). But either of the 
situation is not problematic in itself. Problematic situation is when, 
along with log updates, we start getting other data/meta updates. This 
meta/data may or may not be as stable or transient. But point is, why to 
bother about whether log is as hot/cold as something else. Problem can 
be solved by isolating log-data in its own chamber, in its own stream. 
It will either remain all-valid or turn all-invalid, unaffected by 
everything else that goes around.

 > Option 4: let the filesystem decide what is best dynamically,
 > because the lifetime of metadata and how often it is written is
 > a dynamic property of the specific metadata type.

I think log should be treated independently than any other meta/data. 
Matching dynamic nature of meta-data with life-time hints seems harder 
(than log) to get right. Abstraction-wise, FS can try to be very 
accurate about changing life-time hints (change something from warm to 
cold to hot etc.). But one should note that streams come with allocation 
granularity. One can refer "SGS" in NVMe spec, page 275 - 
https://nvmexpress.org/wp-content/uploads/NVM_Express_Revision_1.3.pdf. 
Or, as seen in above figure 1, internally each write-hint/stream is 
assigned on a fixed-size large region. Therefore possibility of internal 
fragmentation needs to be considered while hoping from one hint to 
another.



On Wednesday 05 December 2018 03:39 AM, Dave Chinner wrote:
> On Tue, Dec 04, 2018 at 05:41:26PM +0530, Kanchan Joshi wrote:
>> I expect log to have lifetime as "SHORT" in general. Log is bound to
>> be overwritten, as XFS continues performing transaction. So it is
>> not good idea to place it (inside SSD) with some other meta/data
>> that is more stable (or less stable, for that matter).
>> By assigning a distinct write-hint (SHORT, or anything else than
>> NONE) to log, this problem of mixing is solved.
> 
> So, we have different definitions of what is "short lived"
> and what is "long lived". The log is a -static allocation- it never
> moves and so it always gets overwritten in place. It exists for the
> life of the filesystem, so it's a long-lived structure. Some
> metadata moves around - it's allocated and freed on demand, but is
> still overwritten in place while it's in use.
> 
> The in-use life time of metadata can be very short, but it can also
> be very long. It may never get overwritten, or it could be
> overwritten multiple times a second. We have no real idea what is
> going to happen with each individual piece of metadata because it is
> completely dependent on user workloads.
> 
> So from a metadata perspective, life-time refers to how long the
> metadata is in use in the filesystem, not how often it is accessed
> or written. There's no "one-size-fits-all" bucket here.
> 
>> Keeping a mount option seemed to offer more flexibility to
>> admin/system-designers.
> 
> OTOH, it gives everyone who is not an expert in storage and
> filesystem implemetnations an oportunity to screw up in new and
> exciting ways that are difficult to detect and impossible for XFS
> developers to reproduce or debug.
> 
>>
>> Assuming a single large SSD, hosting two XFS
>> volumes - one catering to fsync-heavy workloads, while another one
>> with reduced frequency of log writes. In that situation, one would
>> not want to mix the writes of two logs and instead prefer to
>> configure one log as "SHORT" and another one as "MEDIUM or EXTREME".
> 
> Here's the problem: you're making an assumption that "frequency of
> log writes" equates to "the log is overwritten more often", and
> that's not true. Frequent fsyncs typically mean lots of small log
> writes that block each other, while applicaitons that don't use
> fsync will be doing lots large async log writes and potentially
> writing a lot more metadata to the log because nothing is blocking
> waiting on journal IO completion......
> 
> Filesystems rarely behave in the ways non-filesystem developers
> expect them to.
> 
>> Also, this way (through mount option) seemed more in sync with how
>> rest of the kernel currently deals with streams/write-hints. In
>> order to be useful, write-hints need to be converted to specific
>> stream numbers. For NVMe SSDs, this is done by nvme-core module, but
>> only if it is loaded with "streams=1" option. F2FS has mount option
>> for passing write-hints. Default behavior is passing no write-hint.
> 
> There is no need for mount options, because we already have a
> fcntl() interface that applications can use for setting write hints
> on files. It was introduced in 4.13, and XFS already plumbs it
> through for buffered write IO.
> 
> FYI:
> 
> $ man fcntl
> ....
>     File read/write hints
> 
>         Write lifetime hints can be used to inform the kernel about
>         the relative expected lifetime of writes on a given inode or
>         via  a  particular  open  file description.   (See open(2)
>         for  an  explanation of open file descriptions.) In this
>         context, the term "write lifetime" means the expected time
>         the data will live on media, before being over¿ written or
>         erased.
> .....
> 
> And the interfaces are:
> 
>         F_GET_RW_HINT (uint64_t *; since Linux 4.13)
>         F_SET_RW_HINT (uint64_t *; since Linux 4.13)
>         F_GET_FILE_RW_HINT (uint64_t *; since Linux 4.13)
>         F_SET_FILE_RW_HINT (uint64_t *; since Linux 4.13)
> 
> And the types are:
> 
>         RWH_WRITE_LIFE_NOT_SET
>         RWH_WRITE_LIFE_NONE
>         RWH_WRITE_LIFE_SHORT
>         RWH_WRITE_LIFE_MEDIUM
>         RWH_WRITE_LIFE_LONG
>         RWH_WRITE_LIFE_EXTREME
> 
> We probably also should make sure direct IO uses this hint, too, and
> ideally we want set the write hint for the metadata in that file to
> the same value as the user data being written, as the file metadata
> is likely to have a similar lifetime to the user data it refers to.
> 
> IOWs, we want different metadata to have appropriately different
> write hints, some of it will be controllable by the user per-file
> write hints, others will be controlled by the filesystem itself as
> userspace has no visibility or control over how that internal
> metadata is managed.
> 
>> To summarize, I have listed three schemes below. Please let me know
>> which one sounds more acceptable for patch -
>> 1. [Current proposal] Keep write-hint (NONE) as default, and make it
>> overridable through mount option.
>> 2. Keep immutable write-hint (say SHORT). Provide no mount option.
>> 3. Keep write-hint (SHORT) as default, and make it overridable
>> through mount option.
> 
> Option 4: let the filesystem decide what is best dynamically,
> because the lifetime of metadata and how often it is written is
> a dynamic property of the specific metadata type.
> 
> Cheers,
> 
> Dave.
> 
