Return-Path: <SRS0=BnrD=2S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66F20C2D0C6
	for <linux-xfs@archiver.kernel.org>; Sat, 28 Dec 2019 11:12:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26F5C20748
	for <linux-xfs@archiver.kernel.org>; Sat, 28 Dec 2019 11:12:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=iith.ac.in header.i=@iith.ac.in header.b="6qdU/boi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbfL1LMZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 28 Dec 2019 06:12:25 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:43032 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbfL1LMZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 28 Dec 2019 06:12:25 -0500
Received: by mail-ed1-f66.google.com with SMTP id dc19so27638427edb.10
        for <linux-xfs@vger.kernel.org>; Sat, 28 Dec 2019 03:12:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=iith.ac.in; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=/s2CBrumkJFVtykT5eYDRgUcmKE1psjhhYWiFnDV+lY=;
        b=6qdU/boiK4K9OWDoGbkl1y4HhiTdZsyacZ1C8Xut/dQmFVDAdqA1/OVggvF/DMZxYf
         3Qaxxx8R8wAy3CAMFulvrxuZs4hw6M77wLqaVIuPcH9sVdWw7Ow10as1rXWOwVc1d95a
         vxONBDy+hFGydCS78/ZUx+cnJguBDAnKia+SQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=/s2CBrumkJFVtykT5eYDRgUcmKE1psjhhYWiFnDV+lY=;
        b=Tix41VEGEQNXwbzISvCp/ny+vk6j9w39PZD1VczVMcJKWB/SLhXxucfrmthijh7lxp
         JBpqsXdS1UopIFl2U/V90zIjLscOq933Hvg5aTfT/P5JfW/A1YS0Or04FBqUrdZPyCuG
         iOrotnCw6z3fVi2VXnoF0I3kqTFsRWFPMevMep6mkWUrUElc5XNBs9t2DH1kEhuYoeyc
         EjDIj41btu7Mm0mk27gQF0mK3u56/E4RfxPaCgDF64uFMfQ3FZZOix8u8/Km5nTG8gzN
         bLvC5NbHd8HXY59QhOOf3fMgMIQHdIsktuOxFeRrsDysxWywLPviTyO/yptD2Pw3uyJ1
         3oZg==
X-Gm-Message-State: APjAAAUfGx5r1AeQnx576Lzv1WwIBWxqCeyyLa5xaX7b7YD8DtkXEsMo
        wBP78JYzJ/+OX4AlYoJxHHzPEoSEAlq1NvwNpiJM99x9kIw=
X-Google-Smtp-Source: APXvYqz1woKa9LJgWt4nLtlzI9E3O1OvZU3FIRGR41dVKQyLENRvMjEF8XiTLHPpoDOYS8FF9w1rx/xl2eJ0GKu3j2k=
X-Received: by 2002:a17:906:19c8:: with SMTP id h8mr21943587ejd.250.1577531541988;
 Sat, 28 Dec 2019 03:12:21 -0800 (PST)
MIME-Version: 1.0
From:   Utpal Bora <cs14mtech11017@iith.ac.in>
Date:   Sat, 28 Dec 2019 16:41:46 +0530
Message-ID: <CAH3av2k4c63LKQ0eG9twweXEgC7QD7G_w3=c23tSO5rLP_cAfQ@mail.gmail.com>
Subject: How to fix bad superblock or xfs_repair: error - read only 0 of 512 bytes
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

My XFS home drive is corrupt after trying to extend it with lvm.
This is what I did to extend the partition.
1. Extend Volume group to use a new physical volume of around 1.2TB.
This was successful without any error.
    vgextend vg-1 /dev/sdc1

2. Extend logical volume (home-lv) to use the free space.
    lvextend -l 100%FREE /dev/mapper/vg--1-home--lv -r

3. Resized home-lv and reduce 55 GB
   lvreduce -L 55G  /dev/mapper/vg--1-home--lv -r

I assumed that -r will invoke xfs_grow internally.
Everything was working fine until the server was restarted.
After restart, the home volume is not mounting. Please see the following.

server% sudo mount -t xfs /dev/mapper/vg--1-home--lv /home
mount: /home: can't read superblock on /dev/mapper/vg--1-home--lv.

server% dmesg| tail
[162580.208796] attempt to access beyond end of device
[162580.208800] dm-3: rw=4096, want=6650552320, limit=6640066560
[162580.208805] XFS (dm-3): last sector read failed

server% sudo xfs_repair -n /dev/mapper/vg--1-home--lv
Phase 1 - find and verify superblock...
xfs_repair: error - read only 0 of 512 bytes

OS: Ubuntu Server 18.04.3
Kernel: 4.15.0-72-generic

I have gone through the earlier posts on this subject. They did not help me.

Is it possible to repair the XFS volume? Kindly suggest.

Regards,

Utpal Bora
Ph.D. Scholar
Computer Science & Engineering
IIT Hyderabad
