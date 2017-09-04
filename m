Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:36251 "EHLO
        mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751949AbdIDHbN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Sep 2017 03:31:13 -0400
MIME-Version: 1.0
In-Reply-To: <20170903210427.GJ4073@magnolia>
References: <1504451271-29202-1-git-send-email-amir73il@gmail.com>
 <20170903174513.GI4073@magnolia> <20170903182133.GA1757@lst.de> <20170903210427.GJ4073@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 4 Sep 2017 10:31:11 +0300
Message-ID: <CAOQ4uxhUqKnphuLDTpx7UWJJg6A++D6xCMqe1P0YtRtX36ARxw@mail.gmail.com>
Subject: Re: [RFC][PATCH] fstests: regression test for xfs leftover CoW extent error
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Sep 4, 2017 at 12:04 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Sun, Sep 03, 2017 at 08:21:33PM +0200, Christoph Hellwig wrote:
>> > So basically there are two bugs here -- the fcollapse/finsert code needs
>> > to shift the CoW fork extents down and up;
>>
>> Or make sure that we don't have any extents in the COW fork?
>
> It's a big hammer approach, but yes that'd work.
>
> We're already forcing all the dirty pages out anyway so I guess it's no
> big deal.
>
>> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> > index 9207d61..ae3b18f 100644
>> > --- a/fs/xfs/xfs_inode.c
>> > +++ b/fs/xfs/xfs_inode.c
>> > @@ -1625,7 +1625,7 @@ xfs_itruncate_extents(
>> >         /*
>> >          * Clear the reflink flag if we truncated everything.
>> >          */
>> > -       if (ip->i_d.di_nblocks == 0 && xfs_is_reflink_inode(ip)) {
>> > +       if (ip->i_d.di_nblocks == 0 && ip->i_cnextents == 0 && xfs_is_reflink_inode(ip)) {
>>
>> Btw, it seems like we should generally clear the reflink flag and
>> tag if ip->i_cnextents is zero and not even bother looking at di_nblocks.
>
> We can't -- imagine shortening to 8k a reflinked 12k file that hasn't been
> written to.  It has no cow extents, but we cannot drop the reflink flag.
>

This change fixes the reported error.
I will re-post the test once there is a commit that explains the problem,
unless one of you guys wants to re-post the test and make it less brain dead
that's also fine with me.

Thanks,
Amir.
