Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from firestarter.dermichi.com ([194.177.153.153]:41874 "EHLO
        firestarter.dermichi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1035504AbdDUHnz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2017 03:43:55 -0400
Subject: Re: xfsaild in D state seems to be blocking all other i/o
 sporadically
References: <ced08a44-d736-6250-c682-0f495a882bea@dermichi.com>
 <82e1fa48-909c-97a4-6bf9-5b84cf0af986@dermichi.com>
 <20170419140446.3rl2pruz2dlcr5cg@eorzea.usersys.redhat.com>
 <d6f598d1-7e7e-ac85-3cdc-e4f4bfdba94e@dermichi.com>
 <20170419180811.GB41631@bfoster.bfoster>
 <268ce851-dad0-a777-526a-82ad967490cd@dermichi.com>
 <20170419205525.GD5205@birch.djwong.org>
 <86fbec25-f026-350b-ffe3-b0b182b768ac@dermichi.com>
 <20170419234838.GH12369@dastard>
 <f3e222a4-bcdb-6c61-79b0-1450c12e054f@dermichi.com>
 <20170420231603.GJ12369@dastard>
From: Michael Weissenbacher <mw@dermichi.com>
Message-ID: <c8842112-444c-2051-1001-323b7180af57@dermichi.com>
Date: Fri, 21 Apr 2017 09:43:49 +0200
MIME-Version: 1.0
In-Reply-To: <20170420231603.GJ12369@dastard>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

Hi Dave!
On 21.04.2017 01:16, Dave Chinner wrote:
> On Thu, Apr 20, 2017 at 09:11:22AM +0200, Michael Weissenbacher wrote:
>> On 20.04.2017 01:48, Dave Chinner wrote:
>>>
>>> The problem is that the backing buffers that are used for flushing
>>> inodes have been reclaimed due to memory pressure, but the inodes in
>>> cache are still dirty. Hence to write the dirty inodes, we first
>>> have to read the inode buffer back into memory.
>>>
>> Interesting find. Is there a way to prevent those buffers from getting
>> reclaimed?
> 
> Not really. It's simply a side effect of memory reclaim not being
> able to reclaim inodes or the page cache because they are dirty, and
> so it goes and puts lots more pressure on clean caches. The working
> set in those other caches gets trashed, and this it's a downward
> spiral because it means dirty inodes and pages take longer are
> require blocking IO to refill on demand...
> 
Yesterday i found this patch for rsync:
http://insights.oetiker.ch/linux/fadvise/
It adds the option "--drop-cache" to rsync which sets
POSIX_FADV_DONTNEED to prevent caching. Been running with this option
since yesterday. Unfortunately, even this hasn't changed my problem.

>> In fact the best thing would be to disable file
>> content caching completely. Because of the use-case (backup server) it's
>> worthless to cache file content.
>> My primary objective is to avoid those stalls and reduce latency, at the
>> expense of throughput.
> 
> Set up dirty page cache writeback thresholds to be low (a couple of
> hundred MB instead of 10/20% of memory) so that data writeback
> starts early and throttles dirty pages to a small amount of memory.
> This will help keep the page cache clean and immediately
> reclaimable, hence it shouldn't put as much pressure on other caches
> when memory reclaim is required.
> 
In fact i already turned those down to 1024MiB/512MiB - not much change
here. I also set xfssyncd_centisecs to 100 like advised by you. Also not
much change after that.

I also noticed that unmounting the file system takes a really long time
after the problem occured (up to around 5 minutes!). Even when there was
nothing at all going on before the unmount. Would it help to capture the
unmount with trace-cmd?

Here is another theory. Could it be that not the rsync's, but the rm's
issued by rsnapshot are causing the problem? Would it help to serialize
all "rm -Rf" calls? Those always delete the oldest backups, which can't
possibly be in the cache and because of that all those inodes need to be
read into memory during deletion. Maybe those rm's are filling up the
XFS log?

If that doesn't work out either i guess my only chance would be to
partition the device with LVM and create a separate XFS for every
rsnapshot instance. In that scenario every file system should get it's
own xfsaild, allowing them to run in parallel and not blocking each other?

cheers,
Michael
