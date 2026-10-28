Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793203516;
	b=pgT05EwDTzLWTBs1MVU39IplQlB9hFWkiIDGu8R0IQeu9+eCqPxyob7XH9enwVpLvyC+
	 jlu4h1gZMkiPQ9xquEFCBTRpnOG/C02PEWAC21ICSLKWGaQmDoQNQCdl0tqt8Gie//n1Y
	 T+dNs2jv6/14UnX4XBtY2FWW69lU/rv5HMmk5f9NstMEQ27rTEoV5bnVRbgnIyxzpb9e7
	 oqbic5Vw1F17dNZVTCQh7ZzkpRzs/TyiQzJek8B9MUKaDVK+NSD6f6LTSmahQiJT/q8tX
	 WGXGWG91lkhHzv1lR8pKmkwng+jNRUOzrE+NWiHDwX/OD2V7N/7qlGx/B1WUpk6ZEQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793203516;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:X-Developer-Signature:
	 X-Developer-Key:Content-Transfer-Encoding;
	bh=88sfbrcRMagQo5uewTZLqJVOWmvLIZ7ZDDHfajCvQ8w=;
	b=b3efSz0M7kC/RNoRtfrO4IoFCeCwElBH+4/+7s8r/KV2dMMNRGnjOiGAxBC7QSz8cPcr
	 xV34w14tS50zT1NyCPhR94CH4Xr3gG3hKt4qXrFoRxLp2rUygmaN6Mwm5z2VX3wOAhkJL
	 X1/AIoPdJWKOWvgC4tG599EfVobpPrc8wCFz/GtCfQ5KMGdIGq4g5RmVdvEByQCWYG1LE
	 nUNoMzyD/aQVSUMl3F/g5+k+AV6nxEZo+rUE77w8XtvxaBii/WOJ4kKH2+uMikiHXDaaG
	 wNmqqgQ4y8NmbQqvwITNxLf6IN96MwxMJTTaohpGNj5QAxeYwk1oIt/CLLTQ3AyQhRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iEGdvb86;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8F2606AA59;
	Wed, 28 Oct 2026 16:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iEGdvb86
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57CF1F01285;
	Wed, 28 Oct 2026 16:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793203515;
	bh=88sfbrcRMagQo5uewTZLqJVOWmvLIZ7ZDDHfajCvQ8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iEGdvb862gVq48UUgyRl/Xm6JMHFkS0Jzxlmh1uQ/FP154kv0/TjitiGESsor5WdQ
	 C8Ve/mHow4xmhrJmq+PhbjqnTBi5ymT89KYt5rqJvqLtaHs91auSgZty38iRzuAaNY
	 sGOGJMPqaSegYASCqriuMvHoyhSXhrWH0cznQKI8Z8TELXfHtMN7ZKOD1MT2ckz4xo
	 lCT7U8xwgQPyPE/kc4kGz4PVC7PcOGpFDQc0DU1uHdID0r52NAIP/kj47a3WIfts6K
	 K+2/BYbdOrzkQy31h86d4L7UB6r0C0qvkhbPm3Kgu+qXygGQYSsxvoxsYUNq3oppIg
	 lKbUPV9aoH+oA==
From: Christian Brauner <brauner@kernel.org>
To: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	ecryptfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org,
	exfat@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ntfs@lists.linux.dev,
	ocfs2-devel@lists.linux.dev,
	linux-btrfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-efi@vger.kernel.org,
	linux-mtd@lists.infradead.org,
	linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH RFC 14/28] ntfs: don't set SB_RDONLY after filesystem errors
Date: Wed, 28 Oct 2026 17:05:06 +0100
Message-ID: <20261028-fixstern-halunken-skelett-fb3cd0824159@brauner>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <atW1VhJXAIvtYPfd@hyunchul-PC02>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org> <20261012-work-fs-sb_rdonly-v1-14-60743a3dc326@kernel.org> <atW1VhJXAIvtYPfd@hyunchul-PC02>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2009; i=brauner@kernel.org; h=from:subject:message-id; bh=p94qtq7P6Iyb9ro/ig3qsXfneKNkQl3vnYSgqxFYI4M=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9kjX5zM8Xn3WMa65c5ROjC84Wi7I8Vdelxp8Uknu7e NHt2DMXO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbSfZDhvxvLvOPaJy5+bO6u aPynfMBQpNjbPaLkmuimi/UFjT7r0xgZDpy9vTtgcu3kQxtM9P637q1UPByx2Tj5+w2OmuViLbe MGQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Mon, Oct 19, 2026 at 03:14:46PM +0900, Hyunchul Lee wrote:
> Before this patch, SB_RDONLY is set, so remount,rw returned -EROFS. With
> this patch, sb_rdonly(sb) is false, so remount,rw skips the check and
> return success even though writes are rejected with -EROFS.

Yes, that's intended. ntfs_reconfigure() only refuses the transition
from ro to rw. After an error with errors=remount-ro
ntfs_handle_error() sets NV_Errors and NV_EmergencyRO. A remount to
read-only works and a remount to read-write after that fails with
-EROFS. A "mount -o remount,rw" of a volume that is still read-write
isn't a transition. It returns 0 but doesn't change anything.

That's how ext4 behaves since commit d3476f3dad4a ("ext4: don't set
SB_RDONLY after filesystem errors"). __ext4_remount() only looks at
ext4_emergency_state() if the read-only state changes. And every other
filesystem in this series does the same.

> I think that the condition should be test NVolErrors(), for example
>
>     if ((sb_rdonly(sb) || NVolErrors(vol)) &&
>         !(fc->sb_flags & SB_RDONLY)) {

NV_Errors is the wrong bit for this. It's also set outside of
ntfs_handle_error() no matter what errors= says. map_mft_record_folio()
sets it when an mft record fails its checks and ntfs_read_locked_inode()
when it marks an inode bad. So with errors=continue (which is the
default?) a single corrupt mft record leaves NV_Errors set on a volume that is
still writable.

With your change every remount that keeps such a volume read-write, e.g. just
to change another option, would fail with "Volume has errors and is read-only".

If you really want ntfs to refuse remount,rw in the emergency state then
NVolEmergencyRO() is the bit to test. But then ntfs would behave
differently from ext4 and the rest of this series. So I'd rather keep it
as is.

Fwiw, in the next version reconfigure_super() refuses the transition to
read-write itself. It uses the generic emergency read-only state Jan asked for.
