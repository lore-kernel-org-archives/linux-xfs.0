Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:40245 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752134AbeDDV16 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Apr 2018 17:27:58 -0400
Received: by mail-oi0-f67.google.com with SMTP id x9-v6so20622453oig.7
        for <linux-xfs@vger.kernel.org>; Wed, 04 Apr 2018 14:27:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180404212340.GA12737@outlook.office365.com>
References: <152246898837.36038.26895928842345061.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180404212340.GA12737@outlook.office365.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 4 Apr 2018 14:27:57 -0700
Message-ID: <CAPcyv4jknruAmkPEVx0X6Bd3uRs_FYdPf-W-5cDO1Z+kaG5+uw@mail.gmail.com>
Subject: Re: [v8, 11/18] mm, dax: enable filesystems to trigger dev_pagemap
 ->page_free callbacks
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrei Vagin <avagin@virtuozzo.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Michal Hocko <mhocko@suse.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, david <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>

On Wed, Apr 4, 2018 at 2:23 PM, Andrei Vagin <avagin@virtuozzo.com> wrote:
> Hi Dan,
>
> I catch the following bug on the linux-next 20180404. git bisect brought me to this commit:

Yes, I will be yanking this functionality out of -next shortly and try
again for v4.18.
