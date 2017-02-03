Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:35911 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752026AbdBCTu6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Feb 2017 14:50:58 -0500
Received: by mail-ot0-f194.google.com with SMTP id 36so3362980otx.3
        for <linux-xfs@vger.kernel.org>; Fri, 03 Feb 2017 11:50:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170203180826.GA31044@birch.djwong.org>
References: <20170203095715.7955-1-hch@lst.de> <20170203174541.GS9134@birch.djwong.org>
 <20170203180826.GA31044@birch.djwong.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 3 Feb 2017 21:50:57 +0200
Message-ID: <CAOQ4uxiH6iWNzPQtzhf3K+Ta1-PO-dHPX0MmuxSe8m_M_WZd=Q@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: update ctime and mtime on clone destinatation inodes
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Fri, Feb 3, 2017 at 8:08 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> On Fri, Feb 03, 2017 at 09:45:41AM -0800, Darrick J. Wong wrote:
>> [cc amir since he piped up about the v1 patch]
>>
>> On Fri, Feb 03, 2017 at 10:57:15AM +0100, Christoph Hellwig wrote:
>> > We're changing both metadata and data, so we need to update the
>> > timestamps for clone operations.  Dedupe on the other hand does
>> > not change file data, and only changes invisible metadata so the
>> > timestamps should not be updated.
>> >
>> > This follows existing btrfs behavior.
>> >
>> > Signed-off-by: Christoph Hellwig <hch@lst.de>
>> > ---
>> >  fs/xfs/xfs_reflink.c | 13 ++++++++++---
>> >  1 file changed, 10 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
>> > index d5a2cf2b469b..199ce0100bc6 100644
>> > --- a/fs/xfs/xfs_reflink.c
>> > +++ b/fs/xfs/xfs_reflink.c
>> > @@ -961,13 +961,15 @@ STATIC int
>> >  xfs_reflink_update_dest(
>> >     struct xfs_inode        *dest,
>> >     xfs_off_t               newlen,
>> > -   xfs_extlen_t            cowextsize)
>> > +   xfs_extlen_t            cowextsize,
>> > +   bool                    is_dedupe)
>> >  {
>> >     struct xfs_mount        *mp = dest->i_mount;
>> >     struct xfs_trans        *tp;
>> >     int                     error;
>> >
>> > -   if (newlen <= i_size_read(VFS_I(dest)) && cowextsize == 0)
>> > +   if (is_dedupe &&
>> > +       newlen <= i_size_read(VFS_I(dest)) && cowextsize == 0 && is_dedupe)
>> >             return 0;
>>
>> Redundant is_dedupe tests here.
>>
>> I also wonder if we really /want/ to emulate the existing btrfs
>> behavior, which seems to be:
>>
>> reflink: update mtime & ctime
>> dedupe: do not update mtime or ctime
>>
>> In particular, dedupe changes the inode metadata, which should qualify
>> for a ctime update, right?
>
> OTOH, /me fishes out the discussion between mfasheh & zygo where they
> discuss changing btrfs to avoid [cm]time updates on dedupe:
>
> https://patchwork.kernel.org/patch/6683161/
>
> So... <shrug> I'm willing to preserve the 'dedupe doesn't update
> timestamps' behavior even though we're definitely changing di_nextents
> (and possibly di_cowextsize).
>

I wasn't writing code, or talking at all, when ctime was conceived,
but I believe di_nextents and di_cowextsize are not what ctime
is about. To my understanding, because user can change mtime,
ctime keeps a more reliable record about last time inode "metadata"
was changed, where "metadata" is the rest of the records visible in stat().
Since dedup does not change any of that POSIX metadata -
no ctime change seems reasonable to me.

> (Though, you may note, I didn't write any code to update the timestamps
> in the original patches, so clearly I'm not all that passionate either
> way. :P)
>
