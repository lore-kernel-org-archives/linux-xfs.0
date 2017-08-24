Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44828 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751277AbdHXH04 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 03:26:56 -0400
Date: Thu, 24 Aug 2017 09:26:54 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 09/13] dax: Allow dax_iomap_fault() to return pfn
Message-ID: <20170824072654.GD20465@quack2.suse.cz>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-10-jack@suse.cz>
 <20170823183400.GG13778@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170823183400.GG13778@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, Boaz Harrosh <boazh@netapp.com>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org

On Wed 23-08-17 11:34:00, Christoph Hellwig wrote:
> > @@ -1416,6 +1416,7 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
> >   * @vmf: The description of the fault
> >   * @pe_size: Size of the page to fault in
> >   * @ops: Iomap ops passed from the file system
> > + * @pfnp: PFN to insert for synchronous faults if fsync is required
> >   *
> >   * When a page fault occurs, filesystems may call this helper in
> >   * their fault handler for DAX files. dax_iomap_fault() assumes the caller
> > @@ -1423,13 +1424,13 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
> >   * successfully.
> >   */
> >  int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
> > -		    const struct iomap_ops *ops)
> > +		    const struct iomap_ops *ops, pfn_t *pfnp)
> 
> Please keep the iomap_ops argument the last one for the exported
> function (and probably all others for consistency).

Hum, I wanted the output argument to be the last one. But I don't care
much. Swapped.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
