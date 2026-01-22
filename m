Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0F328136C;
	Thu, 22 Jan 2026 05:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769061602; cv=none; b=ec9usn5+MQQZJRF80MpJQCxufRH+LVTWH+caQA9u0T661zyzviGvIujcBs0SVvDXo2yd3TgN5G6Lwh0GoDsltfp+qwxCA+kDg3bE6b8j8WSUe9T6xoCN1T9vCXmQVKX1JkXtkZBgHSC1303ghZ8AIVRu/CDExYps0zuRLU+C35U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769061602; c=relaxed/simple;
	bh=AUM4cTsAHo2KpfyeYkwusVbFC2K/h4rgaNm312fW9tc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eRyRDIp3iTZ5F+LqBGfGL/NKVM0r6o1lOFzfnIN28Avf0o9Qsvd6z3Dfn63+XxwBA7xeqwhNJfRzSrYuqhi/ogiZjWRu2Xdi3y+SMdJZmMdO6mEQ3gqdVZzY8K3Uji/cM+AhKGkro5uDIkNEaXy4mdgWv9WOuzc27XP2SoE1USA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E5719227AA8; Thu, 22 Jan 2026 06:59:56 +0100 (CET)
Date: Thu, 22 Jan 2026 06:59:56 +0100
From: Christoph Hellwig <hch@lst.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/15] iomap: only call into ->submit_read when there
 is a read_ctx
Message-ID: <20260122055956.GA24006@lst.de>
References: <20260121064339.206019-1-hch@lst.de> <20260121064339.206019-11-hch@lst.de> <20260122004451.GN5945@frogsfrogsfrogs> <CAJnrk1YAbcODi8pkG9XawciDpaHqdbZE+ucji73D_F=Jv1kQXg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1YAbcODi8pkG9XawciDpaHqdbZE+ucji73D_F=Jv1kQXg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 21, 2026 at 06:44:12PM -0800, Joanne Koong wrote:
> On Wed, Jan 21, 2026 at 4:44 PM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Wed, Jan 21, 2026 at 07:43:18AM +0100, Christoph Hellwig wrote:
> > > Move the NULL check into the callers to simplify the callees.  Not sure
> > > how fuse worked before, given that it was missing the NULL check.
> 
> In fuse, ctx->read_ctx is always valid. It gets initialized to point
> to a local struct before it calls into
> iomap_read_folio()/iomap_readahead()

Ok, thanks.

