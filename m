Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A73881737
	for <linux-xfs@vger.kernel.org>; Fri, 31 May 2024 15:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717170289; cv=none; b=m3XnCUWjMrvPndd4ABim6FDhnIvTKtwPJaY+/ae9tDey8gjDb2Xgjwva6FWOpzR/b+ECW0/qoWw7YTuEXWJeJN8KHWW1ii20HrtAl1FB80atH0Qc6PfM0AY6htXUxtKcY1MZ+UKtolmE5Qyu70DxILX7+8AapPZL8EW77WWq/GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717170289; c=relaxed/simple;
	bh=IXRTBMJGT+iSuCCQAkiOZnTweB6qbKtOWyUhz+MPsEA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QDpQvVLmhOSU0ZFB19JY/3tKf0hj1EgQgt5SBss+V7V+S3IIO5DT5OQjpKRXQa2hpAfyu6oOLHEK3p9hckXB/HF0CRPMLhCRfh+Lutc+w6IWXX13b/Fd0CdKc8tiswCg5DMLNNxNlbI/OrsFNGZqXOEsJqXKmg1g2RQN5QpYMmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NKgZSZxu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NKgZSZxu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717170286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xxl866ZDHDKQJI6Eanti9jZI/91ugmixsdkqx9T3qKc=;
	b=NKgZSZxuTy6oMcRAcaQhlBp+5+Sz3oN73oaGRfFrKPxVo1y5X0lLDU3gGbs7vHw1NZlWmU
	cpiZTvGCFPjEDJI7QLrgiSioJ6vNy4Xwjr3V6jyiiBl4y8lROuo9/AbTFmtwfD06ybAODW
	mocR6q9AH1+XzGcVH6Ovf7KLCXU/lmU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-53-0_-x3j11OjGLwyrj4RtVfA-1; Fri, 31 May 2024 11:44:40 -0400
X-MC-Unique: 0_-x3j11OjGLwyrj4RtVfA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8060101A52C;
	Fri, 31 May 2024 15:44:39 +0000 (UTC)
Received: from bfoster (unknown [10.22.8.96])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6413D105480A;
	Fri, 31 May 2024 15:44:39 +0000 (UTC)
Date: Fri, 31 May 2024 11:44:57 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Zhang Yi <yi.zhang@huaweicloud.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	brauner@kernel.org, david@fromorbit.com, chandanbabu@kernel.org,
	jack@suse.cz, willy@infradead.org, yi.zhang@huawei.com,
	chengzhihao1@huawei.com, yukuai3@huawei.com
Subject: Re: [RFC PATCH v4 1/8] iomap: zeroing needs to be pagecache aware
Message-ID: <ZlnweWTV4Y5STK-q@bfoster>
References: <20240529095206.2568162-1-yi.zhang@huaweicloud.com>
 <20240529095206.2568162-2-yi.zhang@huaweicloud.com>
 <ZlnMfSJcm5k6Dg_e@infradead.org>
 <20240531140358.GF52987@frogsfrogsfrogs>
 <ZlnZMiBJ6Fapor5G@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZlnZMiBJ6Fapor5G@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

On Fri, May 31, 2024 at 07:05:38AM -0700, Christoph Hellwig wrote:
> On Fri, May 31, 2024 at 07:03:58AM -0700, Darrick J. Wong wrote:
> > > +			/*
> > > +			 * XXX: It would be nice if we could get the offset of
> > > +			 * the next entry in the pagecache so that we don't have
> > > +			 * to iterate one page at a time here.
> > > +			 */
> > > +			offset = offset_in_page(pos);
> > > +			if (bytes > PAGE_SIZE - offset)
> > > +				bytes = PAGE_SIZE - offset;
> > 
> > Why is it PAGE_SIZE here and not folio_size() like below?
> > 
> > (I know you're just copying the existing code; I'm merely wondering if
> > this is some minor bug.)
> 
> See the comment just above :)
> 
> 

FWIW, something like the following is pretty slow with the current
implementation on a quick test:

  xfs_io -fc "falloc -k 0 1t" -c "pwrite 1000g 4k" <file>

... so I'd think you'd want some kind of data seek or something to more
efficiently process the range.

Brian

