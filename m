Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54152 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726792AbfACXR1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jan 2019 18:17:27 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 882AA251F9
        for <linux-xfs@vger.kernel.org>; Thu,  3 Jan 2019 23:17:26 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202127] cannot mount or create xfs on a  597T device
Date: Thu, 03 Jan 2019 23:17:26 +0000
Message-ID: <bug-202127-201763-nKEiV4L3g2@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202127-201763@https.bugzilla.kernel.org/>
References: <bug-202127-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202127

--- Comment #9 from daimh@umich.edu ---
[root@watsons-s1 ~]# /opt/MegaRAID/storcli/storcli /c0 show | head -n 30
Generating detailed summary of the adapter, it may take a while to complete.

Controller = 0
Status = Success
Description = None

Product Name = AVAGO MegaRAID SAS 9361-16i
Serial Number = SK82367083
SAS Address =  500062b201dbbcc0
PCI Address = 00:02:00:00
System Time = 01/03/2019 18:17:05
Mfg. Date = 06/06/18
Controller Time = 01/03/2019 23:17:05
FW Package Build = 24.19.0-0047
BIOS Version = 6.34.01.0_4.19.08.00_0x06160200
FW Version = 4.720.00-8218
Driver Name = megaraid_sas
Driver Version = 07.706.03.00-rc1
Current Personality = RAID-Mode
Vendor Id = 0x1000
Device Id = 0xCE
SubVendor Id = 0x1000
SubDevice Id = 0x9371
Host Interface = PCI-E
Device Interface = SAS-12G
Bus Number = 2
Device Number = 0
Function Number = 0
Drive Groups = 1

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
