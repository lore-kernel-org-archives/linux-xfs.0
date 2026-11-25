Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795585590;
	b=oduw/g25JYhNVmZKztNZ0ZNxpkIM5aO60bWiZy6dFNrNnTsizTbiP7/jobiTn1ehrtEi
	 WxXLSk8/uWDcz1QH9I0s+sbmbD/T9lGqfH5xJc1mzHyLmubANXEwGlO4xfxQucn9UbNqf
	 jhr+P53Bc/mu4WJ19tC2MZU+G/jZUmp5qUpSa+i4BahKbFaoRACNAkK66oPsGM/inEQcv
	 A3+nzAKoCbSG56F4WiUQKx2E/cyqkTwSVUlfnp9Ox8fWKQwUvPL6R2V/uEzTckFAqPShJ
	 U//XHBc81FZmnb0t5d5tBKh1tq6vS+4R19Pd4qJws1JajCPmfSbdQcCdEjuKOQo2gkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795585590;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:User-Agent;
	bh=UjppQW2z3LMcQZPhdZjylAHGYGZ3oGJ4FmReTYyNVi0=;
	b=B2SkMnhICtCTxkc5dgRn0nlbMfqk5R4zhRNdEPX9qYhFYzV/pVaSXwSX5aXDfhTr+d/w
	 RydSNWhOHMJrwmo1hlkdwcPGMcyuelQCHxTiu2pnXkTEEUfra0+IibZ1KFP5lY3f7Goti
	 HdNjcX+IqwLIHCRXJqDydAEyjA+/0e30/azF3bc6Pui/fAjK0pPiN8s1jNpYzKdH/r/lt
	 8wuy5VubIoFWrzfNmuAGZpdAnS0B1Ty5R68nATldSXiXlj1Mmn3lBmNVMqryKcrW1vc0t
	 zZt1h/wkSlkRXxtMKBsCj3axQN8TSR8cHUpKqx0dPPCgNQu2wn4xeaZizYO2/vbaQ5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB602606A31E;
	Wed, 25 Nov 2026 05:46:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB602606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DEB7968BEB; Wed, 25 Nov 2026 06:46:24 +0100 (CET)
Date: Wed, 25 Nov 2026 06:46:24 +0100
From: Christoph Hellwig <hch@lst.de>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	glaubitz@physik.fu-berlin.de, frank.li@vivo.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	vdubeyko@coreweave.com, linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v5 1/5] iomap: add iomap_dio_end_io() helper
Message-ID: <20261125054624.GB20515@lst.de>
References: <20261118004844.3849979-1-slava@dubeyko.com> <20261118004844.3849979-2-slava@dubeyko.com> <20261120-flach-befanden-notaufnahme-b0a663466be3@brauner> <20261120182135.GA2183@lst.de> <ac4e59cc1a1a89fc5d3b33aa481cfa8372562f2d.camel@dubeyko.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac4e59cc1a1a89fc5d3b33aa481cfa8372562f2d.camel@dubeyko.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 23, 2026 at 02:25:52PM -0800, Viacheslav Dubeyko wrote:
> On Fri, 2026-11-20 at 19:21 +0100, Christoph Hellwig wrote:
> > On Fri, Nov 20, 2026 at 02:48:09PM +0100, Christian Brauner wrote:
> > > On Tue, Nov 17, 2026 at 04:48:40PM -0800, Viacheslav Dubeyko wrote:
> > > > The helper updates i_size without any locking, so it can be used
> > > > only
> > > > by file systems that issue all direct writes extending i_size
> > > > synchronously (IOMAP_DIO_FORCE_WAIT) under inode_lock.
> > > 
> > > Meh, this should really not be named so it looks like its the
> > > default
> > > completion handler. iomap_dio_end_io() really sounds like it.
> > 
> > Well, it actually should be the default handler as it does the right
> > thing for simple file systems.  In fact I'd prefer to automatically
> > call it if no ->end_io is set as that would remove a lot of
> > boilerplate.
> > 
> > It would be nice to do that and remove the duplicate version in
> > various
> > file systems.
> 
> So, what's the final consensus on the function name? :) How should I
> name it?

iomap_dio_write_end_io can call it directly from iomap_dio_complete
for writes that don't have a ->end_io caller.
