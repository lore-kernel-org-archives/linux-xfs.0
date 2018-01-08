Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35140 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756315AbeAHMBx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jan 2018 07:01:53 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.21) with SMTP id w08C1Bcc006507
        for <linux-xfs@vger.kernel.org>; Mon, 8 Jan 2018 07:01:52 -0500
Received: from e06smtp14.uk.ibm.com (e06smtp14.uk.ibm.com [195.75.94.110])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2fc85ur80m-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 08 Jan 2018 07:01:29 -0500
Received: from localhost
        by e06smtp14.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <gerald.schaefer@de.ibm.com>;
        Mon, 8 Jan 2018 11:58:52 -0000
Date: Mon, 8 Jan 2018 12:58:47 +0100
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: Re: [PATCH v4 04/18] dax: require 'struct page' by default for
 filesystem dax
In-Reply-To: <151407698249.38751.17338746909239708376.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
        <151407698249.38751.17338746909239708376.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Message-Id: <20180108125847.50cd19cb@thinkpad>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, jack@suse.cz, linux-nvdimm@lists.01.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, ross.zwisler@linux.intel.com, hch@lst.de

On Sat, 23 Dec 2017 16:56:22 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> If a dax buffer from a device that does not map pages is passed to
> read(2) or write(2) as a target for direct-I/O it triggers SIGBUS. If
> gdb attempts to examine the contents of a dax buffer from a device that
> does not map pages it triggers SIGBUS. If fork(2) is called on a process
> with a dax mapping from a device that does not map pages it triggers
> SIGBUS. 'struct page' is required otherwise several kernel code paths
> break in surprising ways. Disable filesystem-dax on devices that do not
> map pages.
> 
> In addition to needing pfn_to_page() to be valid we also require devmap
> pages.  We need this to detect dax pages in the get_user_pages_fast()
> path and so that we can stop managing the VM_MIXEDMAP flag. For DAX
> drivers that have not supported get_user_pages() to date we allow them
> to opt-in to supporting DAX with the CONFIG_FS_DAX_LIMITED configuration
> option which requires ->direct_access() to return pfn_t_special() pfns.
> This leaves DAX support in brd disabled and scheduled for removal.
> 
> Note that when the initial dax support was being merged a few years back
> there was concern that struct page was unsuitable for use with next
> generation persistent memory devices. The theoretical concern was that
> struct page access, being such a hotly used data structure in the
> kernel, would lead to media wear out. While that was a reasonable
> conservative starting position it has not held true in practice. We have
> long since committed to using devm_memremap_pages() to support higher
> order kernel functionality that needs get_user_pages() and
> pfn_to_page().
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  arch/powerpc/platforms/Kconfig |    1 +
>  drivers/dax/super.c            |   10 ++++++++++
>  drivers/s390/block/Kconfig     |    1 +
>  fs/Kconfig                     |    7 +++++++
>  4 files changed, 19 insertions(+)

dcssblk seems to work fine, I did not see any SIGBUS while "executing
in place" from dcssblk with the current upstream kernel, maybe because
we only use dcssblk with fs dax in read-only mode.

Anyway, the dcssblk change is fine with me. I will look into adding
struct pages for dcssblk memory later, to make it work again with
this change, but for now I do not know of anyone needing this in the
upstream kernel.

Reviewed-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>

