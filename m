Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59776 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726325AbfEOQvi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 May 2019 12:51:38 -0400
Subject: Re: [PATCH] xfs_db: add extent count and file size histograms
References: <20190514185026.73788-1-jorgeguerra@gmail.com>
 <20190514233119.GS29573@dread.disaster.area>
 <CAEFkGAxFuh5qLrfSTreVLHGaaP9VtxTbfeePEwq2iqm0OLamxA@mail.gmail.com>
 <731994db-9f24-a3a8-02a9-eb92535b93f5@sandeen.net>
 <CAEFkGAwdx6DC1YS_NaChYqz0Zp1+GxtrgpcQ262eLgYfX5U35w@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <cd58e171-8b41-38c2-3ed9-639db82c080a@sandeen.net>
Date: Wed, 15 May 2019 11:51:37 -0500
MIME-Version: 1.0
In-Reply-To: <CAEFkGAwdx6DC1YS_NaChYqz0Zp1+GxtrgpcQ262eLgYfX5U35w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jorge Guerra <jorge.guerra@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Omar Sandoval <osandov@osandov.com>, Jorge Guerra <jorgeguerra@fb.com>

On 5/15/19 11:47 AM, Jorge Guerra wrote:
> On Wed, May 15, 2019 at 9:24 AM Eric Sandeen <sandeen@sandeen.net> wrote:
>>>> For example, xfs_db is not the right tool for probing online, active
>>>> filesystems. It is not coherent with the active kernel filesystem,
>>>> and is quite capable of walking off into la-la land as a result of
>>>> mis-parsing the inconsistent filesystem that is on disk underneath
>>>> active mounted filesystems. This does not make for a robust, usable
>>>> tool, let alone one that can make use of things like rmap for
>>>> querying usage and ownership information really quickly.
>>>
>>> I see your point, that the FS is constantly changing and that we might
>>> see an inconsistent view.  But if we are generating bucketed
>>> histograms we are anyways approximating the stats.
>>
>> I think that Dave's "inconsistency" concern is literal - if the on-disk
>> metadata is not consistent, you may wander into what looks like corruption
>> if you try to traverse every inode while mounted.
>>
>> It's pretty much never valid for userspace to try to traverse or read
>> the filesystem while mounted.
> 
> Sure, I understand this point.  Then can we:
> 
> 1) Abort scan if the we detect "corrupt" metadata, the user would then
> either restart the scan or decide not to.
> 2) Have a mechanism which detects if the FS changed will scan was in
> progress and tell the user the results might be stale?

none of that should be shoehorned into xfs_db, tbh.  It's fine to use it
while unmounted.  If you want to gather these stats on a mounted filesystem,
xfs_db is the wrong tool for the job.  It's an offline inspection tool.
The fact that "-r" exists is because developers may need
it, but normal admin-facing tools should not be designed around it.

>>
>>>> To solve this problem, we now have the xfs_spaceman tool and the
>>>> GETFSMAP ioctl for running usage queries on mounted filesystems.
>>>> That avoids all the coherency and crash problems, and for rmap
>>>> enabled filesystems it does not require scanning the entire
>>>> filesystem to work out this information (i.e. it can all be derived
>>>> from the contents of the rmap tree).
>>>>
>>>> So I'd much prefer that new online filesystem queries go into
>>>> xfs-spaceman and use GETFSMAP so they can be accelerated on rmap
>>>> configured filesystems rather than hoping xfs_db will parse the
>>>> entire mounted filesystem correctly while it is being actively
>>>> changed...
>>>
>>> Good to know, I wasn't aware of this tool.  However I seems like I
>>> don't have that ioctl in my systems yet :(
>>
>> It was added in 2017, in kernel-4.12 I believe.
>> What kernel did you test?
> 
> Yeap, that's it we tested in 4.11.

Catch up!  *grin*

-Eric
