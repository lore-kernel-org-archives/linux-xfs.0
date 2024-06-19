Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF45155C8A;
	Wed, 19 Jun 2024 17:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718818135; cv=none; b=sJkd/8FKa15h9IyizMbcvLymreqHbDKCnPBqArtGGHBDTay+/0+ZF/ZvagiPwr8a0oE1cp6XRgcNvRnDyZjrN3BmfgVEe40yGIUXD3Q3EDTaYAWw0/T7Obf9s7/dWXenBKyHSqba2K0JArvWpjO5TOn0a79LOcO9uDs0waRlIyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718818135; c=relaxed/simple;
	bh=mF8oKVP9YSu/Fo6MsKaEcsZfPJJRy5dXoz2nF63BwnI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NY1Ma1i7weg+HxWXQtmPgzDd2CL93rtEXmTDpGGlGJ5siw1rYG0DvrY0kJ66njcaoBUmMXlbNh3YsPjgXRihUUVFSd+g67a9ikaJjNZiv814LnVf3fTKepHVVL2kkM23C9sTyOyZiiHJQLWIw3B7TWlNHGDoRPSbUt6Zxc5qD4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IHdscgCl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IHdscgCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC96C2BBFC;
	Wed, 19 Jun 2024 17:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718818135;
	bh=mF8oKVP9YSu/Fo6MsKaEcsZfPJJRy5dXoz2nF63BwnI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IHdscgClPwN+Vf4b5oHps+hP5riB+n7GrmL4oAOUCfHkO9lNiWv0p2cSZxAL7XuYg
	 lJl7+ihuatnPutsfXKSGAvtT/gRTYo0psg8oYdwo9qup7j+Nkbcx2sEHavM9OsyZ66
	 tyIEaHLHBJaJhvSafBzBHfz7ZDUTal0Fd64CEKdihb09WScXV0N26UzjCcS6It3aOp
	 3KypRCtMnE3bIgLJUJi25FBK2YjQB3JYDU2qGXzHerhXNMb8iCpsLjXOOxsaOavq/C
	 i6o0QDznVxUzrsQRGPi0eWIGwmgEtY2DZUbc/BIIUQfzVSWIiq2/IfAcuU+6GR5F4X
	 zBl3FENq4qqfg==
Date: Wed, 19 Jun 2024 10:28:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, Allison Henderson <allison.henderson@oracle.com>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	fstests@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/11] common: add helpers for parent pointer tests
Message-ID: <20240619172854.GS103034@frogsfrogsfrogs>
References: <171867145793.793846.15869014995794244448.stgit@frogsfrogsfrogs>
 <171867145930.793846.17850395645232280136.stgit@frogsfrogsfrogs>
 <ZnJ38HnvfHRbZR-s@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnJ38HnvfHRbZR-s@infradead.org>

On Tue, Jun 18, 2024 at 11:17:20PM -0700, Christoph Hellwig wrote:
> > +++ b/common/parent
> 
> Should the file and functions have an xfs_ prefix as it's all about
> xfs parent pointers, which won't be portable to other file systems?

> Or maybe just merge it into common/xfs?

I've been trying not to add to the clutter in common/xfs -- except for
the three parent pointers tests, nobody else needs those helpers.  I
don't want to make every xfs fstest parse that stuff.

I'll prefix the pptr helpers though.

--D
