Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48890 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751423AbdJFQSk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 6 Oct 2017 12:18:40 -0400
Subject: Re: agcount for 2TB, 4TB and 8TB drives
References: <CAJH6TXgShHj6UynrNAs8eG0ZRFz5gSGGY1ZARPSofsNibi0Grg@mail.gmail.com>
 <20171006153803.GI7122@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8e6fd742-8767-e786-746d-2b9f2929b98c@sandeen.net>
Date: Fri, 6 Oct 2017 11:18:39 -0500
MIME-Version: 1.0
In-Reply-To: <20171006153803.GI7122@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: linux-xfs@vger.kernel.org

On 10/6/17 10:38 AM, Darrick J. Wong wrote:
> On Fri, Oct 06, 2017 at 10:46:20AM +0200, Gandalf Corvotempesta wrote:
>> Hi to all,
>> i'm new to XFS.
>>
>> Which is the proper agcount for 2TB, 4TB and 8TB drives (not part of any RAID) ?
>>
>> mkfs.xfs automatically choosen 4 AGs. Isn't this too low ?
> 
> No.  Have a look at calc_default_ag_geometry in libxcmd/topology.c for
> how we calculate the default AG count / size.  4TB single-disks and
> smaller get 4 AGs; larger than that get 1AG per TB.  RAID arrays are
> different.

Right; max AG size is 1T (for a default mkfs):

        /*
         * For a single underlying storage device over 4TB in size
         * use the maximum AG size.  Between 128MB and 4TB, just use
         * 4 AGs and scale up smoothly between min/max AG sizes.
         */

But if there is a stripe unit, it goes into multi-disk mode, assumes
you have more parallelism than a single spindle, and makes more AGs.

        /*
         * For the multidisk configs we choose an AG count based on the number
         * of data blocks available, trying to keep the number of AGs higher
         * than the single disk configurations. This makes the assumption that
         * larger filesystems have more parallelism available to them.
         */

If you have a single 8T disk with only a handful of heads, you won't
benefit from more AGs.

> Semirelated question: for a solid state disk on a machine with high CPU
> counts do we prefer agcount == cpucount to take advantage of the
> high(er) iops and lack of seek time to increase parallelism?
> 
> (Not that I've studied that in depth.)

Interesting question.  :)  Maybe harder to answer for SSD black boxes?

-Eric
