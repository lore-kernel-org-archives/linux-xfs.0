Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C083E2DC32C;
	Fri, 31 Jul 2026 13:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785505237; cv=none; b=m6AfCv7Y0cIXF13Pi/m4FzBUEwYHBQfWQLwpwfBnIxpw0QGuyRHz3AwuyjEL9UfKL3fwse2KvtLgCFGQCIyrK4rULakRL/ET886MQTp+30MDIVHHV0fmWnLWU8qrqv0BRA9tmfCXcflSSoQ7ZCmibnXZdlBjVNwBHGKOiDi9V/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785505237; c=relaxed/simple;
	bh=UWrM5sCI0KyLwjnMnvxDn3Cdzv7ChWKrafDS99hYyNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XOol1ZcGWoZ6bcEa3xv3Ux/F2ekCNXcPSQCcEn6MXcQ4k8xmP+x0lyimuy+sEBUpixNJYSSKQLpyvoidjdR4zKH13YG+1V2zK5RmqOipxb1Jy7Dcuh6TO1O8KoiWrC9yzPVFytCHFbe86k6lWfd7qs/tRJoNN+F95h0adhhMSbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JK45eDli; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JK45eDli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8306F1F000E9;
	Fri, 31 Jul 2026 13:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785505236;
	bh=qF//E3nueZ4vw4sGkAcBDeRueLufahsoe9sZTMQav+4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JK45eDlizvXb0S3+mMWxvXQ5m2JAjH3Yg0XsPdD/RE1JzaoRZm40dihHGPyj9vD/Q
	 jOUUO/XFv7AvsrswGuMxysA5kAXqXfGGzrQpr5KuK1XCJapiqebLLKtb7wMiTNqfvQ
	 yjieNuDZXoP8QTiG8XbdSgpIKJbXVDPGyX8cZpEJUtk0cVrHUNpHminwSSVK9d2RN0
	 ieEyp+6XzHBK8EkQ7L8CvJBiinbuLEEaspe78zDfP7JXDQsDDe7YxbnwWTZGpwJ9Uc
	 ph9Wi49TUXinWecQsjVOFRkskXcN2FTYfXbRulqvKwHBmwd/VoNAUl1CgVF7GXGZXI
	 p4qG9RmjfR0Dg==
Date: Fri, 31 Jul 2026 15:40:29 +0200
From: Christian Brauner <brauner@kernel.org>
To: hch@lst.de, "Darrick J . Wong" <djwong@kernel.org>, 
	linux-fsdevel@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>
Cc: changfengnan@bytedance.com, kbusch@kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
	David Sterba <dsterba@suse.com>, Gao Xiang <xiang@kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Andreas Gruenbacher <agruenba@redhat.com>, 
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, libaokun@linux.alibaba.com, bfoster@redhat.com, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: (subset) [PATCH v5 00/22] iomap: convert to in-iter iomap_next()
 model
Message-ID: <20260731-hirte-hacken-atmen-bdecd01097f1@brauner>
References: <20260729192737.3190206-1-joannelkoong@gmail.com>
 <20260730-habseligkeiten-adrett-axthieb-e619a48325ad@brauner>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260730-habseligkeiten-adrett-axthieb-e619a48325ad@brauner>

> [20/22] iomap: remove ->iomap_begin()/->iomap_end() legacy path
>         https://git.kernel.org/vfs/vfs/c/0210c4ba2547

That accidently slipped in. I have not dropped this from the v7.3 merge
window. I'll get a v7.3-rc1.iomap ready with the last three patches.

-- 
