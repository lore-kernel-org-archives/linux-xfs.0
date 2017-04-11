Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:37851 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751514AbdDKMDQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2017 08:03:16 -0400
Received: by mail-wm0-f42.google.com with SMTP id u2so59220899wmu.0
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2017 05:03:16 -0700 (PDT)
Subject: Re: filesystem dead, xfs_repair won't help
References: <CAF950WLvp7SWnDHU_AY+j3CYtCDWYLdN=AkNZgNB2yU3sVxsJQ@mail.gmail.com>
 <612a9d5a-9877-405c-ef7c-dc9632a1d8bc@scylladb.com>
 <20170410153529.GE3991@bfoster.bfoster>
 <974df72a-04fe-fba4-4b48-89426b8783e0@scylladb.com>
 <20170411133033.65c89ee8@harpe.intellique.com>
 <13452866-4e5e-371c-269b-cee60e0c6b59@scylladb.com>
 <20170411140007.05af2bcd@harpe.intellique.com>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <9d2587d5-e1f1-e5bb-d276-bc6731b2fce8@scylladb.com>
Date: Tue, 11 Apr 2017 15:03:12 +0300
MIME-Version: 1.0
In-Reply-To: <20170411140007.05af2bcd@harpe.intellique.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org



On 04/11/2017 03:00 PM, Emmanuel Florac wrote:
> Le Tue, 11 Apr 2017 14:40:15 +0300
> Avi Kivity <avi@scylladb.com> écrivait:
>
>> $ sudo xfs_db -c "sb 0" /tmp/fs
>> xfs_db: /tmp/fs is not a valid XFS filesystem (unexpected SB magic
>> number 0x5846534d)
>> Use -F to force a read attempt.
>> $ sudo xfs_db -F -c "sb 0" /tmp/fs
>> xfs_db: /tmp/fs is not a valid XFS filesystem (unexpected SB magic
>> number 0x5846534d)
>> xfs_db: V1 inodes unsupported. Please try an older xfsprogs.
> Oops, I forgot one important part, sorry, you must restore the
> meta_dump to a file first:
>
> xfs_mdrestore /tmp/fs /tmp/fsimage
>
> then run xfs_db on the /tmp/fsimage:
>
> xfs_db -c 'sb 0' -c 'p' /tmp/fsimage
>

magicnum = 0x58465342
blocksize = 4096
dblocks = 125026902
rblocks = 0
rextents = 0
uuid = 50b25ad8-3eb9-4273-b7f2-d0a435b3a08f
logstart = 67108869
rootino = 96
rbmino = 97
rsumino = 98
rextsize = 1
agblocks = 31256726
agcount = 4
rbmblocks = 0
logblocks = 61048
versionnum = 0xb4b5
sectsize = 512
inodesize = 512
inopblock = 8
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 9
inopblog = 3
agblklog = 25
rextslog = 0
inprogress = 0
imax_pct = 25
icount = 1959744
ifree = 89
fdblocks = 91586587
frextents = 0
uquotino = null
gquotino = null
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 4
unit = 0
width = 0
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 1
features2 = 0x18a
bad_features2 = 0x18a
features_compat = 0
features_ro_compat = 0x1
features_incompat = 0x1
features_log_incompat = 0
crc = 0x3ebf41de (correct)
spino_align = 0
pquotino = null
lsn = 0x70002828b
meta_uuid = 00000000-0000-0000-0000-000000000000


