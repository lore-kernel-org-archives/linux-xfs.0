Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8421B011E
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 14:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724943367; cv=none; b=hyMp7qkiDzhuft5ljj3bEhJZFdeBurpxMEw46oI0jegVLJmrd/cWbzz5ZyYcJ7HF3V+GlBDtCsu47kpDch/POoAexd/WUcHCmodXRbDOb6mY/JGI/pD3a7RtwTT7MWNltMLsjIMcz/FfnGWK4WA3Pef3WyNvX8OZ3EItYOb5Gp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724943367; c=relaxed/simple;
	bh=Vhp8lZQTRGE9+DtwT83uuAvqZx8qYIWjx2zvk/125GE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L1F/lLpbIWXwmz6waDRt1RbzgNyC/ia6rqkGd/fjUfmBaGs6limRVAfgLclOBopZhpkaU9gXzm1COyibJHles5QV5F7RORfeFG2gre6IzQo2jxrVQdGuDze9ZdNJ3mblKGKu23mWari3qZZa8DWgI/G/2Z1AD5mV2uaJAIXjJ+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MmAqPIDw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MmAqPIDw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724943363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9cRloZXT1BxmTHsCQe9fbhVyjA60k3chwho7sJ4uFjE=;
	b=MmAqPIDwDitNDsTr4nQfTZJLp7h/eyW28+o2UQ0UHwgdPnlYY8aCyjUZYD8yq0CtCUFgDs
	xNx+DEVZbH6BCxOj8BpXogcU8PUb/v7RtVTDmThuMQOPpQ9ClMNYhskE4rAQ9m6Sj498lF
	DAd1Nd9m3V/XJDO1RWG3Mht79xyysDI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-266-_fRGoTwrNrGIUZG25HdfDw-1; Thu,
 29 Aug 2024 10:56:02 -0400
X-MC-Unique: _fRGoTwrNrGIUZG25HdfDw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 77F601954B03;
	Thu, 29 Aug 2024 14:55:50 +0000 (UTC)
Received: from bfoster (unknown [10.22.16.95])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 32C0419560AD;
	Thu, 29 Aug 2024 14:55:49 +0000 (UTC)
Date: Thu, 29 Aug 2024 10:56:49 -0400
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	josef@toxicpanda.com, david@fromorbit.com
Subject: Re: [PATCH v2 1/4] fsx: don't skip file size and buf updates on
 simulated ops
Message-ID: <ZtCMMSaA-yEw73lX@bfoster>
References: <20240828181534.41054-1-bfoster@redhat.com>
 <20240828181534.41054-2-bfoster@redhat.com>
 <20240829012716.GF6224@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240829012716.GF6224@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Wed, Aug 28, 2024 at 06:27:16PM -0700, Darrick J. Wong wrote:
> On Wed, Aug 28, 2024 at 02:15:31PM -0400, Brian Foster wrote:
> > fsx supports the ability to skip through a certain number of
> > operations of a given command sequence before beginning full
> > operation. The way this works is by tracking the operation count,
> > simulating minimal side effects of skipped operations in-memory, and
> > then finally writing out the in-memory state to the target file when
> > full operation begins.
> > 
> > Several fallocate() related operations don't correctly track
> > in-memory state when simulated, however. For example, consider an
> > ops file with the following two operations:
> > 
> >   zero_range 0x0 0x1000 0x0
> >   read 0x0 0x1000 0x0
> > 
> > ... and an fsx run like so:
> > 
> >   fsx -d -b 2 --replay-ops=<opsfile> <file>
> > 
> > This simulates the zero_range operation, but fails to track the file
> > extension that occurs as a side effect such that the subsequent read
> > doesn't occur as expected:
> > 
> >   Will begin at operation 2
> >   skipping zero size read
> > 
> > The read is skipped in this case because the file size is zero.  The
> > proper behavior, and what is consistent with other size changing
> > operations, is to make the appropriate in-core changes before
> > checking whether an operation is simulated so the end result of
> > those changes can be reflected on-disk for eventual non-simulated
> > operations. This results in expected behavior with the same ops file
> > and test command:
> > 
> >   Will begin at operation 2
> >   2 read  0x0 thru        0xfff   (0x1000 bytes)
> > 
> > Update zero, copy and clone range to do the file size and EOF change
> > related zeroing before checking against the simulated ops count.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> Oh wow, I really got that wrong. :(
> 

Eh, so did I. ;) That the code was mostly right was pretty much just
luck. Thanks for the thoughtful reviews.

Brian

> Well, thank you for uncovering that error;
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D
> 
> 
> > ---
> >  ltp/fsx.c | 40 +++++++++++++++++++++-------------------
> >  1 file changed, 21 insertions(+), 19 deletions(-)
> > 
> > diff --git a/ltp/fsx.c b/ltp/fsx.c
> > index 2dc59b06..c5727cff 100644
> > --- a/ltp/fsx.c
> > +++ b/ltp/fsx.c
> > @@ -1247,6 +1247,17 @@ do_zero_range(unsigned offset, unsigned length, int keep_size)
> >  	log4(OP_ZERO_RANGE, offset, length,
> >  	     keep_size ? FL_KEEP_SIZE : FL_NONE);
> >  
> > +	if (!keep_size && end_offset > file_size) {
> > +		/*
> > +		 * If there's a gap between the old file size and the offset of
> > +		 * the zero range operation, fill the gap with zeroes.
> > +		 */
> > +		if (offset > file_size)
> > +			memset(good_buf + file_size, '\0', offset - file_size);
> > +
> > +		file_size = end_offset;
> > +	}
> > +
> >  	if (testcalls <= simulatedopcount)
> >  		return;
> >  
> > @@ -1263,17 +1274,6 @@ do_zero_range(unsigned offset, unsigned length, int keep_size)
> >  	}
> >  
> >  	memset(good_buf + offset, '\0', length);
> > -
> > -	if (!keep_size && end_offset > file_size) {
> > -		/*
> > -		 * If there's a gap between the old file size and the offset of
> > -		 * the zero range operation, fill the gap with zeroes.
> > -		 */
> > -		if (offset > file_size)
> > -			memset(good_buf + file_size, '\0', offset - file_size);
> > -
> > -		file_size = end_offset;
> > -	}
> >  }
> >  
> >  #else
> > @@ -1538,6 +1538,11 @@ do_clone_range(unsigned offset, unsigned length, unsigned dest)
> >  
> >  	log5(OP_CLONE_RANGE, offset, length, dest, FL_NONE);
> >  
> > +	if (dest > file_size)
> > +		memset(good_buf + file_size, '\0', dest - file_size);
> > +	if (dest + length > file_size)
> > +		file_size = dest + length;
> > +
> >  	if (testcalls <= simulatedopcount)
> >  		return;
> >  
> > @@ -1556,10 +1561,6 @@ do_clone_range(unsigned offset, unsigned length, unsigned dest)
> >  	}
> >  
> >  	memcpy(good_buf + dest, good_buf + offset, length);
> > -	if (dest > file_size)
> > -		memset(good_buf + file_size, '\0', dest - file_size);
> > -	if (dest + length > file_size)
> > -		file_size = dest + length;
> >  }
> >  
> >  #else
> > @@ -1756,6 +1757,11 @@ do_copy_range(unsigned offset, unsigned length, unsigned dest)
> >  
> >  	log5(OP_COPY_RANGE, offset, length, dest, FL_NONE);
> >  
> > +	if (dest > file_size)
> > +		memset(good_buf + file_size, '\0', dest - file_size);
> > +	if (dest + length > file_size)
> > +		file_size = dest + length;
> > +
> >  	if (testcalls <= simulatedopcount)
> >  		return;
> >  
> > @@ -1792,10 +1798,6 @@ do_copy_range(unsigned offset, unsigned length, unsigned dest)
> >  	}
> >  
> >  	memcpy(good_buf + dest, good_buf + offset, length);
> > -	if (dest > file_size)
> > -		memset(good_buf + file_size, '\0', dest - file_size);
> > -	if (dest + length > file_size)
> > -		file_size = dest + length;
> >  }
> >  
> >  #else
> > -- 
> > 2.45.0
> > 
> > 
> 

