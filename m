Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:35411 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755240AbdEDOAf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 May 2017 10:00:35 -0400
MIME-Version: 1.0
In-Reply-To: <20170504135913.GA17831@lst.de>
References: <1493904383-2187-1-git-send-email-amir73il@gmail.com>
 <1493904383-2187-3-git-send-email-amir73il@gmail.com> <20170504133417.GD17222@lst.de>
 <CAOQ4uxjxyEGZOAm2rCR+PcdFqfmJxgBBO7_SexPkPRy+0eePOA@mail.gmail.com> <20170504135913.GA17831@lst.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 4 May 2017 17:00:34 +0300
Message-ID: <CAOQ4uxh0_68r7Ycf877RGHhA9rfUJtyN=q4V2_FohvD1gmBAig@mail.gmail.com>
Subject: Re: [PATCH v2 2/8] xfs: re-define uuid_t as common struct uuid_v1
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Miklos Szeredi <miklos@szeredi.hu>, Theodore Tso <tytso@mit.edu>, Richard Weinberger <richard@nod.at>, Mark Fasheh <mfasheh@versity.com>, Dan Williams <dan.j.williams@intel.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs <linux-xfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, May 4, 2017 at 4:59 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Thu, May 04, 2017 at 04:57:51PM +0300, Amir Goldstein wrote:
>> I did consider defining uuid_t as uuid_be.
>> most of the patch set would have remained the same and
>> xfs_uuid_getnodeuniq() would use struct uuid_v1 explicitly
>> instead of implicitly.
>
> At least don't add new users of uuid_v1.  Moving that stuff into
> uuid.[ch] was a major mistake, and I wish review would have caught
> it back then.

Fine. I can keep xfs_uu_t for now.
It's not really a part of the effort to move the generic helpers to uuid.h.
