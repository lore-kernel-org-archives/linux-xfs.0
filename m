Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57738 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbfEOQYj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 May 2019 12:24:39 -0400
Subject: Re: [PATCH] xfs_db: add extent count and file size histograms
References: <20190514185026.73788-1-jorgeguerra@gmail.com>
 <20190514233119.GS29573@dread.disaster.area>
 <CAEFkGAxFuh5qLrfSTreVLHGaaP9VtxTbfeePEwq2iqm0OLamxA@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <731994db-9f24-a3a8-02a9-eb92535b93f5@sandeen.net>
Date: Wed, 15 May 2019 11:24:37 -0500
MIME-Version: 1.0
In-Reply-To: <CAEFkGAxFuh5qLrfSTreVLHGaaP9VtxTbfeePEwq2iqm0OLamxA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jorge Guerra <jorge.guerra@gmail.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Omar Sandoval <osandov@osandov.com>, Jorge Guerra <jorgeguerra@fb.com>

On 5/15/19 11:15 AM, Jorge Guerra wrote:
> Thanks Dave,
> 
> I appreciate you taking the time to review and comment.
> 
> On Tue, May 14, 2019 at 4:31 PM Dave Chinner <david@fromorbit.com> wrote:
>>
>> On Tue, May 14, 2019 at 11:50:26AM -0700, Jorge Guerra wrote:
>>> From: Jorge Guerra <jorgeguerra@fb.com>
>>>
>>> In this change we add two feature to the xfs_db 'frag' command:
>>>
>>> 1) Extent count histogram [-e]: This option enables tracking the
>>>    number of extents per inode (file) as the we traverse the file
>>>    system.  The end result is a histogram of the number of extents per
>>>    file in power of 2 buckets.
>>>
>>> 2) File size histogram and file system internal fragmentation stats
>>>    [-s]: This option enables tracking file sizes both in terms of what
>>>    has been physically allocated and how much has been written to the
>>>    file.  In addition, we track the amount of internal fragmentation
>>>    seen per file.  This is particularly useful in the case of real
>>>    time devices where space is allocated in units of fixed sized
>>>    extents.
>>
>> I can see the usefulness of having such information, but xfs_db is
>> the wrong tool/interface for generating such usage reports.
>>
>>> The man page for xfs_db has been updated to reflect these new command
>>> line arguments.
>>>
>>> Tests:
>>>
>>> We tested this change on several XFS file systems with different
>>> configurations:
>>>
>>> 1) regular XFS:
>>>
>>> [root@m1 ~]# xfs_info /mnt/d0
>>> meta-data=/dev/sdb1              isize=256    agcount=10, agsize=268435455 blks
>>>          =                       sectsz=4096  attr=2, projid32bit=1
>>>          =                       crc=0        finobt=0, sparse=0, rmapbt=0
>>>          =                       reflink=0
>>> data     =                       bsize=4096   blocks=2441608704, imaxpct=100
>>>          =                       sunit=0      swidth=0 blks
>>> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
>>> log      =internal log           bsize=4096   blocks=521728, version=2
>>>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
>>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>> [root@m1 ~]# echo "frag -e -s" | xfs_db -r /dev/sdb1
>>> xfs_db> actual 494393, ideal 489246, fragmentation factor 1.04%
>>
>> For example, xfs_db is not the right tool for probing online, active
>> filesystems. It is not coherent with the active kernel filesystem,
>> and is quite capable of walking off into la-la land as a result of
>> mis-parsing the inconsistent filesystem that is on disk underneath
>> active mounted filesystems. This does not make for a robust, usable
>> tool, let alone one that can make use of things like rmap for
>> querying usage and ownership information really quickly.
> 
> I see your point, that the FS is constantly changing and that we might
> see an inconsistent view.  But if we are generating bucketed
> histograms we are anyways approximating the stats.

I think that Dave's "inconsistency" concern is literal - if the on-disk
metadata is not consistent, you may wander into what looks like corruption
if you try to traverse every inode while mounted.
 
It's pretty much never valid for userspace to try to traverse or read
the filesystem while mounted.

>> To solve this problem, we now have the xfs_spaceman tool and the
>> GETFSMAP ioctl for running usage queries on mounted filesystems.
>> That avoids all the coherency and crash problems, and for rmap
>> enabled filesystems it does not require scanning the entire
>> filesystem to work out this information (i.e. it can all be derived
>> from the contents of the rmap tree).
>>
>> So I'd much prefer that new online filesystem queries go into
>> xfs-spaceman and use GETFSMAP so they can be accelerated on rmap
>> configured filesystems rather than hoping xfs_db will parse the
>> entire mounted filesystem correctly while it is being actively
>> changed...
> 
> Good to know, I wasn't aware of this tool.  However I seems like I
> don't have that ioctl in my systems yet :(

It was added in 2017, in kernel-4.12 I believe.
What kernel did you test?

-Eric
