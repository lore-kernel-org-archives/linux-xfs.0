Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4462D610C;
	Tue, 21 May 2024 05:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716267915; cv=none; b=DJ8+p2d7ObPcxgT77ZKnB+/h4giQvGNfB7MA69hHQ2q64NOEQvZR/q2sJxOCaRC9Meb8BF+agX+8C5+8BmGEdySPmdI7De7a0J1WVbEU1C379UkXep6Iqrme5wzsZb7PAijWvJ24HpPTaDM1Xung1yF5mFpOfGEMB2EUxMQJn+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716267915; c=relaxed/simple;
	bh=RP9vcw96CaaKADIQLctJHFBaWOSJ/J3L6fKmt2ShDuI=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=WF8Q0GrGNQD+bfav+OmtaeDz/LVrb5gb31Jn1KgJ0dX1tS9C4/hPODGmW+v8ceTTmvwZ0oxeiia7jCrvqpdjP5TV2yXUxsrQDF3WERA5huBPM+/FLIPEcvl87X9ENMSRcEUaoi3Dsj9c3lnKveeVMSplFZDWes7UzddZ/yJbgp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Vk2Rq39h4z4f3jcq;
	Tue, 21 May 2024 13:04:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 542A91A08CC;
	Tue, 21 May 2024 13:05:04 +0800 (CST)
Received: from [10.174.179.80] (unknown [10.174.179.80])
	by APP2 (Coremail) with SMTP id Syh0CgDH6w58K0xmGAdNNg--.20155S3;
	Tue, 21 May 2024 13:05:01 +0800 (CST)
Subject: Re: [bug report] Internal error isnullstartblock(got.br_startblock) a
 t line 6005 of file fs/xfs/libxfs/xfs_bmap.c.
To: Guangwu Zhang <guazhang@redhat.com>, linux-block@vger.kernel.org,
 linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <CAGS2=Ypq9_X23syZw8tpybjc_hPk7dQGqdYNbpw0KKN1A1wbNA@mail.gmail.com>
From: Zhang Yi <yi.zhang@huaweicloud.com>
Message-ID: <ae36c333-29fe-1bfd-9558-894b614e916d@huaweicloud.com>
Date: Tue, 21 May 2024 13:05:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAGS2=Ypq9_X23syZw8tpybjc_hPk7dQGqdYNbpw0KKN1A1wbNA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:Syh0CgDH6w58K0xmGAdNNg--.20155S3
X-Coremail-Antispam: 1UD129KBjvJXoW7KryxKFy8CryrZr47XrW3GFg_yoW8Kr4fpF
	yq9ws8CrW0gw15XrnFv3Wjg3WYqa1qka4xZ3yvgF1xAF1fGryqv3s2vFyYgry8Cw4rZryj
	qayv9ryDK3Z8CaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0E
	wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
	80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0
	I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
	k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
	1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUzsqWUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 2024/5/20 19:48, Guangwu Zhang wrote:
> Hi,
> I get a xfs error when run xfstests  generic/461 testing with
> linux-block for-next branch.
> looks it easy to reproduce with s390x arch.
> 
> kernel info :
> commit 04d3822ddfd11fa2c9b449c977f340b57996ef3d
> 6.9.0+
> reproducer
> git clone xfstests
>  ./check generic/461
> 
> 

I guess this issue should be fixed by 5ce5674187c3 ("xfs: convert delayed
extents to unwritten when zeroing post eof blocks"), please merge this commit
series (include 4 patches) and try again.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5ce5674187c345dc31534d2024c09ad8ef29b7ba

Yi.

> [ 5322.046654] XFS (loop1): Internal error isnullstartblock(got.br_startblock) a
> t line 6005 of file fs/xfs/libxfs/xfs_bmap.c.  Caller xfs_bmap_insert_extents+0x
> 2ee/0x420 [xfs]
> [ 5322.046859] CPU: 0 PID: 157526 Comm: fsstress Kdump: loaded Not tainted 6.9.0
> + #1
> [ 5322.046863] Hardware name: IBM 8561 LT1 400 (z/VM 7.2.0)
> [ 5322.046864] Call Trace:
> [ 5322.046866]  [<0000022f504d8fc4>] dump_stack_lvl+0x8c/0xb0
> [ 5322.046876]  [<0000022ed00fc308>] xfs_corruption_error+0x70/0xa0 [xfs]
> [ 5322.046955]  [<0000022ed00b7206>] xfs_bmap_insert_extents+0x3fe/0x420 [xfs]
> [ 5322.047024]  [<0000022ed00f55a6>] xfs_insert_file_space+0x1be/0x248 [xfs]
> [ 5322.047105]  [<0000022ed00ff1dc>] xfs_file_fallocate+0x244/0x400 [xfs]
> [ 5322.047186]  [<0000022f4fe90000>] vfs_fallocate+0x218/0x338
> [ 5322.047190]  [<0000022f4fe9112e>] ksys_fallocate+0x56/0x98
> [ 5322.047193]  [<0000022f4fe911aa>] __s390x_sys_fallocate+0x3a/0x48
> [ 5322.047196]  [<0000022f505019d2>] __do_syscall+0x23a/0x2c0
> [ 5322.047200]  [<0000022f50511d20>] system_call+0x70/0x98
> [ 5322.054644] XFS (loop1): Corruption detected. Unmount and run xfs_repair
> [ 5322.977488] XFS (loop1): User initiated shutdown received.
> [ 5322.977505] XFS (loop1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xb
> 4/0xf8 [xfs] (fs/xfs/xfs_fsops.c:458).  Shutting down filesystem.
> [ 5322.977772] XFS (loop1): Please unmount the filesystem and rectify the proble
> m(s)
> [ 5322.977877] loop1: writeback error on inode 755831, offset 32768, sector 1804
> 712
> 00:00:00
> 
> 
> .
> 

