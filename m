Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:46560 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728886AbfAVPzG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Jan 2019 10:55:06 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 6E9682B150
        for <linux-xfs@vger.kernel.org>; Tue, 22 Jan 2019 15:55:05 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202127] cannot mount or create xfs on a  597T device
Date: Tue, 22 Jan 2019 15:55:04 +0000
Message-ID: <bug-202127-201763-EmnNUjwzS7@https.bugzilla.kernel.org/>
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

--- Comment #27 from Eric Sandeen (sandeen@sandeen.net) ---
It may still fail, but you've specified your sunit * swidth incorrectly
(backwards)

[  316.159473] XFS (sda): stripe width (64) must be a multiple of the stripe
unit (256)

>From the manpage:

       sunit=value and swidth=value
              Used  to  specify  the  stripe  unit  and width for a RAID
              device or a stripe volume.  "value" must be  specified  in
              512-byte  block  units. These options are only relevant to
              filesystems that were created with non-zero data alignment
              parameters.

              The sunit and swidth parameters specified must be compati‐
              ble with the existing  filesystem  alignment  characteris‐
              tics.   In  general,  that means the only valid changes to
              sunit are increasing it by a  power-of-2  multiple.  Valid
              swidth  values  are  any integer multiple of a valid sunit
              value.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
