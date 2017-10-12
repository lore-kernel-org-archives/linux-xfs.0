Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:46907 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755587AbdJLQcS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2017 12:32:18 -0400
MIME-Version: 1.0
In-Reply-To: <20171012135127.GG29293@quack2.suse.cz>
References: <150776922692.9144.16963640112710410217.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150776923320.9144.6119113178052262946.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171012135127.GG29293@quack2.suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Oct 2017 09:32:17 -0700
Message-ID: <CA+55aFyy-nz99c6erFh=aeyCOzsk0td5wHaVLpwBNA-sWNDZkA@mail.gmail.com>
Subject: Re: [PATCH v9 1/6] mm: introduce MAP_SHARED_VALIDATE, a mechanism to
 safely define new mmap flags
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Arnd Bergmann <arnd@arndb.de>, Linux API <linux-api@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>

On Thu, Oct 12, 2017 at 6:51 AM, Jan Kara <jack@suse.cz> wrote:
>
> When thinking a bit more about this I've realized one problem: Currently
> user can call mmap() with MAP_SHARED type and MAP_SYNC or MAP_DIRECT flags
> and he will get the new semantics (if the kernel happens to support it).  I
> think that is undesirable [..]

Why?

If you have a performance preference for MAP_DIRECT or something like
that, but you don't want to *enforce* it, you'd use just plain
MAP_SHARED with it.

Ie there may well be "I want this to work, possibly with downsides" issues.

So it seems to be a reasonable model, and disallowing it seems to
limit people and not really help anything.

                 Linus
