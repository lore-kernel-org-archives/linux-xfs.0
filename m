Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C023F39FA;
	Tue, 30 Jun 2026 10:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782817185; cv=none; b=qSqyz+Unbi7PR5DEhraBXpqPC1v1LGxmhtlfxMfSTbPK+7GRThlJ2LD8XBYG5zuv2m/57JDhHrRfv6CEyNpHcXKfEHYcbBc1sOMPuVOfShC19674P5+laQP1capIrOB99GAfFN74WQXQFQCJPFo9fsbWKX3Ti+OogyyaZms03vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782817185; c=relaxed/simple;
	bh=TUAbSdcMksg0bmS0By0VwbiRzN8Obuh5IyHncgdUb9w=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=YhecyBh2sncRjgUKoRZ81jmx7FKlk7v4nw/emXrFgAqqzcuNHMWI6qdEtJMWSzXCkttfQC146qaxGewmcopGw1WhdrpzXwgSkbM1M1j9WhBXSDt5yst5EyXq4FqdZBrPtGoAt6XNpuNsQ4K8onC52HHxaXCvO6rWwpc5X6c83ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VpqZAZAM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VpqZAZAM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E1A1F00A3D;
	Tue, 30 Jun 2026 10:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782817184;
	bh=gtN+mH0tHftFaZuToE4XkmhsPuPdXnALpsg0N+2g4us=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=VpqZAZAM3P6Pr2cwrHCGC6Di1RxfQZxI+vHEL3mFpy647UAbAyxnfpJsj1nc8GBm6
	 lkqUAG1ZGuoLteeo0OepPpF+/dhrDQ7nhmoKbJR/D2DMIvxSjdVlLn2b6cyBs1MYWV
	 EtsvHMwPcU74bgRhZE+fotRSRRZylJkS+J6+ew51PXuV5L9xZWKfGdbrAc1duMYmMN
	 cv/4wGnKBCGQOcnY2CqD/zNjxcUdRgMQZ4iYkO7K4qw8VWTJlrncZo91m7E4IGiNcx
	 FinWPrRxq2K9q1tBFuGN2egfWMWKRlJos4jMf5KlnZpKEPm8OHxC5snrKO0AgV+Q1I
	 epYQ0i4zXTKUQ==
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org
In-Reply-To: <20260629125229.3400726-1-hch@lst.de>
References: <20260629125229.3400726-1-hch@lst.de>
Subject: Re: [PATCH] iomap: add a separate bio_set for iomap_split_ioend
Message-Id: <20260630-zitat-begossen-tapfer-0ff968ffa21a@brauner>
Date: Tue, 30 Jun 2026 12:59:38 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=895; i=brauner@kernel.org;
 h=from:subject:message-id; bh=TUAbSdcMksg0bmS0By0VwbiRzN8Obuh5IyHncgdUb9w=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ5L5xv6ZHW9txhdruN6qRbmgeun3rIYx2wa3qOqqJJ/
 p3dAXFmHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPh7Wb4p9W0MElOuqG07s20
 mdoOu86Lan7boLxbcH5ZzCoWoxX+Vxj+B8xzfHC8h+eEUt/6OZsmLxXa3XN201Lpdq0Xs47+F/X
 z4gQA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Mon, 29 Jun 2026 14:52:29 +0200, Christoph Hellwig wrote:
> iomap: add a separate bio_set for iomap_split_ioend

Applied to the vfs-7.3.iomap branch of the vfs/vfs.git tree.
Patches in the vfs-7.3.iomap branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.3.iomap

[1/1] iomap: add a separate bio_set for iomap_split_ioend
      https://git.kernel.org/vfs/vfs/c/f2727952b21d

