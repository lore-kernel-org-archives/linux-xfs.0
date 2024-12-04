Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C701A8F6C
	for <linux-xfs@vger.kernel.org>; Wed,  4 Dec 2024 20:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733343250; cv=none; b=LliX3KHOqKG6HgcTmEf3pCYRZAQmHJNiqE7W3kILkHkl48MfwgMVRGJMZzRQQcWwynHMhg06ccUoQX7PqNhIERbaW0E6HoWaZK3ACvK9sx09npuprpzukLbF2LGGNyq4QTkmx+c9aMhrJnfgBLSqxjx6DOZktXFm1MbpuG2vtfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733343250; c=relaxed/simple;
	bh=5//+zjTHF4aIgrlYz259MB95QB0KGc1zppQQthXuadc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t0ea3cyOKi+7+XYoPwOtB4mqFdiG+3TEo1v0SpqmhUHqvbAA+egPJQBNI2dhPmmIx8hgk9+EXmGQBnfGtEFVA4V1vie8e/VmvcA0PY7Os20H3gxB5Hqoa2C5EFXI26vWFKEpsYu6jpU4fSeTD1uONN8v5mgxETLrGyRTgpNdOxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=iAa/uItT; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=HhqAM09u; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="iAa/uItT";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="HhqAM09u"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EDEF41F38F;
	Wed,  4 Dec 2024 20:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1733343246; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=No4UGkvEfLibjmin0Fdcf+hUstYM4LA+PjPkYUmF8MM=;
	b=iAa/uItTHNIxCv+UjDQkcp7qQO85j8eO3474lPZUUts5Ju6XbOJ5vsZzqo1InK4FF7buEJ
	EqYIvM4WbSB9vvwofm6xxEFPbBEQy8J1fHiAO+N4FIs3L4eapo0LAduUHBKVybE3VVsdkn
	x2yc3dePmL6RfnslndpJTOm51S2idcc=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1733343245; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=No4UGkvEfLibjmin0Fdcf+hUstYM4LA+PjPkYUmF8MM=;
	b=HhqAM09uVNp3iF1Am8GY+kllbTKdOpc2tdANsbmhW20Znd6HERFYmGx8Cj0FFlJyxKvIlU
	RFgLPSdaqKX3zWMzvqI4Ef0j2ww3ZTYcALy/tGZIi42NTLlI9q8r11Z1o0qCIi9ob6hVjP
	VCpiC1/Onbrc0zkjYs9ubna3FlUdTSA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 78B2013A41;
	Wed,  4 Dec 2024 20:14:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 96i6GQ24UGeHQAAAD6G6ig
	(envelope-from <ailiop@suse.com>); Wed, 04 Dec 2024 20:14:05 +0000
Date: Wed, 4 Dec 2024 21:13:56 +0100
From: Anthony Iliopoulos <ailiop@suse.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: grub-devel@gnu.org,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Marta Lewandowska <mlewando@redhat.com>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Jon DeVree <nuxi@vault24.org>
Subject: Re: [PATCH GRUB] fs/xfs: fix large extent counters incompat feature
 support
Message-ID: <Z1C4BB31S9HdYlDM@technoir>
References: <985816b8-35e6-4083-994f-ec9138bd35d2@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <985816b8-35e6-4083-994f-ec9138bd35d2@redhat.com>
X-Spam-Score: -3.80
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email]
X-Spam-Flag: NO
X-Spam-Level: 

On Wed, Dec 04, 2024 at 07:50:28AM -0600, Eric Sandeen wrote:
> When large extent counter / NREXT64 support was added to grub, it missed
> a couple of direct reads of nextents which need to be changed to the new
> NREXT64-aware helper as well. Without this, we'll have mis-reads of some
> directories with this feature enabled.
> 
> (The large extent counter fix likely raced on merge with
> 07318ee7e ("fs/xfs: Fix XFS directory extent parsing") which added the new
> direct nextents reads just prior, causing this issue.)

Indeed 07318ee7e11a has a commit-date after the author-date of aa7c1322671e,
so it wasn't applied to the tree yet when I submitted the patch:

$ git show -s --pretty="%h %aI %cI" 07318ee7e aa7c1322671e
07318ee7e11a 2023-10-17T23:03:47-04:00 2023-10-30T18:01:22+01:00
aa7c1322671e 2023-10-26T11:53:39+02:00 2023-11-22T19:13:46+01:00

> Fixes: aa7c1322671e ("fs/xfs: Add large extent counters incompat feature support")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks for catching this,

Reviewed-by: Anthony Iliopoulos <ailiop@suse.com>

Regards,
Anthony
