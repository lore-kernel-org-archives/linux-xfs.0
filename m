Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4195146E8D
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 16:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709050207; cv=none; b=jImKy2nSj5w6jfysHtkjsMOtcrcNoigPigMN3EMAqYfYyjgajln9DkHV81LHincsCxMDvR/dg08RXNGf+PilFCg3cpk2ZR0r4bV4Cn5sNntNcyZv7CDgOGJbREOyVeXq/vYsEf+2+HxZYANKbRcQJ3cdCAH+7dJeWu8J0JeV9FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709050207; c=relaxed/simple;
	bh=K/c5dNgCTVFU5u3QiPRO3//NsnA43gL89ZJNXdPmGEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ea3KECmfXrJuWJMR+9FTXAfKVU3yeNSITvouGg+02mvFXu9/67eAnFRpw8CeGsDbGhUe9Ekm/8MQnLFyJ4iMOp/5K6F2so2B2F7jZYBmPlIoo2MoS6XtMG+uw6YoOHo0n3kZwg51erI69oyZnp0MmyRJu1Aqu7kvrzETKqIT0l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CQYzeKjo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CQYzeKjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BCDC433F1;
	Tue, 27 Feb 2024 16:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709050207;
	bh=K/c5dNgCTVFU5u3QiPRO3//NsnA43gL89ZJNXdPmGEQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CQYzeKjo5/ISpMcL6kvg28FKHoKwt1PS45NJXvUw0OXvieU7Rohf/Z+Jp4waZsnR0
	 /mE9XdBvQLl0A/Nr9msbAFPN1VbmMIaJ5bywj7mYQIFmtI0ah+f5ylRVLmRcbS49W4
	 k1/KDX4VH9J53zg5t8eAaExb7AkfZa2vDTR4TJJ0ft1h6wMJY7Yk3h9zAnrYGJG2XF
	 0H391ROt8gjL3Vu3r8ORDXMII0f71cEOtfFpHGmtV5faywLrmQpo53BZRU7Mn5+M3k
	 z9mYlaauaLtVTltsMmQKP133YwlKcbaca8cennUf2HTOhxIA5Xp8vJo1hisHViip27
	 S9tHqQd4HbKvQ==
Date: Tue, 27 Feb 2024 08:10:07 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 5/6] xfs: hoist multi-fsb allocation unit detection to a
 helper
Message-ID: <20240227161007.GX616564@frogsfrogsfrogs>
References: <170900011118.938068.16371783443726140795.stgit@frogsfrogsfrogs>
 <170900011214.938068.18217925414531189912.stgit@frogsfrogsfrogs>
 <Zd4E_0nWedVHXl6s@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd4E_0nWedVHXl6s@infradead.org>

On Tue, Feb 27, 2024 at 07:51:27AM -0800, Christoph Hellwig wrote:
> > +static inline bool xfs_inode_has_bigallocunit(struct xfs_inode *ip)
> > +{
> > +	return XFS_IS_REALTIME_INODE(ip) && ip->i_mount->m_sb.sb_rextsize > 1;
> > +}
> 
> Given that bigallocunit is an entirely new term in XFS, maybe add
> a big fat comment explaining it?
> 
> Otherwise this looks useful.

How about:

/*
 * Decide if the file data allocation unit for this file is larger than
 * a single filesystem block.
 */

--D
