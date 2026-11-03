Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793680852;
	b=YK2puQepYa6dil40+eINo/re1568QrEVeinEMaTyDGYT1WPpoPBmKEPDUw9lyJ9v+q97
	 XScvVg6/RA8e0lAJrP3jmFVnH4t5dHbL1/VLIG/QbwfTjeQVzRHSyvkkYst0jWcky9Lcx
	 yxKp8u5KaEltC7cOxCfjo/DzKDx20DIZhjZZJwUWum/x7cXXI+kVUAyjpSJTlTU3xjBgm
	 4MweZixbJmNG1VljaUuRAU7cJbkfqG+wCU5EG7bvNokfEDlqefEifC9d1/f5CvFray3Xn
	 47wY9fEXs6Sv4jZjOUXQoz/UG0yEni90dFPR86rstri2N/MjSKstlWdJ/YgWISekmig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793680852;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
	bh=j4UWGF2Jl/A/3GEHz2p1BlrUwEyemSNO9c8LNyLgpDo=;
	b=QrwEjrYNWMfsGs0zgxQDhwkrq9eBCARkQA2yvCqmhaQ5WgHy2Xbkz6wpKvDlp+myz9uw
	 JzSKnzYiwtj+AS7kkJuOaXPWGkPxJmnkv/NVW+qh0t8Xl8ErYqF7W6q/b+mODZXkHUXu1
	 r2sXW6I5Uumri6iaZTJmPWq+yPZc3V3phqYKrg3qYiTsRilA/g8Gz//tZgXHsrkGWxt7+
	 wv92NhvBmgzocsQV+TWw45IWhxd0CPP6uyK0dq6UsCWYl5nYJMCS11zEnnaUj34adjRGK
	 wh//JBwR4APoC8fBYnErVazDbV0IlfWK0/jGov+PMuNeWf/hIK10ugPL9TK8Fh02GoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=FkSycQ7R;
	arc=none smtp.remote-ip=113.46.200.226
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6588F606A329;
	Tue,  3 Nov 2026 04:40:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6588F606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=FkSycQ7R
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=j4UWGF2Jl/A/3GEHz2p1BlrUwEyemSNO9c8LNyLgpDo=;
	b=FkSycQ7RjKZ9tN1oz45numLfH/pVXallKdAD74jIpOhHQiZgJ26gRiPJhxsUqBaW61mOULeN2
	VqWVk8ezofSx+cnGJU+X5gnO8K1hfPetn2Q6RfKoaewMyVJRcR89s5lMQfLt65HBSfSp11MIqYe
	Ft6QqHRNvkcHW6Bw2YcHhaM=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4jJbVD4hjPzKmVr;
	Tue,  3 Nov 2026 12:40:36 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 86D4140586;
	Tue,  3 Nov 2026 12:40:41 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 kwepemk300003.china.huawei.com (7.202.195.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 3 Nov 2026 12:40:40 +0800
Message-ID: <68fe0706-733d-4ba4-9420-107b70e8b8dc@huawei.com>
Date: Tue, 3 Nov 2026 12:40:39 +0800
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iomap: allow writeback from kswapd again
To: Yiqing Wu <wuyiqing@cmss.chinamobile.com>, Christian Brauner
	<brauner@kernel.org>
CC: <gfs2@lists.linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Shakeel
 Butt <shakeel.butt@linux.dev>, <linux-xfs@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<syzbot+5e659793378ad9e06387@syzkaller.appspotmail.com>
References: <20261103023804.8074-1-wuyiqing@cmss.chinamobile.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20261103023804.8074-1-wuyiqing@cmss.chinamobile.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk300003.china.huawei.com (7.202.195.93)



On 11/3/2026 10:38 AM, Yiqing Wu wrote:
> Commit ff59f71f1c95 ("iomap: simplify writepages reclaim guard") removed
> the PF_KSWAPD exemption from the iomap_writepages() guard on the
> assumption that kswapd can no longer reach filesystem writeback now
> that pageout() returns PAGE_ACTIVATE for non-shmem, non-anon folios.
> That assumption only covers the folio reclaim path.  kswapd can still
> reach filesystem writeback through the inode shrinkers, and syzbot
> reports exactly that on GFS2:
> 
>    WARNING: (current->flags & PF_MEMALLOC) in iomap_writepages
>    kswapd -> balance_pgdat -> shrink_node -> shrink_slab
>    -> super_cache_scan -> prune_icache_sb -> evict
>    -> gfs2_evict_inode -> evict_linked_inode -> gfs2_log_flush
>    -> gfs2_ordered_write -> filemap_fdatawrite -> do_writepages
>    -> gfs2_writepages -> iomap_writepages
> 
> Under memory pressure kswapd evicts GFS2 inodes whose glock is still
> dirty, and gfs2_evict_inode() -> gfs2_log_flush() ->
> gfs2_ordered_write() then writes back the ordered data of every inode
> on sd_log_ordered.  This is long-standing, intentional behaviour: in
> the default data=ordered mode GFS2 must flush dirty data before the
> log commit that writes the metadata.  Writeback from kswapd has been
> explicitly allowed since 2010, when the guard was still in XFS:
> commit d4f7a5cbd544 ("xfs: allow writeback from kswapd"), because
> the kswapd stack usage is low and it cannot deadlock on the
> filesystem.
> 
> Beyond the noisy warning the new guard is actively harmful: it returns
> -EIO on every hit (WARN_ON_ONCE only limits the report), while
> gfs2_ordered_write() ignores the filemap_fdatawrite() return value, so
> the log commit proceeds with metadata even though the ordered data was
> never written, breaking the data-before-metadata ordering guarantee of
> data=ordered mode.
> 
> Restore the historical semantics of the guard using the
> current_is_kswapd() helper that replaced the PF_KSWAPD flag: warn about
> and refuse writeback from direct or memcg reclaim, but allow it from
> kswapd, as was the case from 2010 until ff59f71f1c95.

I only considered the folio reclaim path and missed that kswapd can
still reach filesystem writeback via the inode shrinkers, thanks for
your fix.

Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>

> 
> Fixes: ff59f71f1c95 ("iomap: simplify writepages reclaim guard")
> Reported-by: syzbot+5e659793378ad9e06387@syzkaller.appspotmail.com
> Closes: https://syzbot.org/bug?extid=5e659793378ad9e06387
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: gfs2@lists.linux.dev
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: linux-xfs@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Yiqing Wu <wuyiqing@cmss.chinamobile.com>
> ---
>   fs/iomap/buffered-io.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index d6e2f1ded5ca..324da0f5cb29 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -2082,7 +2082,7 @@ iomap_writepages(struct iomap_writepage_ctx *wpc)
>   	 * Writeback from reclaim context should never happen except in the case
>   	 * of a VM regression so warn about it and refuse to write the data.
>   	 */
> -	if (WARN_ON_ONCE((current->flags & PF_MEMALLOC)))
> +	if (WARN_ON_ONCE((current->flags & PF_MEMALLOC) && !current_is_kswapd()))
>   		return -EIO;
>   
>   	while ((folio = writeback_iter(mapping, wpc->wbc, folio, &error))) {

