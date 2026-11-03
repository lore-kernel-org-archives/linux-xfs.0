Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793695326;
	b=FFrvQ2wN0zs3ad+FjyLBlBNze+RAtS1zw7t/sO3SR5oB6Fw0lonT4k3/5x28FC4lrZ+1
	 hXqDaFjlxpgICzvl7Dd93Jpg2wyFwj8L2BSQjIePXoB5nA7WIlY98B8I3hCN7pqR4oVMq
	 W+gPKasPNlb1ZKLJ33+yG1SLFlMRoTr77kWjUL0Ye/xwxjmk4dfb/uH3XoiX4buU61iey
	 DktdezmzHe7vn0mucunECzyt/VX0pPPErdbdVd8dZgG2feQZbxXJPrzDAcqlFxlddrMEp
	 6LmjtVSf69In/heebjKgvAuOY/VBJ3LANdQUJu9Hn7Rcf1BU/dUweOJgAIfBkDRTvHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793695326;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=/Mmu1SJgefq+KaAvFDsItBgRjAHi+/Cf/AJ8uC5U19o=;
	b=TPqhH+WHQc/9w73gfgBL4/Gw0kknalL4kWx+rV4KERJ1qy1WHQ3Bo4em2MmKDO7XFwIy
	 88rjgyysa8AQmXa44AEx8Xu/cHswLyt58odxvcy7WuEO5BMwCnN/68Me2VjoqTqLUc5tg
	 VD120fEHrI6I5qan78nDiqYTNCQpgSY/qNFZoBUwqT+kHyqw7VDsI6il0QFwkv5NzCTuU
	 QlDmp0yNDeCJgyxnw1i7Ox8rtCTqXHGAF+9fL7TCXZhQPnxFfid1itMvPFTmQZ4oCu72s
	 xPiZaqNCATXX1HATAWwQIRdM3WC3Ag/GgwIDM6b1pjoEFsDvOBatdQn/jvlEKZglWeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ArRY5tYD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DF8606D834;
	Tue,  3 Nov 2026 08:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ArRY5tYD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8121F1F000C1;
	Tue,  3 Nov 2026 08:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793695325;
	bh=/Mmu1SJgefq+KaAvFDsItBgRjAHi+/Cf/AJ8uC5U19o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ArRY5tYDCFtc+xAoM77X7yHuc7rwLTxS1aG8aniTRKZtQGG442iT2gAjl2m+2dnnS
	 G+x+3k3jdG/f9V6Ry2EC6wMt93w+qL6UAFF3n4mG2B4dCloG5G4EwLnqrfLFnbkFJu
	 TVKZ97pmWfUobd6UGBB3rVmPxEolFi8QvwwI97bWdICu7aoijfe08s48DJ+voAL4Sr
	 Tw0HK23tCKk2+MLHCh/kPVnPF5cV8SneXBmKrRyfbWAsj4nk316I3t0Y1VXaYkys8F
	 wkP/2Fq9Ez76IMQS8TueH6Gfef4ET86iQJ5WDrGrumAkawpwZDe14gdg0mEl2dWHO8
	 BA07yDEdurjig==
Date: Tue, 3 Nov 2026 09:41:58 +0100
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-mm@kvack.org, ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 33/34] xfs: allow remounting read-only after a shutdown
Message-ID: <20261103-galgen-ehebruch-stehen-a967c14ce53e@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-33-2f44f64f0b66@kernel.org>
 <20261103054155.GB1559@lst.de>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261103054155.GB1559@lst.de>

On Tue, Nov 03, 2026 at 06:41:55AM +0100, Christoph Hellwig wrote:
> Btw, if my previous reply wasn't clear:  please add the test for this
> to xfstests where they actually get run regularly and not the kernel
> selftests which for file systems are basically unused.
> 
> Bonus points for having generic tests instead of purely file system
> specific ones.

I can drop the tests from this series but xfstests for this will be a
follow-up.
