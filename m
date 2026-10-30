Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793322449;
	b=A9QdVH51i3fj93CYCuRnk6QVcZ9Mkn8cFjw3lg+EfLP37akEKce+Ue69SNGWVGsLT61Q
	 SvZRFMj53vlgtZaL7V8+oDPkPdU1B1TcHeeD1w0Ib5thzaCjxCOGQ26iZrgEfuQXMAd/T
	 cYBfuFRYpidIhtBajDhdzU9CMp8JvEJJ7LO83cd4EOKHaLM+Xj8dbN9ZbddJ1QFOqu0/G
	 GDVkhTmveNXqEW1WEhSerHhQCQw2s2/a0z3b7ugIlyT65ISzK5/cqhb3HrKPlVXWE3rzP
	 7uvrSGs8Lwk02x1mmhnV5Dbry+ON7rZJrfhX5EWF/lJT6xbfUj6+YMh8jGyanyl/q7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793322449;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=PZrFme8Z9ERkoIaIGLnSAqVdeuU7p1Vpb8U9cUCLBTg=;
	b=YeBSsl050FlRwg39Hncpl1rMQGguN/5Ak48O4AtgTQrddDsnFovdiOzVvTi3r8FkzkgE
	 +nrbI0j5W54f3XmwPRjhgNohvzOZh0qGsFpQU+aPqlIDK6yGJu9/I/SRCJrKp/e1/vTsn
	 8J2eHmzsTmBmKkdBYVm3C8MaxkvD08lHfQBs06iLBRqfEKlpNyZuex8vc9JDeJe7k23th
	 L5swiNSmvGe3++H/WbVl2M1hUJE8r41phGcnoW2C9Nu4WXg6zBLYKIP+FGaRcS72U+tCJ
	 M1JCr1mmuloobNetHjBgxoEuoL/DqXBRsLfK+hTj2BdPCN+h67q4+PMP47twqUEL7hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.112
Received: from dggmsgout12.his.huawei.com (dggmsgout12.his.huawei.com [124.71.93.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEB7606A31C;
	Fri, 30 Oct 2026 01:07:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DEB7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggmsgout12.his.huawei.com (SkyGuard) with ESMTP id 4jG2xf4xphz1ygS;
	Fri, 30 Oct 2026 09:07:02 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E4CB840657;
	Fri, 30 Oct 2026 09:07:18 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCn5fTF7eNq3yxsCQ--.62529S3;
	Fri, 30 Oct 2026 09:07:18 +0800 (CST)
Message-ID: <cddab9e4-0b57-40c3-a38b-34c738254f87@huaweicloud.com>
Date: Fri, 30 Oct 2026 09:07:16 +0800
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
Subject: Re: [PATCH 1/2] iomap: don't mark unwritten parts of a folio uptodate
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 Chris Mason <clm@meta.com>, Josef Bacik <josef@toxicpanda.com>,
 Matthew Wilcox <willy@infradead.org>, Joanne Koong <joannelkoong@gmail.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Brian Foster <bfoster@redhat.com>,
 linux-xfs@vger.kernel.org, stable@vger.kernel.org
References: <20261029-work-iomap-ai-fixes-v1-0-7eda63bc1b13@kernel.org>
 <20261029-work-iomap-ai-fixes-v1-1-7eda63bc1b13@kernel.org>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20261029-work-iomap-ai-fixes-v1-1-7eda63bc1b13@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgCn5fTF7eNq3yxsCQ--.62529S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAF4kGF1DJw4fGr18CrWktFb_yoW5CrWkpr
	Z8Kayjkrs7tr17Zwn7ZF9rAry0yw43Wr43CF18G3s8Z3Z0qrWxWr1vgayYvF18ZrZ7GFWF
	qF4v9Fy5W3W5ZrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6x
	kF7I0E14v26F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAq
	x4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6x
	CaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I
	0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWU
	tVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcV
	CY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAF
	wI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa
	7IU17KsUUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 10/29/2026 6:34 PM, Christian Brauner wrote:
> For a buffered write into a hole, an unwritten or new extent, or past
> EOF __iomap_write_begin() zeroes the parts of the blocks outside of the
> write and then marks the blocks uptodate. That includes the range of the
> write itself which still holds whatever was in the folio before. It only
> becomes valid once the copy from userspace has filled it in.
> 
> But the copy can come up short and __iomap_write_end() only rejects a
> short copy if the folio isn't uptodate. If the zeroed blocks were all
> that was missing the folio is uptodate by then, the short copy is
> accepted, and the rest of the range is exposed to readers and can end up
> on disk. A source buffer that ends in an unmapped page is enough:
> 
>         ftruncate(fd, 4096);
>         pwrite(fd, p, 3000, 100);    /* 16 bytes at p, then PROT_NONE */
>         pread(fd, buf, 4096, 0);
> 
> The write returns 16 and the read returns 2984 bytes of whatever was in
> that page before. If other blocks of the folio aren't uptodate the short
> copy is rejected but the zeroed blocks keep their uptodate bits and the
> retry with the copied length leaves the same bytes behind.
> 
> Only mark blocks uptodate in __iomap_write_begin() after reading them.
> __iomap_write_end() marks the zeroed blocks uptodate once the copy has
> succeeded and rejects a short copy.
> 
> Willy reported this back in 2024 (cf. [1]) and Zhang Yi posted the same
> fix (cf. [2]) but it never got merged.
> 

Ha, thanks for picking this fix back up. I had missed this patch while
sending the iomap fixes.

> [1]: https://lore.kernel.org/all/ZqsN5ouQTEc1KAzV@casper.infradead.org
> [2]: https://lore.kernel.org/all/20240812121159.3775074-6-yi.zhang@huaweicloud.com
> 
> Fixes: 9dc55f1389f9 ("iomap: add support for sub-pagesize buffered I/O without buffer heads")
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good to me.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>  fs/iomap/buffered-io.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 907873073b03..d6e2f1ded5ca 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -920,6 +920,7 @@ static int __iomap_write_begin(const struct iomap_iter *iter,
>  		if (iomap_block_needs_zeroing(iter, block_start)) {
>  			if (WARN_ON_ONCE(iter->flags & IOMAP_UNSHARE))
>  				return -EIO;
> +			/* uptodate once copied, see __iomap_write_end() */
>  			folio_zero_segments(folio, poff, from, to, poff + plen);
>  		} else {
>  			const struct iomap *iomap = iomap_iter_srcmap(iter);
> @@ -943,8 +944,8 @@ static int __iomap_write_begin(const struct iomap_iter *iter,
>  
>  			if (iomap->flags & IOMAP_F_ZERO_TAIL)
>  				folio_zero_segment(folio, to, poff + plen);
> +			iomap_set_range_uptodate(folio, poff, plen);
>  		}
> -		iomap_set_range_uptodate(folio, poff, plen);
>  	} while ((block_start += plen) < block_end);
>  
>  	return 0;
> 

