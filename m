Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from synagogue.naos.co.nz ([203.171.38.148]:60942 "EHLO
        synagogue.naos.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751840AbdIZJCQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2017 05:02:16 -0400
Received: from [172.20.254.10] (client10.vpn.naos.co.nz [172.20.254.10])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by synagogue.naos.co.nz (Postfix) with ESMTPSA id DFBB44036D
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2017 21:54:28 +1300 (NZDT)
From: Ewen McNeill <xfs@ewen.mcneill.gen.nz>
Subject: Rationale for hardware RAID 10 su, sw values in FAQ
Message-ID: <b8c45869-849f-5124-f74f-68da0f9f34d7@mcneill.gen.nz>
Date: Tue, 26 Sep 2017 21:54:28 +1300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The FAQ:

http://xfs.org/index.php/XFS_FAQ#Q:_How_to_calculate_the_correct_sunit.2Cswidth_values_for_optimal_performance

suggests using:

su = hardware RAID stripe size on single disk

sw = (disks in RAID-10 / 2)

on hardware RAID 10 volumes, but doesn't provide a reason for that "sw" 
value (other than that "(disks in RAID-10 / 2)" are the effective data 
disks).

In the RAID 5 / RAID 6 case, obviously you want (su * sw) to cover the 
user data that you can write across the whole array in a single stripe, 
since that is the "writeable unit" on the array on which 
read/modify/write will need to be done -- so you do not want to have a 
data structure spanning the boundary between two writeable units (as 
that means two blocks will need to be read / modify / written).

In the RAID 10 case it is clearly preferable to avoid spanning across 
the boundary of a _single_ disk's (pair's) stripe size (su * 1), as then 
_two_ pairs of disks in the RAID 10 need to get involved in the write 
(so you potentially have two seek penalties, etc).

But in the RAID 10 case the each physical disk is just paired with one 
other disk, and that pair can be written independently of the rest -- 
since there's no parity information as such, there's normally no need 
for a read / modify / write cycle of any block larger than, eg, a 
physical sector or SSD erase block.

So why is "sw" in the RAID 10 case given as "(disks in RAID-10 / 2)" 
rather than "1"?  Wouldn't

su = hardware RAID stripe size on single disk

sw = 1

make more sense for RAID 10?

In the RAID 10 case, spanning across the whole data disk set seems 
likely to align data structures (more frequently) on the first disk pair 
in the RAID set (especially with larger single-disk stripe sizes), 
potentially making that the "metadata disk pair" -- and thus both 
potentially having more metadata activity on it, and also being more at 
risk if one disk in that pair is lost or that pair is rebuilding.  (The 
same "align to start of disk set" would seem to happen with RAID 5 / 
RAID 6 too, but is unavoidable due to the "large smallest physically 
modifiable block" issue.)

What am I missing that leads to the FAQ suggesting "sw = (disks in 
RAID-10 / 2)"?  Perhaps this additional rationale could be added to that 
FAQ question?  (Or if "sw = 1" actually does make sense on RAID 10, the 
FAQ could be updated to suggest that as an option.)

Thanks,

Ewen

PS: In the specific case that had me pondering this today, it's RAID 10 
over 12 spindles, with a 512KB per-spindle stripe size.  So that's 
either 512KB * 1 = 512KB, or 512KB * 6 = 3072KB depending on the rationale.
