Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8F521C180;
	Wed,  5 Feb 2025 05:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738734923; cv=none; b=aFwfn3LSCD3KyUA5xNZvW+vjQ0ERumI3UdBsj/XdV4V+0yRxxK4NHn6SeZpx/f/LdlG5Of2ySJRLI+K2cxCV6emzlCyTHkn95G6wcrstlcTKJdOWgrXt+AR05UfONooIBcqYp6yOcwkH4X/0zeeDN1qlVRXWXB74iEb5ohtVdQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738734923; c=relaxed/simple;
	bh=wJ07+2VpiId5ZncZp/wvx9cY02+Ai08eh+lWcYAvCu8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ww+A9LVJRl4x4KV0uB9yhOGkvsgIkQ5td4yDKwcLR74mrSm1Tl4EdnPt5Gd1HBkhUcHPr4TGrvnnF5laeL9cLdt30ZSLriYf5P1aa8N9uq8D9wp8E+BC4HkhCEXFMXSZrtPTW3KNsIx/1aZpZSou4TxtwTgQNmqdEaw+9OESiYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aCaTSM1Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aCaTSM1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E0AC4CED1;
	Wed,  5 Feb 2025 05:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738734922;
	bh=wJ07+2VpiId5ZncZp/wvx9cY02+Ai08eh+lWcYAvCu8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aCaTSM1QrnrdBoENlk3kZzuwT701sSIMNlXKZjDiigGSpsDa/HlvLX1GCc+Dpmjwf
	 nPCdvJR9tQUX9xlapyRVTbrG12XtPJTFayNvPnqMCDAxHNDEu+TuoN/5SrULLLqiQr
	 3JsAETOA6vz4M4K3I3uMKlg4BXmfEfnaUttb11u8=
Date: Wed, 5 Feb 2025 06:55:19 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs-stable@lists.linux.dev, linux-xfs@vger.kernel.org,
	syzbot+3126ab3db03db42e7a31@syzkaller.appspotmail.com,
	eflorac@intellique.com, hch@lst.de, cem@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCHSET RFC 6.12] xfs: bug fixes for 6.12.y LTS
Message-ID: <2025020556-bagful-cosmos-2a72@gregkh>
References: <173869499323.410229.9898612619797978336.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173869499323.410229.9898612619797978336.stgit@frogsfrogsfrogs>

On Tue, Feb 04, 2025 at 10:51:15AM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> Here's a bunch of bespoke hand-ported bug fixes for 6.12 LTS.
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> With a bit of luck, this should all go splendidly.
> Comments and questions are, as always, welcome.

Should we take these into the next stable release, or do you want us to
wait a bit?

thanks,

greg k-h
