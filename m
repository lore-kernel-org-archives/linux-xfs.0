Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from walrus.jabberwocky.com ([173.9.29.57]:34769 "EHLO
        mail.jabberwocky.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726361AbeLXBzq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Dec 2018 20:55:46 -0500
Received: from grover.home.jabberwocky.com (grover.home.jabberwocky.com [172.24.84.28])
        by mail.jabberwocky.com (Postfix) with ESMTPSA id B4CDE206F016
        for <linux-xfs@vger.kernel.org>; Sun, 23 Dec 2018 20:50:02 -0500 (EST)
From: David Shaw <dshaw@jabberwocky.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Subject: Using su and sw when the underlying RAID changes
Message-Id: <1CFB1ED6-B218-4E73-9A2F-0D2F62C9C2AB@jabberwocky.com>
Date: Sun, 23 Dec 2018 20:50:02 -0500
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello,

I have a question around su and sw on a RAID.  Using some RAID systems, including mdadm under Linux, it's possible to reshape the array such that the su and sw settings used at mkfs time are no longer the correct ones.  For example, lets's say I make a 2 device RAID 0, run mkfs.xfs on it, and use it for a while.  That RAID is sw=2.  Then I need more space so I add another device, reshaping it to a 3 device RAID 0.  If I did a fresh mkfs.xfs on the (now) 3 device RAID 0 I would have sw=3, but given that I don't want to lose all the contents, the existing formatting is still sw=2.

Are there any best practices (including, I suppose, "don't do that") for handling this sort of thing?  So far as I know there is no way to change su or sw for already allocated data structures.  I understand that the existing data will still be readable, albeit not optimally stored.  How bad is it to have incorrect su or sw?

Thanks for any advice,

David
