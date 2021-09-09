Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4200AC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Sep 2021 03:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F07261181
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Sep 2021 03:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350162AbhIIDku (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Sep 2021 23:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235831AbhIIDkp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Sep 2021 23:40:45 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24A7C061575
        for <linux-xfs@vger.kernel.org>; Wed,  8 Sep 2021 20:39:36 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id a20-20020a0568300b9400b0051b8ca82dfcso779933otv.3
        for <linux-xfs@vger.kernel.org>; Wed, 08 Sep 2021 20:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=yakkadesign-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=8tReEnxpDrsvdFvND/u33nwq70sBwu2BtziAJF23Atk=;
        b=C3w5FcBVVhZTnelAVtBXDsRyxVvdsm0m0N5bWGQkEKE2FNudQsqAj6k2r3IRNj8R3Q
         xbd/NtN4kccyv9jFnhmJbho4wgDjdDuXzj8fv+DOFVjwr9NR5JXprHYFnxdf95lAJrX7
         6y0EVbUDcj0pNeQREulbL2IJLaKlkndEi3bv6RxZxvWjHpAQjlCA/mxXF3XwABtVkRbS
         X+TdrdMkwLG/ehbcPXrcxme83+ecgxIHC1jgDoKYSpHf0WaeJ/eqVKKPXJZwdKibtQxm
         UTmzlbRb0tfBX/c10lPhrx+fR9iYXqU1mzl7ouBacI26A/7niNyedwdo8vGpcIe6F+0x
         vEDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=8tReEnxpDrsvdFvND/u33nwq70sBwu2BtziAJF23Atk=;
        b=PeR9xKlu3OlecXxlax5W17OolITuWoWSbqJBOnCGsa6rEmBQhgl9sbsYrkn3A8Ir8l
         AxDr6Iuonyl1hK/J+UkDa0nQTsHgEgHGI580jZL/Esf4du9hsMnImztdMn36U0RHt4a0
         rGDmkK/2WegtEw76BKwHy3rtayXhdyLhqs9pPHuaDea1m4DqEjQ7EKWa14FUxOBYDZbW
         eYP2eWKQUlMwlHFbMvxSJboEcTZKdUeMUC4ls0n8DnzYcaCl2tmdmPvwsXNGlOBzcquU
         bJnlDMnYeY38X+94mN4fMJ7zDMW2TNY9f3lr9Z45/KsUsoeH5cj968ev5yojyQMzJjQt
         mklg==
X-Gm-Message-State: AOAM533z9XGN4dymTY9IOwWHsR+4j7xAWyHIzrxsm1NAXD4EOgJqdfY/
        3dcEK3L6RNeWNvt7l86FWonzbJlAnWBivgqvo0k=
X-Google-Smtp-Source: ABdhPJynkZAqydP1KCqUG2V+iy/OuxCbDd7BpfAKtPcCWJjBjhDpiiT9lhApeS8JoxbAG2YJbb9BBA==
X-Received: by 2002:a05:6830:91:: with SMTP id a17mr710893oto.189.1631158775800;
        Wed, 08 Sep 2021 20:39:35 -0700 (PDT)
Received: from ?IPv6:2602:306:bc57:e350:5a91:cfff:fe5a:fe83? ([2602:306:bc57:e350:5a91:cfff:fe5a:fe83])
        by smtp.googlemail.com with ESMTPSA id p81sm134516oia.48.2021.09.08.20.39.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Sep 2021 20:39:34 -0700 (PDT)
Subject: Re: Repair Metadata corruption detected at xfs_inode_buf_verify on
 CentOS 7 virtual machine
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <055dbf6e-a9b5-08a1-43bc-59f93e77f67d@yakkadesign.com>
 <20210908213924.GB2361455@dread.disaster.area>
 <987fa28b-4928-8557-0f09-73839790e910@yakkadesign.com>
 <20210909025445.GC2361455@dread.disaster.area>
From:   brian <a001@yakkadesign.com>
Message-ID: <9b338235-1a28-951a-5d8c-09e0af97329e@yakkadesign.com>
Date:   Wed, 8 Sep 2021 23:39:33 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20210909025445.GC2361455@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

@Dave,


I would consider myself a beginner with Linux file systems.  I'm not 
sure how to implement your suggestions.  If you have any suggested 
places to dig deeper, let me know.


When you say 'mount -o ro,norecovery <dev>', do you mean to boot the VM 
I'm having problems with and add this from the prompt?  I'm not sure 
what <dev> is.  I assume you mean /dev/.... Also, I thought I had to add 
what is being mounted (e.g., image file).


So far, I've been using the xfs_repair that is build into the VM (CentOS 
7).  I've only accessed xfs_repair while in the emergency mode.  I'm not 
sure how to use another version; I didn't think the emergency mode had 
internet.


Can you give me more direction in how to execute on your suggestions?


Thank you again for your help.  I appreciate all the help.


Brian


On 09/08/2021 10:54 PM, Dave Chinner wrote:
> On Wed, Sep 08, 2021 at 07:08:54PM -0400, brian wrote:
>> Here is an update of the error.  If something looks off, let me know and
>> I'll double check I transcribed correct.  Let me know if there is a way to
>> post a screenshot.
>>
>> ----------------------------------------------------------------------------
>>
>> XFS (dm-2): Metadata corruption detected at xfs_inode_buf_verify+0x14d/0x160
>> [xfs] xfs_inode block 0x1b5c1c0 xfs_inode_buf_verify
>> XFS (dm-2): Unmount and run xfs_repair
>> XFS (dm-2): First 128 bytes of corrupted metadata buffer:
>> ffffae6842564000: 16 49 77 8a 32 7e 72 52 14 bb 51 98 7c a5 2c 9a
>> .Iw.2~rR..Q.|.,.
>> ffffae6842564010: dd 28 4d 94 88 03 2b 8c 99 33 67 ca 6a d5 aa c9
>> .(M...+..3g.j...
>> ffffae6842564020: f8 f8 78 c7 90 fc f5 af 7f 95 03 07 0e 0c 4a 37
>> ..x...........J7
>> ffffae6842564030: 7c f8 70 c7 09 14 c7 81 a5 a7 a7 cb a8 a8 28 b9
>> |.p...........(.
>> ffffae6842564040: 68 d1 a2 a0 73 f5 ae d5 73 94 23 3d 3d 5d 46 46
>> h...s...s.#--]FF
>> ffffae6842564050: 46 ca f9 f3 e7 3b 69 4c d3 94 6d db b6 75 14 3d
>> F....;iL..m..u.=
>> ffffae6842564060: 30 68 77 ec d8 e1 a4 d9 b7 6f 9f 0c 0b 0b 0b 32
>> )hw......o.....2
>> ffffae6842564070: 8e 9d 29 aa 03 4b 4c 4c 0c 52 66 29 a5 7c f4 d1
>> ..)..KLL.Rf).|..
>> XFS (dm-2): metadata I/O error in “xlog_recov_do..(read#2)” at daddr 0x1b32
>> error 117
> Ok, that doesn't contain inodes. It's not even recognisable
> as filesystem metadata at all.
>
>> ----------------------------------------------------------------------------
>>
>> My computer is an older CentOS 6 box (on my todo list to replace).  I have
>> an array of VirtualBox VMs.  All my data including VMs is in /home/brian
>> directory.  I run rsync to backup /home/brian directory to a USB drive.
>> Rsync treats the files of the VM just like any other file.  I noticed that
>> the VMs can get corrupted if I leave them running during back up with rsync
>> so I normally shut them down.  For this instance, I didn't shut down the VM
>> when I launched rsync.
>>
>> @Dave
>> Regarding your image file question, I don't believe the above is an image
>> file.  Rsync copies file by file.  And I can navigate to the USB like my
>> internal hdd.
>>
>> Regarding the freeze files system, no I did not freeze the guest.
>>
>> Regarding the older backups, I just have the rsync backup on a USB drive.
>> I've been working with a copy from the USB to try at get this machine back,
>> thus the unmodified USB rsync that was taken while the machine was running
>> exists.
>>
>> While rsync was running, I had Selenium running web app tests in Chrome.
>> All the data from my program was being written to a shared folder.  Chrome
>> has it's own internal cache that could be changing but overall, I wouldn't
>> expect the file system to be changing too much especially the booting part.
> Log recovery covers anything that changed in the filesystem - it has
> nothing to do with what is being accessed by boot operations.
>
>> My ultimate goal is to get to the data on this VM.  I've tried to mount this
>> .vdi file in another instance of CentOS but have not been successful.  I may
>> spin up an Ubuntu instance to try to get to the data.  The data on this VM
>> can be recreated but I prefer not to have to redo the work.
> 'mount -o ro,norecovery <dev>' will allow you to skip log recovery
> and hopefully let you navigate the filesystem. It will not be error
> free, though, because log recovery is needed for that to occur.
>
> If the filesystem looks mostly intact, copy all the data off it you
> can. Then unmount it is and run xfs_repair -L <dev> on it to blow
> away the log and repair any corruption found. This will cause data
> loss, so don't do this unless you are prepared for it of have a
> complete copy of the broken filesystem.
>
> I'd highly recommend doing this with a recent xfs_repair, not the
> tools that came with CentOS 6.
>
> You could also do dry-run testing by taking a metadump of the broken
> filesystem and restoring that to an image file and running reapir on
> that image file. That will at least tell you how much of the
> directory structure will be trashed and wht you'll be able to access
> after repair.
>
> It may be that mounting w/ norecovery is your best bet of recovering
> the contents of the bad filesystems, so do that first...
>
> Cheers,
>
> Dave.

