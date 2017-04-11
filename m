Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:32823 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753696AbdDKLkT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2017 07:40:19 -0400
Received: by mail-wr0-f179.google.com with SMTP id l28so37463326wre.0
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2017 04:40:18 -0700 (PDT)
Subject: Re: filesystem dead, xfs_repair won't help
References: <CAF950WLvp7SWnDHU_AY+j3CYtCDWYLdN=AkNZgNB2yU3sVxsJQ@mail.gmail.com>
 <612a9d5a-9877-405c-ef7c-dc9632a1d8bc@scylladb.com>
 <20170410153529.GE3991@bfoster.bfoster>
 <974df72a-04fe-fba4-4b48-89426b8783e0@scylladb.com>
 <20170411133033.65c89ee8@harpe.intellique.com>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <13452866-4e5e-371c-269b-cee60e0c6b59@scylladb.com>
Date: Tue, 11 Apr 2017 14:40:15 +0300
MIME-Version: 1.0
In-Reply-To: <20170411133033.65c89ee8@harpe.intellique.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org



On 04/11/2017 02:30 PM, Emmanuel Florac wrote:
> Le Tue, 11 Apr 2017 10:46:07 +0300
> Avi Kivity <avi@scylladb.com> écrivait:
>
>> $ sudo xfs_repair /dev/nvme0n1
>> Phase 1 - find and verify superblock...
>> couldn't verify primary superblock - not enough secondary superblocks
>> with matching geometry !!!
> Which version of xfs_repair is this?

xfsprogs-4.9.0-1.fc25.x86_64

> Try to export the FS structure with xfs_metadump, something like
>
> xfs_metadump /dev/nvme0n1 /some/file.dmp
>
> And check the errors it reports, they may be informative.

bad magic number
xfs_metadump: cannot read superblock for ag 1
bad magic number
xfs_metadump: cannot read superblock for ag 2
Metadata CRC error detected at xfs_agfl block 0x1dcf0963/0x200
bad magic number
xfs_metadump: cannot read superblock for ag 3
Metadata CRC error detected at xfs_agfl block 0x2cb68e13/0x200
xfs_metadump: Filesystem log is dirty; image will contain unobfuscated 
metadata in log.
cache_purge: shake on cache 0x55accee162b0 left 3 nodes!?


> In the case where metadump works out fine, you should then try to have a
> look at the FS structure using the dump (to avoid wrecking it more that
> it already is):
>
> xfs_db -c "sb 0" /some/file.dmp
>

$ sudo xfs_db -c "sb 0" /tmp/fs
xfs_db: /tmp/fs is not a valid XFS filesystem (unexpected SB magic 
number 0x5846534d)
Use -F to force a read attempt.
$ sudo xfs_db -F -c "sb 0" /tmp/fs
xfs_db: /tmp/fs is not a valid XFS filesystem (unexpected SB magic 
number 0x5846534d)
xfs_db: V1 inodes unsupported. Please try an older xfsprogs.


