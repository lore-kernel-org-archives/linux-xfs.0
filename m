Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EBB449B33
	for <linux-xfs@vger.kernel.org>; Mon,  7 Sep 2026 09:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788772382; cv=none; b=Rp16+7FznO7QIGixNmFDQMQIsnwhyaWqRPWQHQt4VFTf17jlQftAne4OyBj8iSFlxGvRaxpXp2ZyqBO3Seq0ScivALN+9NxM2jkS8GAiQesK+zRG3AKEM5DHXNpVJcUH3czBWgFYGihWH6XwU9f5d68TRmugkWDYUiIY1VGTJsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788772382; c=relaxed/simple;
	bh=DYp+xhrrYTxK5lnKdUI3+Bt11ZfXuFhWM5iVT2sePfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TMvtHTuYdf1Zsv1Y3pPywSAMadwoGFDoAGEe03JpiUItnjqcj1OyknguaEVzKid8h4YDLyxWaMzB7F0dSOZHrlaxUdecyrQALDGr+6oEcKggvKD9y4vY+CtkQm0N3TgJIr+/V68WJhA7/kSI2suJ6cBQEkX0kZHuyS98uO0b0i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QtEtjseU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QtEtjseU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D4C1F00A3A;
	Mon,  7 Sep 2026 09:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788772379;
	bh=qbXhz2W8x5mKJNA+rTA4dGzKgiDpUFkbGT4ryB55JR0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QtEtjseUSkAA9U5VIJNyzte6QX/xgQQj0NXJW1WcxjAT+z9kJuB9rwHYhOtVFayFV
	 4k0phw3KXg/8oKU7opqjFTk65kNi79tYVXY5ixtglu93JpxWfX2XEuVSZLFL/Jl5r9
	 KamTXF4Fl5JNSpBNMlHe2Mg58c7vSNn5PVPUWfV1YrEeN4gxlDB1d7hI+iclAM4OCy
	 1qXzp5kepb+/pAsXH1kpWTDzvvxxTy+66rari3MjU/VAcOQG28m6Sj7BMQc1DqqL1P
	 zcLG2N8wG8tRVCFEMZZEefuyHo7K5es748E7Jo6AQf9yvFePunFYEVM14zfFkbU7TY
	 oMIVGa9XspXrA==
Date: Mon, 7 Sep 2026 11:12:56 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_io: cleanup headers
Message-ID: <ap6ACCJlSDon9ilv@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260907080100.749981-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907080100.749981-1-hch@lst.de>

On 2026-09-07 11:01:00, Christoph Hellwig wrote:
> Drop extra externs and deep tab indentation of the function and
> variable names.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
