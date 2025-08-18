Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D9A263F52;
	Mon, 18 Aug 2025 04:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755491856; cv=none; b=DqxzdMMAacRIotHqY8rwGEggjPP++hG021BHCcQ3sXD0yEpqTINjZ+gt0EOksRjmnqS0UxTZQpbsa72xtZ6r5nxtBcbsvymu7ITW24Eaak8ef8OXHawxU4blFsG+6mHEfhqQlctAcwAHvumR+Nmb5ijj9SMZOCxzS9gHWrEckXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755491856; c=relaxed/simple;
	bh=OzKhllUJgxE8f5DRItzMWTr/zxmwFP09zIVFJRCdTcw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jdzii0JvG/MCNgVKVzObAHAoqUdO/omEKqPUPamDWaARy73ZiQmzFWhR85CeuznxwmDTS/VP+koHpDfbvek/l8vc4/97e0sikQcLl90eEwHw1UchMst+aZpOXMFEgjb8zPfcizZPC2wGY5qXHTWL3iR4jY7ylWJTj0SMZAfDub8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vUZItgjx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vUZItgjx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=maYmslETCWG8Wv0ihlJT3aab029z77BNwcKFXO/89co=; b=vUZItgjxxZas5wL13tDBNXNK7t
	PX6Q4zBDQnENVNwDdJKtZXjVbF7D+JflkRgwsADb6sNjvhslRZ0TUhS2vdSY1mPxyJu1M+uAiELMR
	5mQOZVja3o1W8nJN4hQMEtuVcnavMc+Lmnx27XyfAoVvDojMItVpQCZEiuQSbpuOxtFkGIqTlU6cl
	fIR6sYH+p6Pzh0Xs/SY2t03+h+EfDWaEVX8DLv3dhm59/WuwR4rL+bmSxVjSHgjXljQZPdGQE6ZCA
	jGVjzxae3YSAUPNDVqS/+9c/9Ohghzf7bz3fmiiquBOSmPBU79C8qsTz+vqvPsW7TI1LL29GUBo0I
	K7R6ZLHg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1unrci-00000006Taw-4Bg1;
	Mon, 18 Aug 2025 04:37:32 +0000
Date: Sun, 17 Aug 2025 21:37:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, zlang@redhat.com,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] generic/427: try to ensure there's some free space
 before we do the aio test
Message-ID: <aKKuDLPgJqlCKXYz@infradead.org>
References: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
 <175381957936.3020742.7058031120679185727.stgit@frogsfrogsfrogs>
 <aIopyOh1TDosDK1m@infradead.org>
 <20250812185459.GB7952@frogsfrogsfrogs>
 <aJwfiw9radbDZq-p@infradead.org>
 <20250813061452.GC7981@frogsfrogsfrogs>
 <aJwvi03EX0LWzXfI@infradead.org>
 <20250814221623.GT7965@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814221623.GT7965@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 14, 2025 at 03:16:23PM -0700, Darrick J. Wong wrote:
> On Tue, Aug 12, 2025 at 11:24:11PM -0700, Christoph Hellwig wrote:
> > On Tue, Aug 12, 2025 at 11:14:52PM -0700, Darrick J. Wong wrote:
> > > Yeah... for the other ENOSPC-on-write paths, we kick inodegc, so maybe
> > > xfs_zoned_space_reserve (or its caller, more likely) ought to do that
> > > too?
> > 
> > Can you give this a spin?  Still running testing here, but so far
> > nothing blew up.
> 
> Running inodegc_flush() once doesn't fix it, but doesn't hurt either.

Weird.  I can't think of anything else that would hide the available
space in this case.

