Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6589E7581D
	for <linux-xfs@vger.kernel.org>; Fri, 31 May 2024 09:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717146728; cv=none; b=MXYXzufOdL4EQla8n/ZCk1bIDfTMhc24KEQABtyNFmhnews+YwuILxElxmk1RasosdFcVyTSAVPGygUAh7SWLwvZuQUOhSqZBxFh4HEB3ITZhCFHvaGqzQkGz5yYxE/SQtH4ilC7cATN8GvJp9lpxdHFsftujPjhQVX0+EsSGuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717146728; c=relaxed/simple;
	bh=90eZYDsDkdobFo1+uRfBhBRZoiY9eRzMfHEllbBgeF0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VEGT+yPy2oefmElZaEzJQP0uFkh1Nnzanpg5mw15lhqSKMXIFQItsfUKOrq93YgcyG/+BfMANLsZjNOaJO99SAprhv4Z//cvnjhZ7k43B6zmXvzWLeA7UrJgZS0EXXH/7diifSOCDBdCMlTg1gE+8BG8+6KNjTgdfKGfzy0bt4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W5TStczr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W5TStczr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2AF6C116B1;
	Fri, 31 May 2024 09:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717146728;
	bh=90eZYDsDkdobFo1+uRfBhBRZoiY9eRzMfHEllbBgeF0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W5TStczrqZHhcFw4ljRnk/eU+8plAjT4x7m3ruu7qsAN4obx0E0anj+rEJoRHAeTj
	 5cTHynXEJCTpBOuNycD7KV8T8yJPFVd/O0ZjnkqyCLahKZQ1hv2IwQpasZANebk6u4
	 T2ee2pCnJnQvBLPiaCk80vo0u2Gb7euFQ+kjnOp2EYbHjWPVC1t//Juxg3RPKcTiPt
	 ln07yU/xsUA9t5dMyDbeV1nBzxsXtf2FhlIzO1OP5YcewA9KQZ1BE17xIfUWOHz1KN
	 V/N2ROzQViTp+bFaPlK82R3jOTIKu/PjkOU4rEFMU2N+KO25u8j8i1eiZWPcT8NbfQ
	 RwWs6uUW4vtPA==
Date: Fri, 31 May 2024 11:12:03 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org, 
	cem@redhat.com
Subject: Re: [PATCH 2/2] xfs_io: Fix do not loop through uninitialized var
Message-ID: <hnujyacu34pxapltol6oyrofuvjcazycqmrejuscxtcxnkyizx@icxvek5xqy6b>
References: <20240530223819.135697-1-preichl@redhat.com>
 <20240530223819.135697-3-preichl@redhat.com>
 <MCCHGj74NBLdCCMNdRFJ0jtg1mW0B3XT8zyeeJl1toW9tAmMvNxkbYcTSaGVFZNqRSalvbICMWCoXJKkBL0b8w==@protonmail.internalid>
 <20240530224842.GA52987@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240530224842.GA52987@frogsfrogsfrogs>

On Thu, May 30, 2024 at 03:48:42PM GMT, Darrick J. Wong wrote:
> On Fri, May 31, 2024 at 12:38:19AM +0200, Pavel Reichl wrote:
> > Red Hat's covscan checker found the following issue:
> >
> > xfsprogs-6.4.0/io/parent.c:115:2: var_decl: Declaring variable "count" without initializer.
> > xfsprogs-6.4.0/io/parent.c:134:2: uninit_use: Using uninitialized value "count".
> >
> > Currently, jdm_parentpaths() returns EOPNOTSUPP and does not initialize
> > the count variable. The count variable is subsequently used in a for
> > loop, which leads to undefined behavior. Fix this by returning from the
> > check_parents() function immediately after checking the return value of
> > the jdm_parentpaths() function.
> >
> > Signed-off-by: Pavel Reichl <preichl@redhat.com>
> 
> I'm waiting on Carlos to take the xfsprogs 6.9 stuff so that I can
> resend the new parent pointer code[1] for 6.10 which blows away the last
> of the old SGI pptr code.

I'm working on it :) sorry the delay should be ready most late next week.

 
> 
> --D
> 
> [1] https://lore.kernel.org/linux-xfs/170405006341.1804688.11009892277015794783.stgit@frogsfrogsfrogs/
> 
> > ---
> >  io/parent.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/io/parent.c b/io/parent.c
> > index 8f63607f..93f40997 100644
> > --- a/io/parent.c
> > +++ b/io/parent.c
> > @@ -112,7 +112,7 @@ check_parents(parent_t *parentbuf, size_t *parentbuf_size,
> >  	     jdm_fshandle_t *fshandlep, struct xfs_bstat *statp)
> >  {
> >  	int error, i;
> > -	__u32 count;
> > +	__u32 count = 0;
> >  	parent_t *entryp;
> >
> >  	do {
> > @@ -126,7 +126,7 @@ check_parents(parent_t *parentbuf, size_t *parentbuf_size,
> >  			       (unsigned long long) statp->bs_ino,
> >  				strerror(errno));
> >  			err_status++;
> > -			break;
> > +			return;
> >  		}
> >  	} while (error == ERANGE);
> >
> > --
> > 2.45.1
> >
> >
> 
