Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274EF33B6F8
	for <linux-xfs@vger.kernel.org>; Sat, 10 Oct 2026 10:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791629213; cv=none; b=rrcwK9vODvfQVcPeTtHHxKw/TS/JpMBXkkpMhdoCRWrIIbMdU60Qthj+EOY5gUGuzh92trmpBkmPAb/8HK2bYXa7bPBVEGhpmfbzZ7N5X/jrBgSJeZCO+1iwXd/qIDqYCch3+2Z/s+aXvTvg/+JPGhlEoifaNwSdhYtbycXk5co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791629213; c=relaxed/simple;
	bh=2OXpxzVaD4amaaPzsJzucI1EvIrqMiN6nv8IkLqcye0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=kC2wZQ7GJBvHZNuH/pzEycmAE8x+hzG2nBFbuDbu+rQzq4sGBHpMz/MSU7CJbvKtedqYoJEjx+PYA8ZLzMaEMpC2NJpQLJhWY28FBEtVzRBFYEFE2oLfupsxup6adBg3RizCWGFB5qMF1K3U0QIf3Bdm9vYcYhaxzDCma7p5ctI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=hic8GV/F; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="hic8GV/F"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=vh09zewHW59fN1iyW+yiOONYdwLM0CM8/IIYK7HEnqQ=;
	b=hic8GV/FOnmmacX8QE+JtdEMzP5eiFtp8p8r3gklVGqfhkFXIoB4rkDkHkfYMBPdFlqHRR+eO
	pMoGE5jtGClcfa8M2SV/0gHwYHXgRV7ryMyPxfDYE1v4XfWXtKOATGGAZpjS6XIb3bnjy1/swJp
	bRJV5X3Ro2R5A7T+Zb+9xKY=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4j20Th2T9CzRhQs;
	Sat, 10 Oct 2026 18:34:32 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 6B5804058C;
	Sat, 10 Oct 2026 18:46:44 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 kwepemk300003.china.huawei.com (7.202.195.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sat, 10 Oct 2026 18:46:43 +0800
Message-ID: <f15d804d-f3d8-433f-97d1-5dfcabcc381c@huawei.com>
Date: Sat, 10 Oct 2026 18:46:42 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next v3] xfs: fix NOFS state corruption in btree split
 worker
To: Carlos Maiolino <cem@kernel.org>, <linux-xfs@vger.kernel.org>
CC: "Darrick J . Wong" <djwong@kernel.org>, Shakeel Butt
	<shakeel.butt@linux.dev>, Dave Chinner <dchinner@redhat.com>, Christoph
 Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>
References: <20260921071030.3214538-1-wangkefeng.wang@huawei.com>
 <179122359071.102066.15509293508787425638.b4-ty@kernel.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <179122359071.102066.15509293508787425638.b4-ty@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk300003.china.huawei.com (7.202.195.93)



On 10/6/2026 2:06 AM, Carlos Maiolino wrote:
> On Mon, 21 Sep 2026 15:10:30 +0800, Kefeng Wang wrote:
>> xfs_btree_split_worker() calls xfs_trans_set_context() and
>> xfs_trans_clear_context() on the caller's transaction, overwriting
>> tp->t_pflags with the worker's NOFS state. When the caller already has
>> PF_MEMALLOC_NOFS set (e.g. xfs_end_ioend_write, xfs_dio_write_end_io),
>> the corrupted tp->t_pflags causes xfs_trans_free() to erroneously clear
>> the caller's NOFS protection.
>>
>> [...]
> 
> Applied to for-next, thanks!

Thank，I checked linux-next's next-20261009, and there was a commit
23f91a51425e, but the code was incorrect during the conflict resolution.
I don't know if this is the correct state for linux-next, just a reminder.


> 
> [1/1] xfs: fix NOFS state corruption in btree split worker
>        commit: 23f91a51425ed3d4a5c42978fc25f1087611e4ba
> 
> Best regards,

