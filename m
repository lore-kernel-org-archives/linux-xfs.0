Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBA52F12AF;
	Wed,  1 Apr 2026 06:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775025011; cv=none; b=oiMIoTYli1uNIaC0f8ULt+M4ZwK4nD11J7BFJNuO7cTczHvx4QWGAQLibT/9G0rs6xN2fdYl+Am5pbmgmJ3txY1olWaUwvngKoQAJcT/R7G6khlDBNrWfGBz+X1eWITPvw6fsh2991GllpNIFOx85oVKMoQhPS58RO8WkMhulNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775025011; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lY8Ofb0fkV6/vLJm4Q0sJ3feW/fBwstmRbjP3Hq2VQYgTwEsC9iKyNLAe7C5NYzkT+7uvNS2XfyOjzzHjKAkaxdCVwJQa+NT3kUYxCAuOvAqKryWU0Wrs9YFjVV25vuHQHk4Avh3I8AsbRPw/G6jxFmKhFbjKLuhNiiwJo6lLpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5E18D68AFE; Wed,  1 Apr 2026 08:30:07 +0200 (CEST)
Date: Wed, 1 Apr 2026 08:30:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v6 07/22] iomap: teach iomap to read files with fsverity
Message-ID: <20260401063007.GC24459@lst.de>
References: <20260331212827.2631020-1-aalbersh@kernel.org> <20260331212827.2631020-8-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331212827.2631020-8-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

