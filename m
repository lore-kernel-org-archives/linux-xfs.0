Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC921C2324;
	Fri, 26 Jun 2026 05:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782450727; cv=none; b=OC6xwxToadu90LJZxLj7Sh9xewnOlYzpGSlrUDLsR25TAs8nclJ9pdvQE3S+15SptCM5W4RBJ1Ks9K8q2vwM1kGi6oNxFFwZ0xYJCbwKcYnxgGqzHSGQyQhnAZdEPYGA5oyhCeeZZKC6rfbWaroPSB1BIix2ISLbhvH6fcQrbGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782450727; c=relaxed/simple;
	bh=OnrtGagV3vt9IOQrFYFZRP/Ptf7WSF9yWRw5+Altx8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b7QZ2w9ppb76G5QJBndt71m9Ckltok4QC+wdvP/E1FLqxDoic7mJ8Nok9mrx9oDFFGcRMBNU6rISktmOkqPXKkm1mH2Za/EALOYaUJcp+EW6jD9fi9hjVPD5kLIA/BwmuUzPqJ9bDrOpWhyA/8SXIlIq7vKoOywx1EvYICQRyA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3CCC168B05; Fri, 26 Jun 2026 07:12:03 +0200 (CEST)
Date: Fri, 26 Jun 2026 07:12:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, willy@infradead.org, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v1 1/3] iomap: add ->iomap_next() and
 iomap_process() helper
Message-ID: <20260626051203.GA9013@lst.de>
References: <20260625024723.1611000-1-joannelkoong@gmail.com> <20260625024723.1611000-2-joannelkoong@gmail.com> <20260625125656.GA22620@lst.de> <CAJnrk1a3dY9r=jGVyTLT0k-J11wrdFc4sM6P94FBKwpi5TQTNw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJnrk1a3dY9r=jGVyTLT0k-J11wrdFc4sM6P94FBKwpi5TQTNw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 25, 2026 at 02:03:13PM -0700, Joanne Koong wrote:
> > As for the arguments:  I don't really see much of a point in passing
> > the iomap/scrmap separately vs just the iter.  Or am I missing something
> > here?
> 
> It was meant to safeguard against a callback modifying iomap-internal
> non-mapping fields (iter->pos/len/status/iter_start_pos) but maybe
> this is unnecessary. I'll drop the 2 args and make it non-const.

As in my reply to Gao I missed the constness point.  So I think keeping
the current version should be ok.  I'm a little worried that we might
end up with something not beeing const in the end like the iter private
data, though.

