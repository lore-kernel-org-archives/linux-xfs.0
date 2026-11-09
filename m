Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.152
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794236461;
	b=nvsxu25ahdOCBJXIoukZ304Z0gZyg9xt77IHsm+BCZIfzpmsGCMy+ZWun8N00+ybu30r
	 j+jCOvS+H4rDIcZrAG58iW4L93lsLEtooT9EKU3b2cod3Ynm0Ya/8HYf+Bg9eJzjYSj6W
	 SLvYWLvRtwT99HWfhKp0hqzQ5H/X8UNugX6zxrCJLDoLieffN4x5tOwp1VNdDaXer5xB2
	 I668sGywI9knryXt0/W2GNnQ/Ff9dZAwQMrVkHb5yE/Y2Qc5Tx8lgp9W24BdxChdZc2u+
	 e6/wqK505n+8rQ6dDN2/e6ckiLM38gY5Sgbi7eI8tgDHfx6lP9M4wr92zg2Fg1B1sAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794236461;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=t6HKgMz0rlrDWzJh5UQqQ6u/n93e6MBMruPVrER9q5M=;
	b=WEuhNmVhIp/qVCtPArNY+/2JKv2MnPuNO1+5j3OJU1bmf6bBIA7fk5AJvumPMnMUZEtX
	 1DB5KE547u7cSexPlRiozi+wRXW2uii7mI+6G5wf+BJmYVTb80MmM/RQYzHhi3NuMz0Mi
	 z8A8x8C/QW+GLGmsHIpMo/a63E9NH6rj9VjEcgkUANKFj1qJney9BmwvUjrO9OInNuoW9
	 g7zmgGbohA+KWSgpJQvZd+wUdE52pxJCHdCGC2+kHomS04uO0VacV5fywSJ5PSW7fAM0J
	 nOo4TGiIrl9cl0krH/LZHDTHx38hE928u9zv4NB1F0m+Pj3P4DvqUdqe11vK7SaN98Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=sandeen.net;
	spf=pass smtp.mailfrom=sandeen.net;
	dkim=pass header.d=sandeen.net header.i=@sandeen.net header.a=rsa-sha256 header.s=fm3 header.b=IKpIopw4;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=zMRwF5PA;
	arc=none smtp.remote-ip=103.168.172.152
Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F0B606A325
	for <linux-xfs@vger.kernel.org>; Mon,  9 Nov 2026 15:01:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10F0B606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sandeen.net header.i=@sandeen.net header.a=rsa-sha256 header.s=fm3 header.b=IKpIopw4;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=zMRwF5PA
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 6933D140016C
	for <linux-xfs@vger.kernel.org>; Mon,  9 Nov 2026 10:01:00 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Mon, 09 Nov 2026 10:01:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1794236460;
	 x=1794322860; bh=t6HKgMz0rlrDWzJh5UQqQ6u/n93e6MBMruPVrER9q5M=; b=
	IKpIopw4RrQqABpKg7YmZHEiJBSUS9yy/9VLuKbm6UUvy+lzb/WdxFe+4GMvt7Jx
	6AW6TIw0me551gk3fTFUKxMWN2O7Z/EDC3clCdpc6XXvqKRdgCQrQ7W5qdRRosSU
	OM6r7/OwUJewAiue2MeVMFQ07xQaC4/SDYNSMzPcok71pQeBNWvK3Y12D3qCx86Z
	+3HIAyFQlkCjTSAltSa5QaMsoK3jnr2jx3q6hYYvpeoVaeUjr2LF3eOHmSdOM/VG
	odVQVaTWvn5xqXu+Nilt2NuA1npt86BujBhmwUgnBZzDvcSaowoaCi1W7nOhexTx
	fgZLvY6aT/xm5c94gAroqQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1794236460; x=1794322860; bh=t
	6HKgMz0rlrDWzJh5UQqQ6u/n93e6MBMruPVrER9q5M=; b=zMRwF5PAr8IqpNROt
	4p9skQ4c11sYho+Zn7GvzugZntqMs+dfnMWX/060zcyVKQQlBZaJPl3qKAkHzgV/
	ugMlG2UQ3V59Ets+oNryLoWeCi1b1t6UaZQsj2EllYitpW7CrC5n9QH1wrGW0Z30
	UqKipMQF2seI/pHaKlbI88H7xModubOsowothgohuq7KV3wa5wI3l/ldB/wkidSc
	YtYw1ymUPe3noWn7fybR7yWEFnBi+IEbcfSkhT8IhNpiLV2q6LpVn67c+7Eu9Zkt
	9UQpeqDd6Tshpt6HGpM05ki0pERU9KhA0nFLE9PxF0tvb1gqDWOjo5smTyT1emUi
	XtxKA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=sandeen.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794236460; d=sandeen.net;
	mf=PHNhbmRlZW5Ac2FuZGVlbi5uZXQ+;
	rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm3:rsa-sha256:KRv2onY37Bzkt6nhXJlTeNhOfVvnFh+9bTv+h0q4XvdxqIp
	gLmBsh1JAdRhjTlKX6BI6cHI+uv90D9Vp50Rcj9pk78QKNxzS81K2vTlEuxrZQfB
	ACUFoX1NK64o3g53X0fl31uqGQyoBeJZ6dYhu/JKUbaWjk8S/Y48SFiuV9c5L40x
	AvEpIbm7mqmeVD2l/T+Ee93EbjIUu4x4Iyn64y0YsYxgRHvitbSXcUkb3i+DpR6X
	VUOKI4c29NApRu2SEHuiqLKBxbLm5iqe2/3ZwY08WK8J7XiRrl/x++ik/mWcJfVN
	dHYb6AUw1BR4piVZhL+TolLOgchVuxxEpKuC89w==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=13;
	hn=content-language,content-transfer-encoding,content-type,date,
	feedback-id,from,in-reply-to,message-id,mime-version,references,
	subject,to,user-agent;
Message-Instance: m=1; h=sha256:eK4iClFrhJlkuKh7LIvj/PFDr0lQ69hSsHonSH7uqCc=:OEiYVCbPKVHalA/bk11W5IgB31QlGLIq5YAYtb3WVsI=;
X-ME-Sender: <xms:LODxamio53k9Bl5nxux4pTiDz87HyQd0-qb1GWEauA4MzbR7EU9-GA>
    <xme:LODxat84cB9TZGQugRmpGdyyEuLF9rvVv-gCgkWVcWvAg9TUMP2FGGeZBTDqxxP6z
    m_VKIe58dtzaA9rQ9mpypW-AgutdAGoKaObCiGeZfBOyGQ0a08JHEI>
X-ME-Received: <xmr:LODxajv8loFfBNbYWHGMVgGhrBcgCAwNVCP7zldO2EMkryWisZcKU4AW8k-HzVTPckYeRSUmVWPHhgbhMgne3Q>
X-ME-Proxy-Cause: dmFkZTFhs/uWzabuCbyVSrUa7msUYwqx77HBzeDwOlW5esL9UNrnZEBUN/tJRyZQOxQ6aB
    anQGRgwwwT9Yfy+3f8QJ98ctFV5DKvk/XDsKfQSmYCX6gDF1LMS21zssRlS5vUBXquRkWT
    +jEFmreuThfiE6MCubn5bwMAe2pSD2H0dwJOaX1sfeNU1TqzvWAhAxKCWdXsLYFO4Cx3zz
    D2UL0kg8xgE7wZRKchvUiatguVBJ+u4cX1CLtXq3LivJyLVjFus+eVaNO2LUcnJ7sTJ+J8
    zUjk7Xt9eg8sB8OB6uA6PNXQ9gxZA4TGq1H8sAz6v8j4BkodmNHUD4kE0QpE+yerXA7Afy
    3kXO5Zwcn7hDcjPSVoopFa/VDanhRcYRJvZubWUtyTRUOfLByiZGHbfByKepiKgv5KKltL
    6JL9cqCpzmNYgnaXhop/a2eGcPNMlvryCBCKFLxO7bV+Gk5vAVZXJUMZxs5LEKDbKF6rik
    HqWehIIYJ+tTWUdlIVac+hOjjBkdzn9f+TTxo10nmBNZHtoRLPqVmp8Swsk4L+paSUFKCf
    sY8T9ZFGBB9EOcIvL6y10hvaQdHgOZ2+r1cAUXyUbsE8+D6zFuP2MVJysHIlQB2q/vcgb7
    cwrhtLxY2kite5WwDS1sGwQMh4t2aH1Eu2J9dJtYfPg9Hp9FMOO+84x+Nw/Q
X-ME-Proxy: <xmx:LODxakbov-ynp5rPiHf7UurUaTxp7L3n88ZthPbyy0gScTXmiN8OxA>
    <xmx:LODxajq_Ea4BNTcjfY8l2iIFFcCoJUH-Onk6Mh9GcvcDFAHgEtYvhA>
    <xmx:LODxap90f2aMQTw3LaDOD0oxwhD_P7iV6IdG9VyWy8XyI6zDMOYiwA>
    <xmx:LODxai-Lnprl3HWZsU4VdrpTwba95Ku0rT0InWB-zEmQGoeSw_dd0Q>
    <xmx:LODxajjVNn4VlIoG_Xz0ahtiA_TLuxyHNy7oO4x_NfDA5R6hu3hQTNcc>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <linux-xfs@vger.kernel.org>; Mon, 9 Nov 2026 10:01:00 -0500 (EST)
Message-ID: <787673a3-7149-4d7b-97bc-028678837e46@sandeen.net>
Date: Mon, 9 Nov 2026 09:00:59 -0600
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
Subject: Re: xfs log recovery: six distinct issues, one per report (index)
To: linux-xfs@vger.kernel.org
References: <tencent_F39A283F1F83A8B954C5EFE09123A72F5307@qq.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <tencent_F39A283F1F83A8B954C5EFE09123A72F5307@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Perhaps you can test your reproducers against the

[RFC] [PATCH 00/48] Validate journal log items during log recovery. 50 messages 

series which is on the list?

-Eric

On 11/9/26 8:00 PM, Guikun Yang wrote:
> Hi,
> 
> Between 2026-11-07 and 2026-11-09 I sent six separate reports about
> log recovery in fs/xfs. They were posted as replies under one subject
> line, which was a mistake on my part - they are independent defects,
> each with its own root cause, its own reproducer and its own fix. This
> mail is an index so they can be handled one by one; no action beyond
> that is implied.
> 
> 1. XLOG_WAS_CONT_TRANS with no buffered region reads ri_buf[-1]
>    native NULL deref at mount, no sanitizer needed
>    Message-ID: <c30-xfs-wascont-rideref-20261107@qq.com>
>    fs/xfs/xfs_log_recover.c, xlog_recover_add_to_cont_trans()
> 
> 2. Logged superblock geometry installed without validation
>    UBSAN shift-out-of-bounds via sb_inopblog
>    Message-ID: <c31-xfs-logged-sb-geometry-20261107@qq.com>
>    fs/xfs/xfs_buf_item_recover.c, xfs_sb_from_disk() +
>    xfs_update_last_ag_size()
> 
> 3. ilf_len used as buffer read length without requiring whole blocks
>    KASAN slab-out-of-bounds in xfs_inode_buf_verify()
>    Message-ID: <c34-xfs-ilf-len-oob-20261108@qq.com>
>    fs/xfs/xfs_inode_item_recover.c:351
> 
> 4. ilf_size read from a region shorter than the format header
>    KASAN slab-out-of-bounds in xlog_recover_add_to_trans()
>    Message-ID: <c37-xfs-ilf-size-short-region-20261109@qq.com>
>    fs/xfs/xfs_log_recover.c, region collection stage
> 
> 5. Buffer data map runs index ri_buf[] unchecked in
>    do_inode_buffer()
>    KASAN slab-out-of-bounds in xlog_recover_do_inode_buffer()
>    Message-ID: <c40-xfs-inodebuf-item-index-20261109@qq.com>
>    fs/xfs/xfs_buf_item_recover.c:625
> 
> 6. The same unchecked source index in do_reg_buffer(), with the
>    destination side already fixed by CVE-2026-80536
>    KASAN slab-out-of-bounds in xlog_recover_do_reg_buffer()
>    Message-ID: <c41-xfs-regbuf-run-index-20261109@qq.com>
>    fs/xfs/xfs_buf_item_recover.c:464
> 
> Separately, ilf_boffset (report of 2026-10-31, bumped on 2026-11-08)
> still has no bound and is a distinct issue from the six above:
>    Message-ID: <x1-xfs-ilf-boffset-20261031@qq.com>
> 
> All seven reproduce at mount(2) from a crafted image, are deterministic,
> and are unchanged in mainline as of 2026-11-09. Reproducers are
> available on request. Happy to send any of them as a patch series
> instead if that is preferred.
> 
> Thanks,
> Guikun Yang
> 
> 

