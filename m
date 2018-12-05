Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua1-f66.google.com ([209.85.222.66]:41128 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727240AbeLERB7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Dec 2018 12:01:59 -0500
MIME-Version: 1.0
References: <20181203083416.28978-1-david@fromorbit.com> <20181203083416.28978-10-david@fromorbit.com>
 <20181204154347.GA6925@infradead.org> <20181204221847.GQ6311@dastard> <20181205140925.GA21109@infradead.org>
In-Reply-To: <20181205140925.GA21109@infradead.org>
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Date: Wed, 5 Dec 2018 12:01:45 -0500
Message-ID: <CAN-5tyEuEidvyjmOUpc7zM=JgWsDpaoiBtzywDBC4TXmxVxxKw@mail.gmail.com>
Subject: Re: [PATCH 09/11] vfs: push copy_file_ranges -EXDEV checks down
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-nfs <linux-nfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

On Wed, Dec 5, 2018 at 9:09 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Dec 05, 2018 at 09:18:47AM +1100, Dave Chinner wrote:
> > I'll drop it if you want, but then I'll just have to come back after
> > all the NFS code is merged and do yet more cleanup work.
>
> IFF we want these NFS "features" we'll have to get it right before
> merging the code.  But even with that I'd rather fix the glaring
> issues you are fixing in your first patches as a priority before
> adding more features.  In other words:  don't worry about NFS, lets
> get the existing code right before worrying about the next round
> of potential issues.

Dave,

Do you mind in v2 removing the 'retry, ret=EAGAIN' piece and leave the
call to the nfs42_copy_file_range() (with the superblock block check)?
If not, I could provide the patch.

This is a piece of code that got in as a part of the async copy
patches and it was meant for the upcoming server-to-server series.
This code will go right back in with the next series. But since dead
piece of code is glaring wrong currently by all means let's fix it.

Thank you.
