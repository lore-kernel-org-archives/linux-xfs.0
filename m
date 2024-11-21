Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3DC1D88D5
	for <linux-xfs@vger.kernel.org>; Thu, 21 Nov 2024 14:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732198233; cv=none; b=ZEx6em52iQ8sY9VsCaCi8aCIqX3kw2kJKMCR3i7jJqtKhcqG3VHdDc6dUQrWuiHgztxd3QwCOxHWZJ5rD1UPx/bJmDKhmdCYQn+p08JXxeC+1lI3VMpVDTEEm8ND1j+26lVgONk7L1xxAvZuh+CG8uyWtz6AEdu+nKhNyPyYmYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732198233; c=relaxed/simple;
	bh=vunV3qDX3ypSy6suBGRSkgNhkncleVTExEi7cc1ozJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DYPVILwZjN7HMFd1kJucd4mrhHsxfHdVtQv0EjaETjsKIuC/7BBU+pQNO1WxifFfx51ICu61qP7JygDI3Gw/GQL0KTm/kx+KlzOMMDLvXunhqtNGVazpJv484618JuM0MQ3IR2H47NLbLKmITEwbH5/rqfuV7tx1H/oWV/Izx90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fFGrPtBf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fFGrPtBf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732198229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eeizq7DEWbqDKhGJDneppeYXaizAuhV/f+365w7I82U=;
	b=fFGrPtBfJD1lnsc6duDEYAO/0xdrORABDM4U3qJuf4Enu45EvPqIbCCkCVUXpGRe8JrDXk
	ba8y+6x3BGTAA//ZV32kuYO9+S1FC1pk196sNNsHsiB7An33U+QSUKOkzCgdYzQ/v1UQqw
	6CgDRv+sACgrOXyZXFd06spvB4vkH6Q=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-645-8HSeNZzQMXCNWG3sByYIoA-1; Thu,
 21 Nov 2024 09:10:25 -0500
X-MC-Unique: 8HSeNZzQMXCNWG3sByYIoA-1
X-Mimecast-MFC-AGG-ID: 8HSeNZzQMXCNWG3sByYIoA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C816A19560BE;
	Thu, 21 Nov 2024 14:10:24 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.120])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A763E30000DF;
	Thu, 21 Nov 2024 14:10:23 +0000 (UTC)
Date: Thu, 21 Nov 2024 09:11:56 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 01/12] generic/757: fix various bugs in this test
Message-ID: <Zz8_rFRio0vp07rd@bfoster>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
 <173197064441.904310.18406008193922603782.stgit@frogsfrogsfrogs>
 <20241121095624.ecpo67lxtrqqdkyh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241121100555.GA4176@lst.de>
 <Zz8nWa1xGm7c2FHt@bfoster>
 <20241121131239.GA28064@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241121131239.GA28064@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Nov 21, 2024 at 02:12:39PM +0100, Christoph Hellwig wrote:
> On Thu, Nov 21, 2024 at 07:28:09AM -0500, Brian Foster wrote:
> > IIRC it was to accommodate the test program, which presumably used
> > discard for efficiency reasons because it did a lot of context switching
> > to different point-in-time variations of the fs. If the discard didn't
> > actually zero the range (depending on the underlying test dev), then at
> > least on XFS, we'd see odd recovery issues and whatnot from the fs going
> > forward/back in time.
> 
> But the fundamental problem is that discard does not actually zero
> data.  It sometimes might, but also often doesn't because it's not
> part of the contract.  That's why my patch two switch to the zeroing
> ioctl is the right thing.  Note that this doesn't mean explicitly
> writing zeroes, it still uses zeroing offloads available in the drivers.
> 

Ok. I get that wrt discard.. I'm saying that's why we inserted dm-thin
into the stack, because it had predictable behavior that fell in line
with this particular design quirk of the higher level test program.

I've no issue with changing it so long as we maintain effectiveness of
the test. I'm not familiar enough with the zeroing offloads in the
drivers you mention to know whether that means this test can still run
quickly in the general case, or only with select hardware..?

> > I don't recall all the specifics, but I thought part of the reason for
> > using discard over explicit zeroing was the latter made the test
> > impractically slow. I could be misremembering, but if you want to change
> > it I'd suggest to at least verify runtimes on some of the preexisting
> > logwrites tests as well.
> 
> I'm all for speeding up tests.  But relying on a unspecified side effect
> of an operation and then requiring a driver that implements that side
> effect without documenting that isn't really good practice.
> 

It's a hack to facilitate test coverage. It would obviously need to be
revisited if behavior changed sufficiently to break the test.

I'm not really sure what you're asking for wrt documentation. A quick
scan of the git history shows the first such commit is 65cc9a235919
("generic/482: use thin volume as data device"), the commit log for
which seems to explain the reasoning.

Brian

