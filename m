Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794620798;
	b=4i5QX92CE7jzh8rviVJFyIbVOnnHzs+gyAsamWE7PL5P/XasHf+AiQsSP+Az6GWYTy20
	 Mq/EE0xlDEXzbiBmwLertZYgAjWrr9Q/IQtmWA0JKxsYJoGGGXQIQItyDb5zPp8jpzpFd
	 BW2ozMD4INwF0B8N5+7N5uCkzCwyKjeon6L5+LGjlRyMtelnUgal1YDgVjr7Bwo0brSy6
	 o9mHgOdncO9idE7Kfw+AIQqzj4l8+BLRWGCWdYenGSnn2Po1hdblsu4JF0GHLNI0x54IZ
	 50rBIyGMqx+GilmWmt1054B8aIWj2paS3ijlfWIpnDE1jQJtW03F8v/DF9rbPQId7zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794620798;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=6MXh/y1BidXf3leIHCkcHFW+ILNKZW5M2/kil2iQsmY=;
	b=Ijidbh/8c/GSvlpAAyXpoR0NfyOp7J+rLLT6D249SMBe14x6b91KX0KBctTVxYjUsM6P
	 q2vm9kabGnhAl3ORUDKfNr4RxRqJDEWiil/v3OMTuR3270zkMF7h9VNK6WANlEcif0yPo
	 khN1I0pO6fbAXfajqsG8A3G3Xv/i99ZschItFiNHbLOajhRF6dgU1XQWEGSaLsz3C6V1Q
	 6h0bHV1SudDnW9zZxAX4x6PiyoNF7iBsm/iNDOz5AWUmpitILlj89f20yuoAchNwrH1np
	 FDPC2rP1zJJqYrHqL4A7SraVXCkfuGVPt7+JeGV1icGnN0ecoSsrEGa1Ewzo+P7gklA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=sandeen.net;
	spf=pass smtp.mailfrom=sandeen.net;
	dkim=pass header.d=sandeen.net header.i=@sandeen.net header.a=rsa-sha256 header.s=fm3 header.b=gKpCWELf;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=gDiWDJNh;
	arc=none smtp.remote-ip=103.168.172.139
Received: from flow-a4-smtp.messagingengine.com (flow-a4-smtp.messagingengine.com [103.168.172.139])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70102606A889
	for <linux-xfs@vger.kernel.org>; Sat, 14 Nov 2026 01:46:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70102606A889
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sandeen.net header.i=@sandeen.net header.a=rsa-sha256 header.s=fm3 header.b=gKpCWELf;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=gDiWDJNh
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.phl.internal (Postfix) with ESMTP id A513D1381988
	for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2026 20:46:34 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Fri, 13 Nov 2026 20:46:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1794620794;
	 x=1794627994; bh=6MXh/y1BidXf3leIHCkcHFW+ILNKZW5M2/kil2iQsmY=; b=
	gKpCWELfj8H1dVMzus6dBv7KtrgTnGqpXt6OnQabT4/eewoNxYo6xtOnufmhhBii
	s1/40ks+qeob7RJ1uIjrRQr22uGIAdR5Uu6iRmQR2mwPlhLNt84w+cxKcUuh1Z+5
	RvYNyH+5GHbqN8ReswTVj4BwQlrIHFokmJuH8OTmbuO3jaQkObhtu4sky2rdN+pX
	EGNlanaTZHk3LAtjsPi6HXxSg8oKAK685f+7SKtdKgSMsamHNb72qzT8oCnrWT7P
	sHCeuTlt1zEFNXXMEjAXHJd5CJlL/ouwQ+1EqriQiVAHMqumtdfyOTaLJZAmMgat
	af6PU4M3MWnZugC6XOrZiQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1794620794; x=1794627994; bh=6
	MXh/y1BidXf3leIHCkcHFW+ILNKZW5M2/kil2iQsmY=; b=gDiWDJNhGRAQkRob+
	hjZnKPtOlRxIUuGyJLsc8odi8eqmpiTQ6ZkfXzgs5cF/tmf+oaYPHPDT2xQoGtug
	3CjAs1J3uM085y3thTinGaXKOKWIpHPa/pEaoY+ZdNUiejMdAbXTjnRyqaZi5fh6
	AQmt/soeIMa2D1LZADxIfSEvRnINiXlI3pvwK4MmWrvijJ43d2xfZZh0IumnCgYU
	xUDanaKpjV7sg4WqE9N2Ln+xiZUCq0pbxrotEgJP6VhgUXhjU9CP6MrCxivHUYGz
	9uBiYYOFp+hfywF9pyVrVMffb9DZYgGj0P0Owm6gKiUM6JPCT8EyTies2sr3ZH1H
	kkLUQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=sandeen.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794620794; d=sandeen.net;
	mf=PHNhbmRlZW5Ac2FuZGVlbi5uZXQ+;
	rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm3:rsa-sha256:Bn+Q4n4dWdYL01C6B6/4KPxdea/jUyypkHkKUdjVu5v0e1v
	e0qxeevRGoApFLvMzcp70EwYGmhZhwNda9JliPdpXqwk65/4dMdQaZIeAFDMWcgp
	fIEzcKfUnSRsDdXiisb9XuampBbpvRFqCFTA61LUHL7TTem7bQsqFNUHmsqVfgHQ
	Wjh7f6Ldwd/I67dgGcOt1rNfE8ZIZAscxiG1JGPU5es4IM3YyoKAnwRjoSdOWq+1
	HDBXY9/lEyHwuAsdXOdGFDj/+gnSBVS4iAGEX/RT0LjWGg8uddqCNS9qD4/J6RyU
	qRkB/tzzPMQzRWrILJPXjCxF782cM2wqn3UpiNA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=13;
	hn=content-language,content-transfer-encoding,content-type,date,
	feedback-id,from,in-reply-to,message-id,mime-version,references,
	subject,to,user-agent;
Message-Instance: m=1; h=sha256:GKh62SahXT0elXdvl2F83iYf83YKjgVy1qON8iSuxBw=:BHQ/RL4bD2u1whCeQX4UzRm/Y81MkEUBE7mMmvwxlwA=;
X-ME-Sender: <xms:er33aoJwaM-gn6h1nlF9Suk97HdWnEESrYVs7_Rn1g2rnPfIC4Kosg>
    <xme:er33avHHBD9XH7kYprMFRjvIykftAUAL8bqFXcvLheULJKCPqe98yFrqJLoqBoQae
    EinXpwHo70lwZqhBG1NAqT0sFtZvVyk9iyeO5ZTHIc_EXfEY5kns-Bu>
X-ME-Received: <xmr:er33auUS-uz-JZ9Ua1eUlJvpeG3eQ1glklLYZP1kGB6G0l-1vDXT1p1rjvC-5dp_jYG77DpyTh54EfNb6z_8AA>
X-ME-Proxy-Cause: dmFkZTEGoyDVCBXSyGkYDJv6e2U2M7HBTpe2HQC0e0SSbIpBI7dHuVoaoRS/JspsA6i52t
    mNGs3/o31A6YZXeWRrW1U91KeY+m3MF0rW3OcS0hQhisdMT7TWe4IDdRYYjwJcYsi/FDqL
    FnKjyHamDCWLIIvbkDEfbuGu+WmmNTwOY6VXHUYcNXq7I5uUkhK1d5Wjb8cf6/s/IVLC2C
    lB1M9IvjWROufAnSavVps2bmeoMyT5jH8A77mB5m3fXKMI76zooBAVRFPR2eqjUHJUvbbf
    kjIlTAir6+LvgDKOmaTaInaLHDAHIo4dNMy2lYtN2qiYkqT0lkjIMsT/Bsy6o6V9oEY7pZ
    Nz2wxt/P/JbpjH3Dm+Z/CSrIRKUz/D0tCIPBZPEfKDEZ6RDw9Ws4apyHeI6w/IRPZ3uumh
    UD9JONtIkxhkJ0Mnx1dpXPjStgyfsE5jp2DgiUg1ARinb8teTk/tpWTR9BM78JfNG2qkpD
    p0Cg7oOf3m9bShgOdtqPQuIIRFKb2FVw4lyWg19IJAfJwHhHaGGd9g/UcWf/kEhHeqexrK
    ZRGJiXCYhb992SBoYCXtSlLHFC+LeX76TyJN0WdBTt24jCnPinWF8OD9NzUkLbBIEYyABz
    CltBz1F4opnD4i6418zcxfu4y6PQoDcGsCwN4c2byNwuKpM4fsgAPKswvUhA
X-ME-Proxy: <xmx:er33aqhKBf2E5PyLmfONc7wE7ZwQum58xU0HcW_8_-vkpQ5cvB_KEA>
    <xmx:er33avSuWKCPJ_M-ZLAcaN_Vm3w-6BS1jOb2LER4Wm5_ltmBmYzgFg>
    <xmx:er33atGijJXh8wTMRlZYfmpmVrPe4EQpw6kR6pw2I4be9hN7QLg7kQ>
    <xmx:er33anki1GxR1tmjbgPzoFqz-5X-u05DTwCr0VmFq59P9eCznBAkug>
    <xmx:er33asLwuQ_LZRT9i9IOXmVQ02-NuhmmUv3BXiciW1sAi2oEfnRXAPwp>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2026 20:46:34 -0500 (EST)
Message-ID: <84fd7775-d64c-4d3d-b83b-226fc170ff4e@sandeen.net>
Date: Fri, 13 Nov 2026 19:46:33 -0600
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
Subject: Re: [PATCH] xfs: validate dquot buffer geometry in dquot log recovery
To: linux-xfs@vger.kernel.org
References: <20261113110128.4001610-1-hdthky0@gmail.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20261113110128.4001610-1-hdthky0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/13/26 5:01 AM, Xingyuan Mo wrote:
> xlog_recover_dquot_commit_pass2() has never really validated the dquot
> log item. The only check on qlf_len is a DEBUG-only ASSERT, and
> qlf_boffset goes straight into xfs_buf_offset() to pick the dquot slot
> inside the chunk buffer:
> 
>         dqb = xfs_buf_offset(bp, dq_f->qlf_boffset);
>         ...
>         memcpy(ddq, recddq, item->ri_buf[1].iov_len);

There's a large patch series on the list already, which contains the patch:

[PATCH 30/48] xfs: validate dquot items during recovery

Can you run your test case against that series, and if it passes, perhaps
give it a Tested-by:?

-Eric

> Both the offset and the length of the memcpy come from the journal of
> the filesystem being mounted, so a crafted log can make mount time
> replay write past the end of the chunk buffer. Sub-page block sizes
> get an exact-size kmalloc for the buffer, so an offset of one blocksize
> lands right on the KASAN redzone; larger offsets are wild writes. On
> CRC filesystems the dd_lsn load in between is out of bounds too. The
> recovery regions are allocated to the logged length, so a short region
> 0 also turns the qlf_* dereferences into out-of-bounds reads.
> 
> Make this code validate the item like the rest of log recovery does:
> both regions must be exactly the expected size, qlf_len must be 1, and
> qlf_boffset must point inside the buffer that is about to be read.
> The readahead path gets the region length and qlf_len checks too.
> 
> I reproduced this on a v4 filesystem with 512-byte blocks and user
> quota enabled: force a few dquot transactions into the log, crash the
> box so they stay dirty, rewrite qlf_boffset of the on-disk XFS_LI_DQUOT
> items to 512 (one block past bp->b_addr) and mount. Without the fix,
> replay trips KASAN:
> 
> BUG: KASAN: slab-out-of-bounds in xlog_recover_dquot_commit_pass2+0x32a/0x500
> Write of size 104 at addr ffff88801c8b0200 by task mount/430
> CPU: 0 UID: 0 PID: 430 Comm: mount Not tainted 7.4.0-rc2-00021-gb3dfbde62cf1 #44 PREEMPT(lazy)
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x73/0xb0
>  print_report+0xd1/0x610
>  kasan_report+0xff/0x130
>  kasan_check_range+0x10c/0x1c0
>  __asan_memcpy+0x3f/0x70
>  xlog_recover_dquot_commit_pass2+0x32a/0x500
>  xlog_recover_items_pass2+0x7d/0x1b0
>  xlog_recover_commit_trans+0x585/0x630
>  xlog_recovery_process_trans+0xe2/0xf0
>  xlog_recover_process_ophdr+0xf8/0x1d0
>  xlog_recover_process_data+0x126/0x270
>  xlog_recover_process+0x132/0x210
>  xlog_do_recovery_pass+0x6be/0x8f0
>  xlog_do_log_recovery+0x65/0x90
>  xlog_do_recover+0x7d/0x2b0
>  xlog_recover+0x1bc/0x2d0
>  xfs_log_mount+0x17b/0x2c0
>  xfs_mountfs+0x70a/0xe70
>  xfs_fs_fill_super+0xaca/0xf60
>  get_tree_bdev+0x14/0x20
>  xfs_fs_get_tree+0x19/0x20
>  vfs_get_tree+0x54/0x170
>  path_mount+0x4ad/0x13a0
>  __x64_sys_mount+0x1dd/0x210
>  do_syscall_64+0x10b/0x5f0
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>  </TASK>
> 
> With the fix the same image is rejected without any out-of-bounds
> access, and a pristine dirty log still recovers fine:
> 
> XFS (loop2): log mount/recovery failed: error -117
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Xingyuan Mo <hdthky0@gmail.com>
> ---
>  fs/xfs/xfs_dquot_item_recover.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
> index b8854316ac756..3172efb94c277 100644
> --- a/fs/xfs/xfs_dquot_item_recover.c
> +++ b/fs/xfs/xfs_dquot_item_recover.c
> @@ -47,7 +47,9 @@ xlog_recover_dquot_ra_pass2(
>  
>  	dq_f = item->ri_buf[0].iov_base;
>  	ASSERT(dq_f);
> -	ASSERT(dq_f->qlf_len == 1);
> +	if (item->ri_buf[0].iov_len != sizeof(struct xfs_dq_logformat) ||
> +	    dq_f->qlf_len != 1)
> +		return;
>  
>  	xlog_buf_readahead(log, dq_f->qlf_blkno,
>  			XFS_FSB_TO_BB(mp, dq_f->qlf_len),
> @@ -84,7 +86,7 @@ xlog_recover_dquot_commit_pass2(
>  		xfs_alert(log->l_mp, "NULL dquot in %s.", __func__);
>  		return -EFSCORRUPTED;
>  	}
> -	if (item->ri_buf[1].iov_len < sizeof(struct xfs_disk_dquot)) {
> +	if (item->ri_buf[1].iov_len != sizeof(struct xfs_disk_dquot)) {
>  		xfs_alert(log->l_mp, "dquot too small (%zd) in %s.",
>  			item->ri_buf[1].iov_len, __func__);
>  		return -EFSCORRUPTED;
> @@ -110,13 +112,22 @@ xlog_recover_dquot_commit_pass2(
>  	 */
>  	dq_f = item->ri_buf[0].iov_base;
>  	ASSERT(dq_f);
> +
> +	if (item->ri_buf[0].iov_len != sizeof(struct xfs_dq_logformat))
> +		return -EFSCORRUPTED;
> +
>  	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id);
>  	if (fa) {
>  		xfs_alert(mp, "corrupt dquot ID 0x%x in log at %pS",
>  				dq_f->qlf_id, fa);
>  		return -EFSCORRUPTED;
>  	}
> -	ASSERT(dq_f->qlf_len == 1);
> +	if (dq_f->qlf_len != 1)
> +		return -EFSCORRUPTED;
> +
> +	if (dq_f->qlf_boffset > BBTOB(XFS_FSB_TO_BB(mp, dq_f->qlf_len)) -
> +				  sizeof(struct xfs_dqblk))
> +		return -EFSCORRUPTED;
>  
>  	/*
>  	 * At this point we are assuming that the dquots have been allocated

