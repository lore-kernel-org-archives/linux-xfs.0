Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194DD25485D
	for <linux-xfs@vger.kernel.org>; Fri,  2 May 2025 13:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746192817; cv=none; b=DV6ND1LcMM8jKMbETdV3ULVbtlyAl5wVjcRe7QG4PTQAxRK3kkT+nNCEw26MTu6dZYPLmflNPBiECOyasM4G6G3Hqa6SC8VQRKQ/bpfNHRlq0Wr0eod4vijq6XeaLMtOjG1ZWa22MYNw0YB26kZKv/1iPyyXkyuUGPaEdFyeMyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746192817; c=relaxed/simple;
	bh=YX3L0lHArVa4cEVT5SxJ3DOMDbZYRO/IgKsEnba4x6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TpcinCDUA2oMZQEpmyRtViZSFuN8imHHFoWkUP4Wb74+yjo2tApWDPTlqXLhrqIBnTzirCOkhLXcAOwyIpTvotWGpRYE2EdiMdbJNm2DqnzOW2CTMN9HcTi5OYA3vetKiu6iNOmfQ0fm6M23cK9LN2BxXix+new/dcAMHEb/aCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Received: from trampoline.thunk.org (pool-173-48-82-148.bstnma.fios.verizon.net [173.48.82.148])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 542DXAYE000384
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 2 May 2025 09:33:12 -0400
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id E2FE62E00E9; Fri, 02 May 2025 09:33:09 -0400 (EDT)
Date: Fri, 2 May 2025 09:33:09 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        "zlang@kernel.org" <zlang@kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        "djwong@kernel.org" <djwong@kernel.org>, hch <hch@lst.de>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>
Subject: Re: [PATCH] ext4/002: make generic to support xfs
Message-ID: <20250502133309.GB29583@mit.edu>
References: <20250502113415.14882-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502113415.14882-1-hans.holmberg@wdc.com>

On Fri, May 02, 2025 at 11:35:01AM +0000, Hans Holmberg wrote:
> xfs supports separate log devices and as this test now passes, share
> it by turning it into a generic test.

Was this fixed by a kernel commit to the XFS tree?  If so, could you
add a _fixed_by_kernel_commit pointing at the fix?  And while you're
at it, could you add:


[ $FSTYP == "ext4" ] && \
	_fixed_by_kernel_commit 273108fa5015 \
	"ext4: handle read only external journal device"

to the test?  This will make it easier for people using LTS kernels to
know which commits they need to backport.

Many thanks!

						- Ted
