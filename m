Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47791 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752057AbeADIQb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Jan 2018 03:16:31 -0500
Date: Thu, 4 Jan 2018 09:16:29 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 01/18] mm, dax: introduce pfn_t_special()
Message-ID: <20180104081629.GB2548@lst.de>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com> <151407696622.38751.4716967585354728059.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151407696622.38751.4716967585354728059.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, jack@suse.cz, linux-nvdimm@lists.01.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, ross.zwisler@linux.intel.com, hch@lst.de

On Sat, Dec 23, 2017 at 04:56:06PM -0800, Dan Williams wrote:
> In support of removing the VM_MIXEDMAP indication from DAX VMAs,
> introduce pfn_t_special() for drivers to indicate that _PAGE_SPECIAL
> should be used for DAX ptes. This also helps identify drivers like
> dccssblk that only want to use DAX in a read-only fashion without
> get_user_pages() support.
> 
> Ideally we could delete axonram and dcssblk DAX support, but if we need
> to keep it better make it explicit that axonram and dcssblk only support
> a sub-set of DAX due to missing _PAGE_DEVMAP support.

I'd suggest to just delete it for now.  If the powerpc and S/390
people have an interest in it they should resurrect it properly and
fully.
