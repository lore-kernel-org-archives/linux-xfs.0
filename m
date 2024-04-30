Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED795129E89
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 10:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474658; cv=none; b=EnL0nyuU5uvudQXOxZ90Ox7McxZWT1VItQDSwdkCAa+aUwsIHMZ7OGeMsmAuMrEcoVPBEUvjxWTgd121Wl4iyqDPFKTlExuz/1gIqbWINV8lK9gErSiSHI/VaLctCY4tL2myeD7hYGM6ukyPbpqTcOWpOY8I/MhFhbqu8EbR2+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474658; c=relaxed/simple;
	bh=hNTix9c/KNbA7MDjtEDmXkKnUGkV+MSGzRN3KaT5l6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZjyfCTh9EYeueyK+QnpYcxzZ7gy9kvA73KEAlFRbEkuYDnwGD8ptIaQ1GoM+m9dCAi3xbSRf18zDC2hup/iaquSFFGMSgYGqi6wMiHo1m6p8I/SQnnCMHa2deE9jBcsU5fSTDH87ohYUI1rslKe3TC7kvaQhr2LsvAjy7NAlp18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BGdSydr6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BGdSydr6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714474655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fp9/Rfo4M3FP7SnDTvi+VUmmT4FwbiK4FpTWgTX+fow=;
	b=BGdSydr6j8uSJ19aA58kutac4FMRe1ZpwGvxjRcjL+iNIkexqU91wqIpRBU6b8ArHgJ1+z
	C+RpPiaKqlbzhZxXl8VBzusWt0Yd1QhI8x5Uvq2rmGBFZCknTgm2mQd+w3W7PvV/3kwgLh
	Ik5BBg6cvBLf8CtGPtAZ91wEAnJjQi4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-DB-iNrq2O3i1k-GaOhO1OA-1; Tue, 30 Apr 2024 06:57:30 -0400
X-MC-Unique: DB-iNrq2O3i1k-GaOhO1OA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EED0080017B;
	Tue, 30 Apr 2024 10:57:29 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.117])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B6671121306;
	Tue, 30 Apr 2024 10:57:29 +0000 (UTC)
Date: Tue, 30 Apr 2024 06:59:47 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Sam Sun <samsun1006219@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: restrict the h_size fixup in
 xlog_do_recovery_pass
Message-ID: <ZjDPIwcuh-j9JIjT@bfoster>
References: <20240429070200.1586537-1-hch@lst.de>
 <20240429070200.1586537-3-hch@lst.de>
 <Zi-QJG3tuRptnDVX@bfoster>
 <20240429171552.GE31337@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429171552.GE31337@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

On Mon, Apr 29, 2024 at 07:15:52PM +0200, Christoph Hellwig wrote:
> On Mon, Apr 29, 2024 at 08:18:44AM -0400, Brian Foster wrote:
> > > -		if (h_len > h_size && h_len <= log->l_mp->m_logbsize &&
> > > +		if (!xfs_has_reflink(log->l_mp) && xfs_has_reflink(log->l_mp) &&
> > > +		    h_len > h_size && h_len <= log->l_mp->m_logbsize &&
> > 
> > ... but I'm going to assume this hasn't been tested. ;) Do you mean to
> > also check !rmapbt here?
> 
> Heh.  Well, it has been tested in that we don't do the fixup for the
> reproducer fixed by the previous patch and in that xfstests still passes.
> I guess nothing in there hits the old mkfs fixup, which isn't surprising.
> 

Yeah.. (sorry, just teasing about the testing.. ;).

> > Can you please also just double check that we still handle the original
> > mkfs problem correctly after these changes? I think that just means mkfs
> > from a sufficiently old xfsprogs using a larger log stripe unit, and
> > confirm the fs mounts (with a warning).
> 
> Yeah.  Is there any way to commit a fs image to xfstests so that we
> actually regularly test for it?
> 

Not sure.. ideally we could fuzz the log record header somehow or
another to test for these various scenarios, since we clearly broke this
once already.

I don't quite recall if I looked into that at the time of the original
workaround. To Darrick's point, I wonder if there would be some use to
an expert logformat command or something that allowed for some bonkers
parameters (assuming something like that doesn't exist already).

I'm out on PTO for (at least) today, but I can take a closer look at
that once I'm back and caught up...

Brian

