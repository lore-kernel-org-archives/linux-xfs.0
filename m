Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587499;
	b=sgLDlTEa+j4e4KfJvncl3KwCwNR27Ede7lZu7D+qSBqSTMPr/Ua7U2xJAGxpWLuayiul
	 5Tjdq73PDgibaqULdlcq4Ig5ulTfA8HFIryCUsRwlgLAlU+vxzZaqEBqMyBaCRXrCG+pT
	 FzdimIItVkemnEEmORKne0LSYXIPlJ8S+VexHNBnILlsBTPKz3n4/7b1QqYyKSEiRLQmw
	 oWnaPWTbyCR+1vnwpFVQwtDPDntfip8FUfPrXG3d9jJ6BQOtMDfJnE/8Vb0j+i4+enz8I
	 hOyC6PubCntMRPMf0gJY8wTO7TEaPUAmBP87K6giPfiSHPuz8QX4zTvhbvFO/RvxK1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587499;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=jaN/WIqfszFLrNNj/gphAZn4uRhMsiZROimoWt6zDMY=;
	b=IwATBTUyihxrdEkH1pLE+IfHiiOvgPEeLDB8aLTOmwKHY8jyTCOT7SKe9hYgx4YjSI3X
	 PwiYxDUsmYuQVzGbseUpRM1nvZBcSIvgROS8LAcfFqhthEwDNgX4L9HaFf77oS+imv7V3
	 BbI2Oo1KrnOmYmnolo3Qk9cjPx3wjXlI9US2PhrQ95b+ojY5EoyVLuMXg6ZWJTgnKnOuE
	 5gh7gxu8QuVEQRZTdVlLruXbbEl9bwbL/k4AfS1W0zGLdGd6h5ZJJBXFdpY2aoYYekIAz
	 miTcxBZTfgg3H7P9hlNm5RU7Jkul+hvI424Asxfl+ALCtDI9G3xf8S5iGNx2Kg7AwMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10675606A6AF;
	Wed, 25 Nov 2026 06:18:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10675606A6AF
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 69A8968AFE; Wed, 25 Nov 2026 07:18:14 +0100 (CET)
Date: Wed, 25 Nov 2026 07:18:14 +0100
From: Christoph Hellwig <hch@lst.de>
To: Daejun Park <daejun7.park@samsung.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Oliver O'Halloran <oohall@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	linuxppc-dev@lists.ozlabs.org
Subject: Re: (2) [PATCH v2 2/2] xfs: skip the fsync flush when a later
 flush has completed
Message-ID: <20261125061814.GC20968@lst.de>
References: <20261120181706.GB1954@lst.de> <20261111-xfs-fsync-flush-seq-v2-0-b5c00c25d276@samsung.com> <20261111-xfs-fsync-flush-seq-v2-2-b5c00c25d276@samsung.com> <CGME20261120181715epcas2p3fe7b223290792dc835b5dff5374b2cbc@epcms2p7> <20261124023930epcms2p76ee61d14c5333dd04b4466b9f11bbcf8@epcms2p7>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124023930epcms2p76ee61d14c5333dd04b4466b9f11bbcf8@epcms2p7>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 24, 2026 at 11:39:30AM +0900, Daejun Park wrote:
> > > +	 * DAX writes are not block I/O, so DAX only skips the flush when
> > > +	 * this log force flushed, as before.
> >
> > I don't get the DAX part.  As far as cache flushes are concerned we
> > don't special case DAX anywhere else, why here?
> 
> I was not sure that a flush issued by another CPU covers DAX data on
> powerpc, so I kept the old behaviour for DAX. I never verified that.
> The existing log_flushed skip may already rely on such a flush.

Yeah, if that is an issue on powerpc, xfs and others alredy hit it.
Adding the author and maintainer who signed off on PAPR SCM to clarify
if this is an issue.  Although if it is it probably needs to be worked
around in the driver.

