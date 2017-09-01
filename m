Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:34269 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751725AbdIAKh3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2017 06:37:29 -0400
MIME-Version: 1.0
In-Reply-To: <20170901095222.GC24482@lst.de>
References: <1504100302-3297-1-git-send-email-amir73il@gmail.com>
 <20170831134722.GA6912@lst.de> <CAOQ4uxgrdijqVpFm+rZ4JE_ZY0A_CZdSPHQEb8S1_R_dyJYzSg@mail.gmail.com>
 <20170831163954.GH21939@bfoster.bfoster> <CAOQ4uxisPbcoNp8N8Y4yGdWDBfZ=PR7CgkKGbLGS6cbU6bx2rw@mail.gmail.com>
 <20170901095222.GC24482@lst.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 1 Sep 2017 13:37:28 +0300
Message-ID: <CAOQ4uxhgp82Oz-fTFNwRy3Yr-9xqVpwEFYQ82QqX7mze2sK0xQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix incorrect log_flushed on fsync
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <jbacik@fb.com>, "stable [v4.9]" <stable@vger.kernel.org>

On Fri, Sep 1, 2017 at 12:52 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Thu, Aug 31, 2017 at 10:20:19PM +0300, Amir Goldstein wrote:
>> > IIUC, basically we need to guarantee that a flush submits after
>> > file_write_and_wait() and completes before we return.
>>
>> Yeh. unless we check if file_write_and_wait() submitted anything
>> at all.
>
> Even if file_write_and_wait did not submit anything we need to
> make sure a flush was submitted and completed after entering
> xfs_file_fsync.  For one to deal with the case where we wrote
> back data from the flusher threads or the VM, and also for
> the direct I/O case.
>

Right.

>
> Btw, do you have any results for your simple catch?  I wonder
> how much of an issue it actually is in practice.

Well since the bug was demonstrated using crash simulator,
I have no idea how often one would run into this with actual power
failure, but does it really matter how often, if we *know* that it can
happen?

The sequence of bios that I illustrated in commit message is
what I saw regardless of the crash simulator, and that sequence
leaves a data block in the disk cache, with nothing that guaranties
a FLUSH afterwards. So for an unlucky subject, that gives a window
of data loss in case of power failure at least until the next time
a flusher thread runs. That could be seconds, no?

I am working on a variant of the flushseq you suggested using
log->l_last_sync_lsn that may be simple enough and not as painful
as turning off optimization for WANT_SYNC log buffer.

Amir.
