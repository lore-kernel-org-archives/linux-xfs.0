Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:59303 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964922AbdKCCct (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Nov 2017 22:32:49 -0400
From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 02/15] mm, dax: introduce pfn_t_special()
In-Reply-To: <150949210553.24061.5992572975056748512.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150949209290.24061.6283157778959640151.stgit@dwillia2-desk3.amr.corp.intel.com> <150949210553.24061.5992572975056748512.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Fri, 03 Nov 2017 13:32:44 +1100
Message-ID: <87ines6qib.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Paul Mackerras <paulus@samba.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de, Arnd Bergmann <arnd@arndb.de>

Dan Williams <dan.j.williams@intel.com> writes:

> In support of removing the VM_MIXEDMAP indication from DAX VMAs,
> introduce pfn_t_special() for drivers to indicate that _PAGE_SPECIAL
> should be used for DAX ptes. This also helps identify drivers like
> dccssblk that only want to use DAX in a read-only fashion without
> get_user_pages() support.
>
> Ideally we could delete axonram and dcssblk DAX support, but if we need
> to keep it better make it explicit that axonram and dcssblk only support
> a sub-set of DAX due to missing _PAGE_DEVMAP support.

I sent a patch to remove axonram (sorry meant to Cc you):

  http://patchwork.ozlabs.org/patch/833588/

Will see if there's any feedback.

cheers
