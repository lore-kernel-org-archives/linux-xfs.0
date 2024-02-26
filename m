Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FAA5A7B9
	for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2024 13:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708952639; cv=none; b=LW3VueNXZ33qREuayWgaX04V1PoQoLk6rl83sOqJ5oK2DwRSWNzg/uDEA8WDmK1JyAvsKNtji3KmaiCoQwpgeuByx7yg/YBn/ZWUDKiXevI69d/FLHFu3ZYb6z5zYUrC4XjY686Nh8tx5PHqiezmDgAvmJPgGRLIqtnh0kJ4n5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708952639; c=relaxed/simple;
	bh=e+VujSJl+4wgc5vb80A0nGMu318GmGaINTVZhlD4yrU=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=jQkvAW6D/8lmd3jNsb+csKtwUl42qrmoD8QYySMSSOnx1xL00laZz9pP7a30HI5nU38761rp+0E4iO+GtJeVF9GYqTsSqKFNdQ1uy8kTFpXWyQomx9bYr20Y135gTsxo96TGBQ40xp+gEjg0LQwb5/PXDibIGyAipl2WXNJDtSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yao/KfSd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yao/KfSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE43C433C7;
	Mon, 26 Feb 2024 13:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708952638;
	bh=e+VujSJl+4wgc5vb80A0nGMu318GmGaINTVZhlD4yrU=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=Yao/KfSdJBFxAeus8RSMieAcLo5S9EY6LpJrnG6ZHsPpyFKyvMWO+LePZo6GBXdOl
	 y8NFfUSgMrKlUcHDqayDMzP0AHdmcsbnFlGa0H3M9gxD7ECFs/p7nncPpNwT6eNFa8
	 dpvj45ihsociINlcxwcc+vQu5Fce/ZFn1UTgZoOifM45UwB1aer3n534BPI934tZWV
	 XqVnsBUhbdOLwqTpBfozp2HDidmX5UCu49cFOAW4gZ/F5xWg+L2cZ2+6b2yO9hn7yE
	 hXq9X20Tb01Ytj/A7mMrm9UnMOWgh34eLTUFiD2iIkyIRhk1h6StEIH9XDtaK9symw
	 oFHy5KDAFzpww==
References: <20240224010220.GN6226@frogsfrogsfrogs>
 <ZdxnZnmNvdyy_Xil@infradead.org>
User-agent: mu4e 1.10.8; emacs 27.1
From: Chandan Babu R <chandanbabu@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Chandan Babu R
 <chandanrlinux@gmail.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PRBOMB] xfs: online repair patches for 6.9
Date: Mon, 26 Feb 2024 18:29:43 +0530
In-reply-to: <ZdxnZnmNvdyy_Xil@infradead.org>
Message-ID: <874jdv5qdh.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Feb 26, 2024 at 02:26:46 AM -0800, Christoph Hellwig wrote:
> On Fri, Feb 23, 2024 at 05:02:20PM -0800, Darrick J. Wong wrote:
>> pc : kfree+0x54/0x2d8
>> lr : xlog_cil_committed+0x11c/0x1d8 [xfs]
>
> This looks a lot like the bug I found in getbmap.  Maybe try changing
> that kfree to a kvfree?

CIL context structures are allocated using kzalloc() (i.e. kmalloc() with
__GFP_ZERO flag appended to flags argument). So kfree() should work right?

Darrick, I have not been able to recreate the bug after several attempts.

-- 
Chandan
