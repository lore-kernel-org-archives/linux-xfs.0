Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:32852 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751618AbdECSey (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 May 2017 14:34:54 -0400
MIME-Version: 1.0
In-Reply-To: <1493831747.30052.10.camel@linux.intel.com>
References: <1493756363-5113-1-git-send-email-amir73il@gmail.com>
 <1493802823.4154.3.camel@linux.intel.com> <CAOQ4uxh4Ysg9Q_K2sK9zefvid3hvzswDKxSa-QTN9_D0fAWvyQ@mail.gmail.com>
 <1493809233.30052.1.camel@linux.intel.com> <CAOQ4uxj3ppxm4LC6xr54n6GUF1T=yhQ4-5YJfbjXcBJugVENZQ@mail.gmail.com>
 <1493829352.30052.6.camel@linux.intel.com> <1493831747.30052.10.camel@linux.intel.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 3 May 2017 21:34:51 +0300
Message-ID: <CAOQ4uxg6=X8GVfWBBYwYLHyNcx7E856kEFM339abLsVEbWzi_Q@mail.gmail.com>
Subject: Re: [RFC][PATCH] linux/uuid.h: hoist uuid_is_null() helper from libnvdimm
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Richard Weinberger <richard@nod.at>, "Darrick J . Wong" <darrick.wong@oracle.com>, Mark Fasheh <mfasheh@versity.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs <linux-xfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Theodore Tso <tytso@mit.edu>

On Wed, May 3, 2017 at 8:15 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:

>
> By the way, notice that uuid_v1 type (which had been moved to uuid.h
> already) is the same what xfs uses as uuid_t.
>
> So, helpers against it we can prefix with uuid_v1_[foo_bar()].
>

I really don't see why we can't use the exact same helpers
found in fs/xfs/uuid.c and uuid_t as well for that matter.

They are mostly similar to the libuuid API that filesystems
tools use in userspace and they don't collide with your
uuid_{le|be} helpers.
