Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D52F29117A
	for <linux-xfs@vger.kernel.org>; Mon,  5 May 2025 22:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746483441; cv=none; b=DLOMTdF7hO3Nyr2jRS1mk0I3UCBqS3Nh2+vpQi4U+qxf6IiNu3fzaRYTyxoLtozhCqMXfpM35jBBITeh3jOQPEaqMGJStbLiKWujx6ENSB7X/tb/WesKo0IODwKJ6eWg/dFwxTnAaU3akm1WJRDZ4qmrb0dA+aGldKZAcPrJNv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746483441; c=relaxed/simple;
	bh=e+x5rAREwkTIbErn1FtZKoq2Pz1fycajN7srH/QekG0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lnoud/pipaO5ZyqFZNNTot3WRCjVZPxCMxgaTz3FGNOZPsbiPuoOsowHOWAWHQMxJfovnFVhcZBso5Bs4dx8kt0qJMTM3Dn3JMWPw9+ABDvKWK8qyNnt/FlrawHnuYpAfZWQwM9na5m0nVCjDuamQfnAeFOI2qPGey70ljPPJgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=qV3SXqIG; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="qV3SXqIG"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-30572effb26so4715676a91.0
        for <linux-xfs@vger.kernel.org>; Mon, 05 May 2025 15:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1746483439; x=1747088239; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MERLGTHs/RrtUtLm0v7jU2OTI0wGhvJkJK+5yu5RY+8=;
        b=qV3SXqIG8LOTyNh8LMsmf6TL1js4N26rFfID3fboiAPaafDbrKKC7wU9AJmA8muXm9
         6JIap6KwzRdUT2qL5WCrY5KYBfo8+VRMsg/R8vYBN6W/323+dvqa8YT7wwWtgTbYIUIr
         dKIvv9VbMvZczuE+mvCr4o22HPbEZV7OXr8aUJvwS7dcnp/cjXe8MS8GsXptml/9+hB5
         6Rr0jJvhirFAF5d0+B6CsOCCOBsnJYXIqfUWN+8ace1TdyRaf9jzZrwH0QDGsXUP1dDy
         ISDTVS5x5srVWybXqqKMFdPvGI2ZIclJjTm/MkwGIfvoD+GrLp0AQ19Eh+nXWE2fFkXL
         6zGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746483439; x=1747088239;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MERLGTHs/RrtUtLm0v7jU2OTI0wGhvJkJK+5yu5RY+8=;
        b=nrbl2A3gwlQH3A9xAoTpZihma7GQtfYsnHY201+QiEhEigmFi3+a+uTqX+s/E8OJNi
         L/yKtFPGdE6Saom9x8FROzG7XFIqOBh8ZOFWQWATWG0VZUiuXo/4XWKrWRLR5uIGKS81
         hyzRm6C5TaRaaygKO/cYO1EDZ8+LS+f66N1vpM5Ua4PbDNNCttGsEEuqt6gyFBSMJACW
         +qg4Y3eAZBRBRsbKux/07v+ofjOFO/Zhkj68yL4wT6m0pbtQ80AROUPYXPtlStYLkhKU
         ptQWYw+JooF39+hNHGAhtHIZXZYjGcGR56tUNr5n+V4JJEL50zBiR1xiF8Bo6q0qNNyh
         6EFw==
X-Forwarded-Encrypted: i=1; AJvYcCXoXsQP52F23CGNfOAafZGg9iretK45+iUlJYbG5nQ59TsZoK3rVdtuZbu4u4hEDo7vw5uPimArEnY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ0RwSU08kJoF7SRPLAtxG6O4rnPQtw0G79T4DKaDOJt7Wm+dr
	rf9ciAJoa1pZU94U9y6GT6hh8b2xIRl1QBez3mm+JA/kUpxQ0U/bNFseasa6NqdFJUWF0XCkVBn
	K
X-Gm-Gg: ASbGnct+XXipRWo3p+cnqZPIhM2rKOSzZEVvwm+tDfV0PIvk3grYLF2npxRoIBZKEha
	R/Vk/58COEVfQ98Tb7UzJA6r+XoboJdmZvpyTINhodgGzVChttEn8cvTkt4/QlxDFo0PVB1Q8zd
	BX+mvJmyAzHc0cFWMPSHCRtTmEe6nPC2ox1dQTSwJuOlmiO+W2oT6jtscAK8AZf4niMjnPpi0Nj
	G/BV/hkbqr0BbA6pamequGFhGaeH5UFDD7MRmFbk+NqZZPaCMibGMc+jV8Lp7acpmc6gdIrg3ER
	Dv8AxuJYKCajd6rQ0NjPMFQhIU4gzxMg0UrgWSwD8r3vF/bjy71h0MC7mK4Gm7HomzYE1ILJ28r
	vFZffNINrKIdkqPJOwwY7FFbb
X-Google-Smtp-Source: AGHT+IHrvwwqSoSlfObVoPWp8AjVunSDrM2JhYnGT2PWGcNQNPXU+yqDU5LcnUBQQVLLeR5E/xxEgw==
X-Received: by 2002:a17:90b:5824:b0:309:eb44:2a58 with SMTP id 98e67ed59e1d1-30a4e623cb7mr18675373a91.22.1746483439392;
        Mon, 05 May 2025 15:17:19 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-60-96.pa.nsw.optusnet.com.au. [49.181.60.96])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a47625aeasm9535767a91.36.2025.05.05.15.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 15:17:18 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uC47g-0000000HSCB-0wDj;
	Tue, 06 May 2025 08:17:16 +1000
Date: Tue, 6 May 2025 08:17:16 +1000
From: Dave Chinner <david@fromorbit.com>
To: Charalampos Mitrodimas <charmitro@posteo.net>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xfs: Verify DA node btree hash order
Message-ID: <aBk47Oqsy63jSBJY@dread.disaster.area>
References: <20250505-xfs-hash-check-v2-1-226d44b59e95@posteo.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250505-xfs-hash-check-v2-1-226d44b59e95@posteo.net>

On Mon, May 05, 2025 at 08:06:39AM +0000, Charalampos Mitrodimas wrote:
> The xfs_da3_node_verify() function checks the integrity of directory
> and attribute B-tree node blocks. However, it was missing a check to
> ensure that the hash values of the btree entries within the node are
> non-decreasing hash values (allowing equality).
> 
> Add a loop to iterate through the btree entries and verify that each
> entry's hash value is greater than the previous one. If an
> out-of-order hash value is detected, return failure to indicate
> corruption.

Ok, the code is fine, but....

> This addresses the "XXX: hash order check?" comment and improves
> corruption detection for DA node blocks.

.... it doesn't address that comment.

That comment was posed as a question for good reasons.

Ask yourself this question and then do the math: what is the
overhead of doing this hash order check on a 64kB directory node
block? How many times does this loop iterate, and how much extra CPU
does that burn when you are processing tens of thousands of these
blocks every second?

IOWs, that comment is posed as a question because the hash order
check is trivial to implement but we've assumed that it is -too
expensive to actually implement-. It has never been clear that the
additional runtime expense is worth the potential gain in corruption
detection coverage.

In terms of performance and scalability, we have to consider what
impact this has on directory lookup performance when
there are millions of entries in a directory. What about when
there are billions of directory entries in the filesystem? What
impact does this have on directory modification and writeback speed
(verifiers are also run prior to writeback, not just on read)?
What impact does it have on overall directory scalability? etc.

Now consider the other side of the coin: what is the risk of
undetected corruptions slipping through because we don't verify the
hash order? Do we have any other protections against OOO hash
entries in place? What is the severity of the failure scenarios
associated with an out-of-order hash entry - can it oops the
machine, cause a security issue, etc? Have we ever seen an out of
order hash entry in the wild?

Hence we also need to quantify the risk we are assuming by not
checking the hash order exhaustively and how it changes by adding
such checking. What holes in the order checking still exist even
with the new checks added (e.g. do we check hash orders across
sibling blocks?).

Are there any other protections on node blocks that already inform
us of potential ordering issues without needing expensive,
exhaustive tests?  If not, are there new, lower cost checks we can
add that will give us the same detection capabilty without the
IO-time verification overhead? (e.g. in the hash entry binary search
lookup path.)

i.e. What is the risk profile associated with the status quo of the
past 30 years (i.e. no hash order verification at IO time) and how
much does that improve by adding some form of hash order
verification?

Hence as a first step before we add such hash order checking, we
need performance and scalability regression testing (especially on
directories containing millions of entries) to determine the runtime
hit we will take from adding the check. Once the additional runtime
overhead has been measured, quantified and analysed, then we can
balance that against the risk profile improvement and make an
informed decision on this verification...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
