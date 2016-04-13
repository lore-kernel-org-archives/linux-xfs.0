Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BB5DF7CA0
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 22:18:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 695B6304066
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 20:18:05 -0700 (PDT)
Received: from mga04.intel.com ([192.55.52.120]) by cuda.sgi.com with ESMTP id
	7zZtFlOmsjxgphO9 for <xfs@oss.sgi.com>;
	Tue, 12 Apr 2016 20:18:04 -0700 (PDT)
Date: Tue, 12 Apr 2016 23:18:01 -0400
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH v2 1/5] dax: add dax_get_unmapped_area for pmd mappings
Message-ID: <20160413031801.GO2781@linux.intel.com>
References: <1460493555-31611-1-git-send-email-toshi.kani@hpe.com>
	<1460493555-31611-2-git-send-email-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1460493555-31611-2-git-send-email-toshi.kani@hpe.com>
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, adilger.kernel@dilger.ca, kirill.shutemov@linux.intel.com, linux-fsdevel@vger.kernel.org, tytso@mit.edu, akpm@linux-foundation.org, linux-ext4@vger.kernel.org, ross.zwisler@linux.intel.com, dan.j.williams@intel.com, viro@zeniv.linux.org.uk

On Tue, Apr 12, 2016 at 02:39:15PM -0600, Toshi Kani wrote:
> + * When the target file is not a DAX file, @addr is specified, the
> + * request is not suitable for pmd mappings, or mm->get_unmapped_area()
> + * failed with extended @len, it simply calls the default handler,
> + * mm->get_unmapped_area(), with the original arguments.

I think you can lose this paragraph.  It describes what the function
does, not why it does it ... and we can see what the function does from
reading the code.

> +unsigned long dax_get_unmapped_area(struct file *filp, unsigned long addr,
> +		unsigned long len, unsigned long pgoff, unsigned long flags)
> +{
> +	unsigned long off, off_end, off_pmd, len_pmd, addr_pmd;
> +
> +	if (IS_ENABLED(CONFIG_FS_DAX_PMD) &&
> +	    filp && !addr && IS_DAX(filp->f_mapping->host)) {
> +		off = pgoff << PAGE_SHIFT;
> +		off_end = off + len;
> +		off_pmd = round_up(off, PMD_SIZE);
> +
> +		if ((off_end > off_pmd) && ((off_end - off_pmd) >= PMD_SIZE)) {
> +			len_pmd = len + PMD_SIZE;
> +
> +			addr_pmd = current->mm->get_unmapped_area(
> +					filp, addr, len_pmd, pgoff, flags);
> +
> +			if (!IS_ERR_VALUE(addr_pmd)) {
> +				addr_pmd += (off - addr_pmd) & (PMD_SIZE - 1);
> +				return addr_pmd;
> +			}
> +		}
> +	}
> +
> +	return current->mm->get_unmapped_area(filp, addr, len, pgoff, flags);
> +}

I think this is one of those functions which is actually improved with
gotos, purely to reduce the indentation level.

unsigned long dax_get_unmapped_area(struct file *filp, unsigned long addr,
		unsigned long len, unsigned long pgoff, unsigned long flags)
{
	unsigned long off, off_end, off_pmd, len_pmd, addr_pmd;

	if (!IS_ENABLED(CONFIG_FS_DAX_PMD) ||
	    !filp || addr || !IS_DAX(filp->f_mapping->host))
		goto out;

	off = pgoff << PAGE_SHIFT;
	off_end = off + len;
	off_pmd = round_up(off, PMD_SIZE);
	if ((off_end <= off_pmd) || ((off_end - off_pmd) < PMD_SIZE))
		goto out;

	len_pmd = len + PMD_SIZE;
	addr_pmd = current->mm->get_unmapped_area(filp, addr, len_pmd,
							pgoff, flags);

	if (!IS_ERR_VALUE(addr_pmd)) {
		addr_pmd += (off - addr_pmd) & (PMD_SIZE - 1);
		return addr_pmd;
	}

 out:
	return current->mm->get_unmapped_area(filp, addr, len, pgoff, flags);
}

Now ... back to the original version, some questions:

> +unsigned long dax_get_unmapped_area(struct file *filp, unsigned long addr,
> +		unsigned long len, unsigned long pgoff, unsigned long flags)
> +{
> +	unsigned long off, off_end, off_pmd, len_pmd, addr_pmd;
> +
> +	if (IS_ENABLED(CONFIG_FS_DAX_PMD) &&
> +	    filp && !addr && IS_DAX(filp->f_mapping->host)) {
> +		off = pgoff << PAGE_SHIFT;
> +		off_end = off + len;

Can off + len wrap here, or did that get checked earlier?

> +		off_pmd = round_up(off, PMD_SIZE);
> +
> +		if ((off_end > off_pmd) && ((off_end - off_pmd) >= PMD_SIZE)) {

We're only going to look for a PMD-aligned mapping if the mapping is at
least double PMD_SIZE?  I don't understand that decision.  Seems to me
that if I ask to map offset 4MB, length 2MB, I should get a PMD-aligned
mapping.

Speaking of offset, we don't have any checks that offset is a multiple
of PMD_SIZE.  I know that theoretically we could map offset 1.5MB, length
3MB and see the first 0.5MB filled with small pages, then the next 2MB
filled with one large page, and the tail filled with small pages, but I
think we're better off only looking for PMD-alignment if the user asked
for an aligned offset in the file.

> +			len_pmd = len + PMD_SIZE;
> +
> +			addr_pmd = current->mm->get_unmapped_area(
> +					filp, addr, len_pmd, pgoff, flags);
> +
> +			if (!IS_ERR_VALUE(addr_pmd)) {
> +				addr_pmd += (off - addr_pmd) & (PMD_SIZE - 1);

... then you wouldn't need this calculation ;-)

> +				return addr_pmd;
> +			}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
