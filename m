Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:33601 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750888AbdEBSZU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2017 14:25:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxj3Ug0O-qzUGFyr_DotMftiTqwXsUe7V341bHtfhVHX3g@mail.gmail.com>
References: <1493388001-15879-1-git-send-email-amir73il@gmail.com>
 <20170502073019.GD11582@lst.de> <CAOQ4uxjKbgCwhV4iBNVyfmS5+iR3o1BPF+PDj7YmrPP-qTv1eA@mail.gmail.com>
 <20170502141751.GA21564@lst.de> <CAOQ4uxgO64HhFq-xYOY4r1ob_qH1BQbkHyzBSpwmv0WPxX7A1Q@mail.gmail.com>
 <20170502144730.GA22578@lst.de> <CAOQ4uxj3Ug0O-qzUGFyr_DotMftiTqwXsUe7V341bHtfhVHX3g@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 2 May 2017 21:25:18 +0300
Message-ID: <CAOQ4uxgkM7rsfQJVGiVmmKa20s=D4B+NkQjaNKmSV4F6Hq_V7A@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: publish UUID in struct super_block
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs <linux-xfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Mark Fasheh <mfasheh@versity.com>, Christoph Hellwig <hch@lst.de>, Richard Weinberger <richard.weinberger@gmail.com>

On Tue, May 2, 2017 at 8:09 PM, Amir Goldstein <amir73il@gmail.com> wrote:
...
>>> > Non-uniqueue uuids are an absolute no-go.
>>>
>>> I'm not sure I follow your specific concern here.
>>> Surely you are not proposing to get rid of the nouuid
>>> mount option, are you? So what's the point of hiding
>>> the fact that there are 2 mounted filesystems with the
>>> same uuid from VFS?
>>
>> Because it breaks people using s_uuid.
...

>>
>> It's not.  The whole point of exporting s_uuid is to have a uniqueue
>> identifier for a superblock.  If it's not actually uniqueue there is
>> no point in having or using it.
>
> Well it's useful for my use case. I need s_uuid as a sanity check
> and IIUC, so does cleancache.
> I don't know about EVM/IMA, but apparently, it did well
> with pseudo uniqueness so far.
>

Mimi,

Can you please comment on the implication of starting to publish
sb->s_uuid by xfs on EVM/IMA.

Are there any persistent integrity signatures that could be broken,
because an xfs filesystem once published zeroes for sb->s_uuid
and will start to publish non-zero sb->s_uuid?

BTW, the same question applies w.r.t ubifs, which are also going to
start publishing sb->s_uuid, although I don't if there are ubifs+evm users.

Thanks,
Amir.
