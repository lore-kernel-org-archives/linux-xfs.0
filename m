Return-Path: <SRS0=yyqk=36=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10EFFC3B187
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 23:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D54E320863
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 23:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581377386;
	bh=arVTznMqw7xSxW48Xo/OdvgIkpvkcwR1RQPNs8Mqguo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=NJWvpRLq2fKAth5HpQUKZ5vfhGh7buAfAMKC7Op0/2lV4SoZRZJjw0jPDdQSPvo6i
	 X2qq4yQWB1iDcKwLXe4GNwUXCA5pe/x+a2nbGMRbbNsH1436mBRuhTq+pP15WL3eBJ
	 Cnvbh3e4n8fF7o3+bxeB/g89m0VxqFgFUWOi9cP4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbgBJX3o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Feb 2020 18:29:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:42414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727431AbgBJX3n (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Feb 2020 18:29:43 -0500
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C811720715;
        Mon, 10 Feb 2020 23:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581377383;
        bh=arVTznMqw7xSxW48Xo/OdvgIkpvkcwR1RQPNs8Mqguo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qzalTtHDkFIFUek6BIN5kt1TeDL0ALjfwfuqsItj0pOx/yZ4SUnYZehxsznRPipug
         H/9+Ux3iYsy2dwEDCjT+RTk/gLNwS0yh9idUQ724WMQc2539PzKIgzXgsmGN+woMVj
         YhQl0wCBUBeBTdJYsQGLGsytuKvjYdYM25aCV068=
Date:   Mon, 10 Feb 2020 15:29:42 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Waiman Long <longman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        linux-ext4@vger.kernel.org, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH 01/12] mm: fix a comment in sys_swapon
Message-Id: <20200210152942.2ec4d0b71851feccb7387266@linux-foundation.org>
In-Reply-To: <20200114161225.309792-2-hch@lst.de>
References: <20200114161225.309792-1-hch@lst.de>
        <20200114161225.309792-2-hch@lst.de>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 14 Jan 2020 17:12:14 +0100 Christoph Hellwig <hch@lst.de> wrote:

> claim_swapfile now always takes i_rwsem.
> 
> ...
>
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3157,7 +3157,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>  	mapping = swap_file->f_mapping;
>  	inode = mapping->host;
>  
> -	/* If S_ISREG(inode->i_mode) will do inode_lock(inode); */
> +	/* will take i_rwsem; */
>  	error = claim_swapfile(p, inode);
>  	if (unlikely(error))
>  		goto bad_swap;

http://lkml.kernel.org/r/20200206090132.154869-1-naohiro.aota@wdc.com
removes this comment altogether.  Please check that this is OK?

