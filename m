Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32420111AA
	for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2024 15:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718812752; cv=none; b=LKDnLDPtja44Ahsy+2OOb3m5kD9tuqoP3jtWxM+UmjA8k9EShExXZPh8Cb6FjvSzHte7dA/tB+OkgnwqQpvKl+r8eHWp+KOeRjffLLdveyl328TYeHK5UsDtsF6LgEhe7IRaVBSyT03DLNoMNuUY9Cr7msemZP5VGZMPFtH5TPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718812752; c=relaxed/simple;
	bh=USwJGSoO5sZcPf4gAX5sn9gBXGRBmNhLWmHn/owdrcA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ex/SdQSgNNnEUAWVXmpt+UdqRGvkLbtAPB0CHeRLlS1g0YKA950V3YFmHajLsTzLNWvZXNrhe6/vzpcbWDrM+HuNzSIOC82W+5RVeG9n3tqDEJcTzupqcUSHiRcniypAuzoE77Y7Zxj1xEnmzpD2NDMGjs7nBRwsngIlVy0x9iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 43165219DA;
	Wed, 19 Jun 2024 15:59:08 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DC72A13AAA;
	Wed, 19 Jun 2024 15:59:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aDphNEsAc2ZGLgAAD6G6ig
	(envelope-from <pvorel@suse.cz>); Wed, 19 Jun 2024 15:59:07 +0000
Date: Wed, 19 Jun 2024 17:59:02 +0200
From: Petr Vorel <pvorel@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Li Wang <liwang@redhat.com>, Zirong Lang <zlang@redhat.com>,
	Boyang Xue <bxue@redhat.com>, ltp@lists.linux.it,
	linux-xfs@vger.kernel.org
Subject: Re: [LTP] [PATCH] configure.ac: Add _GNU_SOURCE for struct
 fs_quota_statv check
Message-ID: <20240619155902.GA477172@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20240617053436.301336-1-liwang@redhat.com>
 <20240619092704.GA428912@pevik>
 <CAEemH2d=m3qAJkiv86B+L+iTc5qc+phGn+GO=kEe_fGOXxEMLQ@mail.gmail.com>
 <CAEemH2fH6tX9obxcVS6XJLcMvAvOz-JPe6wWoQdv26x8GAx2rQ@mail.gmail.com>
 <7aeebecc-d5ef-4eea-a4e5-ddbfa411ee1e@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7aeebecc-d5ef-4eea-a4e5-ddbfa411ee1e@redhat.com>
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: 43165219DA
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

> On 6/19/24 7:08 AM, Li Wang wrote:
> > cc Eric Sandeen <sandeen@redhat.com <mailto:sandeen@redhat.com>> who is the author of:

> If adding _GNU_SOURCE to the LTP configure.ac fixes the problem,
> I have no concerns about that.

> However, I also sent a patch to fix xfsprogs - having this wrapper in the
> header is really unnecessary, and will likely cause problems for others
> as well, so I just proposed removing it.

Interesting. OK, let's merge workaround.
Reviewed-by: Petr Vorel <pvorel@suse.cz>

> https://lore.kernel.org/linux-xfs/be7f0845-5d5f-4af5-9ca9-3e4370b47d97@sandeen.net/

Thanks for info! Your patch IMHO makes sense.

Kind regards,
Petr

> (This problem only recently showed up due to other changes, see the explanation
> in the link above)

> Thanks,
> -Eric
