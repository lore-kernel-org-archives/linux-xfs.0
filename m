Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764B824A07C;
	Wed, 18 Mar 2026 22:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773872291; cv=none; b=LKXOgpKmsgTZqXzDTqIXbLKFEJyFvIozM4JkS7E/DhDwTntKgEFCEHewRO6CCGOxh8k6RyjNvzdj+RsJS/vbAipx82SnS68IDBKzU1h0qRTJP03/7o9oEHp+scCPKtOxh58svJfx95E8Ay7seL8K1gR/l2XkE+4/Mgg1NEhhae8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773872291; c=relaxed/simple;
	bh=UDXSWTVAb1RzNbT1dodfSc9/yS6pBWAMOI3W8NucyrY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aXu9oCZFE0kjZCSHH+E82F90stz46YUqZaMB+4xTnJi9I4keAEbUyGwBUAlafD5OwyukQiWUGJ+6m4EU00MAK80Z96SOxy236qU/gGztnaSFUCtch3rdNAtLSBxEcMJTdEnRu6RffT8fWGzSf6oAiMLBOBNMTPQR7YTjJp7iC/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZfNihw7+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZfNihw7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038FDC19421;
	Wed, 18 Mar 2026 22:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773872291;
	bh=UDXSWTVAb1RzNbT1dodfSc9/yS6pBWAMOI3W8NucyrY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZfNihw7+jRy3HikAnwY5y2YVVFrXnzcMCFKbTt1gUyEOD92zsA6+7lNDiM+sdkakW
	 QNeVIjBiPrqeOheAx6OXdqPfMk6E1GeLwQxF305KN9VYAcrB2B8i722wCG29B8VTWS
	 LwPLci6FjLruvguIzKBx1Po+aTySHw5HngQR9v7CH3vzG6f+pw4qyLf3Lbj3OEBUSS
	 cUDn5qhBTmt/c78z/q7imaXkNuOe2W83tPgBkL2UNiJPiA65ED5Bh7HCOr3NSXLWlH
	 +H0dOi0j3GbWgTEQF/Em2LVrgjiZaFqKoOvelufgVJUu7CZBWuL5gocU+5a9RsuVMB
	 jmFfViDVE88XQ==
Date: Wed, 18 Mar 2026 15:18:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Theodore Tso <tytso@mit.edu>, Ravi Singh <ravising@redhat.com>,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	adilger@dilger.ca, jack@suse.com, cem@kernel.org
Subject: Re: [PATCH v2] xfs: return default quota limits for IDs without a
 dquot
Message-ID: <20260318221810.GM1742010@frogsfrogsfrogs>
References: <20260312090810.1145908-1-ravising@redhat.com>
 <20260317065947.306954-1-ravising@redhat.com>
 <jknk6pwirqp5kgxdwr7qez2qzuycmj4eupknf3yvqzlnkyiu5k@nowg6cwpxqc3>
 <20260317133159.GA53921@macsyma-wired.lan>
 <ijwjh525hgf54wclhd4oixvfi3gfrodqrh2pbk7lr3whqw7nqo@k5uotrmekwyt>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ijwjh525hgf54wclhd4oixvfi3gfrodqrh2pbk7lr3whqw7nqo@k5uotrmekwyt>

On Wed, Mar 18, 2026 at 06:29:47PM +0100, Jan Kara wrote:
> Hello!
> 
> On Tue 17-03-26 09:31:59, Theodore Tso wrote:
> > On Tue, Mar 17, 2026 at 01:19:23PM +0100, Jan Kara wrote:
> > > On Tue 17-03-26 14:59:47, Ravi Singh wrote:
> > > > When an ID has no dquot on disk, Q_XGETQUOTA returns -ENOENT even
> > > > though default quota limits are configured and enforced against that
> > > > ID.  This means unprivileged users who have never used any resources
> > > > cannot see the limits that apply to them.
> > > > 
> > > > When xfs_qm_dqget() returns -ENOENT for a non-zero ID, return a
> > > > zero-usage response with the default limits filled in from
> > > > m_quotainfo rather than propagating the error.  This is consistent
> > > > with the enforcement behavior in xfs_qm_adjust_dqlimits(), which
> > > > pushes the same default limits into a dquot when it is first
> > > > allocated.
> > > > 
> > > > Signed-off-by: Ravi Singh <ravising@redhat.com>
> > > 
> > > So XFS guys should also review this but from quota POV this looks like a
> > > right fix to me. So feel free to add:
> > > 
> > > Reviewed-by: Jan Kara <jack@suse.cz>
> > 
> > This was discussed at last week's ext4 conference call, and we
> > wondered whether we might be better off adding a new
> > Q_XGETDEFAULTQUOTA or some such which returned the default quota.
> > This would that the quota userspace utilities would have to be
> > changed, but it would also mean that userspace could distinguish
> > between whether the quota limit was due to a default value being used,
> > or because the user had an actual quota value set.
> 
> First thing to note is that the notion of "default limit" is specific to
> XFS. Other filesystems using quota don't have any default limits. I guess
> most people here know this but I'm spelling it out so that we are all on
> the same page.

*I* actually didn't know that, so thank you for pointing that out!!

> > It also means that in the future, if we wanted to change where the
> > default quota was stored, it would be possible to do that instead of
> > overloading the quota value for uid/gid 0.
> > 
> > We also speculated that perhaps there might be cases where if some
> > process might be running without CAP_SYS_ADMIN, there might be a
> > reason that quota for uid=0 might actually make sense, and so perhaps
> > some future file system format change might want to decouple where the
> > default quota was stored.
> 
> Right. That's why I didn't like the v1 version of the patch. But v2 version
> hides the XFS specific behavior of default limits inside XFS function for
> fetching quotas so that is fully transparent. If XFS decides to change its
> quota format to support limits for root, it can also change this code

Wait, do the other filesystems enforce limits on id 0?

Also, do those non-xfs filesystems also not have default limits?

> fetching and filling in default limits for the user. So until XFS decides
> to change the format, current solution looks fine to me, once it decides to
> change it, it is easy to change this code as well. But obviously this is
> fully XFS developers' area of code so they can do whatever they wish :)

/me bets nobody cares that much in xfsland other than not breaking
userspace tools. ;)

> The only improvement I can see is if we explicitely wanted to expose the
> XFS default limits in some generic way for userspace tools to show. But
> then I'd think we don't really need new quotactl, we could just put this
> into the result of existing Q_XGETQSTATV quotactl.
> 
> Overall I don't have a strong opinion on this and consider these questions
> mostly specific to XFS so XFS guys should decide what they want...

We're stuck with the old ABI behavior unless you all want to add a
Q_<whatever>V2 quotactl command.

--D

> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
> 
