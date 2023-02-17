Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EFD5C64ED6
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Feb 2023 16:14:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbjBQQO5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Feb 2023 11:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjBQQOl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Feb 2023 11:14:41 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54913714A8;
        Fri, 17 Feb 2023 08:14:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KnUFNJfeceytXekVEZZ2PBZbloO4tvSDT1W02Zgchxk=; b=sGL6zNZAPMTbxDBefMd6fe8/U4
        zzDIyvHo90wFVvbrPONPZBoWqZ0GzWT/uRWXKepVKkZOiFLouYNH8bH+Nu99PS3ZzajtdQueVg0Z5
        pj/1Xhq9d3xl6fUQdnHIx5HtawVKRKzcRV6pn7PNanOGObCpYv4DYoBreTu8V1Rkj0z1vIYHyrwEE
        228Z7QatBHC7S1ho0GE/07cz/NsJ4tujgE2/ENftFosFupD6K0dFz3F0x7q+rUqUWcfhe1foBs4kK
        1gG/qp5BTx5I7Ekzxe46w3MP8frb7NQsujh33+Dya8GbrOiaendnwk0MBSyv1jZZ4ukUW4maTbDL2
        jTDtG0/w==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pT3NX-009Rkh-24; Fri, 17 Feb 2023 16:14:31 +0000
Date:   Fri, 17 Feb 2023 16:14:31 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        djwong@kernel.org, david@fromorbit.com, dan.j.williams@intel.com,
        hch@infradead.org, jane.chu@oracle.com, akpm@linux-foundation.org
Subject: Re: [PATCH v10 2/3] fs: introduce super_drop_pagecache()
Message-ID: <Y++n53dzkCsH1qeK@casper.infradead.org>
References: <1676645312-13-1-git-send-email-ruansy.fnst@fujitsu.com>
 <1676645312-13-3-git-send-email-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1676645312-13-3-git-send-email-ruansy.fnst@fujitsu.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 17, 2023 at 02:48:31PM +0000, Shiyang Ruan wrote:
> -		invalidate_mapping_pages(inode->i_mapping, 0, -1);
> -		iput(toput_inode);
> -		toput_inode = inode;
> -
> -		cond_resched();
> -		spin_lock(&sb->s_inode_list_lock);
> -	}
> -	spin_unlock(&sb->s_inode_list_lock);
> -	iput(toput_inode);
> +	super_drop_pagecache(sb, invalidate_inode_pages);

I thought I explained last time that you can do this with
invalidate_mapping_pages() / invalidate_inode_pages2_range() ?
Then you don't need to introduce invalidate_inode_pages().

> +void super_drop_pagecache(struct super_block *sb,
> +	int (*invalidator)(struct address_space *))

void super_drop_pagecache(struct super_block *sb,
		int (*invalidate)(struct address_space *, pgoff_t, pgoff_t))

> +		invalidator(inode->i_mapping);

		invalidate(inode->i_mapping, 0, -1)

... then all the changes to mm/truncate.c and filemap.h go away.
