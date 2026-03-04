Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC0C39A04A
	for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2026 09:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772616669; cv=none; b=GBWRsZnj7Jd4DBJsgvhhqgOzOvl+lGZgcXB0291AIINXHa1nNhMAuZ4GMpjnEo7AYpHSzjKda3ql6E7Iw1Lq4OfYTk6ta8HhXQEq/UkhdVvGF93v8ESMFnyEbGspFlXf3J5k3UnsCF8vhg+cCzjKT3YATeyOwgPjsgmg/Mnrtug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772616669; c=relaxed/simple;
	bh=Tga9ONSZ5TjIr2bVs5/SRoVtA1HQTm5/Bdx9YRZu574=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ak/zyiUFoZlxTH5vqYntDemNDGT1VBQoxSaV8+vr6sTZlZw4/gSxuLjK20XEFjI6T9J6gFxyj6id0iVoEr+IX97LDAJ1qCxCvqcDpwt0HnIqDdqftIaduZebsxiTX5OdMcbmrJY+ay0ftofYGCtigqwLTxRU+a27PJZBP8QcZFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FDUZX3oX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FDUZX3oX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760F8C19425;
	Wed,  4 Mar 2026 09:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772616668;
	bh=Tga9ONSZ5TjIr2bVs5/SRoVtA1HQTm5/Bdx9YRZu574=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FDUZX3oXUm1Y65/78TCtMNi2zqT0wX5Zr7v0TvEv7pY9lF4ZZXLtii9+TuRpS1yq9
	 nroMcxWd7qO7YLa2JGsRSNrBHi88PnxVqfao+eY2T4/6LeF68nKtgdGWhSPf4Glz8t
	 857nMw/iDtIacwGGQSvjGwk3+iPqjEc+vOyYgqr2VUiiXjUtQ1Vgx7HZkUF6TGF/E4
	 bdNCSe8HS3Va+Jy0XgL1fsLgGkIUhVmCxlsPc37BTv8aITJLEnHAjt108elByardtF
	 TI6aQ03PZXjzOSIVmsNRInCM6nKolzqK6d1uzXju3rIRglMEneQcl2iHOl6YKayNiY
	 vq/ATBr+rtWJg==
Date: Wed, 4 Mar 2026 10:31:03 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: Christoph Hellwig <hch@infradead.org>, 
	Pankaj Raghav <p.raghav@samsung.com>, linux-xfs@vger.kernel.org, bfoster@redhat.com, 
	dchinner@redhat.com, "Darrick J . Wong" <djwong@kernel.org>, gost.dev@samsung.com, 
	andres@anarazel.de, lukas@herbolt.com
Subject: Re: [RFC 1/2] xfs: add flags field to xfs_alloc_file_space
Message-ID: <aaf6QgbmQQ56ZlhH@nidhogg.toxiclabs.cc>
References: <20260227140842.1437710-1-p.raghav@samsung.com>
 <20260227140842.1437710-2-p.raghav@samsung.com>
 <aab9Lgt-HUaNq-FL@infradead.org>
 <cz7xkvha3ka6cqilkeolypgbr7rttlxk24uiliqvaou527kjkr@6cx6q3kprtjt>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cz7xkvha3ka6cqilkeolypgbr7rttlxk24uiliqvaou527kjkr@6cx6q3kprtjt>

> > > @@ -646,7 +646,8 @@ int
> > >  xfs_alloc_file_space(
> > >  	struct xfs_inode	*ip,
> > >  	xfs_off_t		offset,
> > > -	xfs_off_t		len)
> > > +	xfs_off_t		len,
> > > +	uint32_t flags)
> > 
> > Messed up indentation.
> > 
> Oops.
> 
> > Given that we've been through this for a lot of iterations, what
> > about you just take Lukas' existing patch and help improving it?
> 
> I did review his patch[1]. The patches were broken when I tested it but I
> did not get a reply from him after I reported them. That is why I decided
> to send a new version.
> 
> [1] https://lore.kernel.org/linux-xfs/wmxdwtvahubdga73cgzprqtj7fxyjgx5kxvr4cobtl6ski2i6y@ic2g3bfymkwi/

If I properly got the timeline, you barely gave him time to reply:

your reply to the original patch: Date: Thu, 26 Feb 2026 14:44:05 +0000
your RFC time: Date: Fri, 27 Feb 2026 15:08:40 +0100

You are around enough time to know that people usually requires more
than 24 hours to reply.

Please, work with him to get this done. It's not a nice thing to do IMHO
to pass over somebody's else work if you are aware there is work being
done.

FWIW you also didn't Cc'ed him in your RFC as you used the wrong email
address... I'm fixing the headers so he gets aware of it.

If by any means I got the timeline wrong above, forget everything I said
other than the "work with him to get this done".

Carlos

