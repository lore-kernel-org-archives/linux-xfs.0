Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54606218D8F
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 14:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728655215; cv=none; b=rbVtgbwCed/GWUfDqD5qESWiDlsDgkqBMUWP3yaUYGVWQliMycLKkbV+ocMq2Ai4+p/wob+ZeLg5X4MdYwmxykensW7cOziXREoRsp6LGS8o61WP5Qr6rEyIoxTnG89smD3JU5olm4FywbiOF9qBCDAivAjXB+ta75NXimcGCSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728655215; c=relaxed/simple;
	bh=W4h80WOZFPMc12+LlNx9x+9axZVOJ+AtFg6NE8o+S80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aEqLsm6no/SOTc+S/sysI/HOXZGnfM2dgVBOviWPMo5wBPI1T3rpZmnZmcwjqFILEzpuXdR4EhQ287JWioJawc4ubmWFfJ0XUCWqjCJeQK97/82ii7sqEVJlfffoqE9kEsjoDAwq6KaX+HFUCuu7hQmP6TI9QdnjhcdWFxIGk9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M24UBqwK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M24UBqwK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728655212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0DPyN7WRsH3mIIgYx+3OE0TVMyoroZMa/gMc3BDqII4=;
	b=M24UBqwKv1yip6QOM7QxzdCAEFSZdLr1Na85xpdPSpKWKBnRuFuz3BbYJq8I7eYdDdXt5u
	j793vzYwcZ0Z2drADOBeYRvfgZihA/py2B9HMTOIra9psoNZmXtpKDZmffcGtDWUzR2QyZ
	cB75aIwy54ElmUQ9DFAAvXmKOcjVkr4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-317-lhuGFnjLM4-T2XOIOF0U8A-1; Fri,
 11 Oct 2024 10:00:08 -0400
X-MC-Unique: lhuGFnjLM4-T2XOIOF0U8A-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3B7CD1955EE6;
	Fri, 11 Oct 2024 14:00:07 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.133])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2D99D30001A3;
	Fri, 11 Oct 2024 14:00:05 +0000 (UTC)
Date: Fri, 11 Oct 2024 10:01:21 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: pass the exact range to initialize to
 xfs_initialize_perag
Message-ID: <ZwkvsY6B78M2GK-H@bfoster>
References: <20240930164211.2357358-1-hch@lst.de>
 <20240930164211.2357358-2-hch@lst.de>
 <ZwfeiYzopK-iD24Y@bfoster>
 <20241011075314.GA2749@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241011075314.GA2749@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Fri, Oct 11, 2024 at 09:53:14AM +0200, Christoph Hellwig wrote:
> On Thu, Oct 10, 2024 at 10:02:49AM -0400, Brian Foster wrote:
> > > -	error = xfs_initialize_perag(mp, sbp->sb_agcount, sbp->sb_dblocks,
> > > -			&mp->m_maxagi);
> > > +	error = xfs_initialize_perag(mp, old_agcount, sbp->sb_agcount,
> > > +			sbp->sb_dblocks, &mp->m_maxagi);
> > 
> > I assume this is because the superblock can change across recovery, but
> > code wise this seems kind of easy to misread into thinking the variable
> > is the same.
> 
> Which variable?
> 

old_agcount and sb_agcount and the fact that the value of the latter
might change down in the recovery code isn't immediately obvious. A
oneliner and/or logic check suggested below would clear it up IMO,
thanks.

Brian

> > I think the whole old/new terminology is kind of clunky for
> > an interface that is not just for growfs. Maybe it would be more clear
> > to use start/end terminology for xfs_initialize_perag(), then it's more
> > straightforward that mount would init the full range whereas growfs
> > inits a subrange.
> 
> fine with me.
> 
> > A oneliner comment or s/old_agcount/orig_agcount/ wouldn't hurt here
> > either. Actually if that's the only purpose for this call and if you
> > already have to sample sb_agcount, maybe just lifting/copying the if
> > (old_agcount >= new_agcount) check into the caller would make the logic
> > more self-explanatory. Hm?
> 
> Sure.
> 

