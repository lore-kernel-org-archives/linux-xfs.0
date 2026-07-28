Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA7F374758;
	Tue, 28 Jul 2026 03:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785210741; cv=none; b=XN2DgHlC7g8sPm0Xt/m/DlDhpKqhH5SSlyH/XpUlXZC26FohCLi/0ZPORloAOUBYWeyM1vBKPw4nOaLOPHvWSZTQc23hx1MzL8IiGHgSuuIfHLtVcBqM5Evc4Jp3oj56k+9c7JLSc14QdvnYhPmvCwE4Wke9AyAjjFkPA3ESa28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785210741; c=relaxed/simple;
	bh=Fsopm8ahpXI0YzA/d1nGteS4G1kmC/HaET+4wI1aOR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n4+9PLwhMd9WYd6Oc91lw3YhPMMj1g3Ly+q6JoP+gCCdtLQNNR8i1C7mVJMqusHrKbOa2J3CvFxz0ECarHnlWxotEQ9gQdlTvVOj0Ea1+hltumzBWm/anY6PEbiXVQ2RXSvBaUaMd+blOfDHF1jAyAkP2OeMQmlmok/oImlSHiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0B7F768AFE; Tue, 28 Jul 2026 05:52:18 +0200 (CEST)
Date: Tue, 28 Jul 2026 05:52:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	changfengnan@bytedance.com, Christian Brauner <brauner@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, Carlos Maiolino <cem@kernel.org>,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/3] iomap: decouple simple direct I/O reads from
 iomap_dio_rw
Message-ID: <20260728035217.GA19245@lst.de>
References: <20260723050201.3381045-1-hch@lst.de> <20260723050201.3381045-3-hch@lst.de> <20260723164722.GF7380@frogsfrogsfrogs> <CAJnrk1Z9wxXf+=d-+5VMcCiDiy4Q7UsBGvzwaPQtAok6avjKPw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJnrk1Z9wxXf+=d-+5VMcCiDiy4Q7UsBGvzwaPQtAok6avjKPw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 24, 2026 at 02:39:49PM -0700, Joanne Koong wrote:
> > > -     ret = iomap_dio_rw(iocb, to, &ext4_iomap_ops, NULL, 0, NULL, 0);
> > > +     ret = iomap_dio_read_simple(iocb, to, ext4_iomap_begin);
> >
> > I was kinda wondering if you can pass ext4_iomap_ops.iomap_begin here
> > to avoid the declaration in ext4.h?
> 
> I think it ends up being a bit cleaner to do it here, otherwise the
> subsequent ext4 patch that replaces .iomap_begin()/.iomap_end() with
> .iomap_next() will have to do it.

Yes, we'd just do the work twice otherwise.

