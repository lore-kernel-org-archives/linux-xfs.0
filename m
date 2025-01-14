Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5617229639
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2025 10:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736850646; cv=none; b=jHNU5bX0GM/PoQau+67m2sL6Rr/wUthOJIpcGKSuzFb8wm24R/ijrrnV2QfRuxt0JErzv+92+2XZyjUNILVli3CYHaG5COxrtU7y6E7yv0fzmFE/GTPbv8BoSS7UNwj0KN5ijdiwxW+poVGtBRrILT4WxPeDQO4TD0iQTmsBXjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736850646; c=relaxed/simple;
	bh=4Vx0boEcckaja8mkW5RLy5zS7F1dkEDkLFV95IqpuaM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=JGNbHvp6WB0vgLzY4EI2AAY9Cbv6EmCtP203O25TGPfzEFZx8dm84OYxlqdUAIhXruqyqgoeZgspNxTf85IW6Wg9DJOp0IGvSZHZmgK9RDM3NRdGbMcga3X1NS23Rj7pEYP/kximVMa8kSGAvlIGWUrALMV1x4p2QITlXzar1nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=URv8MO3w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="URv8MO3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A5AC4CEDD;
	Tue, 14 Jan 2025 10:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736850646;
	bh=4Vx0boEcckaja8mkW5RLy5zS7F1dkEDkLFV95IqpuaM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=URv8MO3wJ1b6krvjFMDpRiRYxj7RSTD4o2gkS+VEF0CajOOP4gv9Cn7oqCmU/AUJ6
	 vc14ixW9SxZUbNFQuma6BxNqFhe4vmr56HVItWnz8t7n6IqTX4hMIvA8JDaa+cPvEJ
	 8w71BTep93HyR+1Ypo0WPJ3MlIbtFHOrpFV7hGSW+a/UQqhFh20mixu9QUKyLN8PPZ
	 3lNBDFe+ezgIWq9Ioe1lIFFIl5DYhsOXeFe0dHjtxlrIrkbnSloP80b9luLYe6uhrS
	 Fq8p2eexaEbln6h5PgWYnyhLuE//CV3AI+2k+LaGg1dJtTxvrfxzTucSy1NDef/H41
	 cwo+WkUg8cIVA==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, Long Li <leo.lilong@huawei.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, yi.zhang@huawei.com, 
 houtao1@huawei.com, yangerkun@huawei.com, lonuxli.64@gmail.com
In-Reply-To: <20250111070544.896052-1-leo.lilong@huawei.com>
References: <20250111070544.896052-1-leo.lilong@huawei.com>
Subject: Re: [PATCH v3] xfs: fix mount hang during primary superblock
 recovery failure
Message-Id: <173685064458.121209.1061885382154933291.b4-ty@kernel.org>
Date: Tue, 14 Jan 2025 11:30:44 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Sat, 11 Jan 2025 15:05:44 +0800, Long Li wrote:
> When mounting an image containing a log with sb modifications that require
> log replay, the mount process hang all the time and stack as follows:
> 
>   [root@localhost ~]# cat /proc/557/stack
>   [<0>] xfs_buftarg_wait+0x31/0x70
>   [<0>] xfs_buftarg_drain+0x54/0x350
>   [<0>] xfs_mountfs+0x66e/0xe80
>   [<0>] xfs_fs_fill_super+0x7f1/0xec0
>   [<0>] get_tree_bdev_flags+0x186/0x280
>   [<0>] get_tree_bdev+0x18/0x30
>   [<0>] xfs_fs_get_tree+0x1d/0x30
>   [<0>] vfs_get_tree+0x2d/0x110
>   [<0>] path_mount+0xb59/0xfc0
>   [<0>] do_mount+0x92/0xc0
>   [<0>] __x64_sys_mount+0xc2/0x160
>   [<0>] x64_sys_call+0x2de4/0x45c0
>   [<0>] do_syscall_64+0xa7/0x240
>   [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: fix mount hang during primary superblock recovery failure
      commit: efebe42d95fbba91dca6e3e32cb9e0612eb56de5

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

