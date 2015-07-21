Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0B4757F89
	for <xfs@oss.sgi.com>; Tue, 21 Jul 2015 08:58:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EA8238F804B
	for <xfs@oss.sgi.com>; Tue, 21 Jul 2015 06:58:05 -0700 (PDT)
Received: from mga01.intel.com ([192.55.52.88]) by cuda.sgi.com with ESMTP id
	B2n4BauuXyLZhPMq for <xfs@oss.sgi.com>;
	Tue, 21 Jul 2015 06:58:01 -0700 (PDT)
Date: Tue, 21 Jul 2015 09:57:58 -0400
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/4] xfs: call dax_fault on read page faults for DAX
Message-ID: <20150721135758.GO13681@linux.intel.com>
References: <1437440945-23457-1-git-send-email-david@fromorbit.com>
	<1437440945-23457-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1437440945-23457-2-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 21, 2015 at 11:09:02AM +1000, Dave Chinner wrote:
> @@ -339,6 +344,8 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
>  	int error;
>  	int major = 0;
>  
> +	WARN_ON_ONCE((vmf->flags & FAULT_FLAG_WRITE) && !complete_unwritten);
> +
>  	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
>  	if (vmf->pgoff >= size)
>  		return VM_FAULT_SIGBUS;

This warning is always going to trigger for ext2, since it doesn't
support the concept of unwritten extents.  Instead, ext2 zeroes the block
before linking it into the tree and returning from get_block.

> @@ -437,7 +444,7 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
>  	 * as for normal BH based IO completions.
>  	 */
>  	error = dax_insert_mapping(inode, &bh, vma, vmf);
> -	if (buffer_unwritten(&bh))
> +	if (buffer_unwritten(&bh) && complete_unwritten)
>  		complete_unwritten(&bh, !error);
>  
>   out:

... so maybe we should do something here like:

	if (buffer_unwritten(&bh)) {
		if (complete_unwritten)
			complete_unwritten(&bh, !error);
		else
			BUG_ON(vmf->flags & FAULT_FLAG_WRITE);
	}

(the XFS changes look fine to me)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
