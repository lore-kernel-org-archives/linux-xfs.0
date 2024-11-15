Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4921CDA23
	for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2024 13:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731678291; cv=none; b=o8kqeIabNqLR3MHxSOOvNVdUy4Phgi26LJk36cY87i+FJsQRh/gGHtZ67obRwaL8qknEE0ZxB85zlpc29f5nSsEQb+NLuGJvwduxtqVSguY/mYKG2AZYn5jGT0B4xvDmn2brSGk1BFLjUbagaa7r4FFkQXMArBaU42U8rhRYV74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731678291; c=relaxed/simple;
	bh=eclX/WNB6up23RyG6MMdIlno6zNEqeC+Ud9ve6B1M+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mrZWRkcdUylSmeTetp2nAr2LhO+EfN63XkfaMFpu2MFz2opkDURuEPSziityqlBuQZBnO7Q1k+jyyywKhsAMn43dQEuSW/hAmcf/3Hg2MszuOo07fC+tRVS0Phx+oRGSYiDuoL2fOxrwlApdT5tMPtqiUQyjTehzGFfkRPN2aXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OAotI1GM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OAotI1GM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731678288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3vEBn66Yd8qWmPxde1FsjTAy+T+e093uZiEN51DgbIg=;
	b=OAotI1GMKfv42pVG09ZHnFF9YfO8XetcJkj7M4xNp805vfvW7L7r+YGF1I5Kv9FEtOiQuz
	oVKJ6ko2LLqggOuFJ/qxhDYWGS42bYI8VumNMzWGx1ycbw+zLmPM+QmM6/2Br5kRhCCtOH
	d1bSTCd3pmSFtkuvaJGs8QRQhliPy2A=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-211-Ol6eX11eMnemIq14vo54CQ-1; Fri,
 15 Nov 2024 08:44:45 -0500
X-MC-Unique: Ol6eX11eMnemIq14vo54CQ-1
X-Mimecast-MFC-AGG-ID: Ol6eX11eMnemIq14vo54CQ
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C38101954B22;
	Fri, 15 Nov 2024 13:44:43 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.120])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 64CDF1953880;
	Fri, 15 Nov 2024 13:44:40 +0000 (UTC)
Date: Fri, 15 Nov 2024 08:46:13 -0500
From: Brian Foster <bfoster@redhat.com>
To: Long Li <leo.lilong@huawei.com>
Cc: brauner@kernel.org, djwong@kernel.org, cem@kernel.org,
	linux-xfs@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com,
	yangerkun@huawei.com
Subject: Re: [PATCH v2 1/2] iomap: fix zero padding data issue in concurrent
 append writes
Message-ID: <ZzdQpXyVNHaT7MGv@bfoster>
References: <20241113091907.56937-1-leo.lilong@huawei.com>
 <ZzTQPdE5V155Soui@bfoster>
 <ZzVhsvyFQu01PnHl@localhost.localdomain>
 <ZzY7r1l5dpBw7UsY@bfoster>
 <Zzc2LcUqCPqMjjxr@localhost.localdomain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zzc2LcUqCPqMjjxr@localhost.localdomain>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Fri, Nov 15, 2024 at 07:53:17PM +0800, Long Li wrote:
> On Thu, Nov 14, 2024 at 01:04:31PM -0500, Brian Foster wrote:
> > On Thu, Nov 14, 2024 at 10:34:26AM +0800, Long Li wrote:
> > > On Wed, Nov 13, 2024 at 11:13:49AM -0500, Brian Foster wrote:
> > > > FYI, you probably want to include linux-fsdevel on iomap patches.
> > > > 
> > > > On Wed, Nov 13, 2024 at 05:19:06PM +0800, Long Li wrote:
> > > > > During concurrent append writes to XFS filesystem, zero padding data
> > > > > may appear in the file after power failure. This happens due to imprecise
> > > > > disk size updates when handling write completion.
> > > > > 
> > > > > Consider this scenario with concurrent append writes same file:
> > > > > 
> > > > >   Thread 1:                  Thread 2:
> > > > >   ------------               -----------
> > > > >   write [A, A+B]
> > > > >   update inode size to A+B
> > > > >   submit I/O [A, A+BS]
> > > > >                              write [A+B, A+B+C]
> > > > >                              update inode size to A+B+C
> > > > >   <I/O completes, updates disk size to A+B+C>
> > > > >   <power failure>
> > > > > 
> > > > > After reboot, file has zero padding in range [A+B, A+B+C]:
> > > > > 
> > > > >   |<         Block Size (BS)      >|
> > > > >   |DDDDDDDDDDDDDDDD0000000000000000|
> > > > >   ^               ^        ^
> > > > >   A              A+B      A+B+C (EOF)
> > > > > 
> > > > 
> > > > Thanks for the diagram. FWIW, I found the description a little confusing
> > > > because A+B+C to me implies that we'd update i_size to the end of the
> > > > write from thread 2, but it seems that is only true up to the end of the
> > > > block.
> > > > 
> > > > I.e., with 4k FSB and if thread 1 writes [0, 2k], then thread 2 writes
> > > > from [2, 16k], the write completion from the thread 1 write will set
> > > > i_size to 4k, not 16k, right?
> > > > 
> > > 
> > > Not right, the problem I'm trying to describe is:
> > > 
> > >   1) thread 1 writes [0, 2k]
> > >   2) thread 2 writes [2k, 3k]
> > >   3) write completion from the thread 1 write set i_size to 3K
> > >   4) power failure
> > >   5) after reboot,  [2k, 3K] of the file filled with zero and the file size is 3k
> > >      
> > 
> > Yeah, I get the subblock case. What I am saying above is it seems like
> > "update inode size to A+B+C" is only true for certain, select values
> > that describe the subblock case. I.e., what is the resulting i_size if
> > we replace C=1k in the example above with something >= FSB size, like
> > C=4k?
> > 
> > Note this isn't all that important. I was just trying to say that the
> > overly general description made this a little more confusing to grok at
> > first than it needed to be, because to me it subtly implies there is
> > logic around somewhere that explicitly writes in-core i_size to disk,
> > when that is not actually what is happening.
> > 
> > > 
> 
> Sorry for my previous misunderstanding. You are correct - my commit
> message description didn't cover the case where A+B+C > block size.
> In such scenarios, the final file size might end up being 4K, which
> is not what we would expect. Initially, I incorrectly thought this
> wasn't a significant issue and thus overlooked this case. Let me
> update the diagram to address this.
> 

Ok no problem.. like I said, just a minor nit. ;)

>   Thread 1:                  Thread 2:
>   ------------               -----------
>   write [A, A+B]
>   update inode size to A+B
>   submit I/O [A, A+BS]
>                              write [A+B, A+B+C]
>                              update inode size to A+B+C
>   <I/O completes, updates disk size to A+B+C>
>   <power failure>
> 
> After reboot:
>   1) The file has zero padding in the range [A+B, A+BS]
>   2) The file size is unexpectedly set to A+BS
> 
>   |<         Block Size (BS)      >|<           Block Size (BS)    >|
>   |DDDDDDDDDDDDDDDD0000000000000000|00000000000000000000000000000000|
>   ^               ^                ^               ^
>   A              A+B              A+BS (EOF)     A+B+C
> 
> 
> It will be update in the next version.
> 

The text above still says "updates disk size to A+B+C." I'm not sure if
you intended to change that to A+BS as well, but regardless LGTM.
Thanks.

Brian

> 
> Thanks,
> Long Li
> 

