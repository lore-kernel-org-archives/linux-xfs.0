Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36EF3093C3
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 12:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773922967; cv=none; b=mNOZ95Rw/o3lzlZhTKvEDiqJug/gMn5oYV/hLUJwrx0WSwj/6sQYKUkV1qBn+GR9lsJqp4BWelKzb+3DGFDH+gJe4LGe6jr/MqMOhP2tL9jlrnVefbo7+FmhfE40OJjIB67PZGG1KBzZGqBn7RqD2xkPnQSwNhQ2uSU8rqSAkmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773922967; c=relaxed/simple;
	bh=pGftddufHc5ibqhP+dCJ7KStXLdkgL+jgHuEG3J37II=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=olFSIpt3scXDSUmP73L7sj3DtrMjPU5ZzAo0E9unQb6ZD7KOPSca1BbwBBf5Y61YuLAXR8abjwc5n/5fbVpuQAbgNva7a0quHA8EEdOz1U8uGRG+wD3NIwIqEHQg5p7hbAn6ty/ZsXqec/OsD/6ZDOOxanLCMJ1pE1TbocKe+jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=cIXozAKm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=PfDyOEIN; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=cIXozAKm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=PfDyOEIN; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="cIXozAKm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="PfDyOEIN";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="cIXozAKm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="PfDyOEIN"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 182494D1F8;
	Thu, 19 Mar 2026 12:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773922964; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T6D7SW7yNUk0ClTnqg249sQPYHwiEnPqJJJ/ybUYZl8=;
	b=cIXozAKmqntrwNIoc9FE/9dE9wJkqIKk3pgu1tyx9auaCEAqNeWT+gIbyp5WbAZabIpzFh
	0gZ6Kasd7QqU9+T/Fk6WgRZ45/YrionkgtDHv3+yiC94TMS0MztdGNls+QQn1Xh/ltOoTq
	K9itUm1Yld4y2x/5BZDXjpmI5G/tRNs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773922964;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T6D7SW7yNUk0ClTnqg249sQPYHwiEnPqJJJ/ybUYZl8=;
	b=PfDyOEINTXjB1f0mBCqq4aUTU5V06mVaKLgACL7K8noMoURLbeLkW9fiAzb9ZZr2f8E8KL
	ipNmkYKb7A2PiaAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cIXozAKm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PfDyOEIN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773922964; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T6D7SW7yNUk0ClTnqg249sQPYHwiEnPqJJJ/ybUYZl8=;
	b=cIXozAKmqntrwNIoc9FE/9dE9wJkqIKk3pgu1tyx9auaCEAqNeWT+gIbyp5WbAZabIpzFh
	0gZ6Kasd7QqU9+T/Fk6WgRZ45/YrionkgtDHv3+yiC94TMS0MztdGNls+QQn1Xh/ltOoTq
	K9itUm1Yld4y2x/5BZDXjpmI5G/tRNs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773922964;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T6D7SW7yNUk0ClTnqg249sQPYHwiEnPqJJJ/ybUYZl8=;
	b=PfDyOEINTXjB1f0mBCqq4aUTU5V06mVaKLgACL7K8noMoURLbeLkW9fiAzb9ZZr2f8E8KL
	ipNmkYKb7A2PiaAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 017EC4273B;
	Thu, 19 Mar 2026 12:22:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4tZVAJTqu2kucAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 19 Mar 2026 12:22:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B3EB1A0B32; Thu, 19 Mar 2026 13:22:35 +0100 (CET)
Date: Thu, 19 Mar 2026 13:22:35 +0100
From: Jan Kara <jack@suse.cz>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>, 
	Ravi Singh <ravising@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	adilger@dilger.ca, jack@suse.com, cem@kernel.org
Subject: Re: [PATCH v2] xfs: return default quota limits for IDs without a
 dquot
Message-ID: <waksu55vh2fm74ltktchuckhezkjq4ggaooqrosixfzsuli5uo@i4q6ixu7r56x>
References: <20260312090810.1145908-1-ravising@redhat.com>
 <20260317065947.306954-1-ravising@redhat.com>
 <jknk6pwirqp5kgxdwr7qez2qzuycmj4eupknf3yvqzlnkyiu5k@nowg6cwpxqc3>
 <20260317133159.GA53921@macsyma-wired.lan>
 <ijwjh525hgf54wclhd4oixvfi3gfrodqrh2pbk7lr3whqw7nqo@k5uotrmekwyt>
 <20260318221810.GM1742010@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318221810.GM1742010@frogsfrogsfrogs>
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	FROM_EQ_ENVFROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:email,suse.com:email]
X-Rspamd-Queue-Id: 182494D1F8
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 

On Wed 18-03-26 15:18:10, Darrick J. Wong wrote:
> On Wed, Mar 18, 2026 at 06:29:47PM +0100, Jan Kara wrote:
> > Hello!
> > 
> > On Tue 17-03-26 09:31:59, Theodore Tso wrote:
> > > On Tue, Mar 17, 2026 at 01:19:23PM +0100, Jan Kara wrote:
> > > > On Tue 17-03-26 14:59:47, Ravi Singh wrote:
> > > > > When an ID has no dquot on disk, Q_XGETQUOTA returns -ENOENT even
> > > > > though default quota limits are configured and enforced against that
> > > > > ID.  This means unprivileged users who have never used any resources
> > > > > cannot see the limits that apply to them.
> > > > > 
> > > > > When xfs_qm_dqget() returns -ENOENT for a non-zero ID, return a
> > > > > zero-usage response with the default limits filled in from
> > > > > m_quotainfo rather than propagating the error.  This is consistent
> > > > > with the enforcement behavior in xfs_qm_adjust_dqlimits(), which
> > > > > pushes the same default limits into a dquot when it is first
> > > > > allocated.
> > > > > 
> > > > > Signed-off-by: Ravi Singh <ravising@redhat.com>
> > > > 
> > > > So XFS guys should also review this but from quota POV this looks like a
> > > > right fix to me. So feel free to add:
> > > > 
> > > > Reviewed-by: Jan Kara <jack@suse.cz>
> > > 
> > > This was discussed at last week's ext4 conference call, and we
> > > wondered whether we might be better off adding a new
> > > Q_XGETDEFAULTQUOTA or some such which returned the default quota.
> > > This would that the quota userspace utilities would have to be
> > > changed, but it would also mean that userspace could distinguish
> > > between whether the quota limit was due to a default value being used,
> > > or because the user had an actual quota value set.
> > 
> > First thing to note is that the notion of "default limit" is specific to
> > XFS. Other filesystems using quota don't have any default limits. I guess
> > most people here know this but I'm spelling it out so that we are all on
> > the same page.
> 
> *I* actually didn't know that, so thank you for pointing that out!!

Then I'm happy I've spelled it out :)

> > > It also means that in the future, if we wanted to change where the
> > > default quota was stored, it would be possible to do that instead of
> > > overloading the quota value for uid/gid 0.
> > > 
> > > We also speculated that perhaps there might be cases where if some
> > > process might be running without CAP_SYS_ADMIN, there might be a
> > > reason that quota for uid=0 might actually make sense, and so perhaps
> > > some future file system format change might want to decouple where the
> > > default quota was stored.
> > 
> > Right. That's why I didn't like the v1 version of the patch. But v2 version
> > hides the XFS specific behavior of default limits inside XFS function for
> > fetching quotas so that is fully transparent. If XFS decides to change its
> > quota format to support limits for root, it can also change this code
> 
> Wait, do the other filesystems enforce limits on id 0?

Yes, generic quota subsystem doesn't treat id 0 in any special way.
Normally CAP_SYS_RESOURCE check makes the limits irrelevant but with user
namespaces uid 0 can be limited with quota limit e.g. on ext4.

> Also, do those non-xfs filesystems also not have default limits?

Yes, generic quota formats (used by ext2, ext4, ocfs2, f2fs) don't have
default limits. Userspace is responsible to set quota limits using quota
tools when creating user account. GFS2 does its own thing but AFAICS it
doesn't have a notion of default quota limit either.

> > fetching and filling in default limits for the user. So until XFS decides
> > to change the format, current solution looks fine to me, once it decides to
> > change it, it is easy to change this code as well. But obviously this is
> > fully XFS developers' area of code so they can do whatever they wish :)
> 
> /me bets nobody cares that much in xfsland other than not breaking
> userspace tools. ;)
> 
> > The only improvement I can see is if we explicitely wanted to expose the
> > XFS default limits in some generic way for userspace tools to show. But
> > then I'd think we don't really need new quotactl, we could just put this
> > into the result of existing Q_XGETQSTATV quotactl.
> > 
> > Overall I don't have a strong opinion on this and consider these questions
> > mostly specific to XFS so XFS guys should decide what they want...
> 
> We're stuck with the old ABI behavior unless you all want to add a
> Q_<whatever>V2 quotactl command.

Well, the Q_XGETQSTATV quotactl has quite a few free padding space in the
struct so the default limits could be put there if somebody cared enough...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
