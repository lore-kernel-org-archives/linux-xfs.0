Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:34040 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751861AbdDKQoL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2017 12:44:11 -0400
Received: by mail-wr0-f176.google.com with SMTP id z109so1768980wrb.1
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2017 09:44:10 -0700 (PDT)
Subject: Re: filesystem dead, xfs_repair won't help
References: <CAF950WLvp7SWnDHU_AY+j3CYtCDWYLdN=AkNZgNB2yU3sVxsJQ@mail.gmail.com>
 <612a9d5a-9877-405c-ef7c-dc9632a1d8bc@scylladb.com>
 <20170410153529.GE3991@bfoster.bfoster>
 <974df72a-04fe-fba4-4b48-89426b8783e0@scylladb.com>
 <20170411133033.65c89ee8@harpe.intellique.com>
 <13452866-4e5e-371c-269b-cee60e0c6b59@scylladb.com>
 <20170411140007.05af2bcd@harpe.intellique.com>
 <9d2587d5-e1f1-e5bb-d276-bc6731b2fce8@scylladb.com>
 <20170411144906.39323b30@harpe.intellique.com>
 <68ab8fb6-1cfd-66de-d2f3-eab21796fb16@scylladb.com>
 <20170411181355.59c1ee1f@harpe.intellique.com>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <02304e07-022e-0191-e62b-734b59a818fb@scylladb.com>
Date: Tue, 11 Apr 2017 19:44:06 +0300
MIME-Version: 1.0
In-Reply-To: <20170411181355.59c1ee1f@harpe.intellique.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org



On 04/11/2017 07:13 PM, Emmanuel Florac wrote:
> Le Tue, 11 Apr 2017 16:07:56 +0300
> Avi Kivity <avi@scylladb.com> écrivait:
>
>> $ sudo xfs_db -c 'sb 0' -c 'check' /tmp/fsimage
>> ERROR: The filesystem has valuable metadata changes in a log which
>> needs to be replayed.  Mount the filesystem to replay the log, and
>> unmount it before re-running xfs_db.  If you are unable to mount the
>> filesystem, then use the xfs_repair -L option to destroy the log and
>> attempt a repair. Note that destroying the log may cause corruption
>> -- please attempt a mount of the filesystem before doing this.
>>
>>
>> xfs_repair did not recognize the superblock, and started hunting for
>> the second one, emitting dots in the process.  I stopped it, since it
>> failed on the live disk.
>>
> Can you mount the image, or does it fail immmediately because of the
> CRC error?
>

Fails immediately.

I'll probably format it with ext4, wait for the firmware update, and 
then reformat it with xfs.  Since the firmware bug was acknowledged, I 
don't know what we can gain from it.  My disk is mostly a git and imap 
mirror anyway, + a large ccache repository, + a throwaway database.
