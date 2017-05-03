Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36790 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752713AbdECKFP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 May 2017 06:05:15 -0400
MIME-Version: 1.0
In-Reply-To: <1493802823.4154.3.camel@linux.intel.com>
References: <1493756363-5113-1-git-send-email-amir73il@gmail.com> <1493802823.4154.3.camel@linux.intel.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 3 May 2017 13:05:14 +0300
Message-ID: <CAOQ4uxh4Ysg9Q_K2sK9zefvid3hvzswDKxSa-QTN9_D0fAWvyQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] linux/uuid.h: hoist uuid_is_null() helper from libnvdimm
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Richard Weinberger <richard@nod.at>, "Darrick J . Wong" <darrick.wong@oracle.com>, Mark Fasheh <mfasheh@versity.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs <linux-xfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>

On Wed, May 3, 2017 at 12:13 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Tue, 2017-05-02 at 23:19 +0300, Amir Goldstein wrote:
>> We need a helper for VFS to check if struct super_block field s_uuid
>> was filled by the filesystem, before consumers can use it.
>>
>> The libnvdimm code already has a private helper to check if uuid is
>> null
>> and the helper name is not using a private namespace prefix, which
>> prevents us from using the same helper name as a common function.
>>
>
> Hmm...
> Have you checked my branch here:
> https://bitbucket.org/andy-shev/linux/branch/topic%2Fuuid
> ?
>

Hi Andy,

No I have not seen your patches. When do you plan to post them?

> Probably not.
> I have number of patches to make UUID API used kernel wide.
>

That looks nice, but I see you did not get to converting many other
users that represent uuid as u8[16], like libnvdimm, bluetooth,
various filesystems and users of sb->s_uuid (IMA).

> ...including helpers for null UUID check:
> https://bitbucket.org/andy-shev/linux/commits/79029ebe2c32830f82effc0f0b
> 62cce2b6eb7fdb?at=topic/uuid
>

I wouldn't mind using is_null_uuid_le(sb->s_uuid) myself and that is how
I implemented the test in my current patch set, but I can hear the voices of
those saying that there should be a 'natural' helper uuid_is_null(u8 *) for the
users that represent uuid as u8[16] (i.e. filesystems and sb->s_uuid).

Also, I suggest naming your helpers uuid_{le|be}_is_null() to maintain
the uuid_* naming convention with other helpers you added to uuid.h.

Cheers,
Amir.
