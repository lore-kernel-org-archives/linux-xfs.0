Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB42770E6;
	Tue, 21 May 2024 11:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716292681; cv=none; b=eX3dPAuVPA4ep7pNUOMLLoZX1dksJ4/w63rc9Pw+ooiVgTuTd3z3ED2M4MHNdJUE8s3n11chSUeAgPn/Ck6SdpOKF5C5LrB3KUgTRVUkomVj7bOZ6BhAJm2sto2M94bd7iIRg3s6vYtyNicr46XnajkATC+18T7AjQwSC91PSd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716292681; c=relaxed/simple;
	bh=lN9IaRF3VqP0kObfDCQoK5SLkIrja9k2S3g6HRZrlHU=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=mX97apoLM93SSqb7pBVFMjdlJj7V2eFHZ8AMLS6kBISGyNWbdi/wwn1uOCS6jj6uQEGQmK+bPLrhi47JWJW6YEZrdGxgIBthDhlPnr35+CyT7Uo4eajK4L99IrHJDaVO35LxYcNiPyrHlzo83MPs1rtNEd8a5zHvEKbG716vsRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4VkCc96KdHz4f3jXK;
	Tue, 21 May 2024 19:57:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id C572A1A0568;
	Tue, 21 May 2024 19:57:54 +0800 (CST)
Received: from [10.174.179.80] (unknown [10.174.179.80])
	by APP2 (Coremail) with SMTP id Syh0CgBXfA8_jExmnptoNg--.34714S3;
	Tue, 21 May 2024 19:57:53 +0800 (CST)
Subject: Re: [bug report] Internal error isnullstartblock(got.br_startblock) a
 t line 6005 of file fs/xfs/libxfs/xfs_bmap.c.
To: Guangwu Zhang <guazhang@redhat.com>
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
 fstests@vger.kernel.org
References: <CAGS2=Ypq9_X23syZw8tpybjc_hPk7dQGqdYNbpw0KKN1A1wbNA@mail.gmail.com>
 <ae36c333-29fe-1bfd-9558-894b614e916d@huaweicloud.com>
 <CAGS2=YrG7+k7ufEcX5NY2GFy69A7QQwq6BCku2biLHXVEOxWow@mail.gmail.com>
From: Zhang Yi <yi.zhang@huaweicloud.com>
Message-ID: <a053e948-791c-3233-3791-83bf9ea90bde@huaweicloud.com>
Date: Tue, 21 May 2024 19:57:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAGS2=YrG7+k7ufEcX5NY2GFy69A7QQwq6BCku2biLHXVEOxWow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBXfA8_jExmnptoNg--.34714S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGrWDZr1fCFWrGrWxGw1DAwb_yoWrWr1UpF
	yjka1YkrW0qw18Xw12y3WYg3WYqan0k3Wxu34Yqr1IyasxXr92v3s2vF1UWw1UKw15Zryj
	vayqqr9rK3WYkaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
	c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1CPfJUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 2024/5/21 18:06, Guangwu Zhang wrote:
> Hi,
> I use the below script reproduce the error.
> 
>         mkdir -p /media/xfs
>         mkdir -p /media/scratch
>         dev0=$(losetup --find)
>         dd if=/dev/zero of=1.tar bs=1G count=1
>         dd if=/dev/zero of=2.tar bs=1G count=1
>         losetup $dev0 1.tar
>         dev1=$(losetup --find)
>         losetup $dev1 2.tar
>         mkfs.xfs -f $dev0
>         mkfs.xfs -f $dev1
>         mount $dev0 /media/xfs
>         mount $dev1 /media/scratch
>         export TEST_DEV="$(mount | grep '/media/xfs' | awk '{ print $1 }')"
>         export TEST_DIR="/media/xfs"
>         export SCRATCH_DEV="$(mount | grep '/media/scratch' | awk '{
> print $1 }')"
>         export SCRATCH_MNT="/media/scratch"
> 
>         git clone git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
>         cd xfstests-dev
>         make
>         for i in $(seq 20);do
>             ./check generic/461
>         done
> 
> @YI,  Could you list your 4 patch links here ?  the kernel don't work
> well after apply the patch [1]
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5ce5674187c345dc31534d2024c09ad8ef29b7ba
> 

Please try:

5ce5674187c3 ("xfs: convert delayed extents to unwritten when zeroing post eof blocks")
2e08371a83f1 ("xfs: make xfs_bmapi_convert_delalloc() to allocate the target offset")
fc8d0ba0ff5f ("xfs: make the seq argument to xfs_bmapi_convert_delalloc() optional")
bb712842a85d ("xfs: match lock mode in xfs_buffered_write_iomap_begin()")

Yi.

> 
> Zhang Yi <yi.zhang@huaweicloud.com> 于2024年5月21日周二 13:05写道：
> 
>>
>> On 2024/5/20 19:48, Guangwu Zhang wrote:
>>> Hi,
>>> I get a xfs error when run xfstests  generic/461 testing with
>>> linux-block for-next branch.
>>> looks it easy to reproduce with s390x arch.
>>>
>>> kernel info :
>>> commit 04d3822ddfd11fa2c9b449c977f340b57996ef3d
>>> 6.9.0+
>>> reproducer
>>> git clone xfstests
>>>  ./check generic/461
>>>
>>>
>>
>> I guess this issue should be fixed by 5ce5674187c3 ("xfs: convert delayed
>> extents to unwritten when zeroing post eof blocks"), please merge this commit
>> series (include 4 patches) and try again.
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5ce5674187c345dc31534d2024c09ad8ef29b7ba
>>
>> Yi.
>>
>>> [ 5322.046654] XFS (loop1): Internal error isnullstartblock(got.br_startblock) a
>>> t line 6005 of file fs/xfs/libxfs/xfs_bmap.c.  Caller xfs_bmap_insert_extents+0x
>>> 2ee/0x420 [xfs]
>>> [ 5322.046859] CPU: 0 PID: 157526 Comm: fsstress Kdump: loaded Not tainted 6.9.0
>>> + #1
>>> [ 5322.046863] Hardware name: IBM 8561 LT1 400 (z/VM 7.2.0)
>>> [ 5322.046864] Call Trace:
>>> [ 5322.046866]  [<0000022f504d8fc4>] dump_stack_lvl+0x8c/0xb0
>>> [ 5322.046876]  [<0000022ed00fc308>] xfs_corruption_error+0x70/0xa0 [xfs]
>>> [ 5322.046955]  [<0000022ed00b7206>] xfs_bmap_insert_extents+0x3fe/0x420 [xfs]
>>> [ 5322.047024]  [<0000022ed00f55a6>] xfs_insert_file_space+0x1be/0x248 [xfs]
>>> [ 5322.047105]  [<0000022ed00ff1dc>] xfs_file_fallocate+0x244/0x400 [xfs]
>>> [ 5322.047186]  [<0000022f4fe90000>] vfs_fallocate+0x218/0x338
>>> [ 5322.047190]  [<0000022f4fe9112e>] ksys_fallocate+0x56/0x98
>>> [ 5322.047193]  [<0000022f4fe911aa>] __s390x_sys_fallocate+0x3a/0x48
>>> [ 5322.047196]  [<0000022f505019d2>] __do_syscall+0x23a/0x2c0
>>> [ 5322.047200]  [<0000022f50511d20>] system_call+0x70/0x98
>>> [ 5322.054644] XFS (loop1): Corruption detected. Unmount and run xfs_repair
>>> [ 5322.977488] XFS (loop1): User initiated shutdown received.
>>> [ 5322.977505] XFS (loop1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xb
>>> 4/0xf8 [xfs] (fs/xfs/xfs_fsops.c:458).  Shutting down filesystem.
>>> [ 5322.977772] XFS (loop1): Please unmount the filesystem and rectify the proble
>>> m(s)
>>> [ 5322.977877] loop1: writeback error on inode 755831, offset 32768, sector 1804
>>> 712
>>> 00:00:00
>>>
>>>
>>> .
>>>
>>
>>
> 
> 
> --
> Guangwu Zhang
> Thanks
> 

