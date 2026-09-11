Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8CF3E49D1
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 11:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789124742; cv=none; b=UnYEOZODqHN8boCexvDo9lS32mNZooYyK4VakIJ9L85vFDOiBYG0k4D6V8HmJgwFXUnJuQyCUVmzVEAjHYS+QFYU6r7f3G0E8DtgzOtbwTAINWYvSvVGE7WTc1tvs5OberbsUmcMOLb+6EG4q/FT9JFvRZgunHD5SbIVZsG9krA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789124742; c=relaxed/simple;
	bh=ZXIrhc6tE8IBo0cPjuvWAM3z1yEdgsiJ7bR2wBqzcXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hQ4stx2DWCt3ct+DkjCML/BObHKSpIyc0Y+XQEgXqf2I9hsDdeQd9Nb+t2Ab1ZVJ6kpA6KQdp3e5r3ujf6X/zyen+9EzUMrsW9bKztPSIyw9zEOp0XZxGEvPfIx9ru59N1KU5nnSsfwqBDRNpPMxCkw46j2vXpr7DdTjcI71t1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b3U0ryBU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b3U0ryBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349381F000FF;
	Fri, 11 Sep 2026 11:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789124741;
	bh=WRZmeB6yXT+l5Ivl/mj+1p/Vr4WBFOknaFmqyE+ZQkk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b3U0ryBUzlwYTPG5YhWM0ixPKjF1sYZpbV/hcT3r55SkY6Ccamg1LGH6RulxGHlli
	 +KAkF5biKoiNIxf6YXvE7QtJp4WqpqKDw3JHmKeRRrinVLV8Bv0wo9WX2UEJeNDppx
	 DyGfqIxsExUxEbuzOhHbc/AgczhbDrLDdeOOIXrCnhhowfqoAqR5PlnOtuZ9+aG6Cr
	 DJ5EjOCNSxbcfF8/9xU0kZ3ZQLA9V+1AoC2mGyPGUmk0sN7gW+/TIabrWwRWDciSy0
	 cgeQ9lg07A3+8LawX2TrT5WB1QjnCXH+sn03jQY7dW+76EMs93KH/9HSfe0lsMoUk1
	 /cI4pJiXswWFQ==
Date: Fri, 11 Sep 2026 13:05:37 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libxfs: remove xfs_inode.i_size
Message-ID: <aqPgchZIWuFBFd63@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260911070540.1760300-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911070540.1760300-1-hch@lst.de>

On 2026-09-11 09:05:39, Christoph Hellwig wrote:
> This is never actually initialized, and leaves a landmine if anything tries
> to read from it.  Redirect all i_size read macros to i_disk_size instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
