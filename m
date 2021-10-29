Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E19AC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Oct 2021 19:26:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C95A60E8B
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Oct 2021 19:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhJ2T3G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Oct 2021 15:29:06 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:39456 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhJ2T3F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Oct 2021 15:29:05 -0400
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id 19TJPdvb093206;
        Fri, 29 Oct 2021 12:25:41 -0700
Message-ID: <617C4A7E.2040605@tlinx.org>
Date:   Fri, 29 Oct 2021 12:24:46 -0700
From:   L A Walsh <xfs@tlinx.org>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To:     Dave Chinner <david@fromorbit.com>
CC:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: xfsrestore'ing from file backups don't restore...why not?
References: <617721E0.5000009@tlinx.org> <20211026004814.GA5111@dread.disaster.area> <617B5DA3.7060106@tlinx.org>
In-Reply-To: <617B5DA3.7060106@tlinx.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2021/10/28 19:34, L A Walsh wrote:
>
>
> On 2021/10/25 17:48, Dave Chinner wrote:
>> On Mon, Oct 25, 2021 at 02:30:08PM -0700, L A Walsh wrote:
>> > I'm trying to do a cumulative restore a directory from a multi-file 
>> backup
>> > w/names:
>> > -rw-rw-r-- 1 1578485336160 Oct  1 06:51 home-211001-0-0437.dump
>> > -rw-rw-r-- 1  262411348256 Oct 23 04:53 home-211023-1-0431.dump
>> > -rw-rw-r-- 1    1881207032 Oct 25 04:31 home-211025-2-0430.dump
>> >
>>
>> Have you ever successfully restored a directory from a multi-file
>> backup?
> ---
> many times.  I thought back to when I 1st noticed this prob:  When
> I replaced my disks when I had to get new containers.
> All of the backed up "devices" (meta lvm partitions) needed
> a new lvl 0 then.
>
> Before that, never a problem, after that, only have had about 2 times
> trying a restore -- both times, had the message about an ino
> being placed in the orphanage.
>
> The first time this happened, my /home was restored under
> orphanage/<256.0>.  I.e. complete /home tree started at:
> /home/orphanage/<256.0>/home
>
> This time, nothing at all appears under /home/orphanage/<256.0>
> and, interactively in the lvl-0 dump of the home backup,
> nothing appears when I try 'ls' in xfsrestore (interactively) at
> the root of backup.
>>
>> Note that restore errors are often caused by something going wrong
>> during the dump and it not being noticed until restore is run and
>> the error found. And at that point, there's nothing that can be done
>> to "fix" the dump image so it can be restored.
>
>>
>> What was the xfs_dump commands that created these dump files?
The scripts that create the dumps date back to 2008 with last
revisions in 2013, so their style makes it hard to conveniently
provide a listing of params. 

I decided the scripts ned a bit of modernizing and refactoring
to allow easier additions (like echoing the command being
executed...etc)
>>
>>
>> Did you take the dumps from a frozen filesystem or a read-only
>> snapshot of the filesystem, or just take it straight from a running 
>> system?
----
    Does xfs support creating of arbitrary read-only snapshots?
In the past 20+ years running snapshots haven't ever used
a frozen snapshot -- never been that important.
>>
>> What happens if you try to restore one dump at a time? i.e. is the
>> problem in the level 0 dump, or in one of the incrementals that are
>> based on the level 0 dump?
----
    Both, with the most problems in lvl 0.
>>
>> > xfsrestore: NOTE: ino 1879669762 salvaging file, placing in 
>> orphanage/256.0/tools/libboost/boost_1_64_0/doc/html/boost/accumulators/extract/extended_p_square.html 
>>
>>
>> IIUC, this means an ancestor directory in the path doesn't exist in 
>> the inventory and so the path for restore cannot be resolved
>> correctly.  Hence the inode gets placed in the orphanage under the
>> path name that is stored with the inode.
>>
"/home" has an ancestor dir of "/" and "home".  When trying to
restore /home interactively, it showed no files in the root
directory.
>>
>> I /think/ this error implies that the backups (dumps) were taken from 
>> an active filesystem.
This part is most definitely true, w/default backups being run
at 4:30am when the system wasn't likely to be in active use.
>> i.e between the time the dump was started
>> and when the inventory was finally updated, the directory structure 
>> had changed and so the dump is internally inconsistent.
----
    Don't think this is possible.  Backup is of contents of
/home.  I.e. only '/' and '/home' could be deleted/missing,
Neither of which is likely.


>>
>> It would be interesting to know what part of the above path is
>> actually missing from the dump inventory, because that might help
>> explain what went/is going wrong...
---
    Well, at very least am going to rewrite/refactor these
scripts to get some more answers.

