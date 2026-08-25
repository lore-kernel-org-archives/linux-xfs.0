Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C92E44E66D;
	Tue, 25 Aug 2026 18:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787681506; cv=none; b=R8NqJmmrJSmabnl8dkJ9Rh1ksoz4MQtw+DAZy9SKVi18Heo2rpXBeYj1YllimQuk1cc4psQs2s8sjj1FdyQ4yLiJNx7AfmpUkVoExavMGzahgmP+oQLo9Hhg0FTZSj32gxj1E9LcmxRzT4JzX2blqcU7QZqof1ub0wIbFKqIlR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787681506; c=relaxed/simple;
	bh=mOMEaAX4ToxAkvXswiVR5m0OnhIFlSxyaz7MBlDlMTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fK/6YvusEFPX2NUMAP2UkhSJr2FgfO0EUHcoi0A4rt0sMlgB9wPY1jvAqBUL3EV8eaBc+VlkKK3MRB4SfkqjImq8KthVv2OMpyAsT3jyaJsG/Gw2cYXWq/lYZFO9DgCYuzudEXOkVw6iKFnnHuzoKysSa3HqhBnJxPbeEpKZ/sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=msnR1tng; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="msnR1tng"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 337AA1F000E9;
	Tue, 25 Aug 2026 18:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787681505;
	bh=HyyxXEs/aatNQ4BC68nNyTrhhV92AuZ3iqfXWRdVtsg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=msnR1tngeFs57q3Jy593wjQbrf3LW67ZSQNwVElfmx4isKS+AMkEmWQt1qoL4v9BI
	 vVXvjGVhynLeTdwmmGSO1OoAbXCLchsADcZBDVSe4wqzaf3doBN70yseZp5IGzh5kU
	 VjbpJ00g6Mj0S2DgJkjow8azqFbNkFb2RYbMkW0C5eV45TaDIbsuMlcjSgllzbMgCD
	 oP4M3VKSgYJMN2c1UnSOkDJJqPkzwMd+3DpUvanwsazT/lv/pU9boXj7xKsWh64iqg
	 8BxOD1tT89F75SxGdUYfGFiYa/fI54V4i7/aYLrIG3y/XdsqeEKkGBMuXFmXPzfYDF
	 AFt40vVGLCWbA==
Date: Tue, 25 Aug 2026 11:11:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: don't spin forever on zero-length dirents when
 salvaging them
Message-ID: <20260825181144.GS6072@frogsfrogsfrogs>
References: <178760940641.944084.17475223769703836830.stgit@frogsfrogsfrogs>
 <178760940700.944084.17154290942223549187.stgit@frogsfrogsfrogs>
 <20260825062644.GA24324@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825062644.GA24324@lst.de>

On Tue, Aug 25, 2026 at 08:26:44AM +0200, Christoph Hellwig wrote:
> On Mon, Aug 24, 2026 at 10:34:39PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM noticed that xrep_dir_recover_data can spin forever if it
> > encounters an unused dirent that claims to have length zero.  Fix that,
> > and prevent the same thing from happening with a zero-length entry.
> 
> xfstests for this?

Working on it, thanks for reviewing!

> The fix itself looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

--D
