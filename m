Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sender-pp-092.zoho.com ([135.84.80.237]:25420 "EHLO
        sender-pp-092.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750904AbdHNTYZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Aug 2017 15:24:25 -0400
From: ToddAndMargo <ToddAndMargo@zoho.com>
Subject: RFE: source path
Message-ID: <83eb7939-c1b4-b62a-676f-d5cc350a3dc6@zoho.com>
Date: Mon, 14 Aug 2017 12:24:20 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Dear Xfs,

Fedora 26 x64
xfsdump-3.1.6-4.fc26.x86_64


# df | grep "/dev/"
tmpfs            16417652       0   16417652   0% /dev/shm
/dev/md126p2    872803956 5891900  866912056   1% /
/dev/md126p1      1038336  226012     812324  22% /boot
/dev/sdd1      1952559608 2190200 1950369408   1% /lin-bak


I am trying to back up "/" (/dev/md126p2).

This is my run string:

# /usr/sbin/xfsdump -v verbose -M 1 -L 1 -l 0 -f 
/lin-bak/2017-08-11_21-39-07_md126p2.XfsDump  /dev/md126p2

Problem: you get millions of
/usr/sbin/xfsdump: WARNING: could not open regular file ino 1613157757 
mode 0x000081a4: Not a directory: not dumped

The correction is to use "/" as the source instead of /dev/md126p2".

Problem: sometimes you can use the raw device as the source
and sometimes you can not:

Request for Enhancement (RFE): if a raw device is not appropriate
as the source, would you please consider throwing and error
message to the effect?

Many thanks,
-T

