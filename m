Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FCA4C433E6
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 467466146D
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239610AbhCDARJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:17:09 -0500
Received: from smtprelay0140.hostedemail.com ([216.40.44.140]:52526 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241083AbhCCKT1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Mar 2021 05:19:27 -0500
X-Greylist: delayed 7106 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Mar 2021 05:19:25 EST
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave05.hostedemail.com (Postfix) with ESMTP id 4CAE3181C8F29;
        Wed,  3 Mar 2021 08:21:58 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 3F59F180CE5FF;
        Wed,  3 Mar 2021 08:20:18 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: snake87_191524c276c3
X-Filterd-Recvd-Size: 3585
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf04.hostedemail.com (Postfix) with ESMTPA;
        Wed,  3 Mar 2021 08:20:15 +0000 (UTC)
Message-ID: <aed5d2b78c4ac121ca0cf46107334673a3c9a586.camel@perches.com>
Subject: Re: [PATCH v2 08/10] fsdax: Dedup file range to use a compare
 function
From:   Joe Perches <joe@perches.com>
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org
Cc:     darrick.wong@oracle.com, dan.j.williams@intel.com,
        willy@infradead.org, jack@suse.cz, viro@zeniv.linux.org.uk,
        linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        david@fromorbit.com, hch@lst.de, rgoldwyn@suse.de,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Date:   Wed, 03 Mar 2021 00:20:14 -0800
In-Reply-To: <20210226002030.653855-9-ruansy.fnst@fujitsu.com>
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
         <20210226002030.653855-9-ruansy.fnst@fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 2021-02-26 at 08:20 +0800, Shiyang Ruan wrote:
> With dax we cannot deal with readpage() etc. So, we create a dax
> comparison funciton which is similar with
> vfs_dedupe_file_range_compare().
> And introduce dax_remap_file_range_prep() for filesystem use.
[]
> diff --git a/fs/dax.c b/fs/dax.c
[]
> @@ -1856,3 +1856,54 @@ vm_fault_t dax_finish_sync_fault(struct vm_fault *vmf,l
>  	return dax_insert_pfn_mkwrite(vmf, pfn, order);
>  }
>  EXPORT_SYMBOL_GPL(dax_finish_sync_fault);
> +
> +static loff_t dax_range_compare_actor(struct inode *ino1, loff_t pos1,
> +		struct inode *ino2, loff_t pos2, loff_t len, void *data,
> +		struct iomap *smap, struct iomap *dmap)
> +{
> +	void *saddr, *daddr;
> +	bool *same = data;
> +	int ret;
> +
> +	while (len) {
> +		if (smap->type == IOMAP_HOLE && dmap->type == IOMAP_HOLE)
> +			goto next;
> +
> +		if (smap->type == IOMAP_HOLE || dmap->type == IOMAP_HOLE) {
> +			*same = false;
> +			break;
> +		}
> +
> +		ret = dax_iomap_direct_access(smap, pos1,
> +			ALIGN(pos1 + len, PAGE_SIZE), &saddr, NULL);
> +		if (ret < 0)
> +			return -EIO;
> +
> +		ret = dax_iomap_direct_access(dmap, pos2,
> +			ALIGN(pos2 + len, PAGE_SIZE), &daddr, NULL);
> +		if (ret < 0)
> +			return -EIO;
> +
> +		*same = !memcmp(saddr, daddr, len);
> +		if (!*same)
> +			break;
> +next:
> +		len -= len;
> +	}
> +
> +	return 0;
> +}

This code looks needlessly complex.

len is never decremented inside the while loop so the while loop
itself looks unnecessary.  Is there some missing decrement of len
or some other reason to use a while loop?

Is dax_iomap_direct_access some ugly macro that modifies a hidden len?

Why not remove the while loop and use straightforward code without
unnecessary indentatation?

{
	void *saddr;
	void *daddr;
	bool *same = data;
	int ret;

	if (!len ||
	    (smap->type == IOMAP_HOLE && dmap->type == IOMAP_HOLE))
		return 0;

	if (smap->type == IOMAP_HOLE || dmap->type == IOMAP_HOLE) {
		*same = false;
		return 0;
	}

	ret = dax_iomap_direct_access(smap, pos1, ALIGN(pos1 + len, PAGE_SIZE),
				      &saddr, NULL);
	if (ret < 0)
		return -EIO;

	ret = dax_iomap_direct_access(dmap, pos2, ALIGN(pos2 + len, PAGE_SIZE),
				      &daddr, NULL);
	if (ret < 0)
		return -EIO;

	*same = !memcmp(saddr, daddr, len);

	return 0;
}	

I didn't look at the rest.

