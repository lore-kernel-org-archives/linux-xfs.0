Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727073AbfBKUJ0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Feb 2019 15:09:26 -0500
MIME-Version: 1.0
References: <20190204165427.23607-1-mcgrof@kernel.org> <20190205220655.GF14116@dastard>
 <20190208194829.GJ11489@garbanzo.do-not-panic.com>
In-Reply-To: <20190208194829.GJ11489@garbanzo.do-not-panic.com>
From: Luis Chamberlain <mcgrof@kernel.org>
Date: Mon, 11 Feb 2019 14:09:13 -0600
Message-ID: <CAB=NE6UoCabBLEJyfbYiEddymob71L0HMecX7NK=6+YBWeo-BA@mail.gmail.com>
Subject: Re: [PATCH v2 00/10] xfs: stable fixes for v4.19.y
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <Alexander.Levin@microsoft.com>, "4.2+" <stable@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@infradead.org>

On Fri, Feb 8, 2019 at 1:48 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> Perhaps worth noting which was curious is that I could not get to
> trigger generic/464 on sections xfs_nocrc_512 and xfs_reflink_1024.

Well I just hit a failure for generic/464 on 4.19.17 after ~3996 runs
for the xfs_nocrc_512 section, and after 7382 runs for
xfs_refkilnk_1024.
I've updated the expunge list to reflect the difficult to hit failure
of generic/464 and its failure rate on xfs_nocrc_512 on oscheck.

 Luis
