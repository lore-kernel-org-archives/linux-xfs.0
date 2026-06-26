Received: from mail.hallyn.com (mail.hallyn.com [178.63.66.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAF83A759C;
	Fri, 26 Jun 2026 17:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.63.66.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782496490; cv=none; b=MMkGV+YjanEHyEv+nmWiCyfsY2M+9hVl2M5lar2nIn8f6sfAWBF82hLcpE2/hE++ORnejI7zGhRPFySIRr8P2l5+vNBeh90QJGKWIuM/ncD/5oD6yZ2HZye62BBP5B7DkRnprR8kGk0Iy2LvhBPZ35/TS+y0iHYRfdU6TUWP6TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782496490; c=relaxed/simple;
	bh=ZvifW5GkM3RqyG8r+vlWapDYa4Tif4vyCmX+yNfLQgw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FJiNT7P3IjJAUqA8lSHwnJ/WNmOUPJcUAQ7/UaUPrWT5+XGHyZG8r0VT998VEQeqbjh1VDQ2ZU5e2E0aIZP85jbP1FUTeBnJNBGttgcx6JA3lICGZ9ioal8wyp+CSUjghONV3Ci4UlYjDY9/9veH74qtRPCJgCYF62K423X6Oy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hallyn.com; spf=pass smtp.mailfrom=mail.hallyn.com; dkim=pass (2048-bit key) header.d=hallyn.com header.i=@hallyn.com header.b=PBtjy0cO; arc=none smtp.client-ip=178.63.66.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hallyn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.hallyn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hallyn.com header.i=@hallyn.com header.b="PBtjy0cO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=hallyn.com; s=mail;
	t=1782495994; bh=ZvifW5GkM3RqyG8r+vlWapDYa4Tif4vyCmX+yNfLQgw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PBtjy0cO4GOSYTPW9dQQpAC3jhHDkU0YctCNOMURVw5SK/2U0GdUVl7ALKArQi89g
	 nyA6z1yCZ+JliCMl328Kq2PVOlz/MIt1pPpTMSh+OdxxFErpm+Jk/Y0wfXavQyc8BQ
	 4/lyCNcvwVI2/Kv81HwPeumkSbekxubw8vqXt9Fd5mi2+zyR58Vwt6sJyxMFYiiJd+
	 DzAzhaeFLkR8O4EjZTbj6pr/ybWZPfPb/pSg96IFeWL9w8H1sa4DkAjPzQ6WJrBILJ
	 XB2uxSldQcDjp4I1gEUKWsdZfMH/GqvUx/oawjX0pYUMZGM9qsLA9TaE5VgtMa8WS1
	 GWyvAZ7ToPjKQ==
Received: by mail.hallyn.com (Postfix, from userid 1001)
	id 611D7ECA; Fri, 26 Jun 2026 12:46:34 -0500 (CDT)
Date: Fri, 26 Jun 2026 12:46:34 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Paul Moore <paul@paul-moore.com>
Cc: cem@kernel.org, linux-fsdevel@vger.kernel.org, jack@suze.cz,
	djwong@kernel.org, hch@lst.de, serge@hallyn.com,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] capabily: Add new capable_noaudit
Message-ID: <aj66+o90iNkPfRJ8@mail.hallyn.com>
References: <20260626114533.102138-1-cem@kernel.org>
 <20260626114533.102138-2-cem@kernel.org>
 <CAHC9VhQNURc=d4AOVDF-z29fjLasCiLf120Y-N3txEBccpkfSA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHC9VhQNURc=d4AOVDF-z29fjLasCiLf120Y-N3txEBccpkfSA@mail.gmail.com>

On Fri, Jun 26, 2026 at 11:31:06AM -0400, Paul Moore wrote:
> On Fri, Jun 26, 2026 at 7:49 AM <cem@kernel.org> wrote:
> >
> > From: Carlos Maiolino <cem@kernel.org>
> >
> > In some situations (quota enforcement bypass in this case) we'd like to
> > check for a specific capability without triggering spurious audit
> > messages from security modules like selinux.
> >
> > Add a new helper so we don't need to use ns_capable_noaudit() directly.
> >
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  include/linux/capability.h |  5 +++++
> >  kernel/capability.c        | 17 +++++++++++++++++
> >  2 files changed, 22 insertions(+)
> 
> This is Serge's call, not mine, but FWIW, I somewhat prefer to see
> code use the ns_capable_XXX() variants directly as I like to think it
> means some thought went into ensuring the capability check is being
> done in the right namespace.  Yes, we all know that capable() just
> uses the init namespace, but I like to think that having to type that
> out in the parameter list might be a good double check ;)

Hm, yeah, on he one hand it seems like a nice shortcut, but I still
see people confusing what 'capable' really does, so standardizing on
ns_capable_noaudit(&init_user_ns, x) might be worthwhile.

(and then patch 3 can go)
