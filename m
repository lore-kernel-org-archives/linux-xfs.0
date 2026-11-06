Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793960822;
	b=TK9brQ6TG/2OfdwDkPVuhtQBiP5Lc4Ampehr9vCWLCb+PWPlfTX/1wwM9FYwXD1gQU+t
	 /ZlvF2f+y3B7vHUZcZPMnkC9xaff4gkR8lJ3C17qhd25vaWlVEbB1Ckn8prytH1gm/nAH
	 RL/ritTKPd0MxpfDaN+rTiTbj/AgC6osRshD6+ZZ4JhoN/EAsr9MESa7zOBZy71KhB/yP
	 S9jxRd30WtZKraQ+wA8rnoA99MEcIYBrBpIQeBp1bo3yxln+QhZJkD21fAyEQHrTaN52I
	 8en2j6w03PbOVw34gGC2cjAGH2J5dKke/OLQTW+iywsRkhfpuuoDnpm6ldwa6SHaofQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793960822;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=YnGgQSKX+OoaRu8RJrheafmDXI9tz8ioBg8Ptdx1Im3aQUMVF4DxwMe05t/zASeJHzS/
	 AOUrVJSsw9vq+B+LVkYdTaKT+dn3e8kTsm2n6s6kVXbCAHQ4LnariCAMTLGBL4kTqoiMp
	 QkNtM8nVP+Rx7a0TvMGAQsPFvWxdvbpW4AFpTB/bWJb+0zxJcZxayVv8P0w1q4XmYgXlY
	 YmadtJmsHpOFWeEoeGkxsTG0zY153Qju+2/qP1H1yKrtsUIuCeXqN3TDBQLor0fodDZ09
	 XP9kGeTfhp4VcLT4QI1XXIr/QGysmDyU4fzdqLZtU67JNSwtNvU/KOK3r2Vk9yEDHqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AFC606A32C;
	Fri,  6 Nov 2026 10:27:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16AFC606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C5F7F68BEB; Fri,  6 Nov 2026 11:26:58 +0100 (CET)
Date: Fri, 6 Nov 2026 11:26:58 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: ebiggers@kernel.org, hch@lst.de, fsverity@lists.linux.dev,
	dsterba@suse.com, linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jaegeuk@kernel.org,
	chao@kernel.org, tytso@mit.edu
Subject: Re: [PATCH v2 3/5] btrfs: use I_VERITY_BUILDING instead of private
 flags
Message-ID: <20261106102658.GC5319@lst.de>
References: <20261105115532.613467-1-aalbersh@kernel.org> <20261105115532.613467-4-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105115532.613467-4-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

