Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:36695 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755171AbdEDN5x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 May 2017 09:57:53 -0400
MIME-Version: 1.0
In-Reply-To: <20170504133417.GD17222@lst.de>
References: <1493904383-2187-1-git-send-email-amir73il@gmail.com>
 <1493904383-2187-3-git-send-email-amir73il@gmail.com> <20170504133417.GD17222@lst.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 4 May 2017 16:57:51 +0300
Message-ID: <CAOQ4uxjxyEGZOAm2rCR+PcdFqfmJxgBBO7_SexPkPRy+0eePOA@mail.gmail.com>
Subject: Re: [PATCH v2 2/8] xfs: re-define uuid_t as common struct uuid_v1
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Miklos Szeredi <miklos@szeredi.hu>, Theodore Tso <tytso@mit.edu>, Richard Weinberger <richard@nod.at>, Mark Fasheh <mfasheh@versity.com>, Dan Williams <dan.j.williams@intel.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs <linux-xfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, May 4, 2017 at 4:34 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Thu, May 04, 2017 at 04:26:17PM +0300, Amir Goldstein wrote:
>> xfs was defining a non namespaced type named uuid_t and for no good
>> reason. xfs code doesn't care about the internals of uuid_t struct -
>> it only cares about its size.
>>
>> Re-define uuid_t as the common struct uuid_v1 in include/linux/uuid.h
>> and get rid of the xfs private definition.
>
> I'm not sure this really is a good idea.  uuid_v1 currently is only
> used by afs.  I'd much rather switch both afs and xfs to use the
> uuid_be type (which might as well grow the standard uuid_t name while
> we're at it), and use accessors that do the byte-array access for
> the very few places that care about the interpretation.
>

I did consider defining uuid_t as uuid_be.
most of the patch set would have remained the same and
xfs_uuid_getnodeuniq() would use struct uuid_v1 explicitly
instead of implicitly.

Bare in mind that we do need to make small steps, so
I wouldn't mix killing uuid_v1 and actors with this review.

Amir.
