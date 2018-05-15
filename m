Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51784 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752296AbeEOHuF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 May 2018 03:50:05 -0400
Date: Tue, 15 May 2018 00:50:01 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfsprogs 4.16.0 format change, GRUB error unknown filesystem
Message-ID: <20180515075001.GA17568@infradead.org>
References: <CAJCQCtQbns7bbE=mWvYuWMi+R5wdphfEjF1F995PVBsoUovnpg@mail.gmail.com>
 <20180514173610.GC4933@magnolia>
 <CAJCQCtQ04viW=GzfTBWdQPab8orRmzQ2MjHGCSy_VY_k7-PdRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtQ04viW=GzfTBWdQPab8orRmzQ2MjHGCSy_VY_k7-PdRw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs list <linux-xfs@vger.kernel.org>

On Mon, May 14, 2018 at 11:52:18AM -0600, Chris Murphy wrote:
> Is there a reason why this was made default before GRUB was fixed? Or
> would XFS devs prefer to not support /boot on XFS?

A bootloader that reads any non-trivial file system (and that includes
XFS for sure) is a bad idea.  So yes, if distros would not do that by
default it would help a lot.
