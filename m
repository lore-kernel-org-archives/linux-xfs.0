Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF97191F6C;
	Wed, 14 May 2025 15:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747237092; cv=none; b=qxJLL9ACVryXhqGlTdzEfr/DeLrd3S2aoAnLnluQSOv8ydqPk0yqsRP6V1NV1VAscknqUVl4V8LFrsS/h8TyqRGQUiFpTRLVes989s+gY0IrxJdvi5o79TusHv/X3Y6KaacXsTonno1gs67SQkJvt/UZH+G81zaEIpVdYEFJgyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747237092; c=relaxed/simple;
	bh=CMu89UfbyDh7nh7jLcqlXu0X7KEHbwAvQ3aM1+GNlNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VhdG8a8N6alGn+2dasy4ddI6B5YkX9O7Of6oKccZXOH2lXzKlSBNCqivAsOd7t+o1XKEz9irFAd78smaOi7fxhbe0oijkt0ZxGmfUIrBFwH3Aqcz31GqLLgWJctG7K4qhL1PC53Je8GfBK827SFZxGdQLD4lZI7bPXnBHE/HLJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FEgJVlZi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FEgJVlZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9528C4CEE3;
	Wed, 14 May 2025 15:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747237091;
	bh=CMu89UfbyDh7nh7jLcqlXu0X7KEHbwAvQ3aM1+GNlNg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FEgJVlZiYJNF4t6yykbmFO5Lf+BEpfIZ4FKoUAM9blY8pONAWElKkELm6QEkaqots
	 Qi5Ne2SfCRbQ67Dyw9yVmSCLOmVYTRoCgzHjtptUDfhrWBHcLttZm0h1q8rLhrpcGH
	 TWFulAvVuWTEyhHX+xiMVBkL1KcUtx5OvqI3ilx30p6nmGcWaS/a7C0X6IbLwOjrpK
	 3GGqhgExboO+GW0H3xB411++D20PWS5BBPac32xJ9kJXEg7pj1u6R5S8ycwgYPJJuF
	 eyRgaP4Njnym+m3xhvX53RpvNEyrAH4J5wlVLlJSRraSORbcyFN2+GM36OkkS0TdsC
	 6Cm4H5NXzOA3w==
Date: Wed, 14 May 2025 08:38:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 1/6] generic/765: fix a few issues
Message-ID: <20250514153811.GU25667@frogsfrogsfrogs>
References: <20250514002915.13794-1-catherine.hoang@oracle.com>
 <20250514002915.13794-2-catherine.hoang@oracle.com>
 <52fc32f8-c518-434f-ae29-2e72238e7296@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52fc32f8-c518-434f-ae29-2e72238e7296@oracle.com>

On Wed, May 14, 2025 at 01:47:20PM +0100, John Garry wrote:
> On 14/05/2025 01:29, Catherine Hoang wrote:
> > From: "Darrick J. Wong" <djwong@kernel.org>
> > 
> > Fix a few bugs in the single block atomic writes test, such as requiring
> > directio, using page size for the ext4 max bsize, and making sure we check
> > the max atomic write size.
> > 
> > Cc: ritesh.list@gmail.com
> > Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >   common/rc         | 2 +-
> >   tests/generic/765 | 4 ++--
> >   2 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/common/rc b/common/rc
> > index 657772e7..bc8dabc5 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -2989,7 +2989,7 @@ _require_xfs_io_command()
> >   		fi
> >   		if [ "$param" == "-A" ]; then
> >   			opts+=" -d"
> > -			pwrite_opts+="-D -V 1 -b 4k"
> > +			pwrite_opts+="-d -V 1 -b 4k"
> 
> according to the documentation for -b, 4096 is the default (so I don't think
> that we need to set it explicitly). But is that flag even relevant to
> pwritev2?

The documentation is wrong -- on XFS the default is the fs blocksize.
Everywhere else is 4k.

> And setting -d in pwrite_opts means DIO for the input file, right? I am not
> sure if that is required.

It's not required, I mistook where that "-d" goes -- -d as an argument
to xfs_io is necessary, but -d as an argument to the pwrite subcommand
is not.  It's also benign since we don't pass -i.

Curiously the version of this patch in my tree doesn't have the extra
-d... I wonder if I made that change and forgot to send it out.

--D

> >   		fi
> >   		testio=`$XFS_IO_PROG -f $opts -c \
> >   		        "pwrite $pwrite_opts $param 0 4k" $testfile 2>&1`
> > diff --git a/tests/generic/765 b/tests/generic/765
> > index 9bab3b8a..8695a306 100755
> > --- a/tests/generic/765
> > +++ b/tests/generic/765
> > @@ -28,7 +28,7 @@ get_supported_bsize()
> >           ;;
> >       "ext4")
> >           min_bsize=1024
> > -        max_bsize=4096
> > +        max_bsize=$(_get_page_size)
> 
> looks ok
> 
> >           ;;
> >       *)
> >           _notrun "$FSTYP does not support atomic writes"
> > @@ -73,7 +73,7 @@ test_atomic_writes()
> >       # Check that atomic min/max = FS block size
> >       test $file_min_write -eq $bsize || \
> >           echo "atomic write min $file_min_write, should be fs block size $bsize"
> > -    test $file_min_write -eq $bsize || \
> > +    test $file_max_write -eq $bsize || \
> 
> looks ok
> 
> >           echo "atomic write max $file_max_write, should be fs block size $bsize"
> >       test $file_max_segments -eq 1 || \
> >           echo "atomic write max segments $file_max_segments, should be 1"
> 
> 
> Thanks,
> John
> 
