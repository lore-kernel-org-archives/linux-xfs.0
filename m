Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A99313D891
	for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 16:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734454244; cv=none; b=hxhbnZYBCJjZPdfinhZSMbQ4RAoF6Quj7Q2ZaRiG0LjH0JkdXhkmGUDH0kgtAvkrOW5bAsCnFeM1OOHpQ5egVRInj/0uj9d2HfF7kcNGM2zFsB4HzI3u5UFlGOhw13UU8iNypf9gw7y6yiU0NOg2u05GyjAMKCvyRxE4louk864=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734454244; c=relaxed/simple;
	bh=JaAtRzshMQrlTIwXMDIltKhMhSa+Q0WqCluNYE+83aQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XnuBt5I4mQ7+6/b0FXkn3BTZp0TZaw3cG5Jf9hXxx1nhmCLwwVjdkJng/At13/m2DZkvYknMjwAR44oEcpbu4DE5AkksYxkcOlO0c+p5dyKs7tBnp6bgbCrpDhx2pMBMEJ43cFAFqn0i85rGpttVzWKwaLRMnS0oVJA3ny72UIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r6OI1aEZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r6OI1aEZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACD3C4CED3;
	Tue, 17 Dec 2024 16:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734454242;
	bh=JaAtRzshMQrlTIwXMDIltKhMhSa+Q0WqCluNYE+83aQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r6OI1aEZboHngSx0DqQeB+ezwbo/cvaLVIddZGYfQV87fawBgV5Jf75KnDshruqPj
	 I5eLDwXatakArHX4TksXqIOpkHaP+uIW/rSKvba7WLvUFmt6DURzCO/SrJrwZM65Zo
	 qhZZzHoXZblf5+mpOdTVrkQBdp2rKzu7ftdb8hNwFXKEvx81taI5wNVxR86+CKe4q4
	 8jeksnEtGnXF1LYuWc96dh8ZsTdRooR9lO5Q1YgIfsGv+ymh7WnKacBrN236Vo0N5c
	 KYI6VBOXpSBv/05kIr5SsXUmSM4jMwr0DhS4vFmxN1FJj9R8afhs1SNylA3fwGrVTV
	 EPQ5QNJPik/ZQ==
Date: Tue, 17 Dec 2024 08:50:42 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: Weird behaviour with project quotas
Message-ID: <20241217165042.GF6174@frogsfrogsfrogs>
References: <20241128171458.37dc80ed@harpe.intellique.com>
 <Z0jbffI2A6Fn7LfO@dread.disaster.area>
 <20241129103332.4a6b452e@harpe.intellique.com>
 <Z0o8vE4MlIg-jQeR@dread.disaster.area>
 <20241212163351.58dd1305@harpe.intellique.com>
 <20241212202547.GK6678@frogsfrogsfrogs>
 <20241213164251.361f8877@harpe.intellique.com>
 <20241213171537.GL6698@frogsfrogsfrogs>
 <20241216231851.7b265e06@harpe.intellique.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241216231851.7b265e06@harpe.intellique.com>

On Mon, Dec 16, 2024 at 11:18:51PM +0100, Emmanuel Florac wrote:
> Le Fri, 13 Dec 2024 09:15:37 -0800
> "Darrick J. Wong" <djwong@kernel.org> écrivait:
> 
> > No, I don't think that changes anything.  If you can build your own
> > kernel, can you try this out?
> > 
> > --D
> > 
> > xfs: don't over-report free space or inodes in statvfs
> 
> I'll give it a try, but that looks like a patch for old weird RedHat
> kernel, I'm running plain vanilla generally, and much higher versions,
> I'll see how it applies :)

That's from 6.13-rc3; I don't do RH kernels.

--D

> -- 
> ------------------------------------------------------------------------
>    Emmanuel Florac     |   Direction technique
> ------------------------------------------------------------------------
>    https://intellique.com
>    +33 6 16 30 15 95
> ------------------------------------------------------------------------
>  


