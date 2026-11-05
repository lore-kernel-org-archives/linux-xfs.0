Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793865169;
	b=RdHEsKrBVBRW8o7u+vRlnNkD+hbTwwkBlmNvhCBFIzWTFepldZCnCOyKkjQ/s/8bRD8b
	 6x9jETjvifZNN119qPLKcUKzx13Dx0Sk5uKRj421Y7nJpxTME+ysjUAcs/meDa/5MlXqD
	 Ev1zvQG+/8qkRQlIHBuZB2CTsvYy0uUsmtjc9umMOOqYwInruhCfKGWYqEiTXiU3U3NKj
	 sNSYFKULsH/G5sjR4bUma5fYnSIqDuBwhXzJa+x7HV6/Or5KNosGWRg2fasnPmxXuEHRC
	 M1kcNSDByElcPNbEVbSlJzZroBxI+mi3+r/4tvSQIoOB9cJr9Wcq6oqVlBfbj/lTs/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793865169;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=hzbANlYHtH0nKEF4umY8/K7880JB3GR2byaY0YcD/Jc=;
	b=vFOkx+ErGJ6GhhuEayU8SdpVEHTziRhBPKbDH9lXRkKER7ANe6Ei8hXuM8H9YmeLM1Ep
	 Rqbk8QXfgcR9DAw7QYOb8fevs0rm+DTqLVpxufqxapD6GfZZMiiZxRpk+yOc3CQybczN5
	 WAjwA0x7SY1r/NuzMpMzu1dYuveEDEn09YaE/ffybttLIY4ulRVcMOqMN7bB7cTePvEph
	 40jyUJWt51HZLcU7DNAVICn7ZLgfkiL+pzCKuROnnWM4byrddfv+Q0SFj95JBDAHkp7m1
	 JzLyPhMVp9jcixAmAnqc7ouhFw26M9aCTar8i1o47lPd+s+cWpV5/1kE+kXW7bTklcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C680606D804;
	Thu,  5 Nov 2026 07:52:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C680606D804
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DBB1668BEB; Thu,  5 Nov 2026 08:52:44 +0100 (CET)
Date: Thu, 5 Nov 2026 08:52:44 +0100
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, hch@lst.de,
	fsverity@lists.linux.dev, linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH 0/5] fsverity: lift ioctl() input masking and runtime
 inode flag to VFS
Message-ID: <20261105075244.GB17923@lst.de>
References: <20261104194618.103332-1-aalbersh@kernel.org> <20261104215749.GA3648616@google.com>
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
In-Reply-To: <20261104215749.GA3648616@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 04, 2026 at 09:57:49PM +0000, Eric Biggers wrote:
> Changes to 'struct inode' should be Cc'ed to linux-fsdevel as well.

Yes.  Except for that and the two btrfs/f2fs issue reported by Sashiko
this looks sane.  Please try to do a full fsverity xfstests run for
all the touched file systems.

