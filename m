Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D2F1E89C;
	Fri, 25 Oct 2024 01:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729818761; cv=none; b=Efb1koYYiSWWxUw61WAg5z0xgUHafwUimwJYbjU3HZD0n3EYqjbzNaLgXIhzhy5WurzqKRZBANF/j2n02PPYJh1pwazjnQSBFyeyGqPBWaXoffiZCxfTTCJlvme3/DYRaVGjXElFPjLl3HEnyRCP5KIAdVp4yLcpJbb+nZjwN0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729818761; c=relaxed/simple;
	bh=PHxfFpqObkrrSBamze6sZWU16lKkQrT5urkAlZLAiog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DoWtPRk3is84w8aq1nfmq8ZueHmUNwFLJtCdO/lHmMoA9P0PUmyT4kwyarmsGG/bbGso9GIfdm4X7QYXutSm0UXIZ/uGn+I8W/unwvol8xktF0p00YVnuI589JVajK8g/ZSE7lMe30TDPYVrH5Azm7IG8DL7KuWR/r+hAoLGUaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=w6ly9JN3; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="w6ly9JN3"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4XZPs94ttLz9sdB;
	Fri, 25 Oct 2024 03:12:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1729818749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rWq8HddAxnbOButkoMRlw3wmi3/AUyLd9/aAwivCFzE=;
	b=w6ly9JN3wXQqZ/74KIXYwBlwzaxWnhSV8AA28sFZ5obOcwjYsUefajEGjgUSTueJVwQEop
	ZF70fPSCQvj9bYxBtEvn6CLC75YUpF+fdtkFBG3cqQ6aMRSRtX2J0g3RexGTWToFChs3ni
	/k5quLIh1egJVDpsSQuIGGbV2HMvYxaxmTmdQeGUgNNHdv4AMXuorHMYVf5xXpNtOJbMgU
	W1XEg1dOHS5FoxwuLN+TorLv5y9sQRxp/wuQhr5Z0ZL7XuldW42zkx8fZKQt+o5NAcnrKs
	ql+xT8ntyNNCioRO4U2742j7KFPZ5APRRRee3UnwbIBipKOnDC06XuEKhhNI+A==
Date: Fri, 25 Oct 2024 06:42:20 +0530
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>, fstests@vger.kernel.org, 
	zlang@redhat.com, linux-xfs@vger.kernel.org, gost.dev@samsung.com, 
	mcgrof@kernel.org, david@fromorbit.com
Subject: Re: Re: [PATCH 1/2] generic/219: use filesystem blocksize while
 calculating the file size
Message-ID: <tkkmsrqrevdsjxybiheukav2tfqucb6hz2tstl2ritzsv3s5aw@gqjkppt7zie7>
References: <20241024112311.615360-1-p.raghav@samsung.com>
 <20241024112311.615360-2-p.raghav@samsung.com>
 <20241024181910.GG2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241024181910.GG2386201@frogsfrogsfrogs>
X-Rspamd-Queue-Id: 4XZPs94ttLz9sdB

On Thu, Oct 24, 2024 at 11:19:10AM -0700, Darrick J. Wong wrote:
> On Thu, Oct 24, 2024 at 01:23:10PM +0200, Pankaj Raghav wrote:
> > generic/219 was failing for XFS with 32k and 64k blocksize. Even though
> > we do only 48k IO, XFS will allocate blocks rounded to the nearest
> > blocksize.
> > 
> > Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> > ---
> >  tests/generic/219 | 18 +++++++++++++++---
> >  1 file changed, 15 insertions(+), 3 deletions(-)
> > 
> > diff --git a/tests/generic/219 b/tests/generic/219
> > index 940b902e..d72aa745 100755
> > --- a/tests/generic/219
> > +++ b/tests/generic/219
> > @@ -49,12 +49,24 @@ check_usage()
> >  	fi
> >  }
> >  
> > +_round_up_to_fs_blksz()
> > +{
> > +	local n=$1
> > +	local bs=$(_get_file_block_size "$SCRATCH_MNT")
> > +	local bs_kb=$(( bs >> 10 ))
> > +
> > +	echo $(( (n + bs_kb - 1) & ~(bs_kb - 1) ))
> 
> Nit: you can divide here, right?

No. I think you are talking about DIV_ROUND_UP(). We are doing a
round_up operation here.

We should get 64k as sz for bs 32k and 64k.

round_up(48k, 32k/64k) = 64k

> 
> 	echo $(( (n + bs_kb - 1) / bs_kb ))
> 
> The rest seems fine.
> 
> --D
> 
> > +}
> > +
> >  test_accounting()
> >  {
> > -	echo "### some controlled buffered, direct and mmapd IO (type=$type)"
> > -	echo "--- initiating parallel IO..." >>$seqres.full
> >  	# Small ios here because ext3 will account for indirect blocks too ...
> >  	# 48k will fit w/o indirect for 4k blocks (default blocksize)
> > +	io_sz=$(_round_up_to_fs_blksz 48)
> > +	sz=$(( io_sz * 3 ))
> > +
> > +	echo "### some controlled buffered, direct and mmapd IO (type=$type)"
> > +	echo "--- initiating parallel IO..." >>$seqres.full
> >  	$XFS_IO_PROG -c 'pwrite 0 48k' -c 'fsync' \
> >  					$SCRATCH_MNT/buffer >>$seqres.full 2>&1 &
> >  	$XFS_IO_PROG -c 'pwrite 0 48k' -d \
> > @@ -73,7 +85,7 @@ test_accounting()
> >  	else
> >  		id=$qa_group
> >  	fi
> > -	repquota -$type $SCRATCH_MNT | grep "^$id" | check_usage 144 3
> > +	repquota -$type $SCRATCH_MNT | grep "^$id" | check_usage $sz 3
> >  }
> >  
> >  
> > -- 
> > 2.44.1
> > 
> > 

-- 
Pankaj Raghav
