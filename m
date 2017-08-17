Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44400 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750993AbdHQHhL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Aug 2017 03:37:11 -0400
Date: Thu, 17 Aug 2017 09:37:10 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3] xfs: open code end_buffer_async_write in
        xfs_finish_page_writeback
Message-ID: <20170817073710.GB24372@lst.de>
References: <20170816085157.24074-1-hch@lst.de> <20170816154454.GX4796@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170816154454.GX4796@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, bfoster@redhat.com

On Wed, Aug 16, 2017 at 08:44:54AM -0700, Darrick J. Wong wrote:
> I'm assuming 4.14 for this one, unless you know of people banging into
> use-after-free problems and therefore need it pushed into 4.13?

Still waiting for more QA feedback on the original issue.  I think
4.14 is fine for now.
