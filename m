Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:36013 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758306AbdEORsW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 May 2017 13:48:22 -0400
Received: by mail-oi0-f51.google.com with SMTP id h4so139814131oib.3
        for <linux-xfs@vger.kernel.org>; Mon, 15 May 2017 10:48:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170515154308.26739-9-hch@lst.de>
References: <20170515154308.26739-1-hch@lst.de> <20170515154308.26739-9-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 15 May 2017 10:48:21 -0700
Message-ID: <CAPcyv4hzosqta=KcAHs08MAMrzgEt0CbAHTZMZ9d+jh3ymeWFA@mail.gmail.com>
Subject: Re: [PATCH 08/17] uuid: hoist uuid_is_null() helper from libnvdimm
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Shaohua Li <shli@kernel.org>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Mon, May 15, 2017 at 8:42 AM, Christoph Hellwig <hch@lst.de> wrote:
> Hoist the libnvdimm helper as an inline helper to linux/uuid.h
> using an auxiliary const variable uuid_null in lib/uuid.c.
>
> [hch: also add the guid variant.  Both do the same but I'd like
> to keep casts to a minimum]
>
> The common helper uses the new abstract type uuid_t * instead of
> u8 *.
>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> [hch: added guid_is_null]
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Dan Williams <dan.j.williams@intel.com>
