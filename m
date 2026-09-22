Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141F649E5DC
	for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 09:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790068444; cv=none; b=q8TMCOIEcr5NSimkuKgau02iq72IUHB3bF+FoIgncRxuz4xw8JQc4ffkx2jlNm8B6/1s92dhR84ojJKEkH8CZGQprKYOFmCkFc+SxsEj1Lo6ArwzakLXHMLP7Dkh4WVomjiKwmU92zvtk7xrkgLyzILPhHNjHYnlDPvM6mixhXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790068444; c=relaxed/simple;
	bh=x6HQo2Ql98Umszl1bLbKyaBGyakHflH2Y/8sgqKcP6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MjJlwTjEIa79MJMiDpSKiVgKLFQKXTg7D0/8nEfXsVSzPgA0KBwlAdaYUH0KbG44E02D0f2WIucvS8X7TBx/V6d1fy4zB4yWhBrdGIZNneyNnOTE6daryZ7/Ac0+BT3nbkOPaayca6RccPfTqxdJOjqn83H8ByLzBCim8kLBwww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hV6zEvB9; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=l1HC45aM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hV6zEvB9";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="l1HC45aM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790068442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o4baz/6RzxjMCiX3WhcQq7uKFgXpKloXgi45FkMIoFs=;
	b=hV6zEvB9MV/3PE4+QjdWGdmy0XXPOKBVCJnmXFQ5JOXrGbDHeFWLPGTHqjxzbMaFja+Ihr
	MjApVfll9zcmaBufKgbyUckoVzu/5xbUJ3pM20+X/W7nYa3AsaCcpdeUN3FAIiMnFr1eWf
	V1fbIQ2Q4VxLadoS2/tuwaz/3Gly6mk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637-2sjrkoZ2N2inhN04HrSBPA-1; Tue, 22 Sep 2026 05:14:00 -0400
X-MC-Unique: 2sjrkoZ2N2inhN04HrSBPA-1
X-Mimecast-MFC-AGG-ID: 2sjrkoZ2N2inhN04HrSBPA_1790068439
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-490a767b782so30873825e9.2
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 02:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790068439; x=1790673239; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=o4baz/6RzxjMCiX3WhcQq7uKFgXpKloXgi45FkMIoFs=;
        b=l1HC45aMBgZ3xdsjio+YOyFachXKLMHZ43yaEiUZSxWNLhureP/1vW00dqcUTs4Cfs
         cAZ7eDbExdfqfd7jumDGq05Wqgy43tgavAFljqCZwrZDPlodroYA7n0cw53ZsFu88knm
         /vUil+LjTJ2WzWoEnH/r2T1nHlFILNDmT8T84h5WGMfoWudwr6aALc4ysvJURZyvNsm+
         WkHIfqXvEnDl7/f+lAfOPN2nP/ooQQTMbcT5x2AodvDKawVN93woRz2w7FCYoDQ8UmJV
         4o/kz4S8Oxs91owRFPG390XpDgUi3Z9VrbKXP8ePWIar68iP6lU+M0SuEWokdxpZkRu6
         eexA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790068439; x=1790673239;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o4baz/6RzxjMCiX3WhcQq7uKFgXpKloXgi45FkMIoFs=;
        b=mS2X/EOpQpDQs9NVEaBnjmxmXA/r7UuoKNqL5PT2+i0AqXe76k2EkrX+aBhF3ec9Bf
         AbLG44nM1Mg5eS8RyzuQRHaHfjxOG6eu/rDC5nvdEpqReKsdjfLALiQ/lqEGOOWB7jQ7
         N2I29JiU2fIUDbdlQMKSuMWVMMRAPCaXmlyEc9x4//JurYsNJ2zP8sOufIzyh2ER+Lzq
         ptDCnhIKHBC+AqRS8PSlw+MTuG3rcH4eRmwWhDPZmKfbWJQLvOfA7uVBaz8lHIG64JKT
         RMeyuJRXXZqKFcbi0DHWBNKO+LCTxAOzwXg0WGFG7BsF5PvhoOuCGcFKicOiZpEBRaxk
         dwvQ==
X-Forwarded-Encrypted: i=1; AKwUvBzLFopkKGYpnkFSIqcXpoQmSYRLMr5QUyJ0eeTSj4JdIMetmNd8XxS9ZTBio8yqmOoIhL3hccjlmfc=@vger.kernel.org
X-Gm-Message-State: AFuF++kVZs2SrZt2vv/ErSPd9wOyAzh5yXLGIeyI3q5nYa/AC4qf0n6B
	LDgzunoxs5LX4Gap9LXOzAMuLIw8pa2uRTbtruiqODihxwE6JJMQWJvSLlwrmg6LnaPj7ZEhN0C
	cxnnntkJ7JSHRAKCDWR1aL5qrCiIiTEpuklNenmRsA43BSobH5Y9nlja1UvFp
X-Gm-Gg: AYBFou1YU776iWmQdAKdrbXZnWHw5W+XnFL3hWROEiJFiv3MOvvLw55TDm634eIF+oh
	a9zL9isclsxtfVR8UQfF8LdM1SXSRdZsALG+md80JuuZMdwfywxqVpR9uGdm/R5k2Icfpwz9mAC
	PmW0NUVHilwJHRRQtHv4JTIMLsmmE2wLJlfdVtOAG3vRUFTp8IB03fbO6JpfXcWEurzT03XbUfB
	VHDj6nOnXNITpu4WCTcd6GaNkQFUlVVaGBcKHCp2yjx8buo94jAYBVnkeup34qljf+6+NRWrM1X
	RJJIJcv277j/uit4bLk9jdBYCqrKkWU07hvHXst/WXr7Z/s/eTIjgYBEKTqKqVPkM14GsSAwmkv
	E5BbgJtzqJFXYYpqztGDF8yjhXVZ/xux3xA==
X-Received: by 2002:a05:600c:46c7:b0:49e:7a00:b9a5 with SMTP id 5b1f17b1804b1-49fc56dbb20mr184454645e9.4.1790068438825;
        Tue, 22 Sep 2026 02:13:58 -0700 (PDT)
X-Received: by 2002:a05:600c:46c7:b0:49e:7a00:b9a5 with SMTP id 5b1f17b1804b1-49fc56dbb20mr184454405e9.4.1790068438389;
        Tue, 22 Sep 2026 02:13:58 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fdaa4e47csm74372105e9.1.2026.09.22.02.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 02:13:58 -0700 (PDT)
Date: Tue, 22 Sep 2026 11:13:57 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, djwong@kernel.org, 
	ebiggers@kernel.org, Carlos Maiolino <cem@kernel.org>, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v16 12/21] xfs: use read ioend for fsverity data
 verification
Message-ID: <arJFUV3WDkY6zmfD@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-13-aalbersh@kernel.org>
 <arIrtgZ3-9zNuru_@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arIrtgZ3-9zNuru_@infradead.org>

On 2026-09-22 00:18:14, Christoph Hellwig wrote:
> On Fri, Sep 18, 2026 at 01:15:24PM +0200, Andrey Albershteyn wrote:
> > +	if (IS_ENABLED(CONFIG_FS_VERITY) && !error && ioend->io_vi &&
> > +			xfs_fsverity_is_file_data(ip, ioend->io_offset)) {
> > +		if (ioend->io_flags & IOMAP_IOEND_INTEGRITY) {
> > +			fsv_ioend = kmem_cache_zalloc(xfs_fsverity_ioend_cache,
> > +					GFP_KERNEL);
> > +			if (!fsv_ioend) {
> 
> This needs a mempool to be deadlock safe.
> 
> > +				iomap_finish_ioends(ioend, -ENOMEM);
> > +				return;
> > +			}
> > +			fsv_ioend->ioend = ioend;
> > +			INIT_WORK(&fsv_ioend->work, xfs_end_fsverity_io_read);
> > +
> > +			fsverity_enqueue_verify_work(&fsv_ioend->work);
> > +			return;
> > +		}
> > +
> > +		fsverity_verify_bio(ioend->io_vi, &ioend->io_bio);
> > +		error = blk_status_to_errno(ioend->io_bio.bi_status);
> 
> And I think you always need to do the offload because fsverity can
> synchronously read metadata.
> 

hmmm not sure what case you see here.

Without integrity:
For data reads we get here. Here, while verifing data page, fsverity
requests reads of merkle tree pages which WILL NOT go through this
path as no read completion is done for them.

With integrity:
For data reads we get here. Here, while verifing data page, fsverity
requests reads of merkle tree pages which WILL go through this
path as they need integrity verification on the read completion.
Therefore, to use this workqueue for merkle tree pages integrity
verification we offload data block verification to fsverity
workqueue.

-- 
- Andrey

