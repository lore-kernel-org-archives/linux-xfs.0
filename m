Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B26212FA0
	for <linux-xfs@vger.kernel.org>; Wed, 10 Sep 2025 01:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757468563; cv=none; b=RDyxif2afVwhyPfUXPqN55KiY99rvV6sgynzpydcAcRsJ1SqxBaQst+Hm2sJWI9PSA+MqWxXz0oIrZR5obEhCb5h9KL9/K7E72up9cKWdelrIgIvKOHu1Qj1seV/y8YnNO61a+Z0lhnH7NaMq/zBz0SW3FYiBSQN1KsuKwpy33E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757468563; c=relaxed/simple;
	bh=HuRukpqCPlD49s10MoorZgOwO106lGI21DVb28/zCEk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=YbOVpyrjHdd8g55YnrllnQHZXCYm4Ut4Acayo6jSYBrAvqLwMmTOVhrq9v4fwF2dBOs/PxSEBJ9H1GKPDXdCyBHipTCGayqt3eAKJI7WUcbjeHN0azD1/xNvJlqE1wnq3jH3HDrjsKBiDBIdqwyNnaci9QBLt3MUr8gzJttBWWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cM3MC5ckJztTVX;
	Wed, 10 Sep 2025 09:41:43 +0800 (CST)
Received: from kwepemj500016.china.huawei.com (unknown [7.202.194.46])
	by mail.maildlp.com (Postfix) with ESMTPS id EF258180B68;
	Wed, 10 Sep 2025 09:42:38 +0800 (CST)
Received: from [10.174.187.148] (10.174.187.148) by
 kwepemj500016.china.huawei.com (7.202.194.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 10 Sep 2025 09:42:38 +0800
Message-ID: <90dfbc39-c0f2-72b5-d0e2-ba1d4bf80ff8@huawei.com>
Date: Wed, 10 Sep 2025 09:42:37 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH] libfrog: obtain the actual available device when the root
 device is /dev/root
To: Dave Chinner <david@fromorbit.com>
CC: <aalbersh@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	<linux-xfs@vger.kernel.org>, <yangyun50@huawei.com>
References: <6fb6fa53-a1e4-19f0-87e9-443975d2961c@huawei.com>
 <aMDA7wJ5pO91Fewx@dread.disaster.area>
From: Wu Guanghao <wuguanghao3@huawei.com>
In-Reply-To: <aMDA7wJ5pO91Fewx@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemj500016.china.huawei.com (7.202.194.46)



在 2025/9/10 8:06, Dave Chinner 写道:
> On Tue, Sep 09, 2025 at 07:29:02PM +0800, Wu Guanghao wrote:
>> When starting a Fedora virtual machine using QEMU, if the device corresponding
>> to the root directory is the entire disk or a disk partition, the device
>> recorded in /proc/self/mounts will be /dev/root instead of the true device.
> 
> How does this /dev/root situation occur? My fedora VMs
> show the real root device and not /dev/root in /proc/self/mounts,
> so it's not clear to me why /dev/root is being reported here?
> 
I am using a Fedora 42 Server qcow2 image, and then I convert the image to partitions
and LVM devices using qemu-nbd. Afterwards, I pass through the partition devices and
LVM devices using qemu.

$ lsblk
...
nbd0                  43:0    0   10G   0 disk
├─nbd0p1            43:1    0   500M  0 part
├─nbd0p2            43:2    0   1000M 0 part
└─nbd0p3            43:3    0   8.5G  0 part
  └─systemVG-LVRoot 253:7   0   8.5G  0 lvm

qemu start scripts:

qemu-system-aarch64 \
	 ... \
	 -drive id=root,if=virtio,media=disk,format=raw,file=/dev/systemVG/LVRoot \
	 -drive id=boot,if=virtio,media=disk,format=raw,file=/dev/nbd0p2 \
	 -drive id=efi,if=virtio,media=disk,format=raw,file=/dev/nbd0p1 \

> This smells of a custom boot sequence that is mounting the root
> filesystem on a temporary initramfs /dev/root node (which then gets
> removed once the initramfs is done) rather than using pivot_root to
> move the real root fs into place once the real device nodes have
> been initialised and the root fs mounted using them... 
> 
>> This can lead to the failure of executing commands such as xfs_growfs/xfs_info.
>>
>> $ cat /proc/self/mounts
>> /dev/root / xfs rw,seclabel,relatime,attr2,inode64,logbufs=8,logbsize=32k,noquota 0 0
>> devtmpfs /dev devtmpfs rw,seclabel,relatime,size=4065432k,nr_inodes=1016358,mode=755 0 0
>> ...
> 
>>
>> $ mount
>> /dev/sda3 on / type xfs (rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,noquota)
>> devtmpfs on /dev type devtmpfs (rw,relatime,seclabel,size=4065432k,nr_inodes=1016358,mode=755)
>> ...
>>
>> $ xfs_growfs /
>> xfs_growfs: / is not a mounted XFS filesystem
>>
>> $ xfs_growfs /dev/sda3
>> xfs_growfs: /dev/sda3 is not a mounted XFS filesystem
>>
>> $ xfs_info /
>> /: cannot find mount point.#
>>
>> So, if the root device is found to be /dev/root, we need to obtain the
>> corresponding real device first.
> 
> IMO, having a bogus device in /proc/self/mounts output is the
> problem that needs to be fixed here. Working around a broken
> /dev/root device in every userspace utility that reads
> /proc/self/mounts does not feel like the right way to address this
> problem.
> 
I have reviewed the source code of the util-linux mount command and the e2fsprogs resize2fs command,
and both of these have logic for checking and handling /dev/root.

> -Dave.
