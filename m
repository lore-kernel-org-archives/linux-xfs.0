Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44862 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752691AbcKZRwn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 26 Nov 2016 12:52:43 -0500
Subject: Re: XFS + LVM + DM-Thin + Multi-Volume External RAID
References: <1495de1c-3384-f1d6-be76-1ad02fdc8cb1@binghamton.edu>
 <20161124094332.o3hbaubrligsa7l3@eorzea.usersys.redhat.com>
 <20161124194419.GR28177@dastard>
 <96f2ee29-7f75-500d-3ac2-687632ece24b@binghamton.edu>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8c721372-6d69-03e0-ba2c-25ec75209046@sandeen.net>
Date: Sat, 26 Nov 2016 11:52:42 -0600
MIME-Version: 1.0
In-Reply-To: <96f2ee29-7f75-500d-3ac2-687632ece24b@binghamton.edu>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Hall <kdhall@binghamton.edu>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On 11/25/16 8:50 AM, Dave Hall wrote:
>> mkfs.xfs will do this setup automatically on software raid and any
>> block device that exports the necessary information to set it up.
>> In general, it's only older/cheaper hardware RAID that you have to
>> worry about this anymore.
>>
> So how do we know for sure? Is there a way that we can be sure that
> the hardware RAID has exported this information?

If you run mkfs.xfs and it shows stripe geometry in the stdout info,
then it detected stripe geometry.

Otherwise you can use lsblk -t to print the advertised topology:

# lsblk -t /dev/md121 
NAME  ALIGNMENT MIN-IO OPT-IO PHY-SEC LOG-SEC ROTA SCHED RQ-SIZE  RA WSAME
md121         0    512      0     512     512    1           128 128    0B

min io size is the stripe unit, opt IO size is the stripe width.

(in the above case there is no stripe geometry; 512-byte min IO and 0 optimal
IO is uninteresting).

> In lieu of this, is
> there a solid way to deduce or test for correct alignment?

If the device itself doesn't advertise a stripe geometry and you think
it has one, you'll need to look at the device settings, bios, documentation,
configuration, or whatever else to work it out on your own, and then specify
that manually on the mkfs.xfs commandline.

-Eric
