Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41088 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751273AbdDKQsU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 12:48:20 -0400
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
 <02304e07-022e-0191-e62b-734b59a818fb@scylladb.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <25551c0a-90e1-0b2a-ad8d-2b1e814b3b0a@sandeen.net>
Date: Tue, 11 Apr 2017 11:48:19 -0500
MIME-Version: 1.0
In-Reply-To: <02304e07-022e-0191-e62b-734b59a818fb@scylladb.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>, Emmanuel Florac <eflorac@intellique.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org



On 4/11/17 11:44 AM, Avi Kivity wrote:
> 
> 
> On 04/11/2017 07:13 PM, Emmanuel Florac wrote:
>> Le Tue, 11 Apr 2017 16:07:56 +0300
>> Avi Kivity <avi@scylladb.com> écrivait:
>>
>>> $ sudo xfs_db -c 'sb 0' -c 'check' /tmp/fsimage
>>> ERROR: The filesystem has valuable metadata changes in a log which
>>> needs to be replayed.  Mount the filesystem to replay the log, and
>>> unmount it before re-running xfs_db.  If you are unable to mount the
>>> filesystem, then use the xfs_repair -L option to destroy the log and
>>> attempt a repair. Note that destroying the log may cause corruption
>>> -- please attempt a mount of the filesystem before doing this.
>>>
>>>
>>> xfs_repair did not recognize the superblock, and started hunting for
>>> the second one, emitting dots in the process.  I stopped it, since it
>>> failed on the live disk.
>>>
>> Can you mount the image, or does it fail immmediately because of the
>> CRC error?
>>
> 
> Fails immediately.
> 
> I'll probably format it with ext4, wait for the firmware update, and
> then reformat it with xfs. Since the firmware bug was acknowledged, I
> don't know what we can gain from it. My disk is mostly a git and imap
> mirror anyway, + a large ccache repository, + a throwaway database.

Honestly, I'd be a little leary of ext4 too - I don't know what the underlying
problem is, but it must be related to some IO pattern that is more common
on xfs, but it's a leap to say that it's never present on any other fs...

IOWS: a drive firmware bug that corrupts data probably can't be trusted
with any filesystem.

As an experiment, though, if you want to play, it might be interesting to
mkfs.xfs it with a 4096 byte sector size, and see if that makes it happier.
By default, xfs is doing metadata IO in 512 chunks, something other filesystems
won't do by default.

I guess you don't know how to provoke the corruption, though, to be able
to run that test reliably...

-Eric
