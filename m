Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7288CECE
	for <linux-xfs@vger.kernel.org>; Fri, 19 Jan 2024 01:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705628302; cv=none; b=o7D4C+mDs9yASiu3iLlnfteQUnuoIVAjPlpNwRnbBpXB/3b0maikQxXxy9tkHanRPmI0BjzjMORRBKDtJ0zg+uGYG8+Vl1yAwUqUgmcp7I4tSzgmLoyNoUEp5FB4W9Ed2V2V3Qaup7N5Xa8vfEumpQLNzYeV0HYlQWHfqIfkdmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705628302; c=relaxed/simple;
	bh=jzhofwMw9Fo+ZArcyf6+YpN5YOVq2IDotrP0k/xz4aY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IyE4zpGqd0ZasrXpggYqj3ZOzeJEL1CdMGECWYXat2S3yBZ1XM37JY6zON7rKzApKI1Mw/Go0jJy9Qgw0pc7mGpOQDpwTSeky6TNLXpYO/ldtP2bUPSafhXaR+1+ttyE4qYg+Is+NdBqGWAq+6jemg0S0ByU6tftrFROi//ekAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G7pgZ38u; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G7pgZ38u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705628299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RHra5uM8Gv3w/wgAIdPCDklGEvqmXfBowuP5Y2ZF/Rs=;
	b=G7pgZ38uSeA2QyJe66xlArJF6/P1AVSazsFfls/1jZrR29Wx38BIUJeeJL4X03X3qP2iVn
	idXFPirqlm/21iuV5h+aes/eFO5Mgn6G5hfBcLkhvQc0t5hiTBms2mwMiHB/zagIRNtUkx
	phic+5KZOrhR+L0jV6v5w90imH9n+qo=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-tJqBw4c0PQ6AFBS0kM0j6w-1; Thu, 18 Jan 2024 20:38:12 -0500
X-MC-Unique: tJqBw4c0PQ6AFBS0kM0j6w-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-5cf2714e392so321565a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2024 17:38:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705628291; x=1706233091;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RHra5uM8Gv3w/wgAIdPCDklGEvqmXfBowuP5Y2ZF/Rs=;
        b=U6SwDgzDE81XEZnVeJw7vXZVanL9PM5ift+v9reEuv3uKrSkiNwbSz/YAmvOfyKd0U
         /vf/wINWCE9y1cZSMRXR9k5EnxY63KpACUCMgF57ls4bddran1Czkay/H+VHt1t3Kq1a
         oFcEhThZVSRfJjMhKGfX2lvXuwMZB6vxTjx/7Z/lkAgaiqgqPNK6SkS5L/HIUkjO0J3E
         oaN11EDkiZ+HEP9G9w44B84YrB6RJTJPOlRDtuGaW7CfI3DXcwHur+cMvSphFjEtSJsi
         Eo5dFfndB84YGOuKNl4RJ2qT15nxvegaHTrA2Tjpuigv15NcgjLjT/Gp0mJs0F+UEp8X
         7w8A==
X-Gm-Message-State: AOJu0YyoAzDGdXpvZX9SQ3lIAtu4QH/fICiSbqN9OmVBxNWQtLTGJ5h9
	gI+k25ERkArG+vhQwQAFXyWmE5HFjfwSPfQIC7n2DIiwJkWFLD5AZRxaf61Q8qTSBI8Pf7iL9UR
	5WlZ1FOCOXFObOCOdSWhNyr4Js0ZQau4CIiUuL4w4/3De6sJRUlmIr2bzUoMiGXFbiw==
X-Received: by 2002:a05:6a20:4e1b:b0:199:dcb2:8756 with SMTP id gk27-20020a056a204e1b00b00199dcb28756mr258632pzb.59.1705628291261;
        Thu, 18 Jan 2024 17:38:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGFfqKCN7SyF9l3oF76mSxcnRX3bg7Yl3Px4U3HdQgZiA2aUAb/DhxD/+atTuaX1Qd5Q/fkfw==
X-Received: by 2002:a05:6a20:4e1b:b0:199:dcb2:8756 with SMTP id gk27-20020a056a204e1b00b00199dcb28756mr258626pzb.59.1705628290921;
        Thu, 18 Jan 2024 17:38:10 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id g4-20020aa78744000000b006d9bb4400f0sm3939410pfo.88.2024.01.18.17.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jan 2024 17:38:10 -0800 (PST)
Date: Fri, 19 Jan 2024 09:38:07 +0800
From: Zorro Lang <zlang@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [xfstests generic/648] 64k directory block size (-n size=65536)
 crash on _xfs_buf_ioapply
Message-ID: <20240119013807.ivgvwe7yxweamg2m@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20231218140134.gql6oecpezvj2e66@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZainBd2Jz6I0Pgm1@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZainBd2Jz6I0Pgm1@dread.disaster.area>

On Thu, Jan 18, 2024 at 03:20:21PM +1100, Dave Chinner wrote:
> On Mon, Dec 18, 2023 at 10:01:34PM +0800, Zorro Lang wrote:
> > Hi,
> > 
> > Recently I hit a crash [1] on s390x with 64k directory block size xfs
> > (-n size=65536 -m crc=1,finobt=1,reflink=1,rmapbt=0,bigtime=1,inobtcount=1),
> > even not panic, a assertion failure will happen.
> > 
> > I found it from an old downstream kernel at first, then reproduced it
> > on latest upstream mainline linux (v6.7-rc6). Can't be sure how long
> > time this issue be there, just reported it at first.
> >  [  978.591588] XFS (loop3): Mounting V5 Filesystem c1954438-a18d-4b4a-ad32-0e29c40713ed
> >  [  979.216565] XFS (loop3): Starting recovery (logdev: internal)
> >  [  979.225078] XFS (loop3): Bad dir block magic!
> >  [  979.225081] XFS: Assertion failed: 0, file: fs/xfs/xfs_buf_item_recover.c, line: 414
> 
> Ok, so we got a XFS_BLFT_DIR_BLOCK_BUF buf log item, but the object
> that we recovered into the buffer did not have a
> XFS_DIR3_BLOCK_MAGIC type.
> 
> Perhaps the buf log item didn't contain the first 128 bytes of the
> buffer (or maybe any of it), and so didn't recovery the magic number?
> 
> Can you reproduce this with CONFIG_XFS_ASSERT_FATAL=y so the failure
> preserves the journal contents when the issue triggers, then get a
> metadump of the filesystem so I can dig into the contents of the
> journal?  I really want to see what is in the buf log item we fail
> to recover.
> 
> We don't want recovery to continue here because that will result in
> the journal being fully recovered and updated and so we won't be
> able to replay the recovery failure from it. 
> 
> i.e. if we leave the buffer we recovered in memory without failure
> because the ASSERT is just a warn, we continue onwards and likely
> then recover newer changes over the top of it. This may or may
> not result in a correctly recovered buffer, depending on what parts
> of the buffer got relogged.
> 
> IOWs, we should be expecting corruption to be detected somewhere
> further down the track once we've seen this warning, and really we
> should be aborting journal recovery if we see a mismatch like this.
> 
> .....
> 
> >  [  979.227613] XFS (loop3): Metadata corruption detected at __xfs_dir3_data_check+0x372/0x6c0 [xfs], xfs_dir3_block block 0x1020 
> >  [  979.227732] XFS (loop3): Unmount and run xfs_repair
> >  [  979.227733] XFS (loop3): First 128 bytes of corrupted metadata buffer:
> >  [  979.227736] 00000000: 58 44 42 33 00 00 00 00 00 00 00 00 00 00 10 20  XDB3........... 
> 
> XDB3 is XFS_DIR3_BLOCK_MAGIC, so it's the right type, but given it's
> the tail pointer (btp->count) that is bad, this indicates that maybe
> the tail didn't get written correctly by subsequent checkpoint
> recoveries. We don't know, because that isn't in the output below.
> 
> It likely doesn't matter, because I think the problem is either a
> runtime problem writing bad stuff into the journal, or a recovery
> problem failing to handle the contents correctly. Hence the need for
> a metadump.

Hi Dave,

Thanks for your reply. It's been a month passed, since I reported this
bug last time. Now I can't reproduce this issue on latest upstream
mainline linux and xfs-linux for-next branch. I've tried to do the
same testing ~1000 times, still can't reproduce it...

If you think it might not be fixed but be hided, I can try it on older
kernel which can reproduce this bug last time, to get a metadump. What
do you think?

Thanks,
Zorro

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

