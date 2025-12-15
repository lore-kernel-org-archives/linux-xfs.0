Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8065830DED5
	for <linux-xfs@vger.kernel.org>; Mon, 15 Dec 2025 07:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765783193; cv=none; b=Wl0Qa+OkXlu6SIrc4jEW15Nhfn6eHJeyJe3nFQszK1vo4ZqJtQzBYLR96uxTTpi7Mz6WC/PdDjKqJiy/K5lBny8hO6cV4Rat35x8ezuxHL49cjRT2cUOBVP2BAMLKzx5SFcAEA6tSlZ2RDWTm6XY+Hle341HddSLZfdnBa9Yrl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765783193; c=relaxed/simple;
	bh=o+2oGiDBxH53w41dLB4bot2y8w78tANclabDJh4lEYE=;
	h=Subject:To:References:Cc:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ms/Zz9AoAT2RYF0hPZ6QEN25zQYCr2+SIT/rll1yK4BVgX4KaFrhUQXaG2FOI9+mneArs1j1gSjL/aXO7exZEQdnhq2AzmXdTlioYL3b1y221kAnDqX8/Bf+PKIBeIuWzdt2xNMZIpBZp3d0Wz9puy8X+PJ4Y32OD8Fi21Wz4jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dVBJs3hQnzKHLwH
	for <linux-xfs@vger.kernel.org>; Mon, 15 Dec 2025 15:19:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3B9731A0847
	for <linux-xfs@vger.kernel.org>; Mon, 15 Dec 2025 15:19:47 +0800 (CST)
Received: from [10.174.178.185] (unknown [10.174.178.185])
	by APP4 (Coremail) with SMTP id gCh0CgDXOPmPtj9poFoCAQ--.59862S3;
	Mon, 15 Dec 2025 15:19:45 +0800 (CST)
Subject: Re: [PATCH 0/2] Fix two issues about swapext
To: Christoph Hellwig <hch@infradead.org>
References: <20251213035951.2237214-1-yebin@huaweicloud.com>
 <aT-eo76enT15FKkr@infradead.org>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, chandan.babu@oracle.com,
 dchinner@redhat.com, yebin10@huawei.com
From: yebin <yebin@huaweicloud.com>
Message-ID: <693FB68F.50400@huaweicloud.com>
Date: Mon, 15 Dec 2025 15:19:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <aT-eo76enT15FKkr@infradead.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgDXOPmPtj9poFoCAQ--.59862S3
X-Coremail-Antispam: 1UD129KBjvdXoW7JFWDAw4rArWruF1rAry8AFb_yoWDXFgE9F
	n3Wr9xCa1DJw1xWr4kKFs8ZF1DCrsakrykX3y5JF17Kry7Z39rKF4vkr90q3ykGw4SyrZx
	KrnYqryfXF4akjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4AYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AK
	xVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1l
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1veHD
	UUUUU==
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/



On 2025/12/15 13:37, Christoph Hellwig wrote:
> Can you add a sentence or two here how you found the issue?
>

First, we encountered the issue described in 
https://access.redhat.com/solutions/6095011 in our production 
environment.The triggered scenario is that after performing fragmented 
organization, the system suddenly lost power and reset, and then 
encountered a panic when mounting the XFS file system.
After analyzing the vmcore, we identified the cause of the issue. 
Subsequently, while reproducing the issue on linux-next, we also 
discovered the problem described in PATCH[1].

> Any chance you could add a reproducer to xfstests?
>
Yes, this issue is quite reproducible. It occurs inevitably when 
following certain steps. This problem has existed for a long time. I 
think the reason it's not easily detected is that the XFS_IOC_SWAPEXT 
IOCTL command is generally used during defragmentation. Therefore, it is 
almost never included in typical log replay scenarios.
>

