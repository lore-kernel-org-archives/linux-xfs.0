Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34884 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727348AbeIRT4d (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Sep 2018 15:56:33 -0400
Subject: Re: dm-writecache issue
References: <20180911221147.GA23308@redhat.com>
 <alpine.LRH.2.02.1809180741001.6599@file01.intranet.prod.int.rdu2.redhat.com>
 <20180918123238.GI27618@dastard>
 <817349b8-b54e-a16a-276f-7a977f29b449@sandeen.net>
 <20180918142053.GA26193@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <25e71dc1-307f-83b2-d93a-b3215e892523@sandeen.net>
Date: Tue, 18 Sep 2018 09:23:43 -0500
MIME-Version: 1.0
In-Reply-To: <20180918142053.GA26193@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Teigland <teigland@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, Mikulas Patocka <mpatocka@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On 9/18/18 9:20 AM, David Teigland wrote:
>>> I'm betting that the underlying device advertised a logical/physical
>>> sector size of 512 bytes to mkfs, and then adding pmem as the cache
>>> device changed the logical volume from a 512 byte sector device to a
>>> hard 4k sector device.
> Yes
> 
> I've been dealing with this by just using -s size=4096.
> 

So the risk here - in general - is that using a sector size larger
than the advertised physical sector size may - in general - lead to
metadata IOs that are not atomic, when they are required to be so for
consistency.

-Eric
