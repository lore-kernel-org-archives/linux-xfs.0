Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35120 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731544AbfAIOmT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 9 Jan 2019 09:42:19 -0500
Date: Wed, 9 Jan 2019 15:42:15 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 4/5] ext4: disable map_sync for virtio pmem
Message-ID: <20190109144215.GI15397@quack2.suse.cz>
References: <20190109135606.15401-1-pagupta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190109135606.15401-1-pagupta@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Pankaj Gupta <pagupta@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, qemu-devel@nongnu.org, linux-nvdimm@ml01.01.org, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-acpi@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, jack@suse.cz, stefanha@redhat.com, dan.j.williams@intel.com, riel@surriel.com, nilal@redhat.com, kwolf@redhat.com, pbonzini@redhat.com, zwisler@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com, david@redhat.com, jmoyer@redhat.com, xiaoguangrong.eric@gmail.com, hch@infradead.org, mst@redhat.com, jasowang@redhat.com, lcapitulino@redhat.com, imammedo@redhat.com, eblake@redhat.com, willy@infradead.org, tytso@mit.edu, adilger.kernel@dilger.ca, darrick.wong@oracle.com, rjw@rjwysocki.net

On Wed 09-01-19 19:26:05, Pankaj Gupta wrote:
> Virtio pmem provides asynchronous host page cache flush
> mechanism. We don't support 'MAP_SYNC' with virtio pmem 
> and ext4. 
> 
> Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
...
> @@ -371,6 +373,13 @@ static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
>  	if (!IS_DAX(file_inode(file)) && (vma->vm_flags & VM_SYNC))
>  		return -EOPNOTSUPP;
>  
> +	/* We don't support synchronous mappings with guest direct access
> +	 * and virtio based host page cache flush mechanism.
> +	 */
> +	if (IS_DAX(file_inode(file)) && virtio_pmem_host_cache_enabled(dax_dev)
> +						&& (vma->vm_flags & VM_SYNC))
> +		return -EOPNOTSUPP;
> +

Shouldn't there rather be some generic way of doing this? Having
virtio_pmem_host_cache_enabled() check in filesystem code just looks like
filesystem sniffing into details is should not care about... Maybe just
naming this (or having a wrapper) dax_dev_map_sync_supported()?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
