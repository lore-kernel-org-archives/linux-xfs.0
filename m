Received: from mail.hallyn.com (mail.hallyn.com [178.63.66.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8CF1F4C8E;
	Mon, 29 Jun 2026 13:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.63.66.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782740977; cv=none; b=gAxhyG7ePjockNnaIW/GhIW6eUorqN9JZpIV16d07+o8nU87V3HloteBsTS6e8U29DYaFGgxBfANvnprihnYlwbB58EjYZyW9Q86SsaWjxh+7HBJgsROBVjki3eRAiGj4OUDeblxODTHpEin7mYZK8vnXs1Oux1W0ZpzKJFl3/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782740977; c=relaxed/simple;
	bh=xcs7uXt3Py23xY0MK7JE2MEXRlrZ+6wVk+xm1SDt8C4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j+vUfKc1uzAytceheTBzg7xNAyxL9n3/G74GcOz4fl1ap04r7CoaTO7P2PJAi5CDvDSDR4V/7utP1k289mpalCQn6sFuYqpftmIpdRQBa9S/Ky/Em2moFlCpJGaY6qKmrO7rkorPiMD6+nn18+kQ+vuiY3Vs6fmNofgRqbPPTH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hallyn.com; spf=pass smtp.mailfrom=mail.hallyn.com; dkim=pass (2048-bit key) header.d=hallyn.com header.i=@hallyn.com header.b=vSObxrMv; arc=none smtp.client-ip=178.63.66.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hallyn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.hallyn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hallyn.com header.i=@hallyn.com header.b="vSObxrMv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=hallyn.com; s=mail;
	t=1782740966; bh=xcs7uXt3Py23xY0MK7JE2MEXRlrZ+6wVk+xm1SDt8C4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vSObxrMv3wHTJ5gTUlgL6RPVWXeCSUOEaDaOACyd5rmuQXNApKq7CpskbubsXRDXv
	 LOEi3p3ObKrfq4zQbr2C4QCNwW7qSBWkjA2F/K84eUBU/vP62zrkAb1k6u/xgd4+WZ
	 UwRVN6VCx6/lnh/UIhey0gJCng9u5i4ubVoxXP8kNqjLr/SxzvguxTCzFQCMYXnEEV
	 lyPsSWZN84NWONiTVVjJs0N9Rr/oxTMq7hMFqN7sUfHhiPWFZCZfc9D6oUaKESiEyh
	 ix0rbalnuk+u2zx7fBpAnZFvJ1kJS9KktPyAozaZpkjKcLAgfypcla8ePLWV5kJP8m
	 hstMdPNdeSOyA==
Received: by mail.hallyn.com (Postfix, from userid 1001)
	id 9EFCA75C; Mon, 29 Jun 2026 08:49:26 -0500 (CDT)
Date: Mon, 29 Jun 2026 08:49:26 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-fsdevel@vger.kernel.org, jack@suze.cz,
	djwong@kernel.org, serge@hallyn.com,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] capabily: Add new capable_noaudit
Message-ID: <akJ35qliH+npZ3iv@mail.hallyn.com>
References: <20260626114533.102138-1-cem@kernel.org>
 <20260626114533.102138-2-cem@kernel.org>
 <20260629122939.GA21958@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629122939.GA21958@lst.de>

On Mon, Jun 29, 2026 at 02:29:39PM +0200, Christoph Hellwig wrote:
> On Fri, Jun 26, 2026 at 01:45:20PM +0200, cem@kernel.org wrote:
> > +extern bool capable_noaudit(int cap);
> 
> No need for the extern.
> 
> Otherwise this does look nice an clean to me:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> But if the security folks don't like we can live with the more
> verbose version of it I guess.

Honestly I'm ok either way.  If people misunderstand the shortcut,
and ove-ruse it, that's safer than the other way.  The one that
scare me more is ns_capable(&current_user_ns, X).  I need to do an
audit of the current users of that.

So I'm happy to put

Reviewed-by: Serge Hallyn <serge@hallyn.com>

on the set.
