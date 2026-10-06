Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087091DEFE8;
	Tue,  6 Oct 2026 15:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791300216; cv=none; b=sDZIKEoQGiQb2Arc0gYVCC2GwTHyEnr/yX9ym8KTVxeyqwquHCLDXKWT1+Dm0TJTXa5UwmlMy0sAxAkiukKmNMiZfI8pRp4XeiOtvXypAsonoh0l4P2H3GTSgCO+SdNCIue2Ui1S6myyk+AOcRmtbvLH3LOvBLLaHEPfhHIg/To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791300216; c=relaxed/simple;
	bh=EC29gFy+OdLNQxp+scdY9VrpHI3ekrtwUlc2nqRqslI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GwF4puJ0va1N15qy1wgxnFxdB1ZE5xgk+VojWnPQRkrqYI4XmzJYLlwsjFZYvIV+p5A4wjJ/WcEe97gTnIb5ZuvW40zlx4a/fmtAIHg7HD+mh0XvkhOzfbzHkBTVhksAteu1QoDNCTJlnuazGqMQogLbT33ZCnemPBrgw60n6Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ULGrS2Zb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ULGrS2Zb"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 89E0A1F0089B;
	Tue,  6 Oct 2026 15:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791300214;
	bh=Qpq/8PFVnZyNvGiupOuLXM+FAht1H4oM4IIEa/Kd1zs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ULGrS2ZbLONUQXRN7xiCx6xNSWRpNYaQ49ytowqNUqGs631fiS/c6IW3sZUu+cdE7
	 EUvgAkJCDytcN5oIPKpBa2O5LSNnocrg99WbpziGjMSA+SiXFiwQkC5fXGTNfW0F/B
	 tRWsqMDNJ4OkdyNWuxmwZzlM+4OP6atNAv+TLH9uB285sWAblMwhtFAVbDtEaSoJqj
	 r47kA423qa7XfSm9WcVzrrEvF+JNzDuUrmbYutfGP4gNMhycKGrid1Wq99JN++SWUA
	 PP4tzfiW10ibHwmgYDmr9k4cP4BNjlT/ygbmgaZ2quEs/9LTbT7mycWwJT4kRKkBBV
	 t7/BAFHqD4CGw==
Date: Tue, 6 Oct 2026 08:23:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Daejun Park <daejun7.park@samsung.com>
Cc: "cem@kernel.org" <cem@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"dai.ngo@oracle.com" <dai.ngo@oracle.com>,
	"hch@lst.de" <hch@lst.de>, "dgc@kernel.org" <dgc@kernel.org>,
	"sergeybashirov@gmail.com" <sergeybashirov@gmail.com>,
	"cel@kernel.org" <cel@kernel.org>,
	"jlayton@kernel.org" <jlayton@kernel.org>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: (2) [PATCH] xfs: map pNFS layouts to the end of the extent again
Message-ID: <20261006152333.GO1615495@frogsfrogsfrogs>
References: <20261006051324.GV2705364@frogsfrogsfrogs>
 <20261006003425epcms2p586728e55ff5f9bbabc506b672fc4a421@epcms2p5>
 <CGME20261006003425epcms2p586728e55ff5f9bbabc506b672fc4a421@epcms2p8>
 <20261006054846epcms2p8ebfcaa89742030bfc07a7d1bb5ee3dfb@epcms2p8>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006054846epcms2p8ebfcaa89742030bfc07a7d1bb5ee3dfb@epcms2p8>

On Tue, Oct 06, 2026 at 02:48:46PM +0900, Daejun Park wrote:
> On Mon, Oct 05, 2026 at 10:13:24PM -0700, Darrick J. Wong wrote:
> > I wonder, though, should the caller (i.e. NFS) do this trimming to
> > protect itself from other filesystems making the same mistake?
> 
> I agree that nfsd needs a patch as well. nfsd4_block_proc_layoutget()
> could trim every extent after the first to start at the offset asked
> for, moving soff by the same amount for the written and unwritten ones.
> If that sounds right, I can send a patch for it.

Hmm.  You're right that only the filesystem knows where the upper end of
the mapping should be.  So either nfsd limits itself to trimming the
lower end (because we know that we need a mapping for at least one block
starting at @offset) or we just WARN_ON in that case and return EIO or
something?

> This patch still makes sense as it is. Mapping to the end of the extent
> can only be done in XFS, and with the trim in XFS as well, the stable
> fix does not depend on the nfsd patch. What the trim costs shows in the
> 4 KiB random row of the table: 15 LAYOUTGETs instead of 1, with no
> clear change in I/Os done.

<nod> I'm satisfied with the xfs part, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D
