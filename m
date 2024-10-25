Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8397515B13D;
	Fri, 25 Oct 2024 05:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729834119; cv=none; b=TtXHhKyl3ai9KRsQgkiWbbMsj61EO48JPc7vmjT4xmACMwZplwTeKsTrGZzdIUQvIRHSx6eHeYkfVN+mTS3ZVkS1JVBCgkfvq6bS3MXkDIcY0h5XNO44ho7Ov8Rc7OZRGEBC0FbykwVziqhb0X5IClVRAw7g7hUTO4k1rpIk4nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729834119; c=relaxed/simple;
	bh=gNUkUpopSG0AEjCrs8KspM3nbAQKQoINg15YVq6Kea0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r60y2FoFuHzyJyspa1GrhjZWal7I4eauxo1BhCKuOh6Y2/gm0O4YEy2lYViEQpJMchGwYOf/5KTQAPs/siSKgCfz5k42GhJvURxHSh/riVcdiOoVXYfUDUISIMCHgyHNGWbYyT3WFywojZiBuJyI18afjPKuucWhckcxTSvN/l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I1pltOJj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I1pltOJj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4E1C4CEC3;
	Fri, 25 Oct 2024 05:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729834119;
	bh=gNUkUpopSG0AEjCrs8KspM3nbAQKQoINg15YVq6Kea0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I1pltOJjL1dX9X4pwg+7i9h7ORkdkFu/bytSmvTG5AqOn4Y9jrjVvbfl4qVlL7TPW
	 FI5qmBvwfGOofrgzF5Djj8o2dUGHTtPnf7Iz5qu9exeXDI44RbUmdkQw2D3WssYgR5
	 oE5Fd9bAzM2m1ln3006RTL0prVcpZ176pjEGf+H+jFOJ0aPoJBa7eMJqvcuwNB5Gj6
	 MtbadTnCZpKlYD1N9LjtXoB/E+HmvBN7zsc5oo6Isn+L9JW1q13BEBFiZ6iqh+YBRa
	 dpyiVvbZxeVQGPpSrsgR3mv8XDNSNvsXcoEQo7ZHz+6+VwhAUZpSJXGWg2Q1Q+bGp0
	 qKfN+QlJ6v2vw==
Date: Thu, 24 Oct 2024 22:28:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>, fstests@vger.kernel.org,
	zlang@redhat.com, linux-xfs@vger.kernel.org, gost.dev@samsung.com,
	mcgrof@kernel.org, david@fromorbit.com
Subject: Re: Re: [PATCH 1/2] generic/219: use filesystem blocksize while
 calculating the file size
Message-ID: <20241025052838.GS21840@frogsfrogsfrogs>
References: <20241024112311.615360-1-p.raghav@samsung.com>
 <20241024112311.615360-2-p.raghav@samsung.com>
 <20241024181910.GG2386201@frogsfrogsfrogs>
 <tkkmsrqrevdsjxybiheukav2tfqucb6hz2tstl2ritzsv3s5aw@gqjkppt7zie7>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tkkmsrqrevdsjxybiheukav2tfqucb6hz2tstl2ritzsv3s5aw@gqjkppt7zie7>

On Fri, Oct 25, 2024 at 06:42:20AM +0530, Pankaj Raghav (Samsung) wrote:
> On Thu, Oct 24, 2024 at 11:19:10AM -0700, Darrick J. Wong wrote:
> > On Thu, Oct 24, 2024 at 01:23:10PM +0200, Pankaj Raghav wrote:
> > > generic/219 was failing for XFS with 32k and 64k blocksize. Even though
> > > we do only 48k IO, XFS will allocate blocks rounded to the nearest
> > > blocksize.
> > > 
> > > Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> > > ---
> > >  tests/generic/219 | 18 +++++++++++++++---
> > >  1 file changed, 15 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/tests/generic/219 b/tests/generic/219
> > > index 940b902e..d72aa745 100755
> > > --- a/tests/generic/219
> > > +++ b/tests/generic/219
> > > @@ -49,12 +49,24 @@ check_usage()
> > >  	fi
> > >  }
> > >  
> > > +_round_up_to_fs_blksz()
> > > +{
> > > +	local n=$1
> > > +	local bs=$(_get_file_block_size "$SCRATCH_MNT")
> > > +	local bs_kb=$(( bs >> 10 ))
> > > +
> > > +	echo $(( (n + bs_kb - 1) & ~(bs_kb - 1) ))
> > 
> > Nit: you can divide here, right?
> 
> No. I think you are talking about DIV_ROUND_UP(). We are doing a
> round_up operation here.

Hah oops yeah.

> We should get 64k as sz for bs 32k and 64k.
> 
> round_up(48k, 32k/64k) = 64k

<nod>

post clue-bat,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> > 
> > 	echo $(( (n + bs_kb - 1) / bs_kb ))
> > 
> > The rest seems fine.
> > 
> > --D
> > 
> > > +}
> > > +
> > >  test_accounting()
> > >  {
> > > -	echo "### some controlled buffered, direct and mmapd IO (type=$type)"
> > > -	echo "--- initiating parallel IO..." >>$seqres.full
> > >  	# Small ios here because ext3 will account for indirect blocks too ...
> > >  	# 48k will fit w/o indirect for 4k blocks (default blocksize)
> > > +	io_sz=$(_round_up_to_fs_blksz 48)
> > > +	sz=$(( io_sz * 3 ))
> > > +
> > > +	echo "### some controlled buffered, direct and mmapd IO (type=$type)"
> > > +	echo "--- initiating parallel IO..." >>$seqres.full
> > >  	$XFS_IO_PROG -c 'pwrite 0 48k' -c 'fsync' \
> > >  					$SCRATCH_MNT/buffer >>$seqres.full 2>&1 &
> > >  	$XFS_IO_PROG -c 'pwrite 0 48k' -d \
> > > @@ -73,7 +85,7 @@ test_accounting()
> > >  	else
> > >  		id=$qa_group
> > >  	fi
> > > -	repquota -$type $SCRATCH_MNT | grep "^$id" | check_usage 144 3
> > > +	repquota -$type $SCRATCH_MNT | grep "^$id" | check_usage $sz 3
> > >  }
> > >  
> > >  
> > > -- 
> > > 2.44.1
> > > 
> > > 
> 
> -- 
> Pankaj Raghav
> 
