Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DADD18D637;
	Tue, 10 Sep 2024 12:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725970753; cv=none; b=fTQ3PPEjT6vmfc1BoH6+/QiM5XvcHDkpZoS8+f1syRh3r3F3gZQrKFhbdF7rh4OoPIlCtaMtGUHs2f/Nnqi+mD/Y9p1Qoa0tlSOxkmOz9LMxqavKhYVlXkwFvpHVU/y0v4Tz/+P1PvefvSBS01qEGwSxbXKELtpO6fnyxTGxsPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725970753; c=relaxed/simple;
	bh=FeFDw3tcpQr5QC2q1gr3PeoGeD2kMMEO87v/oCfmukY=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=B3QKPZpkzSPAQNNRAX2bbs6HKJAODXLhl3hV7n7XWuVBZoMARXpo7FdyG9qLVnV5IEHEWqFFQbn65T+dQfN5UnjeXNz7I9CpdlTa/xP56Rf+GAaqI2X9gZCscsN3zRdBx4BybiBsB+Mh1wROYFLe+QIwQhb5XTvIlpWcHofHeAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D5RqIDpv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D5RqIDpv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2046AC4CEC3;
	Tue, 10 Sep 2024 12:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725970752;
	bh=FeFDw3tcpQr5QC2q1gr3PeoGeD2kMMEO87v/oCfmukY=;
	h=Date:To:Cc:From:Subject:From;
	b=D5RqIDpvwY5PARY7u9EES16/ifypdTVrQToBHRjreyQI8pmkPViIlV9YZae+kPlPD
	 SY11xRwF/RoZGSOJ2GxsHXSg3MRdTHPd4TPiWzOY6RE3uR+rgqFvYReLafwPBx/Ie5
	 klBrut/UvTE40HJsnaCOWSCe7hqbao3KAqLqE71nYjYRxR15fNojQ8fwp+8pfgQjPK
	 ngQrEn649eqJf30BXAOdgs2Jlm4kQC66IEF7KtADjlduZ72m0/3uhpLilJxwN0hwHd
	 aiUGDqWinLRWT+rX+YooBSus2RVjUhozt5ErLdxsHiKDXUpNceg8iWb70FfOkJc9lM
	 Dp1f50VsrIeqg==
Message-ID: <0a43155c-b56d-4f85-bb46-dce2a4e5af59@kernel.org>
Date: Tue, 10 Sep 2024 14:19:08 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Linus Torvalds <torvalds@linuxfoundation.org>,
 LKML <linux-kernel@vger.kernel.org>
Cc: Netdev <netdev@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-ide@vger.kernel.org, dlemoal@kernel.org, cassel@kernel.org,
 handan.babu@oracle.com, djwong@kernel.org,
 Linux-XFS <linux-xfs@vger.kernel.org>, hdegoede@redhat.com,
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 kernel-team <kernel-team@cloudflare.com>
From: Jesper Dangaard Brouer <hawk@kernel.org>
Subject: Regression v6.11 booting cannot mount harddisks (xfs)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Linus,

My testlab kernel devel server isn't booting correctly on v6.11 branches 
(e.g. net-next at 6.11.0-rc5)
I just confirmed this also happens on your tree tag: v6.11-rc7.

The symptom/issue is that harddisk dev names (e.g /dev/sda, /dev/sdb, 
/dev/sdc) gets reordered.  I switched /etc/fstab to use UUID's instead 
(which boots on v6.10) but on 6.11 it still cannot mount harddisks and 
doesn't fully boot.

E.g. errors:
   systemd[1]: Expecting device 
dev-disk-by\x2duuid-0c2b348d\x2de013\x2d482b\x2da91c\x2d029640ec427a.device 
- /dev/disk/by-uuid/0c2b348d-e013-482b-a91c-029640ec42
7a...
   [DEPEND] Dependency failed for var-lib.mount - /var/lib.
   [...]
   [ TIME ] Timed out waiting for device 
dev-d…499e46-b40d-4067-afd4-5f6ad09fcff2.
   [DEPEND] Dependency failed for boot.mount - /boot.

That corresponds to fstab's:
  - UUID=8b499e46-b40d-4067-afd4-5f6ad09fcff2 /boot     xfs defaults 0 0
  - UUID=0c2b348d-e013-482b-a91c-029640ec427a /var/lib/ xfs defaults 0 0

It looks like disk controller initialization happens in *parallel* on
these newer kernels as dmesg shows init printk's overlapping:

  [    5.683393] scsi 5:0:0:0: Direct-Access     ATA      SAMSUNG 
MZ7KM120 003Q PQ: 0 ANSI: 5
  [    5.683641] scsi 7:0:0:0: Direct-Access     ATA      SAMSUNG 
MZ7KM120 003Q PQ: 0 ANSI: 5
  [    5.683797] scsi 8:0:0:0: Direct-Access     ATA      Samsung SSD 
840  BB0Q PQ: 0 ANSI: 5
  [...]
  [    7.057376] sd 5:0:0:0: [sda] 234441648 512-byte logical blocks: 
(120 GB/112 GiB)
  [    7.062279] sd 7:0:0:0: [sdb] 234441648 512-byte logical blocks: 
(120 GB/112 GiB)
  [    7.070628] sd 5:0:0:0: [sda] Write Protect is off
  [    7.070701] sd 8:0:0:0: [sdc] 488397168 512-byte logical blocks: 
(250 GB/233 GiB)

Perhaps this could be a hint to what changed?

Any hints what commit I should try to test revert?
Or good starting point for bisecting?

--Jesper


Extra system info that might be relevant:

00:11.4 SATA controller: Intel Corporation C610/X99 series chipset sSATA 
Controller [AHCI mode] (rev 05) (prog-if 01 [AHCI 1.0])
         Kernel driver in use: ahci

00:1f.2 SATA controller: Intel Corporation C610/X99 series chipset 
6-Port SATA Controller [AHCI mode] (rev 05) (prog-if 01 [AHCI 1.0])
         Subsystem: Super Micro Computer Inc Device 0834
         Kernel driver in use: ahci

$ lsb_release  -a
LSB Version:	:core-5.0-amd64:core-5.0-noarch
Distributor ID:	Fedora
Description:	Fedora release 40 (Forty)
Release:	40
Codename:	Forty
