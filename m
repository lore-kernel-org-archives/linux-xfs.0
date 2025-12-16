Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13673155C82
	for <linux-xfs@vger.kernel.org>; Tue, 16 Dec 2025 09:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765877481; cv=none; b=jrS+EtcQVBatTSigBEPUegD0edogb+IoA/uqrDkVyIbMgUdUG+x5WUIWZIIsGNsdjWzAH4HDZm8/PZuJZ4phEEfO2eA6GlLzkzxReEacvOLzRTvA5Kd8TjA7GuoGkgC24lErmZY2k7Zy83AbcojVBJqZgZv0dxdZjRMG1/TgLsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765877481; c=relaxed/simple;
	bh=lJjRS4xzL1YJmHvxk54qXOnOWNae51TlZ3pYeTOblb4=;
	h=Subject:To:References:Cc:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=IB2vHSy5622PPeWFHsKuPAFAQ4g+WrmO/i7Ky8icUzpXrdhTnRsN8mkZgTLr0oEHMycgQHhCoTx9Sny/Amw+LEV8zjGWLKu/A3LLguv2NpEfGH9dxCkZnSSHjxEvEDv3L6qbYvUpaf6STtJdvtM1gcffWyKdWfts1+rHxbbmztE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dVs9z2jkTzKHMhV
	for <linux-xfs@vger.kernel.org>; Tue, 16 Dec 2025 17:31:03 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B91BD1A07C0
	for <linux-xfs@vger.kernel.org>; Tue, 16 Dec 2025 17:31:10 +0800 (CST)
Received: from [10.174.178.185] (unknown [10.174.178.185])
	by APP4 (Coremail) with SMTP id gCh0CgD3WPnaJkFpkwqFAQ--.25136S3;
	Tue, 16 Dec 2025 17:31:07 +0800 (CST)
Subject: Re: [PATCH 0/2] Fix two issues about swapext
To: Christoph Hellwig <hch@infradead.org>
References: <20251213035951.2237214-1-yebin@huaweicloud.com>
 <aT-eo76enT15FKkr@infradead.org> <693FB68F.50400@huaweicloud.com>
 <aUAbXIkQ_LfYuPJc@infradead.org>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, chandan.babu@oracle.com,
 dchinner@redhat.com, yebin10@huawei.com
From: yebin <yebin@huaweicloud.com>
Message-ID: <694126DA.5010203@huaweicloud.com>
Date: Tue, 16 Dec 2025 17:31:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <aUAbXIkQ_LfYuPJc@infradead.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgD3WPnaJkFpkwqFAQ--.25136S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tw4DtrWrKF1fXFW3ZF18Xwb_yoW8Xw4rpF
	4rCF4DKrWrKr1DW34xua1IqF10qFW5X34Fgr40q34UCw13JFnagrs2kF4jqFWYqFZ5ZryS
	va4Iv343Zry7ZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1D
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UK2N
	tUUUUU=
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/



On 2025/12/15 22:29, Christoph Hellwig wrote:
> On Mon, Dec 15, 2025 at 03:19:43PM +0800, yebin wrote:
>> First, we encountered the issue described in
>> https://access.redhat.com/solutions/6095011 in our production
>
> That's behind a paywall unfortunately.
>
In fact, the root cause of the problem was not identified.
>>> Any chance you could add a reproducer to xfstests?
>>>
>> Yes, this issue is quite reproducible. It occurs inevitably when following
>> certain steps. This problem has existed for a long time. I think the reason
>> it's not easily detected is that the XFS_IOC_SWAPEXT IOCTL command is
>> generally used during defragmentation. Therefore, it is almost never
>> included in typical log replay scenarios.
>
> Can you send out an xfstests for this?  Or at least a shell script
> fragment?
>
You can reproduce issue as follow steps:
mkfs.xfs -f /dev/sdb
mount  /dev/sdb /home/test
fallocate -l1m  /home/test/file1
for i in `seq 1 127`;do fallocate -p -o $((8192*i)) -l 4096 
/home/test/file1;done
fallocate -l1m  /home/test/file2
for i in `seq 1 127`;do fallocate -p -o $((8192*i)) -l 4096 
/home/test/file2;done
umount /home/test
mount /dev/sdb /home/test
xfs_io -c "swapext /home/test/file1" /home/test/file2
truncate -s 81920 /home/test/file1
truncate -s 81920 /home/test/file2
// wait for iclog submit to disk
echo offline > /sys/class/scsi_disk/0\:0\:0\:1/device/state && umount 
/home/test
echo running > /sys/class/scsi_disk/0\:0\:0\:1/device/state
mount /dev/sdb /home/test  //will trigger issue

