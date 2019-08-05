Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi1-f194.google.com ([209.85.167.194]:45408 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727357AbfHEMfA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Aug 2019 08:35:00 -0400
Received: by mail-oi1-f194.google.com with SMTP id m206so61899916oib.12
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 05:35:00 -0700 (PDT)
MIME-Version: 1.0
References: <156444945993.2682261.3926017251626679029.stgit@magnolia> <20190730144839.GA17025@infradead.org>
In-Reply-To: <20190730144839.GA17025@infradead.org>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Mon, 5 Aug 2019 14:34:49 +0200
Message-ID: <CAHc6FU6MX=QgNKU9MOV6z0QB0gcExB26sFKQVyjzvbGJfdC=5Q@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] iomap: lift the xfs writepage code into iomap
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>

On Tue, 30 Jul 2019 at 16:48, Christoph Hellwig <hch@infradead.org> wrote:
> I don't really see the point of the split, but the result looks fine
> to me.

The split made it easier for me to debug the gfs2 side by backing out
the xfs changes.

Thanks,
Andreas
