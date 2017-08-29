Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46526 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751408AbdH2V0I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Aug 2017 17:26:08 -0400
Date: Tue, 29 Aug 2017 23:26:06 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 1/2] fs, xfs: perform dax_device lookup at mount
Message-ID: <20170829212606.GC8608@lst.de>
References: <150389211501.25151.6477753201827914462.stgit@dwillia2-desk3.amr.corp.intel.com> <150389212075.25151.17146973298430877023.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150389212075.25151.17146973298430877023.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz, linux-nvdimm@lists.01.org, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, hch@lst.de

Call me nitpicky, but..

First this really should be three patches, one for the DAX code, one
for the VFS code and one for XFS.  The DAX and XFS bits looks fine to
me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But I'm a little worried about stuffing more DAX knowledge into the
block mount_bdev helper.  For now it's probably ok as everything
else would involve a lot of refactoring and/or duplication, but
I'm generally not too happy about it.
