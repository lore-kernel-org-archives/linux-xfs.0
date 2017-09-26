Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:49826 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936730AbdIZN7i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2017 09:59:38 -0400
Received: by mail-oi0-f47.google.com with SMTP id i128so11977593oih.6
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2017 06:59:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170926063234.GA6870@lst.de>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
 <20170925231404.32723-4-ross.zwisler@linux.intel.com> <20170926063234.GA6870@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Sep 2017 06:59:37 -0700
Message-ID: <CAPcyv4hKb1PshbjLxyWz2fdj=dK2fi2qgJLFaT9pVnmaOoWV6g@mail.gmail.com>
Subject: Re: [PATCH 3/7] xfs: protect S_DAX transitions in XFS read path
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, "J. Bruce Fields" <bfields@fieldses.org>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@poochiereds.net>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-xfs@vger.kernel.org

On Mon, Sep 25, 2017 at 11:32 PM, Christoph Hellwig <hch@lst.de> wrote:
> We can't just take locking one level up, as we need differnet locking
> for different kinds of I/O.
>
> I think you probably want an IOCB_DAX flag to check IS_DAX once and
> then stick to it, similar to what we do for direct I/O.

I wonder if this works better with a reference count mechanism
per-file so that we don't need a hold a lock over the whole
transition. Similar to request_queue reference counting, when DAX is
being turned off we block new references and drain the in-flight ones.
