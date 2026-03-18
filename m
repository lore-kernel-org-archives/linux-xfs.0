Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F153033CB
	for <linux-xfs@vger.kernel.org>; Wed, 18 Mar 2026 17:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773854991; cv=none; b=mqhZjhD4wL4RPMCAxKDxwdNjfETD9BMHjpUyT1KaH+GnDV2nzbL5Y3vTBo9u9qItWjs+bO3xSxAcSCaDo4gswgaHqAB6WLfbW7hhTPrmcLQOV0hU1UJdQNDw0QVp4YZbOvN+/uWS2OwtEerL4NJMaEenXAwzdmn0oPJD60LGKcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773854991; c=relaxed/simple;
	bh=VQscLPpUpmTUeU4vnS6Ful39fK8HQhXi0pp/Vnu5+lM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JADWQke9A2JOu1BkCNWPijWof0BlpN5ZFRXvdVwpf45uwGkFQRLaa6WdLdPE/ahoqLk7HQE4P2Vz0dTovw0aAU4IQ3NTUGAkpYcGGFZxcp1vHVq5cYP72udL6ZmhidP8HXqb10O8DuZR45n71zSoqNd7HYHn74oNsqHwYw4ogRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TKGW6lqj; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0C5FiSin; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TKGW6lqj; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0C5FiSin; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TKGW6lqj";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0C5FiSin";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TKGW6lqj";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0C5FiSin"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A3C2E4D3C1;
	Wed, 18 Mar 2026 17:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773854987; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3R16bZz4j+pgC2M7JH9BQuYPwdHz7wgWWMAmolI5aR8=;
	b=TKGW6lqj+574EIVmYOwC3VRnzRQRXdg5CcN2rol0zkHYPEJ6v1oyt1wxh1U8Gky225QPpb
	mhcHRrXT71X6rKu6635VTc+eja7x7+vTinhk4m2mcDR43tyseYXvaBBBls8xdqhb9S1g10
	P7h+HVQuIGX23hI5UkM26Wm3yeyAIz0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773854987;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3R16bZz4j+pgC2M7JH9BQuYPwdHz7wgWWMAmolI5aR8=;
	b=0C5FiSinjnwuFoS+SoZ0We+vDdUYTuj/eZTZlcVnPG1yjyzLmzG5JJDJXLbJHjCA1gcgzO
	Buy5keNbnM2PCeAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773854987; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3R16bZz4j+pgC2M7JH9BQuYPwdHz7wgWWMAmolI5aR8=;
	b=TKGW6lqj+574EIVmYOwC3VRnzRQRXdg5CcN2rol0zkHYPEJ6v1oyt1wxh1U8Gky225QPpb
	mhcHRrXT71X6rKu6635VTc+eja7x7+vTinhk4m2mcDR43tyseYXvaBBBls8xdqhb9S1g10
	P7h+HVQuIGX23hI5UkM26Wm3yeyAIz0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773854987;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3R16bZz4j+pgC2M7JH9BQuYPwdHz7wgWWMAmolI5aR8=;
	b=0C5FiSinjnwuFoS+SoZ0We+vDdUYTuj/eZTZlcVnPG1yjyzLmzG5JJDJXLbJHjCA1gcgzO
	Buy5keNbnM2PCeAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 980484273B;
	Wed, 18 Mar 2026 17:29:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FbcZJQvhumkXJAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Mar 2026 17:29:47 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 56D9EA0AFF; Wed, 18 Mar 2026 18:29:47 +0100 (CET)
Date: Wed, 18 Mar 2026 18:29:47 +0100
From: Jan Kara <jack@suse.cz>
To: Theodore Tso <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, Ravi Singh <ravising@redhat.com>, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, adilger@dilger.ca, jack@suse.com, 
	cem@kernel.org
Subject: Re: [PATCH v2] xfs: return default quota limits for IDs without a
 dquot
Message-ID: <ijwjh525hgf54wclhd4oixvfi3gfrodqrh2pbk7lr3whqw7nqo@k5uotrmekwyt>
References: <20260312090810.1145908-1-ravising@redhat.com>
 <20260317065947.306954-1-ravising@redhat.com>
 <jknk6pwirqp5kgxdwr7qez2qzuycmj4eupknf3yvqzlnkyiu5k@nowg6cwpxqc3>
 <20260317133159.GA53921@macsyma-wired.lan>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317133159.GA53921@macsyma-wired.lan>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 

Hello!

On Tue 17-03-26 09:31:59, Theodore Tso wrote:
> On Tue, Mar 17, 2026 at 01:19:23PM +0100, Jan Kara wrote:
> > On Tue 17-03-26 14:59:47, Ravi Singh wrote:
> > > When an ID has no dquot on disk, Q_XGETQUOTA returns -ENOENT even
> > > though default quota limits are configured and enforced against that
> > > ID.  This means unprivileged users who have never used any resources
> > > cannot see the limits that apply to them.
> > > 
> > > When xfs_qm_dqget() returns -ENOENT for a non-zero ID, return a
> > > zero-usage response with the default limits filled in from
> > > m_quotainfo rather than propagating the error.  This is consistent
> > > with the enforcement behavior in xfs_qm_adjust_dqlimits(), which
> > > pushes the same default limits into a dquot when it is first
> > > allocated.
> > > 
> > > Signed-off-by: Ravi Singh <ravising@redhat.com>
> > 
> > So XFS guys should also review this but from quota POV this looks like a
> > right fix to me. So feel free to add:
> > 
> > Reviewed-by: Jan Kara <jack@suse.cz>
> 
> This was discussed at last week's ext4 conference call, and we
> wondered whether we might be better off adding a new
> Q_XGETDEFAULTQUOTA or some such which returned the default quota.
> This would that the quota userspace utilities would have to be
> changed, but it would also mean that userspace could distinguish
> between whether the quota limit was due to a default value being used,
> or because the user had an actual quota value set.

First thing to note is that the notion of "default limit" is specific to
XFS. Other filesystems using quota don't have any default limits. I guess
most people here know this but I'm spelling it out so that we are all on
the same page.

> It also means that in the future, if we wanted to change where the
> default quota was stored, it would be possible to do that instead of
> overloading the quota value for uid/gid 0.
> 
> We also speculated that perhaps there might be cases where if some
> process might be running without CAP_SYS_ADMIN, there might be a
> reason that quota for uid=0 might actually make sense, and so perhaps
> some future file system format change might want to decouple where the
> default quota was stored.

Right. That's why I didn't like the v1 version of the patch. But v2 version
hides the XFS specific behavior of default limits inside XFS function for
fetching quotas so that is fully transparent. If XFS decides to change its
quota format to support limits for root, it can also change this code
fetching and filling in default limits for the user. So until XFS decides
to change the format, current solution looks fine to me, once it decides to
change it, it is easy to change this code as well. But obviously this is
fully XFS developers' area of code so they can do whatever they wish :)

The only improvement I can see is if we explicitely wanted to expose the
XFS default limits in some generic way for userspace tools to show. But
then I'd think we don't really need new quotactl, we could just put this
into the result of existing Q_XGETQSTATV quotactl.

Overall I don't have a strong opinion on this and consider these questions
mostly specific to XFS so XFS guys should decide what they want...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
