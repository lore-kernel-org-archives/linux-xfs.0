Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D6DC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Sep 2021 19:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47FE460ED8
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Sep 2021 19:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237476AbhIITM7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Sep 2021 15:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbhIITM6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Sep 2021 15:12:58 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0DAEC061574
        for <linux-xfs@vger.kernel.org>; Thu,  9 Sep 2021 12:11:48 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id s15so2406082qta.10
        for <linux-xfs@vger.kernel.org>; Thu, 09 Sep 2021 12:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=yakkadesign-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=AUy2UzrS+f6svz6OeT3EBsrf/7+7ZA6qESc+GYZAFf8=;
        b=pXY59L4maXiOjSTCsrPT2wp3cmy8IEVdPsqZuW3YNFGUAxTzeKdbOaZwuoVYQAyOsn
         fi8+7fXeCMOrmsY4pUaGLRkrXQRvWz+03AZrNyUUp8rel1b88E+2rjy2WhqODuZ6FN1I
         leu9xlFYIH0Yi6ftlvTs+r1OvNJLD/9wIUljG/pox+IwzXHb78Uw5wVXpYQFaLsML6xE
         6nn6eAxHJ8Ovo1uE2m9QzPD+Lz+69hw34zLvprrUyyxIMi+XYFo0eXSjUVPQ9YHQPJaM
         kZ1Wpxah9xbit/wmDRCisUNhwPVK5l8oBh3ynKNJVQTSaGUCS0iuGsxopeU+3X/E12pT
         1Osw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=AUy2UzrS+f6svz6OeT3EBsrf/7+7ZA6qESc+GYZAFf8=;
        b=7OdCtlAHjYYtXgn7rOYrrXXG1/+vLh9zwA12V2ouXP0q2HUm1rekVVIYizfY3Obi8a
         lW/RiMmD1ZNb8z1OeiQ4kqrqeEjt/lm7GqIovdYJ09sqHfQCB2p69EdYnONwY0CWchrL
         UIwDTFUmMsRgTLuqrAWISJeAjfFC/bnMDKO1B2JQNaPW2YeUR0FHLv3XkuHewvhJT8FE
         mn83lcvLiiFSYvP2u7Hg6b9JPlyt7t6vbTmSb97nhkETy4Tu4gkkACT4pn+RGXZxblBU
         w57tGkplF8PI5i/xt1S4VClVuAGubq8QniCzht25+9/lubObMQbph+lKD65sCyttbdwe
         nb0A==
X-Gm-Message-State: AOAM532pXx4DRSNr7WWSPz4M4H1+wVLhWYoLV5XYKMH9zv++vxV8pU8s
        bv3hl9a2AH63MU1gwrwMhuSNlRO498X/aWod
X-Google-Smtp-Source: ABdhPJxsNiSHUDiLYirW0zbHjMOZe7hpyfFR75IefxR5D4V2VVRxIcLmG9ofq8lvfNM4dj0d7w0VEg==
X-Received: by 2002:ac8:40d6:: with SMTP id f22mr4521045qtm.345.1631214707608;
        Thu, 09 Sep 2021 12:11:47 -0700 (PDT)
Received: from [192.168.1.187] (107-197-126-53.lightspeed.gnvlsc.sbcglobal.net. [107.197.126.53])
        by smtp.googlemail.com with ESMTPSA id l126sm1972295qke.96.2021.09.09.12.11.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Sep 2021 12:11:47 -0700 (PDT)
Subject: Re: Repair Metadata corruption detected at xfs_inode_buf_verify on
 CentOS 7 virtual machine
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <055dbf6e-a9b5-08a1-43bc-59f93e77f67d@yakkadesign.com>
 <20210908213924.GB2361455@dread.disaster.area>
 <987fa28b-4928-8557-0f09-73839790e910@yakkadesign.com>
 <20210909025445.GC2361455@dread.disaster.area>
From:   brian <a001@yakkadesign.com>
Message-ID: <8a959313-b7ab-5434-7c8f-1cf8990ecb4d@yakkadesign.com>
Date:   Thu, 9 Sep 2021 15:11:45 -0400
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

I switched over to ubuntu and got the error "Device or resource busy".  
How do I get around this error?

Here is what I did:
---------------------------------------------------------
sudo apt-get install qemu
sudo apt install qemu-utils
sudo apt-get install xfsprogs

sudo modprobe nbd max_part=8

sudo qemu-nbd --connect=/dev/nbd0 
/media/sf_virtual_machine_share/centoOS7Python3p9_tmp-disk1.vdi

sudo xfs_repair /dev/nbd0p2
---------------------------------------------------------

I got the error:
---------------------------------------------------------
xfs_repair: cannot open /dev/nbd0p2: Device or resource busy
---------------------------------------------------------



When I tried xfs_repair with the -n flag:
---------------------------------------------------------
sudo xfs_repair -n /dev/nbd0p2
---------------------------------------------------------

I got (I replaced some content with ...  Most of the content was ...):
---------------------------------------------------------
Phase 1 - find and verify superblock...
bad primary superblock - bad magic number !!!
...
attempting to find secondary superblock...
Sorry, could not find valid secondary superblock
---------------------------------------------------------





Here are some things I ran while trying to debug.
cmd:
---------------------------------------------------------
sudo partprobe /dev/nbd0p2
---------------------------------------------------------

Result:
---------------------------------------------------------
Error: Partition(s) 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 
16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 
34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 
52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64 on /dev/nbd0p2 have 
been written, but we have been unable to inform the kernel of the 
change, probably because it/they are in use.  As a result, the old 
partition(s) will remain in use. You should reboot now before making 
further changes.
---------------------------------------------------------


cmd:
---------------------------------------------------------
sudo fdisk -l /dev/nbd0p2
---------------------------------------------------------

Result:
---------------------------------------------------------
Disk /dev/nbd0p2: 101.72 GiB, 109207093248 bytes, 213295104 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
brian@brian-VirtualBox:~/Desktop$ sudo lvmdiskscan
   /dev/loop0  [     219.00 MiB]
   /dev/loop1  [     <55.44 MiB]
   /dev/sda1   [     512.00 MiB]
   /dev/nbd0p1 [       1.00 GiB]
   /dev/loop2  [     <65.10 MiB]
   /dev/nbd0p2 [    <101.71 GiB] LVM physical volume
   /dev/loop3  [     <50.96 MiB]
   /dev/loop4  [     <32.30 MiB]
   /dev/loop5  [      32.30 MiB]
   /dev/sda5   [      <2.00 TiB]
   0 disks
   9 partitions
   0 LVM physical volume whole disks
   1 LVM physical volume
---------------------------------------------------------




cmd:
---------------------------------------------------------
sudo lvscan
---------------------------------------------------------

Result:
---------------------------------------------------------
   ACTIVE            '/dev/centos/swap' [2.00 GiB] inherit
   ACTIVE            '/dev/centos/home' [<49.70 GiB] inherit
   ACTIVE            '/dev/centos/root' [50.00 GiB] inherit
---------------------------------------------------------


cmd:
---------------------------------------------------------
sudo lvm pvscan
---------------------------------------------------------

Result:
---------------------------------------------------------
   PV /dev/nbd0p2   VG centos          lvm2 [101.70 GiB / 4.00 MiB free]
   Total: 1 [101.70 GiB] / in use: 1 [101.70 GiB] / in no VG: 0 [0   ]
---------------------------------------------------------


cmd:
---------------------------------------------------------
sudo lvm lvs
---------------------------------------------------------

result:
---------------------------------------------------------
   LV   VG     Attr       LSize   Pool Origin Data%  Meta%  Move Log 
Cpy%Sync Convert
   home centos -wi-a----- <49.70g
   root centos -wi-a----- 50.00g
   swap centos -wi-a-----   2.00g
---------------------------------------------------------


cmd:
---------------------------------------------------------
sudo e2fsck /dev/nbd0p2
---------------------------------------------------------

result:
---------------------------------------------------------
e2fsck 1.45.5 (07-Jan-2020)
/dev/nbd0p2 is in use.
e2fsck: Cannot continue, aborting.
---------------------------------------------------------


cmd:
---------------------------------------------------------
fsck -N /dev/nbd0p2
---------------------------------------------------------

result:
---------------------------------------------------------
fsck from util-linux 2.34
[/usr/sbin/fsck.ext2 (1) -- /dev/nbd0p2] fsck.ext2 /dev/nbd0p2
---------------------------------------------------------


cmd:
---------------------------------------------------------
sudo stat -f /dev/nbd0p2
---------------------------------------------------------

result:
---------------------------------------------------------
   File: "/dev/nbd0p2"
     ID: 0        Namelen: 255     Type: tmpfs
Block size: 4096       Fundamental block size: 4096
Blocks: Total: 495622     Free: 495622     Available: 495622
Inodes: Total: 495622     Free: 495101
---------------------------------------------------------





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

