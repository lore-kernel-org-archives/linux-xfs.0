Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34076 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750966AbdECMmD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 May 2017 08:42:03 -0400
MIME-Version: 1.0
In-Reply-To: <1493809233.30052.1.camel@linux.intel.com>
References: <1493756363-5113-1-git-send-email-amir73il@gmail.com>
 <1493802823.4154.3.camel@linux.intel.com> <CAOQ4uxh4Ysg9Q_K2sK9zefvid3hvzswDKxSa-QTN9_D0fAWvyQ@mail.gmail.com>
 <1493809233.30052.1.camel@linux.intel.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 3 May 2017 15:42:02 +0300
Message-ID: <CAOQ4uxj3ppxm4LC6xr54n6GUF1T=yhQ4-5YJfbjXcBJugVENZQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] linux/uuid.h: hoist uuid_is_null() helper from libnvdimm
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Christoph Hellwig <hch@lst.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Richard Weinberger <richard@nod.at>, "Darrick J . Wong" <darrick.wong@oracle.com>, Mark Fasheh <mfasheh@versity.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs <linux-xfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Theodore Tso <tytso@mit.edu>

On Wed, May 3, 2017 at 2:00 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Wed, 2017-05-03 at 13:05 +0300, Amir Goldstein wrote:
>> On Wed, May 3, 2017 at 12:13 PM, Andy Shevchenko
[...]

>> I can hear the voices of
>> those saying that there should be a 'natural' helper uuid_is_null(u8
>> *) for the
>> users that represent uuid as u8[16] (i.e. filesystems and sb->s_uuid).
>
> u8 * doesn't represent UUID as a type.
> Perhaps we need to reflect this in the name of the function somehow.
>

OK, since you have no time nor the intention to convert filesystem code
to use uuid_le (not should you), I see 2 options for filesystems/VFS:

1. Use the simple u8* libnvdimm helper proposed by this patch
2. Hoist uuid_t + helpers from fs/xfs/uuid.* to linux/uuid.h lib/uuid.c

If option #2 is preferred, I think we should conform to libuuid's helper
name uuid_is_null() (instead of freebsd's uuid_is_nil()) and maybe
convert libnvdimm and bluetooth to use the xfs helpers as well.

Christoph,

Since you got me started on this helper, do you have a preference?

Amir.
