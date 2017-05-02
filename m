Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:33050 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbdEBRJu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2017 13:09:50 -0400
MIME-Version: 1.0
In-Reply-To: <20170502144730.GA22578@lst.de>
References: <1493388001-15879-1-git-send-email-amir73il@gmail.com>
 <20170502073019.GD11582@lst.de> <CAOQ4uxjKbgCwhV4iBNVyfmS5+iR3o1BPF+PDj7YmrPP-qTv1eA@mail.gmail.com>
 <20170502141751.GA21564@lst.de> <CAOQ4uxgO64HhFq-xYOY4r1ob_qH1BQbkHyzBSpwmv0WPxX7A1Q@mail.gmail.com>
 <20170502144730.GA22578@lst.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 2 May 2017 20:09:48 +0300
Message-ID: <CAOQ4uxj3Ug0O-qzUGFyr_DotMftiTqwXsUe7V341bHtfhVHX3g@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: publish UUID in struct super_block
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs <linux-xfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Mark Fasheh <mfasheh@versity.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>

On Tue, May 2, 2017 at 5:47 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Tue, May 02, 2017 at 05:27:36PM +0300, Amir Goldstein wrote:
>> On Tue, May 2, 2017 at 5:17 PM, Christoph Hellwig <hch@lst.de> wrote:
>> > On Tue, May 02, 2017 at 05:13:56PM +0300, Amir Goldstein wrote:
>> >> How can it create problems if uniqueness is not guaranteed with
>> >> Current s_uuid? Even if we did make the xfs uuid table code generic
>> >> It couldn't be the vfs default. Filesystems will have to opt in.
>> >
>> > It creates problems if you e.g. mount an ext4 fs and a dm snaphot of
>> > it.  The non-XFS file systems are simply buggy in this regard.
>> >
>> > Non-uniqueue uuids are an absolute no-go.
>>
>> I'm not sure I follow your specific concern here.
>> Surely you are not proposing to get rid of the nouuid
>> mount option, are you? So what's the point of hiding
>> the fact that there are 2 mounted filesystems with the
>> same uuid from VFS?
>
> Because it breaks people using s_uuid.

Christoph,

I do agree with you that that situation where s_uuid is unique on a system
is preferred over what we have today. I disagree that not respecting
uniqueness that was not respected until now has the potential to
break any user.

New users that require uniqueness from s_uuid, those are the ones that
should be checking for the not yet existing flag SB_I_AM_UNIQUE.
Old users cannot claim that uniqueness has been broken.
Whether or not there are users that need to check SB_I_AM_UNIQUE
and whether or not we need to hoist the xfs unique uuid implementation
to VFS remains to be seen.

> Take a look at cleancache,
> which identifies a pool with it.  Once you have to snapshot with
> the same uuid the pool concept is broken.  Same for any sort of
> use in file handles.
>

I am not sure that cleancache is a good example for your argument.
s_uuid is needed for the cleancache_init_shared_fs() case, only used by
ocfs2 in-tree fs. From what I can gather from cleancache documentation,
this is meant for a use case where 2 different VMs use the same shared
pool. If I understood correctly, then making s_uuid unique on a single
system is not good enough for this use case anyway.

> The U in UUID stands for unique, and we must ensure that's actually
> true.

Maybe we should re-interpret the U of Universal as Utopic ;-)

>
>>
>> Because that is the the only implication of exporting
>> s_uuid regardless of nouuid mount option.
>>
>> Whether or not ext4 and other fs should restrict
>> multi mount of same uuid is a completely different
>> issue.
>
> It's not.  The whole point of exporting s_uuid is to have a uniqueue
> identifier for a superblock.  If it's not actually uniqueue there is
> no point in having or using it.

Well it's useful for my use case. I need s_uuid as a sanity check
and IIUC, so does cleancache.
I don't know about EVM/IMA, but apparently, it did well
with pseudo uniqueness so far.

Cheers,
Amir.
