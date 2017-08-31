Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sender-pp-092.zoho.com ([135.84.80.237]:25335 "EHLO
        sender-pp-092.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750908AbdHaSE4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 14:04:56 -0400
From: ToddAndMargo <ToddAndMargo@zoho.com>
Subject: What is the proper way to remove an xfs partition?
Message-ID: <837b6a2a-5989-385a-88e3-158f8b614637@zoho.com>
Date: Thu, 31 Aug 2017 11:04:52 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi All,

Fedora 26
BIOS boot = legacy (EUFI give me hives)

I have a SATA backup drive formatted gpt, one partition, xfs. I went 
into gparted, erased the partition, recreated the partition as ext4 and 
formatted it as ext4.

Then I mounted it as ext4, copied some files to it, unmounted it. When I 
went to remount it, mount told me there was something wrong with ext4. 
So I mounted it as xfs AND IT WORKED! I repeated with the same result. 
The drive thinks it is ext4 until the second mount.

Out of shear frustration, I did a dd /dev/zero overwrite of the stinker 
and left it running overnight.  That did the trick, but it takes
forever and I have four more drives to go.

What is the official way to remove an xfs partition?

Many thanks,
-T

