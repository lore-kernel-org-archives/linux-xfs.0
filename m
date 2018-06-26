Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:44196 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933795AbeFZSwu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jun 2018 14:52:50 -0400
Received: by mail-oi0-f66.google.com with SMTP id b5-v6so7868679oiy.11
        for <linux-xfs@vger.kernel.org>; Tue, 26 Jun 2018 11:52:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180626175932.8899-2-ross.zwisler@linux.intel.com>
References: <20180626175932.8899-1-ross.zwisler@linux.intel.com> <20180626175932.8899-2-ross.zwisler@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Jun 2018 11:52:49 -0700
Message-ID: <CAPcyv4iWgPnHmBKhUvhManC6UL9CkLqN_d8vBo6KmcPJdPzuUw@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] pmem: only set QUEUE_FLAG_DAX for fsdax mode
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Toshi Kani <toshi.kani@hpe.com>, Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Jun 26, 2018 at 10:59 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> QUEUE_FLAG_DAX is an indication that a given block device supports
> filesystem DAX and should not be set for PMEM namespaces which are in "raw"
> or "sector" modes.  These namespaces lack struct page and are prevented
> from participating in filesystem DAX.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Suggested-by: Mike Snitzer <snitzer@redhat.com>
> Cc: stable@vger.kernel.org

Why is this cc: stable? What is the user visible impact of this change
especially given the requirement to validate QUEUE_FLAG_DAX with
bdev_dax_supported()? Patch looks good, but it's just a cosmetic fixup
afaics.
