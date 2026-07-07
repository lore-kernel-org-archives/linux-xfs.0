Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50C53F8ED1;
	Tue,  7 Jul 2026 11:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783424257; cv=none; b=FxFfrn12sQj4X/KqTEfDP4Ih3pvEb5bt7H77c813duMXEFUNzs5dq/uWgeg2GqFLXyd/fZ7HaRxcw0eAqW+IH9Hu7kx7Dd0zE3t/mElE9UXD1bHt4/3BzeWiMOa6GgxsQYd5lu/U4DOVTc35dVGoZ6KQxxTq1kBRR/KBAn3j8no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783424257; c=relaxed/simple;
	bh=IxBCKeyOlYlAOx4KijUOBiTZj4pE/kzXjgY9JuPSdyA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=nPouZwDhkCGNm9kQARdnus5e9oQcf0um/Y3w+eJ99k8dncBO5LDRLnUFNPQODfEm5wXs4ek7p8SyKAOICMCzlVsGBzUBJg+ZSXDO59ybUVTMbMnrsfIAN/lSiv9NI6ntRhUV+WpYZpSOrb6ZUw1sdMJ768T/vQFgpZv3FI2RSbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RBnt1mOB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RBnt1mOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A621F00A3E;
	Tue,  7 Jul 2026 11:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783424256;
	bh=Sf4egXDw1If5Htsanbb9RYOlxA/eCL47263H/P3fl9o=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=RBnt1mOB/OFTKQzlcigW46rVhQLxnQEtrGWZFKaAQE9yvkWjZ0bQWaR3abCRM+QpX
	 w9TwFlJItkZG+OTbXYoOKQOlAzl67/8eTL6cmO2xr+lrxHLY7x51hncgFjHVFH8xIJ
	 YDZsZNhisDe7cemUZXEftU5kj3oRRL3DSjMxMK4DXYHX2ri6lSti16SwsEo6CDlZV/
	 mAFieDBydArholwqYKj0nv80yVlCgQep49Gf19v5LUirDl5/IIaPaJOT+ft4djSgqg
	 zJsNoR7r8WT1G5rqizbLgf2sTpDK3LPjXlizv8Wyqh2ALT91a26YHzllqhPa6GdWUv
	 QczI/FpHztWJQ==
From: Carlos Maiolino <cem@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>, 
 Hans Holmberg <hans.holmberg@wdc.com>, Cen Zhang <zzzccc427@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 baijiaju1990@gmail.com
In-Reply-To: <20260705042358.3667466-1-zzzccc427@gmail.com>
References: <20260705042358.3667466-1-zzzccc427@gmail.com>
Subject: Re: [PATCH v3] xfs: tie zoned sysfs lifetime to zone info
Message-Id: <178342425499.389943.15942913459955689973.b4-ty@b4>
Date: Tue, 07 Jul 2026 13:37:34 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Sun, 05 Jul 2026 12:23:58 +0800, Cen Zhang wrote:
> The zoned sysfs directory is currently registered as part of the generic
> per-mount sysfs setup, but the data exposed by nr_open_zones has a
> narrower lifetime.  mp->m_zone_info is allocated by xfs_mount_zones() and
> freed by xfs_unmount_zones(), while the zoned sysfs kobject remained
> registered until xfs_mount_sysfs_del().
> 
> A read of nr_open_zones can therefore enter through the still-live sysfs
> kobject after xfs_unmount_zones() has freed mp->m_zone_info, leading to a
> use-after-free in nr_open_zones_show().
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: tie zoned sysfs lifetime to zone info
      commit: befe3d2705dfd18f1257a0674243b0ba5f337e20

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

