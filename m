Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919AC3D3D16;
	Thu,  2 Jul 2026 07:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782978841; cv=none; b=bRVPlRglubqIXT/IAGBFWfuXUL+ETLNNTsL1HpDFJIVGx2lcfCRdDAxZRcxsfJqNn+Vs1t5/9J4pfl887157mIMkZJJi4XAAA1RwUY0CliF3zYlrNfKkQK6ylSs4V11o1R4yttCvgPNLNCqB7jVuMUTvyeTIOhKutmXgcfpKOLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782978841; c=relaxed/simple;
	bh=6o58NLfbkXMbmiaQXr5qh4IpId+d5kEdNVgO8yrcDpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oKuP8rq5S9fbPpsOkL/YSaTEBsf9Wur2asCHiwpB2W0OSOtnDnDbzHN7jvz5Tnbpuh0+/QBJ1qA7KJP7KUw7DyMZZGkl0ekGCPobf/U6DbpqAajBGTr34lw8SZctJj2yE4ZH2UZbA/yJqJ7zKtJeNOxwaLMUKp2FgFIKJQ/aGNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IJ9wsqsW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IJ9wsqsW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8ABA1F000E9;
	Thu,  2 Jul 2026 07:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782978832;
	bh=Lu/5f2dgCE+mVBKAiqEK/xk/ecgqdV9lUmsI1cHtmm4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IJ9wsqsWaqnPwEOYd1gwDN07DLfl6GgJz6WqWzfGacBnP5zChxjER2b9NjKvxAfL5
	 zJlgblb6BOJPiMUelgOhgvMdJzYVjpKQIEUthiElheAGy4TGwaeIh4XrDDHBkzpaJD
	 KYx1F1oscUh2yxx2niLdYCC6BsmKXRzDfyjh39oLMjCKWCfA4Qcexx76Pt/TboyhbY
	 JZImUkGe+c12X4yg4lvWA8j8u6D0wIYKvQ7c3uhPt58LfJtjZOde4sG2/iOqo9i4cQ
	 9ErRj4IUibki93Dz2lMPoZIpS5pDraFLLz0an8eCL/7u4cjGsZQqU3aptIbBo6+Bvg
	 DrIjajj63OoGA==
Date: Thu, 2 Jul 2026 09:53:48 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suze.cz, djwong@kernel.org, 
	serge@hallyn.com, linux-security-module@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] capabily: Add new capable_noaudit
Message-ID: <akYXOonXC079FQbc@nidhogg.toxiclabs.cc>
References: <20260626114533.102138-1-cem@kernel.org>
 <20260626114533.102138-2-cem@kernel.org>
 <20260629122939.GA21958@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629122939.GA21958@lst.de>

On Mon, Jun 29, 2026 at 02:29:39PM +0200, Christoph Hellwig wrote:
> On Fri, Jun 26, 2026 at 01:45:20PM +0200, cem@kernel.org wrote:
> > +extern bool capable_noaudit(int cap);
> 
> No need for the extern.

Indeed, I was just being consistent with the rest of the file :P


> 
> Otherwise this does look nice an clean to me:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> But if the security folks don't like we can live with the more
> verbose version of it I guess.
> 
> 
