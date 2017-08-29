Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46573 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751280AbdH2Vgh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Aug 2017 17:36:37 -0400
Date: Tue, 29 Aug 2017 23:36:35 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 1/2] fs, xfs: perform dax_device lookup at mount
Message-ID: <20170829213635.GA8946@lst.de>
References: <150389211501.25151.6477753201827914462.stgit@dwillia2-desk3.amr.corp.intel.com> <150389212075.25151.17146973298430877023.stgit@dwillia2-desk3.amr.corp.intel.com> <20170829212606.GC8608@lst.de> <CAPcyv4hA_vkSdZowaJ78FPCOhY2Z_iORX0B63=_RCCGdqack_g@mail.gmail.com> <CAPcyv4i2rS0sAxiJSVxFSHirsycaYofuxp3yPxeyB8xzsryx3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4i2rS0sAxiJSVxFSHirsycaYofuxp3yPxeyB8xzsryx3g@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>

On Tue, Aug 29, 2017 at 02:35:27PM -0700, Dan Williams wrote:
> Actually, why not just do this directly in xfs_fs_mount()? I think I
> can refactor this to not touch mount_bdev() and put all the details in
> the per-fs mount/umount paths.

Yes, and just cache in in the fs specific superblock.
