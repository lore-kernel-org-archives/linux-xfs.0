Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail2.jlbond.com ([68.15.28.130]:52781 "EHLO mail.jlbond.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750889AbdAVBwv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 21 Jan 2017 20:52:51 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.jlbond.com (Postfix) with ESMTP id 000907A30D
        for <linux-xfs@vger.kernel.org>; Sat, 21 Jan 2017 17:20:53 -0800 (PST)
Received: from mail.jlbond.com ([127.0.0.1])
        by localhost (mail.jlbond.com [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id su+o6Gye5NrX for <linux-xfs@vger.kernel.org>;
        Sat, 21 Jan 2017 17:20:53 -0800 (PST)
Received: from [192.168.0.111] (firewall.bbky.org [192.168.0.1])
        by mail.jlbond.com (Postfix) with ESMTP id BFDDF79763
        for <linux-xfs@vger.kernel.org>; Sat, 21 Jan 2017 17:20:53 -0800 (PST)
From: Bond Masuda <bond.masuda@jlbond.com>
Subject: XFS issues with NVMe SSD
Message-ID: <8a562e13-6d86-d9ef-de22-f71d5aa79b60@jlbond.com>
Date: Sat, 21 Jan 2017 17:20:53 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi linux-xfs list:

I've been having XFS file system corruption issues when used with Intel 
NVMe SSD in Fedora 25 Linux as reported here:

https://bugzilla.redhat.com/show_bug.cgi?id=1402533

I don't know if this is XFS issue or not, but ext4 on the same Intel 
NVMe SSD doesn't appear to be a problem. Are linux/xfs devs already 
aware of the problem?

Bond
