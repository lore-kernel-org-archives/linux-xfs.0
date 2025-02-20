Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31991D5CD6
	for <linux-xfs@vger.kernel.org>; Thu, 20 Feb 2025 14:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740063434; cv=none; b=Lrdb79A8+dDUBDnAtGwwp/MIUC8dxjMzY0s0GlTf6htI8NxC3FFy1+xUoPIL5eoJWLbqe3SDcYKMkJX7vUIBOBm4DcjOFRVSKHQc7y0EETdCtlpiqvbmKSKNHKMBuItpY0nW4HkpaH2RJyepkSxwrGuMArdwLw26YmGKKeGVJ9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740063434; c=relaxed/simple;
	bh=cwE9+ImJ3Nvdqe/tAfsto0R6e1kEymh4aPOQZuJK3Gk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h0NSkzS3u9TC9KMgYURMjO3yqf4ZJMqcrkBeiAOAnYpn8V2KpSUBR16pjR9i+fAqvbVJ4uaP6EWFlmYbFqIqcdDW/G6Gz3yWNW69GDv0+Zf4UaAe1ImnO2Ws5mTIMNU9Y9XcRO2yVfrKV+cn8kg5wL9IcaLa9mvm6giPLWji224=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DvkIWo/B; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DvkIWo/B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740063432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nxB2vu7dIgMe3HfcwqaJPCra1cNnSUPv03GtE2jqgiA=;
	b=DvkIWo/BHFzGGG6Bz0gstT3VI3EP/nJJe3/4XsdLDPvSG3T8yZWUMqXJSJ53tmxc3htTsG
	FRVTQhVDSWCtgE1rullawmj9GcOabbBYCRuEvCGjSD2YjGSSj50KP6yD6TG4kLdosnVRTk
	xskImsdAISjmmhDBlp/AFMRdhIxzQRI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-147-UdWIR4TMOhChGhQovzGAnA-1; Thu,
 20 Feb 2025 09:57:10 -0500
X-MC-Unique: UdWIR4TMOhChGhQovzGAnA-1
X-Mimecast-MFC-AGG-ID: UdWIR4TMOhChGhQovzGAnA_1740063429
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 217B91800268;
	Thu, 20 Feb 2025 14:57:09 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.79])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C2BD0300019F;
	Thu, 20 Feb 2025 14:57:07 +0000 (UTC)
Date: Thu, 20 Feb 2025 09:59:44 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH v2 00/12] iomap: incremental advance conversion -- phase 2
Message-ID: <Z7dDYDhi_CDBq8aA@bfoster>
References: <20250219175050.83986-1-bfoster@redhat.com>
 <20250220-mitgearbeitet-nagen-fa0db4e996f8@brauner>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250220-mitgearbeitet-nagen-fa0db4e996f8@brauner>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Feb 20, 2025 at 10:10:41AM +0100, Christian Brauner wrote:
> On Wed, Feb 19, 2025 at 12:50:38PM -0500, Brian Foster wrote:
> > Hi all,
> > 
> > Here's phase 2 of the incremental iter advance conversions. This updates
> 
> Hm, what's this based on? Can you base it on vfs-6.15.iomap, please?
> 

Yup.. this was based on -rc3 plus the previous series that introduced
the core iomap change. I'll give hch a couple days or so for any further
comments and post a v3 with Darrick's nit fixed and rebased on the 6.15
iomap branch. Thanks!

Brian

