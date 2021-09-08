Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 896BCC433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Sep 2021 23:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72DF561090
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Sep 2021 23:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbhIHXKG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Sep 2021 19:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232342AbhIHXKF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Sep 2021 19:10:05 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA2DC061575
        for <linux-xfs@vger.kernel.org>; Wed,  8 Sep 2021 16:08:57 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id z12so41808qvx.5
        for <linux-xfs@vger.kernel.org>; Wed, 08 Sep 2021 16:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=yakkadesign-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=5Jmb+5d1VAkAt/d1Y0GZSVDLPRog4EOphHEyJGxKQUs=;
        b=r7fRYGN314djIv4ggUG4z8KUziG2hGbTLk7VEMr92IY5fF3BiJcL+ezDQHka/jUrk1
         SUTIeo8jEJbCXnWueK+n/yo7i9lHyDU2NSA93MSKt693ifSd+qgEarjAABQF5NiYYZkk
         KGJ/d0Rng5Q+uT+qj+JCulBCnqqDPMQ9ICwY571gEx9aqF6DdNpx9zLQrID5LrVKgUWW
         H8Y7nMB8Dob35gEhiFejoEi+abg/8MLz6BwV6O1nneazFHPLDLWTNgjirZXF11lnWsn5
         guFDmVuRWSZYFOsYSYewPI35coeyisIhKW4phA0kbn3qEm6IyrJAWpbtPzfuKwTGwxFD
         lFTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=5Jmb+5d1VAkAt/d1Y0GZSVDLPRog4EOphHEyJGxKQUs=;
        b=Rjbnz7a8Q4eQ2p36wZ8lu96WvsS+6cQaYdIMIsJS6433gcnZltHIZwYEbrB3swP55g
         mjTnZfgo++2rh2j+E3ulUvjlR7Dyhz6hmyEbDR8OTacvuUzM6tkp9ImBA29ub/4gvx40
         lZ2Vi+J4MY01meiO7wVO8gwxOjxkom75tw8hg2JZdkDGb4ZWMlUmmjUwMXlFI62H4+be
         oi5Nvw0MWgt2uuiBOG9AlMLK6f5k1s0TJ65bxoCDR2lVHqlzwwYQd8EwwUuspJ1dHr2s
         lrI8H8M8ijoPQV5UvbaTPze/byH//6BAvL1tfP178HYRS2/eTSQPtHdto5v6bDBVRUan
         VBNQ==
X-Gm-Message-State: AOAM533jfiR4mKGFpk4D6JzIaPhqzebM6/o+Y+WTxA2rEt7+UqoMz0oe
        8p3Nxm927jC+A01zDRJTIgLCf+mYWz+CaECercQ=
X-Google-Smtp-Source: ABdhPJycuoNjVnoItvisZ6kRpuRDGiO996bugob+NXjas7XZgWK2ksXDYc/O4vPHjWCs3WI/C2g18w==
X-Received: by 2002:a05:6214:1268:: with SMTP id r8mr760141qvv.5.1631142536495;
        Wed, 08 Sep 2021 16:08:56 -0700 (PDT)
Received: from ?IPv6:2602:306:bc57:e350:5a91:cfff:fe5a:fe83? ([2602:306:bc57:e350:5a91:cfff:fe5a:fe83])
        by smtp.googlemail.com with ESMTPSA id w6sm29138qkf.95.2021.09.08.16.08.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Sep 2021 16:08:55 -0700 (PDT)
Subject: Re: Repair Metadata corruption detected at xfs_inode_buf_verify on
 CentOS 7 virtual machine
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <055dbf6e-a9b5-08a1-43bc-59f93e77f67d@yakkadesign.com>
 <20210908213924.GB2361455@dread.disaster.area>
From:   brian <a001@yakkadesign.com>
Message-ID: <987fa28b-4928-8557-0f09-73839790e910@yakkadesign.com>
Date:   Wed, 8 Sep 2021 19:08:54 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20210908213924.GB2361455@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Here is an update of the error.  If something looks off, let me know and 
I'll double check I transcribed correct.  Let me know if there is a way 
to post a screenshot.

----------------------------------------------------------------------------

XFS (dm-2): Metadata corruption detected at 
xfs_inode_buf_verify+0x14d/0x160 [xfs] xfs_inode block 0x1b5c1c0 
xfs_inode_buf_verify
XFS (dm-2): Unmount and run xfs_repair
XFS (dm-2): First 128 bytes of corrupted metadata buffer:
ffffae6842564000: 16 49 77 8a 32 7e 72 52 14 bb 51 98 7c a5 2c 9a 
.Iw.2~rR..Q.|.,.
ffffae6842564010: dd 28 4d 94 88 03 2b 8c 99 33 67 ca 6a d5 aa c9 
.(M...+..3g.j...
ffffae6842564020: f8 f8 78 c7 90 fc f5 af 7f 95 03 07 0e 0c 4a 37 
..x...........J7
ffffae6842564030: 7c f8 70 c7 09 14 c7 81 a5 a7 a7 cb a8 a8 28 b9 
|.p...........(.
ffffae6842564040: 68 d1 a2 a0 73 f5 ae d5 73 94 23 3d 3d 5d 46 46 
h...s...s.#--]FF
ffffae6842564050: 46 ca f9 f3 e7 3b 69 4c d3 94 6d db b6 75 14 3d 
F....;iL..m..u.=
ffffae6842564060: 30 68 77 ec d8 e1 a4 d9 b7 6f 9f 0c 0b 0b 0b 32 
)hw......o.....2
ffffae6842564070: 8e 9d 29 aa 03 4b 4c 4c 0c 52 66 29 a5 7c f4 d1 
..)..KLL.Rf).|..
XFS (dm-2): metadata I/O error in “xlog_recov_do..(read#2)” at daddr 
0x1b32 error 117

----------------------------------------------------------------------------

My computer is an older CentOS 6 box (on my todo list to replace).  I 
have an array of VirtualBox VMs.  All my data including VMs is in 
/home/brian directory.  I run rsync to backup /home/brian directory to a 
USB drive.  Rsync treats the files of the VM just like any other file.  
I noticed that the VMs can get corrupted if I leave them running during 
back up with rsync so I normally shut them down.  For this instance, I 
didn't shut down the VM when I launched rsync.

@Dave
Regarding your image file question, I don't believe the above is an 
image file.  Rsync copies file by file.  And I can navigate to the USB 
like my internal hdd.

Regarding the freeze files system, no I did not freeze the guest.

Regarding the older backups, I just have the rsync backup on a USB 
drive.  I've been working with a copy from the USB to try at get this 
machine back, thus the unmodified USB rsync that was taken while the 
machine was running exists.

While rsync was running, I had Selenium running web app tests in 
Chrome.  All the data from my program was being written to a shared 
folder.  Chrome has it's own internal cache that could be changing but 
overall, I wouldn't expect the file system to be changing too much 
especially the booting part.

My ultimate goal is to get to the data on this VM.  I've tried to mount 
this .vdi file in another instance of CentOS but have not been 
successful.  I may spin up an Ubuntu instance to try to get to the 
data.  The data on this VM can be recreated but I prefer not to have to 
redo the work.

Thank you for your help.

Brian


On 09/08/2021 05:39 PM, Dave Chinner wrote:
> On Wed, Sep 08, 2021 at 10:35:57AM -0400, brian wrote:
>> I have CentOS 7 Virtualbox virtual machine (VM) that gives the following
>> error on boot(removed parts replaced with …)
>> ----------------------------------------------------------------------------
>> XFS (dm-2): Metadata corruption detected at xfs_inode_buf_verify...
>> XFS (dm-2): unmount and run xfs_repair
>> XFS (dm-2): First 128 bytes of corrupted metadata buffer:
>> …
> You cut out the part of the error report that actually means
> something to us. Can you post the error message in full?
>
>> XFS (dm-2): metadata I/O error in “xlog_recov_do..(read#2)” at daddr 0x1b32
>> error 117
>> ----------------------------------------------------------------------------
>>
>> I tried entered emergency mode, entered password and tried:
>>      xfs_repair -L /dev/mapper/centos-root
>>
>> But I got the error:
>>      /dev/mapper/centos-root contains a mounted filesystem
>>      /dev/mapper/centos-root contains a mounted and writable filesystem
> $ man xfs_repair
> ....
>    -d	Repair  dangerously.  Allow xfs_repair to repair an XFS
> 	filesystem mounted read only. This is typically done on a
> 	root filesystem from single user mode, immediately followed
> 	by a reboot.
>
>> Next I booted from the Centos ISO then went
>>        troubleshooting → Rescue a CentOS system  → 1) Continue
>>
>> This fails.  I get lines of = marks.  When I left overnight, I had a blank
>> screen.  When I ALT+Tab to program-log and then back to main, I got a screen
>> of scrolling errors.
> Which typically happens if the filesystem full of inconsistencies
> and corruptions.
>
>> I nightly backup my data including this VM with rsync to a USB drive.  My
>> last backup was while the VM was running.  In Virtualbox and on my computers
>> drive, I deleted the VM using the virtualbox GUI.  I thought this would move
>> the VM to the trash but it permanently deleted the VM.  The problem I'm
>> having is with the backup VM from my USB drive.
> How did you do the backup? Was it an image file backup from the
> host, or a full filesystem rsync from inside the guest ?
>
>> How should I troubleshoot and fix this problem?  My main goal is to get my
>> data off the VM.  I also unsuccessful with mounting the .vdi file in another
>> computer.
> Sounds like you simply backed up the image file on the host?
>
> If so, did you freeze the filesystem in the guest (or the whole
> guest VM) while you did the backup? If the guest fs wasnt' frozen,
> and the VM was active while the backup was done as you say, then it
> is guaranteed that the image file that was copied will contain an
> inconsistent image of the filesystem. If there was lots of
> modifications occurring at the time of the copy being run, it will
> be full of corruptions and may well be completely unrecoverable.
>
> DO you have any older backups you can try to recover from?
>
> Cheers,
>
> Dave.

