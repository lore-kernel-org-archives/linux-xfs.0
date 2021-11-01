Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B48C5C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Nov 2021 19:40:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FDFB61053
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Nov 2021 19:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhKATna (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Nov 2021 15:43:30 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:39460 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbhKATna (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Nov 2021 15:43:30 -0400
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id 1A1Jerqw042854;
        Mon, 1 Nov 2021 12:40:55 -0700
Message-ID: <61804254.3070001@tlinx.org>
Date:   Mon, 01 Nov 2021 12:39:00 -0700
From:   L A Walsh <xfs@tlinx.org>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To:     linux-xfs <linux-xfs@vger.kernel.org>
CC:     Dave Chinner <david@fromorbit.com>
Subject: cause of xfsdump msg: root ino 192 differs from mount dir ino 256
References: <617721E0.5000009@tlinx.org> <20211026004814.GA5111@dread.disaster.area>
In-Reply-To: <20211026004814.GA5111@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


When I xfsdump my /home partition, I see the above diagnostic
where it  lists "bind mount?" might be involved, but as far as
I can see, that's not the case.

grepping for '/home\s' on output of mount:

/bin/mount|grep -P '/home\s'

shows only 1 entry -- nothing mounted on top of it:

/dev/mapper/Space-Home2 on /home type xfs (...)

I have bind-mounts of things like
/home/opt  on /opt, but that shouldn't affect the root node,
as far as I know.

So what would cause the root node to differ from the mountdir
ino?

I try mounting the same filesystem someplace new:

# df .
Filesystem        Size  Used Avail Use% Mounted on
/dev/Space/Home2  2.0T  1.5T  569G  73% /home

mkdir /home2
Ishtar:home# mount /dev/Space/Home2 /home2

Ishtar:home# ll -di /home /home2
256 drwxr-xr-x 40 4096 Nov  1 10:23 /home/
256 drwxr-xr-x 40 4096 Nov  1 10:23 /home2/

Shows 256 as the root inode.  So why is xfsdump claiming
192 is root inode?

I used xfs_db and 192 is allocated to a normal file, while
256 displays nothing for the filename.

How should I further debug this?




