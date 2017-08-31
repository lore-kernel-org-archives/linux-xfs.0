Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54319 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751250AbdHaJ4h (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Aug 2017 05:56:37 -0400
Date: Thu, 31 Aug 2017 11:56:36 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 2/4] xfs: perform dax_device lookup at mount
Message-ID: <20170831095636.GB21443@lst.de>
References: <150412222686.10177.8031279869867070772.stgit@dwillia2-desk3.amr.corp.intel.com> <150412223801.10177.4972035211701096310.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150412223801.10177.4972035211701096310.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nvdimm@lists.01.org, Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <darrick.wong@oracle.com>

We don't really need the dax_device for the log device (yet), but
acquiring it seems harmless, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>
