Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B3B31195B
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2026 20:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784232160; cv=none; b=o6kgI0uz8NS5eqgaEd8ss1Mr/dIN9QaTymLm7sMS3DJ6ggC+22TWA+inFhOAAB2VcXfdiZKWdzASBlASXS1mhNMSDNMLjcH/s7543wav86jA8s76K/lXvYq0pteAag85ecDf1Sda/LPllI8d018Jv89WPp3HBb2qmeeY1odPQbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784232160; c=relaxed/simple;
	bh=cgGWxUwoS8aEbnH6YsB7f1SMuYyIyKoih0lddUbyO7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uZkMVaaXQRiPZ3zJsL9u2MvJugVNyQzDEWKWEE8bhwJj0TFXWa3LeJZGfEOLAFIKJvKvxDvGC1JR+XagWE+a1sIiujWvHN21Il9U6iPvS3xivgfMduP8APGeFEX6xyYUQs4ntnBd+MJxmtVPJt4m0gwhL3IQwe9yvBHSxxhboS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com; spf=pass smtp.mailfrom=fastmail.com; dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b=jZNJaNPp; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=RsT1l1qg; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b="jZNJaNPp";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="RsT1l1qg"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 090C3EC01DD;
	Thu, 16 Jul 2026 16:02:37 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 16 Jul 2026 16:02:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1784232157; x=1784318557; bh=7gIh0LveU6
	ACrOvY7YJlbsdsolFxj0aPw+3QJFL/c2w=; b=jZNJaNPpMbb1YKclxZ9zXg/GBW
	hUEz6KleI/MHjvIKpF77Xuq4rymODXGaSOMJWNF3amJf6fStMKOZ4ZyoEIGPzBx7
	at9kiOTPN0ho0nhTtaDgxCszRvcniTjBG5FEfa6tcj9kYw/nspzcZk2hKbX97KDp
	Zv7Sx3yVhccBsdHtJee2de5vYdPLAwkWvlDHoqww5v0t46JMpCajOKsN7uXoF8H7
	kyaIzNsyXJmI0b8Ukw5PIxOn4nSWV9hLoO6//qRvUnM5K3KMJq45204WJSp9D3Fo
	10AB8JsESSxIX/iiN5ddCw++kT34+i3lhtm0HrZlB9Qa3exNabZeSXsX9Lgg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1784232157; x=1784318557; bh=7gIh0LveU6ACrOvY7YJlbsdsolFxj0aPw+3
	QJFL/c2w=; b=RsT1l1qg35NHjsiN9q1KlmNrAIAX19AWw/Fpu5y3c2xKsT+Fw0S
	WqEWmOea+TDoXQJtSsu6o4Yyhu0ZFXKHNtUjIvzds9tYhQma7qCYLeCRKPeb0VwI
	1SKMzMhr6umxoCISYDSwmZp9iEmhcbGDKQSc/Pz+K+Okhfie+LTtTNYdEoAQaP3a
	m8zJCJB7ETkcg8taFE9iYnaWxndTJRmAu4nZHaEYNJDl2Vo8AAQiK0jVsdovxMJh
	n8RUHlJXGzyA+yyo2TX1ZT8zsuBFdK7AQyxGWjWTMK+CNkNa4P+S7IGLwL6pKR6P
	ran8IZp1/urQZQ4urr7icZ+EcS0CYOM6QDg==
X-ME-Sender: <xms:3DhZaq09TTGMi0zol2FgTo_tvbaUcNx7On_rLy4rG0gKi1scv43TNw>
    <xme:3DhZajFQXB1GxfhOYDNXwrTuseqKRNrdEX1_6YP6ly2SxM3u83srkex2LUSFBvGD-
    6DnYw27ryQfYfUZzrO4Jnc1j58vHRz0g9Hp-bWIniAP6PwW6Jnm6GI>
X-ME-Received: <xmr:3DhZagghzw-00Q_tDYJkUu1yYIDqE1LJsf5i5e7U6lf84I4nHSh20D0C6z799cEeHMXvRz7w_AgVzaNAzsL_b3mI6q_p_No>
X-ME-Proxy-Cause: dmFkZTGfZkWL1Pc1SO/4bWMF1fJ6CiJ5Xq51dKgrnguLQRYS1RRK62UxI6zjBBpVhrkgPH
    Z1AbhXvSZh3o2HyMlYe3uTWI91Yzy6d8vPeuYS0fubvABKibTC84uELIXkTGUBBwijqeQc
    wF3oDQ3UR5RJk1W2p/fi6VtgMMqKNncxQPirbs/vhimFRT1RpqO4nNSxpoCCkiYDDW1vTE
    mNaGmo7TyDhKQAM0xG+iPXAC1PviSim2u1Fa92wvaJpjqP6PZNW2n7yyf7L83vZ4DlygF0
    zAHOSoeyDTDzvH5QDEa6Ys8oIP9xE7EHGZIELRS7HCn9Y0cYvuol2y1hNb80wYOOVXdmtz
    bXu/e+M3nbZg2UePKF27Dz9asgdV8pI4kGrOM9yoQdbuMd7Y28mCmgsh5GdUrAFseGCduq
    itSLmL2SXw28NZG7mtbPNVG2NC6O4UD2P4sh7OT9rHHFHb+zzG4r0VLGQ1qAAnN92vGlVh
    t0acpQz2guCiz6K9dtQUw9HWWz6ACLKPNSmhF9qR72PQJNPtiZSSI9v2lDYgU81fkIJGm9
    HVNE4fXlUml5nQTJCqvtkSjuajwpfQxRUg3WT8ZO/Ce5vN18LarZRiM+UZCsYDfxWvGqID
    pV+7U1E/D3do5Qr6H4jC0M67q5eJlXEOSv9mlyU1deDEz7CqGb04L/3jl1Qg
X-ME-Proxy: <xmx:3DhZam-JGF66eqjQ84FYatWHHV1GJZSmWPHHOP942dZG2P023OBV_w>
    <xmx:3DhZavq7Bvqhy0RGn6S7vkHGqqwMERrxvX8tSpdQ9gXU2nW90RwY3A>
    <xmx:3DhZat-Q0DXeXRs-cH5wpcDJ2G8kjXQuW_ETHg5h7JtY8WX9X25YaQ>
    <xmx:3DhZarW7Hhckmqiagufl6tzPDACnH1wlIkMpdG72JfIKqv4VxFWQuQ>
    <xmx:3ThZanmLU2I09mc0lBUBjx8IflRGM15QorWmax5naYXD8WSBABqOFhRQ>
Feedback-ID: i01894241:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 16 Jul 2026 16:02:36 -0400 (EDT)
Date: Thu, 16 Jul 2026 22:02:35 +0200
From: Jan Palus <jpalus@fastmail.com>
To: linux-xfs@vger.kernel.org
Cc: Reilly Brogan <reilly@reillybrogan.com>
Subject: Re: xfsprogs: 7.1.0 Build Failure
Message-ID: <alkzIx0H-cn169RI@pine.grzadka>
References: <CABqFQkar-sMMyZGw4KfAV51x7F65ddF7d8cszQ8iWiprvnKMFQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABqFQkar-sMMyZGw4KfAV51x7F65ddF7d8cszQ8iWiprvnKMFQ@mail.gmail.com>
User-Agent: NeoMutt/20260616

On 14.07.2026 12:10, Reilly Brogan wrote:
> We're seeing a build failure on AerynOS with 7.1.0 that we didn't get
> with 7.0.1:
> 
> ```
> Installing healer-install
> ../install-sh -o root -g root -m 755 -d /usr/lib/xfsprogs
> /usr/bin/dash ../libtool --quiet --mode=install ../install-sh -o root
> -g root -m 755 xfs_healer xfs_healer_start /usr/lib/xfsprogs
> Usage: /mason/build/x86_64/xfsprogs-7.1.0.tar.xz/libtool [OPTION]...
> [MODE-ARG]...
> Try 'libtool --help' for more information.
> libtool:   error: '/usr/lib/xfsprogs' is not a directory
> make[1]: *** [Makefile:72: install-healer] Error 1
> ```

The issue is a combination of how libtool works and how xfsprogs invokes
libtool especially with regards to $(DESTDIR).

If given single file to copy libtool checks destination param -- if it's
directory then file is copied with same name, or if it's not directory
(ie destination does not exist) the basename is assumed to be new file
name. Either though it is not xfsprogs' intention that's why it works
throughout all Makefiles. Single file is "passed through" if last
component does not exist and later `install-sh` takes care of
adjusting destination with $(DESTDIR).

Things look very different when multiple sources are given. In this case
libtool mandates existence of destination directory and `install-sh`
does not get a chance to incorporate $(DESTDIR).

Source: https://cgit.git.savannah.gnu.org/cgit/libtool.git/tree/build-aux/ltmain.in#n2523

Note the issue is a direct consequence of:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/commit/?id=79551362141a051faf9c3d504fe18ee34ca800f8

and I agree it should be wrapped in a loop.

> 
> We use slibtool as our libtool implementation and dash as /usr/bin/sh
> so perhaps this is an incompatibility with either of those (likely
> slibtool).
> 

Are you 100% positive you're using slibtool? The error above looks very
much like coming from GNU Libtool (as well as help message...). I did
test slibtool and it actually works for me in similar case which could
lead to a conclusion about slibtool incompatibility :).

> It looks like the issue is in `healer/Makefile`. On AerynOS at least
> `$(LTINSTALL) -m 755 $(BUILD_TARGETS) $(PKG_LIBEXEC_DIR)` doesn't work
> if there are multiple BUILD_TARGETS, and this is the only Makefile
> that uses LTINSTALL like that. If I replace it with a loop to install
> each target separately the build succeeds as expected.
> 
> Regards,
> Reilly
