Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752617AbdHOQ2p (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Aug 2017 12:28:45 -0400
Received: from mail-it0-f54.google.com (mail-it0-f54.google.com [209.85.214.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B42D922D3B
        for <linux-xfs@vger.kernel.org>; Tue, 15 Aug 2017 16:28:42 +0000 (UTC)
Received: by mail-it0-f54.google.com with SMTP id 76so6545405ith.0
        for <linux-xfs@vger.kernel.org>; Tue, 15 Aug 2017 09:28:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <150277753660.23945.11500026891611444016.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150277752553.23945.13932394738552748440.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150277753660.23945.11500026891611444016.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Tue, 15 Aug 2017 09:28:21 -0700
Message-ID: <CALCETrU811Ac+DpiUP8MdayA6cD3Jk+Dd0RXAqk5YM6Lj9YsDQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] mm: introduce MAP_VALIDATE a mechanism for adding
 new mmap flags
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Lutomirski <luto@kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>

On Mon, Aug 14, 2017 at 11:12 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> The mmap syscall suffers from the ABI anti-pattern of not validating
> unknown flags. However, proposals like MAP_SYNC and MAP_DIRECT need a
> mechanism to define new behavior that is known to fail on older kernels
> without the feature. Use the fact that specifying MAP_SHARED and
> MAP_PRIVATE at the same time is invalid as a cute hack to allow a new
> set of validated flags to be introduced.

While this is cute, is it actually better than a new syscall?
