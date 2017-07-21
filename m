Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:43284 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750784AbdGUK0s (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 Jul 2017 06:26:48 -0400
Date: Fri, 21 Jul 2017 12:26:46 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] xfs: fix multi-AG deadlock in xfs_bunmapi
Message-ID: <20170721102646.GA13953@lst.de>
References: <20170718172545.18065-1-hch@lst.de> <ac50dda7-6147-1bb2-78ed-b49dafaec242@gmail.com> <09500343-740e-0178-c60a-6ea5e6993c11@gmail.com> <20170720074706.GA22218@lst.de> <0eb47db7-24de-a231-be9f-73d9ae1171fd@gmail.com> <20170720074924.GA22278@lst.de> <16f95f63-1111-9d3c-344c-6b42ddab3b55@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16f95f63-1111-9d3c-344c-6b42ddab3b55@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Jul 20, 2017 at 05:58:42PM +0300, Nikolay Borisov wrote:
> Okay, I confirm that indeed changing the define from 2 to 1 fixes the
> issue.

Thanks for the report, although that leaves me puzzling why..
