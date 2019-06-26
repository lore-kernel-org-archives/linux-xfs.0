Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi1-f193.google.com ([209.85.167.193]:45065 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727181AbfFZNRy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 09:17:54 -0400
Received: by mail-oi1-f193.google.com with SMTP id m206so1848254oib.12
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 06:17:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190626120333.13310-1-agruenba@redhat.com> <20190626125502.GB4744@lst.de>
In-Reply-To: <20190626125502.GB4744@lst.de>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Wed, 26 Jun 2019 15:17:42 +0200
Message-ID: <CAHc6FU5suCE2-TtNMR4mGZ5DHB+3diVL=uUwccKES=eHwSPYkA@mail.gmail.com>
Subject: Re: [PATCH 1/2] iomap: don't mark the inode dirty in iomap_write_end
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, cluster-devel <cluster-devel@redhat.com>, linux-xfs@vger.kernel.org

On Wed, 26 Jun 2019 at 14:55, Christoph Hellwig <hch@lst.de> wrote:
> Doesn't the series also need a third patch reducing the amount
> of mark_inode_dirty calls as per your initial proposal?

The page dirtying already reduces from once per page to once per
mapping, so that should be good enough.

Thanks,
Andreas
