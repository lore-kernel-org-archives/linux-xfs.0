Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65CA17799F;
	Tue, 10 Sep 2024 13:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725973587; cv=none; b=H/BTqMB1zxIBa0t/tX1Ck5TqbdQTJTVeln6tPPaGEDIr10MfS53mLo8m9+6s52T9ZIrzWwBYqP4O+Imhj/clXqKLAjvYxlwiOLZlTmInMWVzbs5qpgGOfVbpey/MSxDQTQDDvTsUbyjjX+PIl+v6FA3Um5+V5f3E3kLR2LxyruY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725973587; c=relaxed/simple;
	bh=8qv/qbqX+FSLrTmUR9r1kfR0lpNJmlhQgGQUTSQPCIk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fsABB+B3khoZXxKaLdOzbI/E9tzL+XuwhqPtZ76dgYHpMBxfXe6+WZP/i7tsVfXhYs6cNV7PXpwQgZ3y4uqckiU7c/9w5klJ6tMnYmeIPhckj/S/kOime2VistGMDCtXpgKWlmFZBZw4fuWS3Ezu3DeQxyFrNKZf+IViA3MmWRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SaCbEsBa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SaCbEsBa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313F4C4CEC3;
	Tue, 10 Sep 2024 13:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725973587;
	bh=8qv/qbqX+FSLrTmUR9r1kfR0lpNJmlhQgGQUTSQPCIk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SaCbEsBaV4XAF8x7PTcwuWqQQ50nPLUyZ2udbfoAzXkwgV46S6sLaLilNmudW1DnV
	 BSjJWPkUtcjzjIlsbWmswDkVllVTlIsdsMGce790rfVa/vq1sWbVWB2AAfyACUA2LA
	 Ng/bM047MJLCa7NyX2rXOM823ettXxCrQ7trR20Fg5Y79oiWu9S+Z42DV2j1z4zqOh
	 iV5S7m/y8N/wXXEk5ZzY7gvhImaJY3zaHjdIXoz4/VpCjufcYIKqi3tPiMtf2hBCRY
	 jSNS34ix6mXdzHnLOLnaV2mf46gqXvNoDVALmgH2CMGG+7c/eA2UjyPT6Tz0WcoVIR
	 LsuvSAc6jrMZA==
Message-ID: <d2c82922-675e-470f-a4d3-d24c4aecf2e8@kernel.org>
Date: Tue, 10 Sep 2024 22:06:23 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Regression v6.11 booting cannot mount harddisks (xfs)
To: Jesper Dangaard Brouer <hawk@kernel.org>,
 Linus Torvalds <torvalds@linuxfoundation.org>,
 LKML <linux-kernel@vger.kernel.org>
Cc: Netdev <netdev@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-ide@vger.kernel.org, cassel@kernel.org, handan.babu@oracle.com,
 djwong@kernel.org, Linux-XFS <linux-xfs@vger.kernel.org>,
 hdegoede@redhat.com, "David S. Miller" <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, kernel-team <kernel-team@cloudflare.com>
References: <0a43155c-b56d-4f85-bb46-dce2a4e5af59@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <0a43155c-b56d-4f85-bb46-dce2a4e5af59@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2024/09/10 21:19, Jesper Dangaard Brouer wrote:
> Hi Linus,
> 
> My testlab kernel devel server isn't booting correctly on v6.11 branches 
> (e.g. net-next at 6.11.0-rc5)
> I just confirmed this also happens on your tree tag: v6.11-rc7.
> 
> The symptom/issue is that harddisk dev names (e.g /dev/sda, /dev/sdb, 
> /dev/sdc) gets reordered.  I switched /etc/fstab to use UUID's instead 
> (which boots on v6.10) but on 6.11 it still cannot mount harddisks and 
> doesn't fully boot.

Parallel SCSI device scanning has been around for a long time... This is
controlled with CONFIG_SCSI_SCAN_ASYNC. And yes, that can cause disk names to
change, which is why it is never a good idea to rely on them but instead use
/dev/disk/by-* names. Disabling CONFIG_SCSI_SCAN_ASYNC will likely not guarantee
that disk names will be constant, given that you seem to have 2 AHCI adapters on
your host and PCI device scanning is done in parallel.

> E.g. errors:
>    systemd[1]: Expecting device 
> dev-disk-by\x2duuid-0c2b348d\x2de013\x2d482b\x2da91c\x2d029640ec427a.device 
> - /dev/disk/by-uuid/0c2b348d-e013-482b-a91c-029640ec42
> 7a...
>    [DEPEND] Dependency failed for var-lib.mount - /var/lib.
>    [...]
>    [ TIME ] Timed out waiting for device 
> dev-d…499e46-b40d-4067-afd4-5f6ad09fcff2.
>    [DEPEND] Dependency failed for boot.mount - /boot.
> 
> That corresponds to fstab's:
>   - UUID=8b499e46-b40d-4067-afd4-5f6ad09fcff2 /boot     xfs defaults 0 0
>   - UUID=0c2b348d-e013-482b-a91c-029640ec427a /var/lib/ xfs defaults 0 0
> 
> It looks like disk controller initialization happens in *parallel* on
> these newer kernels as dmesg shows init printk's overlapping:
> 
>   [    5.683393] scsi 5:0:0:0: Direct-Access     ATA      SAMSUNG 
> MZ7KM120 003Q PQ: 0 ANSI: 5
>   [    5.683641] scsi 7:0:0:0: Direct-Access     ATA      SAMSUNG 
> MZ7KM120 003Q PQ: 0 ANSI: 5
>   [    5.683797] scsi 8:0:0:0: Direct-Access     ATA      Samsung SSD 
> 840  BB0Q PQ: 0 ANSI: 5
>   [...]
>   [    7.057376] sd 5:0:0:0: [sda] 234441648 512-byte logical blocks: 
> (120 GB/112 GiB)
>   [    7.062279] sd 7:0:0:0: [sdb] 234441648 512-byte logical blocks: 
> (120 GB/112 GiB)
>   [    7.070628] sd 5:0:0:0: [sda] Write Protect is off
>   [    7.070701] sd 8:0:0:0: [sdc] 488397168 512-byte logical blocks: 
> (250 GB/233 GiB)
> 
> Perhaps this could be a hint to what changed?

See above. The disk /dev/sdX names not being reliable is rather normal.
Are you sure you have the correct UUIDs of your FSes on the disks ? You can
check them with "blkid /dev/sdX[n]"

> Any hints what commit I should try to test revert?
> Or good starting point for bisecting?

You said that 6.10 works, so maybe start from there ?

-- 
Damien Le Moal
Western Digital Research

