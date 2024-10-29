Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AEF8206510
	for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2024 14:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730211694; cv=none; b=P0OXQISpXB2c+Ytp3wW5jxSgcrIbYWn9Dxn60xQq0nT1LXGPywiTqdPG1c9MBaR+Jf3sypzvpJrboyuQdO40r2RUTTxdoUFksDY442FtUnjnsZeaNcw/wbSgnWliZ69Sw4o3t0USbnmUBqlCPMvh+EtBiwAOUyaSuM02OX5dYQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730211694; c=relaxed/simple;
	bh=SdcHRwGprqGcLb4RZ8FusnGnRiQaHIl6q44DHO6BADg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tkUruOZ0WiCG3Y84nKB6c9iszo2p7HpyDA30y/VxfNdKfATCrPKPBs2wiuapvWc1IHD0d11pkF2aHEmF52zBWC5xuZASMQFMrTFV+qBYupljTd389V2L12Z17IMj6SUR0p3CHsr5SwGzCVamj8yOrl0VBkzwC01mQfgFi48Tibo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cG4fXkGx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cG4fXkGx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730211691;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=93d2hCKZZySB63PUST/gb63AdUGB6oA9cuw4ExQOcO8=;
	b=cG4fXkGxou3YWprye9jEGOR678qmCFg/LW/HclWjRhSQEUJjsUfDJx+m+8EkcX/UGGy9lu
	9wtm6Wnn2MYUy1vBBMgpikjXZAybFyb8X08fGlOk3Dd7XwUA7jhLsn3fNKE+/CwOEhkf38
	6yWCjqT/VtNUdQLRWM1aO4spYlOwZXY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-675-oo--S0ShMh2XG9quhId2jw-1; Tue,
 29 Oct 2024 10:21:27 -0400
X-MC-Unique: oo--S0ShMh2XG9quhId2jw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6F39A19560B2;
	Tue, 29 Oct 2024 14:21:26 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.135])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1BD191955F39;
	Tue, 29 Oct 2024 14:21:24 +0000 (UTC)
Date: Tue, 29 Oct 2024 10:22:52 -0400
From: Brian Foster <bfoster@redhat.com>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, djwong@kernel.org,
	hch@lst.de
Subject: Re: [PATCH 1/2] xfs: online grow vs. log recovery stress test
Message-ID: <ZyDvvN5CGHaEOyaW@bfoster>
References: <20241017163405.173062-1-bfoster@redhat.com>
 <20241017163405.173062-2-bfoster@redhat.com>
 <20241025173242.clzuckwfotkdkpwq@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241025173242.clzuckwfotkdkpwq@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Sat, Oct 26, 2024 at 01:32:42AM +0800, Zorro Lang wrote:
> On Thu, Oct 17, 2024 at 12:34:04PM -0400, Brian Foster wrote:
> > fstests includes decent functional tests for online growfs and
> > shrink, and decent stress tests for crash and log recovery, but no
> > combination of the two. This test combines bits from a typical
> > growfs stress test like xfs/104 with crash recovery cycles from a
> > test like generic/388. As a result, this reproduces at least a
> > couple recently fixed issues related to log recovery of online
> > growfs operations.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> 
> Hi Brian,
> 
> Thanks for this new test case! Some tiny review points below :)
> 
> >  tests/xfs/609     | 69 +++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/609.out |  7 +++++
> >  2 files changed, 76 insertions(+)
> >  create mode 100755 tests/xfs/609
> >  create mode 100644 tests/xfs/609.out
> > 
...
> > diff --git a/tests/xfs/609.out b/tests/xfs/609.out
> > new file mode 100644
> > index 00000000..1853cc65
> > --- /dev/null
> > +++ b/tests/xfs/609.out
> > @@ -0,0 +1,7 @@
> > +QA output created by 609
> > +meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
> > +data     = bsize=XXX blocks=XXX, imaxpct=PCT
> > +         = sunit=XXX swidth=XXX, unwritten=X
> > +naming   =VERN bsize=XXX
> > +log      =LDEV bsize=XXX blocks=XXX
> > +realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> 
> So what's this output in .out file for? How about "Silence is golden"?
> 

No particular reason.. this was mostly a mash and cleanup of a couple
preexisting tests around growfs and crash recovery, so probably just
leftover from that. All of these suggestions sound good to me. I'll
apply them and post a v2. Thanks for the review!

Brian

> Thanks,
> Zorro
> 
> > -- 
> > 2.46.2
> > 
> > 
> 

