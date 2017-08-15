Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:33764 "EHLO
        mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751640AbdHOWbG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Aug 2017 18:31:06 -0400
Received: by mail-yw0-f170.google.com with SMTP id p68so13017118ywg.0
        for <linux-xfs@vger.kernel.org>; Tue, 15 Aug 2017 15:31:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALCETrU811Ac+DpiUP8MdayA6cD3Jk+Dd0RXAqk5YM6Lj9YsDQ@mail.gmail.com>
References: <150277752553.23945.13932394738552748440.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150277753660.23945.11500026891611444016.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CALCETrU811Ac+DpiUP8MdayA6cD3Jk+Dd0RXAqk5YM6Lj9YsDQ@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Aug 2017 15:31:04 -0700
Message-ID: <CAPcyv4g3xvLzQYdpeMX14amZHVZH+kbK+39Dnwv1Z_0o4R-3Yg@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] mm: introduce MAP_VALIDATE a mechanism for adding
 new mmap flags
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Lutomirski <luto@kernel.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>

On Tue, Aug 15, 2017 at 9:28 AM, Andy Lutomirski <luto@kernel.org> wrote:
> On Mon, Aug 14, 2017 at 11:12 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> The mmap syscall suffers from the ABI anti-pattern of not validating
>> unknown flags. However, proposals like MAP_SYNC and MAP_DIRECT need a
>> mechanism to define new behavior that is known to fail on older kernels
>> without the feature. Use the fact that specifying MAP_SHARED and
>> MAP_PRIVATE at the same time is invalid as a cute hack to allow a new
>> set of validated flags to be introduced.
>
> While this is cute, is it actually better than a new syscall?

After playing with MAP_DIRECT defined as (MAP_SHARED|MAP_PRIVATE|0x40)
I think a new syscall is better. It's very easy to make the mistake
that "MAP_DIRECT" defines a single flag vs representing a multi-bit
encoding.
