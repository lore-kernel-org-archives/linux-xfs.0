Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sender-pp-092.zoho.com ([135.84.80.237]:25441 "EHLO
        sender-pp-092.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751831AbdHTF5y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 Aug 2017 01:57:54 -0400
From: ToddAndMargo <ToddAndMargo@zoho.com>
Subject: xfs errors
Message-ID: <42ebd50b-a327-0afb-a53a-e2dedd003415@zoho.com>
Date: Sat, 19 Aug 2017 22:57:49 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Dear Xfs,

Do I report this to you or Red Hat?

Fedora Core 26, x564
xfsdump-3.1.6-4.fc26.x86_64

When I run the following

     # /sbin/xfsdump -v verbose -M 1 -L 1 -l 0 -f 
/lin-bak/2017-08-19_22-30-27_md126p2.XfsDump  /

randomly, I get this error message when I run xfsdump:


     /sbin/xfsdump: ino map phase 1: constructing initial dump list
     /sbin/xfsdump: WARNING: failed to get bulkstat information for 
inode 739
     /sbin/xfsdump: WARNING: failed to get bulkstat information for 
inode 954
     /sbin/xfsdump: WARNING: failed to get bulkstat information for 
inode 1118
     about 40 more of them

And the next time it will run clean.  What gives?

I put a `sunc; sync` before the dump command and it seems to help, but 
it is random, so who knows.

Is this a bug?  Or am I doing something wrong?

Many thanks,
-T

