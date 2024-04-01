Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1039E54919
	for <linux-xfs@vger.kernel.org>; Mon,  1 Apr 2024 21:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712007062; cv=none; b=uRDedg8UKr6LvPpb+sqm5FXcOX5wA/C5VqzMUbEoiSruXplKPIy5tWHynjhXiX241ovsrqNIrL7DdHtwv4KeiPyjtcTw19FCO6MP8y2VnEBcHxpTiKgqmJBXqCwpQnJGEB5nSM5HgLhsWFuNXOT0xdQL91fA4OMQdz/eorfYgBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712007062; c=relaxed/simple;
	bh=9zmdLW6yQBNT9i3D6nbGIvCIxByhDaWex8BNdtfPbIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YsRPIboIEm8yOH1V2IsFbXTS6oTkY0WSXbOCQv78TF+HU+BT6hXsoiQWTLezDD8GhpIGfKTpAx6g+htceEGuTbtOOFqhCyjZjbSBlVLRCyv15tWr/qGs25PxKYJhn2kwanWwFOp+a/L4KG1LySfAMOXWjvtclwUAidKfFY2mQEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=b96JZGVW; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="b96JZGVW"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1e0189323b4so31181215ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 01 Apr 2024 14:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712007060; x=1712611860; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bYJV0ECVuJqRmfLJwnmV6ZzS780nDs1IJ2uCW4Tldqk=;
        b=b96JZGVWdiKc/857U55InkYQiIDP4gzOEsZ0cQAl8kKDDM/6OiLyqPCDv4SiKW9sB6
         YZLy3/0iSLoZ3jPPoaGjY+PWf9pCGQaiTgLSaq/YifVs2nr0iLq5mZKAyTtzubtysXsr
         Dl5/nJX0NeIYdfYaH0FgrXuvPXbhhupIeWqaCdpIl9T8czlnpWpm37QTe9kCeuHvd07+
         Gs8NbsArszz/rHgfDJv+YA8linKRQI0stsPHXO4L6kO4sK+RJmdtWAv8+/5nRUfq260m
         uS0vgx6Dl2GvxK8BRqJbBZ+wSmsKm/gmVSluDuybx5kfviAvTev2XdyooJF7VvrFXtR+
         /02g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712007060; x=1712611860;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bYJV0ECVuJqRmfLJwnmV6ZzS780nDs1IJ2uCW4Tldqk=;
        b=ckA3Djmf+gZuEhrVD3BDoItHI6vN8SFga038YrAoeJOOJNQQERJd4EA3YriP7xlFEX
         Y+WJaMrlHm5NKEfcf3mvWFQUSWhigfXmnw2ihmW35MJ7PktHXSjSMprc6slYc8LWZcsU
         SP+f+fK9qh9MmpZoIT57krlzpctMwEuFfmFQYE2LZ4Kc1wmo8XrMz7b4E6QAZPHkfMyN
         zP0mpV2CMwvviF3SOMNWnupC5hwqQUK8veo4lxbDW+MqoM+L61IroMB3H9cFj/LQOYHe
         TKxgYuWbiaGcpeyyDe+zUySxy6bsf23eoAbqoJQL7MmWn4PjMf38RLf17d4dUj5+y4pZ
         urGw==
X-Gm-Message-State: AOJu0YxbUBkcpgZXZcf/y0/sszvNn8MLZgH2MSgV9A/s+j0vEeIMRI86
	vYtbzsgpH0Ekq6dJT2TOk7YDmBcfd1xgak+h/pjuUtVK3RkfYjAWnsykcQIzYpE=
X-Google-Smtp-Source: AGHT+IEv9VabAjehGDKqJqk4JIaXF60juLsyC0Jbsmz6MiN7aHC7IPALdWdmtgRI9S2wCPbXukBFkw==
X-Received: by 2002:a17:902:6f02:b0:1dd:d0b0:ca86 with SMTP id w2-20020a1709026f0200b001ddd0b0ca86mr10917821plk.59.1712007060120;
        Mon, 01 Apr 2024 14:31:00 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id l2-20020a170902f68200b001e0a28f61d0sm9402900plg.70.2024.04.01.14.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Apr 2024 14:30:59 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rrPF2-000c8I-3B;
	Tue, 02 Apr 2024 08:30:57 +1100
Date: Tue, 2 Apr 2024 08:30:56 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org,
	mcgrof@kernel.org, gost.dev@samsung.com
Subject: Re: [PATCH 00/12] xfs: remove remaining kmem interfaces and GFP_NOFS
 usage
Message-ID: <ZgsnkJanXdMhyhYN@dread.disaster.area>
References: <20240115230113.4080105-1-david@fromorbit.com>
 <y6sfzed3vgrgx4rmguee5np262d66iq7r7cr6k7lapth5bgk5j@v6tig3qf333p>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y6sfzed3vgrgx4rmguee5np262d66iq7r7cr6k7lapth5bgk5j@v6tig3qf333p>

On Mon, Mar 25, 2024 at 06:46:29PM +0100, Pankaj Raghav (Samsung) wrote:
> > 
> > The first part of the series (fs/xfs/kmem.[ch] removal) is straight
> > forward.  We've done lots of this stuff in the past leading up to
> > the point; this is just converting the final remaining usage to the
> > native kernel interface. The only down-side to this is that we end
> > up propagating __GFP_NOFAIL everywhere into the code. This is no big
> > deal for XFS - it's just formalising the fact that all our
> > allocations are __GFP_NOFAIL by default, except for the ones we
> > explicity mark as able to fail. This may be a surprise of people
> > outside XFS, but we've been doing this for a couple of decades now
> > and the sky hasn't fallen yet.
> 
> Definetly a surprise to me. :)
> 
> I rebased my LBS patches with these changes and generic/476 started to
> break in page alloc[1]:
> 
> static inline
> struct page *rmqueue(struct zone *preferred_zone,
> 			struct zone *zone, unsigned int order,
> 			gfp_t gfp_flags, unsigned int alloc_flags,
> 			int migratetype)
> {
> 	struct page *page;
> 
> 	/*
> 	 * We most definitely don't want callers attempting to
> 	 * allocate greater than order-1 page units with __GFP_NOFAIL.
> 	 */
> 	WARN_ON_ONCE((gfp_flags & __GFP_NOFAIL) && (order > 1));
> ...

Yeah, that warning needs to go. It's just unnecessary noise at this
point in time - at minimum should be gated on __GFP_NOWARN.

> The reason for this is the call from xfs_attr_leaf.c to allocate memory
> with attr->geo->blksize, which is set to 1 FSB. As 1 FSB can correspond
> to order > 1 in LBS, this WARN_ON_ONCE is triggered.
> 
> This was not an issue before as xfs/kmem.c retried manually in a loop
> without passing the __GFP_NOFAIL flag.

Right, we've been doing this sort of "no fail" high order kmalloc
thing for a couple of decades in XFS, explicitly to avoid arbitrary
noise like this warning.....

> As not all calls to kmalloc in xfs_attr_leaf.c call handles ENOMEM
> errors, what would be the correct approach for LBS configurations?

Use kvmalloc().

-Dave.
-- 
Dave Chinner
david@fromorbit.com
