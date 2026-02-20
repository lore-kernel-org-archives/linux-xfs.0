Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A5A2DF14C;
	Fri, 20 Feb 2026 07:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771571964; cv=none; b=YD9nthwsXmXJJCmbhvSu2JPzIM60c0DP7YX4l7rcCFdhX8x6PojxzozcN2pZtHDnXS/LPRJlPJL3b6qfQk+H9048UCUX9+O/yPnKVnVicvpZE8BZW3ucwBf3YvHUpLRpeK5OmL6v5a2xaJf5U5WV29lOvj4avfEHWEEDINJOUC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771571964; c=relaxed/simple;
	bh=sglsmqLF4TahxSEHlwTANaP7p5etcxSHxssDTkHgyA0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RFTvF6zH/O4wlv67TgPdbUsilg2tJxe6Dw0zNZ8o+9vyOP7cbxf3B9OYqa3W2xZMuK/w7bizL2b7VLM2qkeo1bnFPStDexhzgzrBi5TLETDWY65noD17JAjq2uTjIT2OGNaWFriZfVUPLuoj1XlzTvXs2eeOmEc6Sh5SF0LMGvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=CyLoXWkx; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=wn1Uy6PE; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="CyLoXWkx";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="wn1Uy6PE"
Date: Fri, 20 Feb 2026 08:19:20 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1771571961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sglsmqLF4TahxSEHlwTANaP7p5etcxSHxssDTkHgyA0=;
	b=CyLoXWkxPlrZ+1Ce9Rao9dJ4NrMjsme5vaMAUHhg5TiDxy25kho/eGXNF/dsz2h9bPqpeb
	+ub7zq7/coVITFK2UaVmHF/caOTeIGZu0Q9mmAOkN+o7TuaFy+habfzVhcydstzQyPxppF
	tDmvyBf7A+DOlqIzQ+3mZKxd9+wCVSsCRCiI/8La5bKOhdaYqgUyCYtNRD1jRXWCVKsYK5
	7lsMjQdvrguV40qaRUoMTw527+kirgq5AMJ0Rt1wKTY/mrAErg/HE9HJ/GW8O4oQGy8+Cy
	LnmbEpXsBeNIr/bX/nWQvd+KAe3qWwVJT66ivxEqVf0ONPlfKhCI6mDVBc7rEw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1771571961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sglsmqLF4TahxSEHlwTANaP7p5etcxSHxssDTkHgyA0=;
	b=wn1Uy6PEHAHQZ+PjUSOYXvyitg8noSGmlpoZPJcohfG/l/wlNgqHRRgI2G0WKLz1NimouE
	PUF4oI+9NoUfzqDQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Dave Chinner <dgc@kernel.org>
Cc: Marco Crivellari <marco.crivellari@suse.com>,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Anthony Iliopoulos <ailiopoulos@suse.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH] xfs: convert alloc_workqueue users to WQ_UNBOUND
Message-ID: <20260220071920.AbnjY1R-@linutronix.de>
References: <20260218165609.378983-1-marco.crivellari@suse.com>
 <aZZmVuY6C8PJMh_F@dread>
 <20260219072556.Bpnr4F5x@linutronix.de>
 <aZeXJeV_EfmOzCxh@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <aZeXJeV_EfmOzCxh@dread>

On 2026-02-20 10:05:09 [+1100], Dave Chinner wrote:
> > Never origin from a user task?
>=20
> Inode GC is most definitely driven from user tasks with unbound
=E2=80=A6
Thank you for the details.

Sebastian
