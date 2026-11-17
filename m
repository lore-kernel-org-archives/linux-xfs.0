Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794935809;
	b=o80puI6zRFY1zfhc3Juc+8wrXrBbrEA823cqppTnNfJMIBDXoviEQsEjRN4NPfreQ78A
	 jolOzQB+jsAsXNhIZ+JCZQ8n+b+lEwdxr4tH1jad0C6nEdWNsi6slgr+qfShjgdhkNK0a
	 V7z+Qq9DsCv6E3Gd6cfzQSTq68SEuN0l1roLUhstk9TTcweB74H/mXBl/egmnf4yrFiE2
	 nUFCM7po9iNiDtBKFAAV+smSqwGxw6I+hbEPisr93ZDbvnMkyHzWIbUAE9sdMXDEJxe3p
	 lE3Xh+ih1Ri6G10VGBYJVvHN65wqlFltSyAp98FIFFsUNW70/LLVsEWSJVTxgCoJhsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794935809;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=QqXbsHo0q3facIPuCah5A336MupYaPGtPZMwemB8dto=;
	b=LPaDVmXK6M7MBP4IX6UspYk5gilB/hKWy2jG0RasMQ0ySfl1yocHjuudlkihLOGJ+W0i
	 kTbPrB500/9otv3FIvuAF6WjsDFbXoG3+5HmXlMnb4Q9ILtE6dm4Z+Lard2RrmNZej2ZQ
	 m9i+rDy8CqF0+XUXxtKBeQQ4fkoTE+Y+L1NgJkRCG5FaxnOrBbivkbJu3jtBMSG8NO3e5
	 MUdR7Xi1wVbNl9DsNgbyU/ZVZzjUa0anUzaiDqgMvPKP6AK4ckdd95lQQaO74JpANzNkV
	 lLE/10bG1pzihKMLVQrUwISZCusWy1w8mo790Vm4sSFlb0gZcFN0vKNBfQE1+srQ7yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HLpISK0x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55289606A31C;
	Tue, 17 Nov 2026 17:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HLpISK0x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9BBF1F000C4;
	Tue, 17 Nov 2026 17:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794935809;
	bh=QqXbsHo0q3facIPuCah5A336MupYaPGtPZMwemB8dto=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=HLpISK0xOCFjEjySD+Hb2JAtQQN5m5KjGgbxDdbEpBnhIvC+Ub+jpZ5f/7koKHU7z
	 mrBf09fpgArizUCUtJJZUb2+OpJN9uOk6UFDmBKkSexV7XZoHeKnK1kXNVNgIbSPFC
	 elmKn1WENyvzLIKdumi+IUN0DoRN1QikrznQQBiHRCWY4Av9jCa7eoolDCZH9RXvnn
	 ptbnECtMCtBiUbWtmAUs4q2crc+NT4ATyce9iJXv4k/uzgdOfxMs8E3kUrPqru3myy
	 fnH5gH28i/Y5RV2zH61U4HRUbioyAD3L3pAuZPqJBePUcrnOrsJWHyB+R248OU/zCy
	 s5esMXdVAiP5w==
From: Christian Brauner <brauner@kernel.org>
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 exfat@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Chi Zhiling <chizhiling@163.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, 
 Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
 "Darrick J. Wong" <djwong@kernel.org>, Chi Zhiling <chizhiling@kylinos.cn>
In-Reply-To: <20261116085752.3908082-1-chizhiling@163.com>
References: <20261116085752.3908082-1-chizhiling@163.com>
Subject: Re: (subset) [PATCH v4 0/5] exfat: fix valid_size update races
Message-Id: <20261117-heilbad-seile-oberdeck-5bf79ca6d840@brauner>
Date: Tue, 17 Nov 2026 18:16:45 +0100
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-04696

On Mon, 16 Nov 2026 16:57:47 +0800, Chi Zhiling wrote:
> From: Chi Zhiling <chizhiling@kylinos.cn>
> 
> exFAT uses valid_size (ValidDataLength) as the on-disk boundary of
> initialised data, but the current code advances it too late and without
> proper serialisation.  Buffered writes can silently lose data reclaimed
> before valid_size covers it, file expansion and page faults can
> initialise the same range concurrently, and a failed or short direct
> write can still grow the file on disk.
> 
> [...]

Applied to the vfs-7.5.iomap branch of the vfs/vfs.git tree.
Patches in the vfs-7.5.iomap branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.5.iomap

[1/5] iomap: export iomap_bio_read_folio_range_sync()
      https://git.kernel.org/vfs/vfs/c/4c7bbc7f82ff

