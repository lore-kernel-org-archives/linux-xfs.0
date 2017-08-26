Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sender-pp-092.zoho.com ([135.84.80.237]:25418 "EHLO
        sender-pp-092.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751120AbdHZX1z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 26 Aug 2017 19:27:55 -0400
Subject: Re: xfs errors
From: ToddAndMargo <ToddAndMargo@zoho.com>
References: <42ebd50b-a327-0afb-a53a-e2dedd003415@zoho.com>
Message-ID: <f43864d4-2874-a843-fda3-870e84160031@zoho.com>
Date: Sat, 26 Aug 2017 16:27:52 -0700
MIME-Version: 1.0
In-Reply-To: <42ebd50b-a327-0afb-a53a-e2dedd003415@zoho.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On 08/19/2017 10:57 PM, ToddAndMargo wrote:
> Dear Xfs,
> 
> Do I report this to you or Red Hat?
> 
> Fedora Core 26, x564
> xfsdump-3.1.6-4.fc26.x86_64
> 
> When I run the following
> 
>      # /sbin/xfsdump -v verbose -M 1 -L 1 -l 0 -f 
> /lin-bak/2017-08-19_22-30-27_md126p2.XfsDump  /
> 
> randomly, I get this error message when I run xfsdump:
> 
> 
>      /sbin/xfsdump: ino map phase 1: constructing initial dump list
>      /sbin/xfsdump: WARNING: failed to get bulkstat information for 
> inode 739
>      /sbin/xfsdump: WARNING: failed to get bulkstat information for 
> inode 954
>      /sbin/xfsdump: WARNING: failed to get bulkstat information for 
> inode 1118
>      about 40 more of them
> 
> And the next time it will run clean.  What gives?
> 
> I put a `sunc; sync` before the dump command and it seems to help, but 
> it is random, so who knows.
> 
> Is this a bug?  Or am I doing something wrong?
> 
> Many thanks,
> -T
> 


This is the error I get when I operate Thunderbird and Firefox during a 
backup.  It is different from the error I see above:

/usr/sbin/xfsdump: WARNING: could not open regular file ino 1181897732 
mode 0x00008180: Stale file handle: not dumped

