Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CF32F7460
	for <linux-xfs@vger.kernel.org>; Wed, 22 Oct 2025 07:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761118087; cv=none; b=dS5HT99b5E1B9DM2rmPZ2AMLpnvhrCknKnW1KiZ6W8cpLosA+tFJ+9uQBbRzFOQ4PD7ZbBNLTB0e8v2U03s9Veqv0oqYaUabvbWEn8PpzkVGdD1E8N0ea9JkNyftFoH9FM/GzXEROdkquXihYUW9qA9lVqB1X8W6zyV3khA5Ye0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761118087; c=relaxed/simple;
	bh=aOrTNeOF+FUKpSZzeeS+CzFRJguYrdRlyQsi312OHmE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k2BHhnejnnZCSYXmR/g3ZW9sSKHoXGyztEPP18Z3Nl1A/JpKHWBWliB4TbXeTbp44FpwMH/WQvAYlYDV+Buw5sAR94CS9aHdwRcGV2mdWN2W8iOhDEW4QfeO1ZCF8NpYj9WGTcF1/PhlfKsmB9Cd+t7kHrhrZiYBzbZh+jVCM5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cs12T4hrkzKHMVh
	for <linux-xfs@vger.kernel.org>; Wed, 22 Oct 2025 15:27:13 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 38B281A12F4
	for <linux-xfs@vger.kernel.org>; Wed, 22 Oct 2025 15:28:01 +0800 (CST)
Received: from [10.174.178.152] (unknown [10.174.178.152])
	by APP2 (Coremail) with SMTP id Syh0CgBXrUV_h_hokJbWBA--.16973S3;
	Wed, 22 Oct 2025 15:28:01 +0800 (CST)
Message-ID: <0e89b047-cacb-4c23-aa83-27de1eb235a5@huaweicloud.com>
Date: Wed, 22 Oct 2025 15:27:59 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
To: Christoph Hellwig <hch@infradead.org>
Cc: Lukas Herbolt <lukas@herbolt.com>, djwong@kernel.org,
 linux-xfs@vger.kernel.org, Zhang Yi <yi.zhang@huawei.com>
References: <aPhk1O0TBOx_fl30@infradead.org>
 <f90b0e3e-7734-4e86-8c73-011e71333272@huaweicloud.com>
 <aPiEi2onSUfAPSdM@infradead.org>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <aPiEi2onSUfAPSdM@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:Syh0CgBXrUV_h_hokJbWBA--.16973S3
X-Coremail-Antispam: 1UD129KBjvdXoW7XF47Jr1fXF1rJrW5ur4kWFg_yoW3tFc_uF
	4UJrs7Cwn8JFyrtay3tr4kGr929w4UXFZrG395XF13KFy3ZFZrAwn5Cw1IvFy8KF97Kr90
	gasxAr9FyF1a9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbz8YFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU7IJmUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 10/22/2025 3:15 PM, Christoph Hellwig wrote:
> On Wed, Oct 22, 2025 at 03:13:38PM +0800, Zhang Yi wrote:
>> This situation will be intercepted in vfs_fallcoate().
> 
> Ah, perfect.
> 
>> Besides, it seems that the comments for the xfs_falloc_zero_range() also
>> need to be updated. Specifically, for inodes that are always COW, there
>> is no difference between FALLOC_FL_WRITE_ZEROES and FALLOC_FL_ZERO_RANGE
>> because it does not create zeroed extents.
> 
> In fact we should not offer FALLOC_FL_WRITE_ZEROES for always COW
> inodes.  Yes, you can physically write zeroes if the hardware supports
> it, but given that any overwrite will cause and allocation anyway it
> will just increase the write amplification for no gain.

Yes, indeed! We can directly return -EOPNOTSUPP for always COW inodes.

Best Regards,
Yi.

