Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5940D15FA7E;
	Tue, 10 Sep 2024 14:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725979763; cv=none; b=HhCt5Ngafp2Yhw0ak107wMoJlRYsoHtRG9BXckYhWRRmQHx39sapHad5JWXWz9Ev1gv7eafpmSGdelOyqNgCwKHTlLY6LOw7Une4UolLHkAaXHSOBMCL6JZlGW/DFuCl9fKaPatl8w53UGydoBLg+rwhGy6ThnV2s58CAmGDDZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725979763; c=relaxed/simple;
	bh=XWaMFbokrzRtCfofNCMQm6vxq7D5SaoYO1/HXlHXoUM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jz8ceQsfZ+z88AZBxNXHa863r3KaSaxTLTeFX8ebhhiY27UnVqdOR9b55Ox/QHdt3++kSpdhCRiphukjC4OxrIFG5GPpQCr5OVlgJwZJeCOxljwGXFN+boSROkFPFV2mx0pR9ey9K9yQSBCsqVKDqXy7I2tpBGARxnWD5ilhPoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QRfobcFL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QRfobcFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD40C4CEC3;
	Tue, 10 Sep 2024 14:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725979762;
	bh=XWaMFbokrzRtCfofNCMQm6vxq7D5SaoYO1/HXlHXoUM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QRfobcFLI9GtjTDx7WiDr9f548doOS/YbQvR5TiY3pchFbRnIlg/d8YKaZdnnrCvj
	 j3v4tLK+rgkX9UauqoOD7JZsmoIg6TB7FmxJt4c858Y0Vo7zC/o4OYwSlgT7geuJhW
	 WbS695wKRRyPhcgvR0C6wHTje4nbOEvzBeVMWWO7mj1lSqIACq1Kwn+6uywbXU2G5j
	 H2Ic6oeXSBSxbuk6tTm0VJgzIZvHd6nCtLei5SwShTbZn/b4975VTM4GHQLJgda00a
	 mPwx57gkmqy8kWnvGeH9mBaN/Qpt4pYnnPx8nuH+FTJ0B/5JSzkdtlxGCWlVKlJhxC
	 6jzjuoET8e/yA==
Message-ID: <ee565fda-b230-4fb3-8122-e0a9248ef1d1@kernel.org>
Date: Tue, 10 Sep 2024 16:49:18 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Regression v6.11 booting cannot mount harddisks (xfs)
To: Damien Le Moal <dlemoal@kernel.org>,
 Linus Torvalds <torvalds@linuxfoundation.org>,
 LKML <linux-kernel@vger.kernel.org>
Cc: Netdev <netdev@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-ide@vger.kernel.org, cassel@kernel.org, handan.babu@oracle.com,
 djwong@kernel.org, Linux-XFS <linux-xfs@vger.kernel.org>,
 hdegoede@redhat.com, "David S. Miller" <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, kernel-team <kernel-team@cloudflare.com>
References: <0a43155c-b56d-4f85-bb46-dce2a4e5af59@kernel.org>
 <d2c82922-675e-470f-a4d3-d24c4aecf2e8@kernel.org>
Content-Language: en-US
From: Jesper Dangaard Brouer <hawk@kernel.org>
In-Reply-To: <d2c82922-675e-470f-a4d3-d24c4aecf2e8@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 10/09/2024 15.06, Damien Le Moal wrote:
> On 2024/09/10 21:19, Jesper Dangaard Brouer wrote:
>> Hi Linus,
>>
>> My testlab kernel devel server isn't booting correctly on v6.11 branches
>> (e.g. net-next at 6.11.0-rc5)
>> I just confirmed this also happens on your tree tag: v6.11-rc7.
>>
>> The symptom/issue is that harddisk dev names (e.g /dev/sda, /dev/sdb,
>> /dev/sdc) gets reordered.  I switched /etc/fstab to use UUID's instead
>> (which boots on v6.10) but on 6.11 it still cannot mount harddisks and
>> doesn't fully boot.
> 
> Parallel SCSI device scanning has been around for a long time... This is
> controlled with CONFIG_SCSI_SCAN_ASYNC. And yes, that can cause disk names to
> change, which is why it is never a good idea to rely on them but instead use
> /dev/disk/by-* names. Disabling CONFIG_SCSI_SCAN_ASYNC will likely not guarantee
> that disk names will be constant, given that you seem to have 2 AHCI adapters on
> your host and PCI device scanning is done in parallel.
> 
>> E.g. errors:
>>     systemd[1]: Expecting device
>> dev-disk-by\x2duuid-0c2b348d\x2de013\x2d482b\x2da91c\x2d029640ec427a.device
>> - /dev/disk/by-uuid/0c2b348d-e013-482b-a91c-029640ec42
>> 7a...
>>     [DEPEND] Dependency failed for var-lib.mount - /var/lib.
>>     [...]
>>     [ TIME ] Timed out waiting for device
>> dev-d…499e46-b40d-4067-afd4-5f6ad09fcff2.
>>     [DEPEND] Dependency failed for boot.mount - /boot.
>>
>> That corresponds to fstab's:
>>    - UUID=8b499e46-b40d-4067-afd4-5f6ad09fcff2 /boot     xfs defaults 0 0
>>    - UUID=0c2b348d-e013-482b-a91c-029640ec427a /var/lib/ xfs defaults 0 0
>>
>> It looks like disk controller initialization happens in *parallel* on
>> these newer kernels as dmesg shows init printk's overlapping:
>>
>>    [    5.683393] scsi 5:0:0:0: Direct-Access     ATA      SAMSUNG
>> MZ7KM120 003Q PQ: 0 ANSI: 5
>>    [    5.683641] scsi 7:0:0:0: Direct-Access     ATA      SAMSUNG
>> MZ7KM120 003Q PQ: 0 ANSI: 5
>>    [    5.683797] scsi 8:0:0:0: Direct-Access     ATA      Samsung SSD
>> 840  BB0Q PQ: 0 ANSI: 5
>>    [...]
>>    [    7.057376] sd 5:0:0:0: [sda] 234441648 512-byte logical blocks:
>> (120 GB/112 GiB)
>>    [    7.062279] sd 7:0:0:0: [sdb] 234441648 512-byte logical blocks:
>> (120 GB/112 GiB)
>>    [    7.070628] sd 5:0:0:0: [sda] Write Protect is off
>>    [    7.070701] sd 8:0:0:0: [sdc] 488397168 512-byte logical blocks:
>> (250 GB/233 GiB)
>>
>> Perhaps this could be a hint to what changed?
> 
> See above. The disk /dev/sdX names not being reliable is rather normal.
> Are you sure you have the correct UUIDs of your FSes on the disks ? You can
> check them with "blkid /dev/sdX[n]"
> 

I have checked that I use the correct UUIDs.

I checked my /etc/fstab have the UUID entries under /dev/disk/by-uuid/
via this oneliner, which needs to have a /etc/fstab entry under each
UUID. We can see I have one partition that I'm not using
(0fd3bc38-6496-401f-87f2-87e09532de53), which is expected.

$ for UUID in $(ls /dev/disk/by-uuid/); do echo $UUID; grep -H $UUID 
/etc/fstab; done
09e8c15f-80d2-47e3-8e73-d3fdfcf33eef
/etc/fstab:UUID=09e8c15f-80d2-47e3-8e73-d3fdfcf33eef / 
     xfs     defaults        0 0
0c2b348d-e013-482b-a91c-029640ec427a
/etc/fstab:UUID=0c2b348d-e013-482b-a91c-029640ec427a	/var/lib/		xfs 
defaults 0 0
0fd3bc38-6496-401f-87f2-87e09532de53
581920da-1ccb-4b25-856c-036310032a74
/etc/fstab:UUID=581920da-1ccb-4b25-856c-036310032a74	/nix			xfs	defaults 0 0
8b499e46-b40d-4067-afd4-5f6ad09fcff2
/etc/fstab:UUID=8b499e46-b40d-4067-afd4-5f6ad09fcff2 /boot 
     xfs     defaults        0 0
cd409a50-0371-47ca-9213-49a2bc7b9317
/etc/fstab:UUID=cd409a50-0371-47ca-9213-49a2bc7b9317 swap 
     swap    defaults        0 0


>> Any hints what commit I should try to test revert?
>> Or good starting point for bisecting?
> 
> You said that 6.10 works, so maybe start from there ?

I tested I could boot tag v6.10, and have started bisection.

I've not tried to deselect CONFIG_SCSI_SCAN_ASYNC as the kernel that
worked on tag v6.10 also had this CONFIG_SCSI_SCAN_ASYNC enabled. So, it
is likely not related to the async controller init.

--Jesper
