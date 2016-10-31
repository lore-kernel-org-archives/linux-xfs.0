Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:37857 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S945887AbcJaUVE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Oct 2016 16:21:04 -0400
Received: by mail-wm0-f47.google.com with SMTP id t79so71839902wmt.0
        for <linux-xfs@vger.kernel.org>; Mon, 31 Oct 2016 13:21:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161031194212.GU14023@dastard>
References: <CAPvv1vytjK-n7Z3=Zi+vScuV-ej3CagQ5rFc9ppVC8JEihZPkQ@mail.gmail.com>
 <8bd7b65f-d85d-2958-dd7d-ba97c91ac9ea@telefonica.net> <CAPvv1vx-Juge8e=36bq4AFvGxs8Kf7-V_v0j+a9LGWYdDo5h+w@mail.gmail.com>
 <20161031194212.GU14023@dastard>
From: "Steffen D." <sdumke@gmail.com>
Date: Mon, 31 Oct 2016 21:20:56 +0100
Message-ID: <CAPvv1vzDQO9iMNhXByGfXrbLEtMt=F1xFd1Ybr63AAuPfvA6iw@mail.gmail.com>
Subject: Re: Fwd: mounting a xfs file system gives the message: "failure code
 -3003" and "structure needs cleaning"
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Hi Dave,

2016-10-31 20:42 GMT+01:00 Dave Chinner <david@fromorbit.com>:
> On Mon, Oct 31, 2016 at 08:29:37PM +0100, Steffen D. wrote:
>> Hello again
>> thanks to Carlos for the hint about the language.
>> Here are the messages in english:
>> ----------
>> linux-ibbi:/home/steffen # LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
>> ...
>
> hmmm - AGFL sizing issue?
>
> What is the error in dmesg when you try to mount the filesystem?

----------
[46389.083808] XFS (sda4): Mounting V5 Filesystem
[46389.193790] XFS (sda4): Starting recovery (logdev: internal)
[46390.697811] XFS (sda4): Metadata corruption detected at
xfs_agf_read_verify+0x5a/0x100 [xfs], block 0x1a1d6001
[46390.697814] XFS (sda4): Unmount and run xfs_repair
[46390.697815] XFS (sda4): First 64 bytes of corrupted metadata buffer:
[46390.697817] ffff880213e2d600: 58 41 47 46 00 00 00 01 00 00 00 02
01 a1 d6 00  XAGF............
[46390.697818] ffff880213e2d610: 00 72 fb d6 00 73 ee 3e 00 00 00 00
00 00 00 02  .r...s.>........
[46390.697819] ffff880213e2d620: 00 00 00 02 00 00 00 00 00 00 00 76
00 00 00 06  ...........v....
[46390.697820] ffff880213e2d630: 00 00 00 07 00 83 6d 93 00 28 47 02
00 00 00 29  ......m..(G....)
[46390.697853] XFS (sda4): metadata I/O error: block 0x1a1d6001
("xfs_trans_read_buf_map") error 117 numblks 1
----------

> What hardware are you running on (cpu, ram, etc) and

Intel i5-4460 4 x 3.20 GHz
8 GB Ram
HDD:
sda: SCSI-SATA ST500DM002-1BD14
sdd: Sandisk SDSSDP128G
Linux OpenSuse 42.1



> where/how was
> this filesystem created? Did it come from another machine?

Was created while installing the previous system (OpenSuse 13.2)

The problem starts after a system crash while I was copying some files.

>
> xfs_reapir -L should fix it, but I'd like to understand what the
> problem was first and how it happened....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Signatur ausser Betrieb.
