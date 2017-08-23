Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41127 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932396AbdHWSeB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Aug 2017 14:34:01 -0400
Date: Wed, 23 Aug 2017 11:34:00 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/13] dax: Allow dax_iomap_fault() to return pfn
Message-ID: <20170823183400.GG13778@infradead.org>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-10-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170817160815.30466-10-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boazh@netapp.com>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org

> @@ -1416,6 +1416,7 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
>   * @vmf: The description of the fault
>   * @pe_size: Size of the page to fault in
>   * @ops: Iomap ops passed from the file system
> + * @pfnp: PFN to insert for synchronous faults if fsync is required
>   *
>   * When a page fault occurs, filesystems may call this helper in
>   * their fault handler for DAX files. dax_iomap_fault() assumes the caller
> @@ -1423,13 +1424,13 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
>   * successfully.
>   */
>  int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
> -		    const struct iomap_ops *ops)
> +		    const struct iomap_ops *ops, pfn_t *pfnp)

Please keep the iomap_ops argument the last one for the exported
function (and probably all others for consistency).

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
