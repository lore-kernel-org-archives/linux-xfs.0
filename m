Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DF2379989
	for <linux-xfs@vger.kernel.org>; Sat, 30 May 2026 06:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780122934; cv=none; b=NkHVvz5nEEyr6Dlxgvz0Z31fuJfN0DVgsagaGAeCr54+hEhzqLRS3qb4DPVUn+I5Cf2/f3yZcWwMiDYuqWSVezjD0TUSM6GfVpX+Iwn6vndi/htlcxo2NcHPHkpy6jgQOOdHbbE67XX5sxMU8HRKQxHntYcGXVTkSPfdITe2TNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780122934; c=relaxed/simple;
	bh=loVTfW3EUDzjdCrZ0aksP4UFmMWs2IIU7itY8RrAO6U=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=o1UTVPmcUGEGC4eTqmwZr/YmLzU9yD7CPeddpdHEU0OOeTWX5ZHZ20o7hrIfFIWTHeraQOQB8/rZIs08ODnQ/WIX6uD2842XsJmXE+w+h8v0K5B4P2xixhtQ1tMCSc8nuKimC5wiztgoOp5A9+KQHPFNpducuBWRRegziCPlVxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nh0FrTOn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nh0FrTOn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDCF21F00893;
	Sat, 30 May 2026 06:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780122933;
	bh=ch1oKXO4J5NuY6MKq2FiuWdhrnnOb9w6dPthQTVPYl4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=nh0FrTOniiL4P3eMmb3dBb75fZJMVmrNXghKdZzxQ1M0m+HE0RRXMyaoGvmucV2zC
	 87NTdsdwKCBUzH4A19vxbWI97deMvSAN1SYkRGKZnNXb4phJoq9pDYfSax58D7U+iL
	 q4coSy502eb2+wnB7TOWHB/Qsa0yc4qaRw0L3v7wFRk8qfzijf9xSM6P8gylzcVxk7
	 YzNQXqUNWa1s+M6PnH6yo+1/mEMSRfHXUhn7xC9iTl6RxVmIfRzxf7TyIWzedh1Q3d
	 RG+YT9ud91Pwg7VEQLSLA00+ICEiHkyTftFgL2Bmv6uIiWXfXkyXI/ye4Aob0XBhOE
	 aPmHctyIDRhEw==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J . Wong" <djwong@kernel.org>, 
 Hans Holmberg <hans.holmberg@wdc.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, 
 Damien Le Moal <dlemoal@kernel.org>, linux-xfs@vger.kernel.org
In-Reply-To: <20260518065224.9066-1-hans.holmberg@wdc.com>
References: <20260518065224.9066-1-hans.holmberg@wdc.com>
Subject: Re: [PATCH v2] xfs: handle racing deletions in
 xfs_zone_gc_iter_irec
Message-Id: <178012293148.22116.17058353589303629949.b4-ty@b4>
Date: Sat, 30 May 2026 08:35:31 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Mon, 18 May 2026 08:52:24 +0200, Hans Holmberg wrote:
> Under heavy garbage collection pressure from RocksDB workloads,
> filesystem shutdowns can occur in xfs_zone_gc_iter_irec when
> xfs_iget() returns -EINVAL for deleted files.
> 
> Fix this by handling -EINVAL just like we handle -ENOENT, allowing
> zone GC to safely ignore stale mappings.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: handle racing deletions in xfs_zone_gc_iter_irec
      commit: bc95fa240a1b8ae64d3dabe87cbe103b912afc45

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

