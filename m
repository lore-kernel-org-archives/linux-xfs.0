Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:36176 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934630AbcKXBXp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Nov 2016 20:23:45 -0500
Received: by mail-io0-f178.google.com with SMTP id x94so54871242ioi.3
        for <linux-xfs@vger.kernel.org>; Wed, 23 Nov 2016 17:23:44 -0800 (PST)
Received: from BUs-MacBook-Pro.local (cpe-66-61-34-121.neo.res.rr.com. [66.61.34.121])
        by smtp.gmail.com with ESMTPSA id i18sm2624557itb.0.2016.11.23.17.23.42
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Nov 2016 17:23:42 -0800 (PST)
From: Dave Hall <kdhall@binghamton.edu>
Subject: XFS + LVM + DM-Thin + Multi-Volume External RAID
Message-ID: <1495de1c-3384-f1d6-be76-1ad02fdc8cb1@binghamton.edu>
Date: Wed, 23 Nov 2016 20:23:42 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello,

I'm planning a storage installation on new hardware and I'd like to 
configure for best performance.  I will have 24 to 48 drives in a 
SAS-attached RAID box with dual 12GB/s controllers (Dell MD3420 with 10K 
1.8TB drives.  The server is dual socket with 28 cores, 256GB RAM, dual 
12GB HBAs, and multiple 10GB NICS.

My workload is NFS for user home directories - highly random access 
patterns with frequent bursts of random writes.

In order to maximize performance I'm planning to make multiple small 
RAID volumes (i.e. RAID5 - 4+1, or RAID6 - 8+2) that would be either 
striped or concatenated together.

I'm looking for information on:

- Are there any cautions or recommendations about  XFS 
stability/performance on a thin volume with thin snapshots?

- I've read that there are tricks and calculations for aligning XFS to 
the RAID stripes.  Can use suggest any guidelines or tools for 
calculating the right configuration?

- I've read also about tuning the number of allocation groups to reflect 
the CPU configuration of the server.  Any suggestions on this?

Thanks.

-Dave

