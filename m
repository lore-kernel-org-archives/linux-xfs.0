Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE4A232392
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 09:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736759805; cv=none; b=LLM08IUsF9XUK7kzXRl+K3c3tUNkUe38TmHu5Ag02y92tQWFR3KxRIg3ecPlW03YJg0rhXrrXwkRfq5fYdXx+Rc2g/G2zT9yuLoo51XOXDaN37AW7lCVP91ly5LJn4oDI/3gYTmIoiHxsJZPQ6ZnnrVruzKhzgA7CBOMTkzm+ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736759805; c=relaxed/simple;
	bh=KYmcnOGjzYeeeNVGuLg63nobikENCRdtb2MRJww/hd4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qEL0xWLV0Sk9HfPTy1cVbbi1LA+JXvbBWWDCS43qmDYW1+CzAU4AuFqonIDfSm8yrteumykgKul8kJe0yiyU2Ca+d7DQs4NclC3GI6QaUGD1umWQjNbjWTKuCw5vDmiXkLb6h6hH44ch7qdhSHDGljFtm8Q5g1cu9KTOGpTwbDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TiD0w/X9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TiD0w/X9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736759802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cfHZWEnV88+EdOqwEluMyfzCRQYW9CvJLFjdihQvYmI=;
	b=TiD0w/X92VAst7vMKYqv0TTzcAyYgRf+EdCdcnyH3Ubu8rVVx1k/XxHHAv4la91Rdz9yQy
	nWOTWZIPXoC4HlHt3/tP/+bOQWL1YUzOPbpZJo8Bn/59PFbW4msdSDSwimbf4K/gaBCaLW
	z+0xsNBie2Jd7JC6gmwqdTL5TPGLHM4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-q4Suz_VGOtibFHCWRMT5uQ-1; Mon, 13 Jan 2025 04:16:41 -0500
X-MC-Unique: q4Suz_VGOtibFHCWRMT5uQ-1
X-Mimecast-MFC-AGG-ID: q4Suz_VGOtibFHCWRMT5uQ
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43623bf2a83so33823065e9.0
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 01:16:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736759800; x=1737364600;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cfHZWEnV88+EdOqwEluMyfzCRQYW9CvJLFjdihQvYmI=;
        b=QcI4njz0gKHWExuX/mJHD/tlpnLAuMobaV4azAvky4mG3SALAFyLR28XcTdK0y4jha
         1g/6OtelRZ+m9gpYKmXdsMh3vGVcxdaO7NCyS/5ZaAGPCnLZQQUvNUn+UQ2ucPosVevg
         DY2ookwn+FR0O5T56ba6nswHeTKi7oNvdxNcBTt4fUuwr4LQRc4cXoqPoba+blPjSnpc
         TvlVQBPxuu5BnmcqqRpLoW4GTiVazHG6aGkk+TLoyW67lEk/PFvXyqZjJ1f3TOO1N/TQ
         c8h6mTtM5csrE/1AloJgzforzozt50QgTzJka/g/cv8KjAB5RJpvlwHMm/RTwpBm1tH/
         +Oeg==
X-Forwarded-Encrypted: i=1; AJvYcCUlEkIcWQAaKI+fH3oxA3ss3RzQS4qYichd1FRGWQMnwm5NWJph1r6Kfa/7ctEJruET1loqVRQWcJI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBb7r++paFzOWnJ9jis4dzXQ6T6yL6owUOYIFSYvKye+ybjumH
	elWT59fHbxQP2am8Fe6U68c9OMQ+/DLp2W6o1WfQCeruXwT37K+Bk2I4RZO3f4IzrXgyrtvTFi7
	Rv4BTCmuJXHpCq5b4Ci5IVpNslgzf2kHmWzzzuLqTt5AbBZCKI+p2Jz9I
X-Gm-Gg: ASbGnctQEuclhMd6z/TJ+QYcet81U+xcjv75Mwm4sAqcYUHdbyFboLc8bgQFt3LT3ys
	IgXIX1ZJsC4wuonoQv4vl6av/TrISrwAiNAv+GPqduB6edRSFVNvbcxj3hu13Q9+tCn6sCmyLei
	6CubaHEYJT+lWyqBjuK2s/p/DPl3YTTJkQMrQtkkvsIrJyXpm46+v+sQLpWRxRrukt6W2pFSFKr
	LJSOsUGRlRhsSM0rpesZxPS/5j76E3cfa9pwY3LpBfSntf6qptm2SWF/U/icjioft4zU406iWov
X-Received: by 2002:a05:600c:444d:b0:434:f739:7ce2 with SMTP id 5b1f17b1804b1-436eedef4e5mr103272355e9.8.1736759800110;
        Mon, 13 Jan 2025 01:16:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF8JqLN+CF2Oc/4vu0B9ZDu0LJ1PjXPWJ091vS48IcL2OXFQcKPjqO7fXsnQh3tAo661H6Bfw==
X-Received: by 2002:a05:600c:444d:b0:434:f739:7ce2 with SMTP id 5b1f17b1804b1-436eedef4e5mr103272035e9.8.1736759799719;
        Mon, 13 Jan 2025 01:16:39 -0800 (PST)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e2ddc5f5sm171083775e9.18.2025.01.13.01.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2025 01:16:39 -0800 (PST)
Date: Mon, 13 Jan 2025 10:16:38 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, 
	david@fromorbit.com, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [RFC] Directly mapped xattr data & fs-verity
Message-ID: <dqgavzsamb5nsjojgvb22rcjc4blmelkrlek6nfv22v3pckwz3@q72vwjv2dtc2>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20250106154212.GA27933@lst.de>
 <prijdbxigrvzr5xsjviohbkb3gjzrans6yqzygncqrwdacfhcu@lhc3vtgd6ecw>
 <20250107165057.GA371@lst.de>
 <j7barlm3iix22ytjuu5y5mptfqzjme5pfdxk2a3vgb43ukoqxg@uhbobs5fs2uz>
 <20250109073908.GL1387004@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250109073908.GL1387004@frogsfrogsfrogs>

On 2025-01-08 23:39:08, Darrick J. Wong wrote:
> On Wed, Jan 08, 2025 at 10:20:59AM +0100, Andrey Albershteyn wrote:
> > On 2025-01-07 17:50:57, Christoph Hellwig wrote:
> > > On Mon, Jan 06, 2025 at 09:56:51PM +0100, Andrey Albershteyn wrote:
> > > > On 2025-01-06 16:42:12, Christoph Hellwig wrote:
> > > > > I've not looked in details through the entire series, but I still find
> > > > > all the churn for trying to force fsverity into xattrs very counter
> > > > > productive, or in fact wrong.
> > > > 
> > > > Have you checked
> > > > 	[PATCH] xfs: direct mapped xattrs design documentation [1]?
> > > > It has more detailed argumentation of this approach.
> > > 
> > > It assumes verity must be stored in the attr fork and then justifies
> > > complexity by that.
> > > 
> > > > > xattrs are for relatively small variable sized items where each item
> > > > > has it's own name.
> > > > 
> > > > Probably, but now I'm not sure that this is what I see, xattrs have
> > > > the whole dabtree to address all the attributes and there's
> > > > infrastructure to have quite a lot of pretty huge attributes.
> > > 
> > > fsverity has a linear mapping.  The only thing you need to map it
> > > is the bmap btree.  Using the dabtree helps nothing with the task
> > > at hand, quite to the contrary it makes the task really complex.
> > > As seen both by the design document and the code.
> > > 
> > > > Taking 1T file we will have about 1908 4k merkle tree blocks ~8Mb,
> > > > in comparison to file size, I see it as a pretty small set of
> > > > metadata.
> > > 
> > > And you could easily map them using a single extent in the bmap
> > > btree with no overhead at all.  Or a few more if there isn't enough
> > > contiguous freespace.
> > > 
> > > > 
> > > > > fsverity has been designed to be stored beyond
> > > > > i_size inside the file.
> > > > 
> > > > I think the only requirement coming from fs-verity in this regard is
> > > > that Merkle blocks are stored in Pages. This allows for PG_Checked
> > > > optimization. Otherwise, I think it doesn't really care where the
> > > > data comes from or where it is.
> > > 
> > > I'm not say it's a requirement.  I'm saying it's been designed with
> > > that in mind.  In other words it is a very natural fit.  Mapping it
> > > to some kind of xattrs is not.
> > > 
> > > > Yes, that's one of the arguments in the design doc, we can possibly
> > > > use it for mutable files in future. Not sure how feasible it is with
> > > > post-EOF approach.
> > > 
> > > Maybe we can used it for $HANDWAVE is not a good idea. 
> > 
> > > Hash based verification works poorly for mutable files, so we'd
> > > rather have a really good argument for that.
> > 
> > hmm, why? Not sure I have an understanding of this
> 
> Me neither.  I can see how you might design file data block checksumming
> to be basically an array of u32 crc[nblocks][2].  Then if you turned on
> stable folios for writeback, the folio contents can't change so you can
> compute the checksum of the new data, run a transaction to set
> crc[nblock][0] to the old checksum; crc[nblock][1] to the new checksum;
> and only then issue the writeback bio.
> 
> But I don't think that works if you crash.  At least one of the
> checksums might be right if the device doesn't tear the write, but that
> gets us tangled up in the untorn block writes patches.  If the device
> does not guarantee untorn writes, then you probably have to do it the
> way the other checksumming fses do it -- write to a new location, then
> run a transaction to store the checksum and update the file mapping.
> 
> In any case, that's still just a linear array stored in some blocks
> beyond EOF, and (presumably) growing in the top of the file.  Maybe you
> can even have a merkle(ish) tree to checksum the checksum leaves.  But I
> don't see why the xattr stuff is needed at all in that case, but what
> I'm really looking for here is this -- do you folks have some future
> design involving these double-checksummed headerless remote xattr
> blocks?  Or a more clever data block checksumming design than the stupid
> one I just came with?
> 
> <shrug>
> 
> > > > I don't really see the advantage or much difference of storing
> > > > fs-verity post-i_size. Dedicating post-i_size space to fs-verity
> > > > dosn't seem to be much different from changing xattr format to align
> > > > with fs blocks, to me.
> > > 
> > > It is much simpler, and more storage efficient by doing away with the
> > > need for the dabtree entries and your new remote-remote header.
> 
> I agree... at least in the absence of any other knowledge.

I will look into post-i_size approach, then.

-- 
- Andrey

