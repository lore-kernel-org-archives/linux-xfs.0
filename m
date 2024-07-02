Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0521A28C
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 20:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719950560; cv=none; b=lmQo8kc88XJX9loi9I0r5O7O0P88ZKD/byzvy4KujrVUfO36tLzmutMayHfW5ZQUQAxuYpAH4Eis5qslXkSx78lY0YXDGHBe71Gl1jqqvhDd8PPk3RynVnGT/gzn5ArTknJR/gSU1w7bcXtKWZMHBMbC49nQXgDKYMm+g0aiVrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719950560; c=relaxed/simple;
	bh=e0uzpdCxlw29WKBNGSI7pwvAHe03CeGHj6AYlsEwXHY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uk2UXdOb3JVbwTB81Elj9cTREAmewtr1fCMKB5Hg9mOMvrz8l8NfLVvvQIKBBjfxg9tXEeub9rJzcJKgGI5D/zDeEWLObVUXIlaVUiWvIj8dBHLuZ5QG43lSJ+paDhgCQhG3OIdugvxU2cv4FvjPPOzEBd9yD0LWFFFpOtkp7s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mhwn7mGb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mhwn7mGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13CEBC116B1;
	Tue,  2 Jul 2024 20:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719950560;
	bh=e0uzpdCxlw29WKBNGSI7pwvAHe03CeGHj6AYlsEwXHY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mhwn7mGbfKqXtRT+HgcBeRWwMLFPMpBSTyratDekB/8iK4utss+EOX37TREEWo2mL
	 WSeu3TA81XhW+ULZ/kvn4fIdfnBIB6TxTVjzG/fISdxlzU/mCfgJT6k7ChD8u6r+5m
	 kEY+xd5v85SR0NsS0BfEfCr8AtiJNYKJ8koT/EW/VJC/HLnaYBx9vGVGEtC7f9mOmf
	 dbLA8HH5R9Eltlwwl1Vjv10TCRxHabM7PMiunOPPXRNuPf/90/8tVwvUP8Ulw23JHK
	 rt1J2ofZcXzU+NOtetEC2zYOoAc9ZERL6ASBZHfRejsqQpxWKjwdSuDZqwHoMQ3xEl
	 lZXoHdK+40uXQ==
Date: Tue, 2 Jul 2024 13:02:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com
Subject: Re: [PATCH 03/24] xfs_logprint: dump new attr log item fields
Message-ID: <20240702200239.GR612460@frogsfrogsfrogs>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
 <171988121108.2009260.6026012075133524751.stgit@frogsfrogsfrogs>
 <20240702062503.GC24089@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240702062503.GC24089@lst.de>

On Tue, Jul 02, 2024 at 08:25:03AM +0200, Christoph Hellwig wrote:
> > +extern int xlog_print_trans_attri_name(char **ptr, uint src_len,
> > +		const char *tag);
> > +extern int xlog_print_trans_attri_value(char **ptr, uint src_len, int value_len,
> > +		const char *tag);
> 
> Maybe drop the pointless externs?
> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Done, thanks.

--D
