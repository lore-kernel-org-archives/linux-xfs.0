Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:34120 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751373AbdCHP3p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2017 10:29:45 -0500
Received: by mail-qk0-f171.google.com with SMTP id p64so71369720qke.1
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2017 07:28:58 -0800 (PST)
Message-ID: <1488976522.2802.8.camel@redhat.com>
Subject: Re: WARNING: CPU: 2 PID: 20539 at fs/iomap.c:954
 iomap_dio_rw+0x39a/0x3b0
From: Jeff Layton <jlayton@redhat.com>
Date: Wed, 08 Mar 2017 07:35:22 -0500
In-Reply-To: <20170307220911.GA25288@infradead.org>
References: <1488922559.3877.6.camel@redhat.com>
         <20170307220911.GA25288@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>

On Tue, 2017-03-07 at 14:09 -0800, Christoph Hellwig wrote:
> On Tue, Mar 07, 2017 at 04:35:59PM -0500, Jeff Layton wrote:
> > I was doing an xfstests run on xfs with v4.11.0-rc1, and these two
> > warnings popped. Looks like invalidate_inode_pages2_range failed? A
> > small patch to print the error there showed that it was returning
> > -EBUSY.
> > 
> > Pretty easy to reproduce by running xfstests generic/095 on a KVM guest
> > running v4.11.0-rc1.
> 
> Can you try:
> 
> "[PATCH v2] iomap: invalidate page caches should be after iomap_dio_complete() in direct write"
> 
> which was sent to the XFS list last week and check if it fixes things
> for you?

I tried it, but the warnings still appear.

To be clear, generic/095 still passes, it's just that the warnings pop
up when it is run.

-- 
Jeff Layton <jlayton@redhat.com>
