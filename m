Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC784B1E6A;
	Thu, 15 May 2025 01:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747273638; cv=none; b=l9k610vnpiIYqj9dFNjNH83yOnLix2+mrDrtMMbNSjXBUcNEsbL6EGmVjwdKXXG0Txn0Rp0tOHCgg2i1zWF3CnS+ektrKKjqVtjwA4XzScV0/ppCxE0pFXL+6epiFBhxp/c2gxdc7l+oI43T/z+Eo0gP5/4RMaCWa+c8Ptm1lCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747273638; c=relaxed/simple;
	bh=lybrXG7ggUT2+z/C/r3+kn9kbzJ+pLxpM1YRuM3E3tk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WbFiqbtTaVKE4EPDhLSvcfIP2HGWQ4BwRYics4FgH0DY97W98iiiD7F1y0f8SSe4vrNm+X1oCrPVjbPj5aIfdsbT56xloJsIh1jL5FHH1AtON/qm+ZlvTweVpvVdr+c3Bf65DsGL2SJvdkMJ3dDHyKpZ8+55xjthAVLUrg3X10Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KHvTfFOl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KHvTfFOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2EC1C4CEE3;
	Thu, 15 May 2025 01:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747273637;
	bh=lybrXG7ggUT2+z/C/r3+kn9kbzJ+pLxpM1YRuM3E3tk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KHvTfFOlbgLsQK2Bh1QcUuw61MIWQNfDryGo4rvA3Rpf4dmi7r7w5J5uoA9QYjW1c
	 Gw8TnxQuWbSSP+xrRpKGR/q2Y6HxBF/a8XLbPqZKwdCA8ota48AE5Er682RvGQ09BJ
	 u2x6cIFvvR1hIwW9SOwp9NwdVEMBfVXfYdWxgwtTv0DFPlki/KjbK+lUIKZSu6nmcE
	 4/6dnCj4HGAQlJVY2YEwmIpprrI5AP6XCizOxeVzPY3tM1/YovLmAqdXQ1sweGORGb
	 sE7J8vBklVaG8zyeyGq6MAFHqGuIp+fep2eNfKOdlla9p/I2whGmAUrSypsjXjAb2S
	 Z9cfjmuErlYNg==
Date: Wed, 14 May 2025 18:47:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: John Garry <john.g.garry@oracle.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>
Subject: Re: [PATCH 1/6] generic/765: fix a few issues
Message-ID: <20250515014717.GL25700@frogsfrogsfrogs>
References: <20250514002915.13794-1-catherine.hoang@oracle.com>
 <20250514002915.13794-2-catherine.hoang@oracle.com>
 <52fc32f8-c518-434f-ae29-2e72238e7296@oracle.com>
 <20250514153811.GU25667@frogsfrogsfrogs>
 <D599CC99-C8C3-4BF9-908B-B115ACA565A4@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D599CC99-C8C3-4BF9-908B-B115ACA565A4@oracle.com>

On Wed, May 14, 2025 at 11:42:40PM +0000, Catherine Hoang wrote:
> > On May 14, 2025, at 8:38 AM, Darrick J. Wong <djwong@kernel.org> wrote:
> > 
> > On Wed, May 14, 2025 at 01:47:20PM +0100, John Garry wrote:
> >> On 14/05/2025 01:29, Catherine Hoang wrote:
> >>> From: "Darrick J. Wong" <djwong@kernel.org>
> >>> 
> >>> Fix a few bugs in the single block atomic writes test, such as requiring
> >>> directio, using page size for the ext4 max bsize, and making sure we check
> >>> the max atomic write size.
> >>> 
> >>> Cc: ritesh.list@gmail.com
> >>> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> >>> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> >>> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> >>> ---
> >>>  common/rc         | 2 +-
> >>>  tests/generic/765 | 4 ++--
> >>>  2 files changed, 3 insertions(+), 3 deletions(-)
> >>> 
> >>> diff --git a/common/rc b/common/rc
> >>> index 657772e7..bc8dabc5 100644
> >>> --- a/common/rc
> >>> +++ b/common/rc
> >>> @@ -2989,7 +2989,7 @@ _require_xfs_io_command()
> >>>   fi
> >>>   if [ "$param" == "-A" ]; then
> >>>   opts+=" -d"
> >>> - pwrite_opts+="-D -V 1 -b 4k"
> >>> + pwrite_opts+="-d -V 1 -b 4k"
> >> 
> >> according to the documentation for -b, 4096 is the default (so I don't think
> >> that we need to set it explicitly). But is that flag even relevant to
> >> pwritev2?
> > 
> > The documentation is wrong -- on XFS the default is the fs blocksize.
> > Everywhere else is 4k.
> > 
> >> And setting -d in pwrite_opts means DIO for the input file, right? I am not
> >> sure if that is required.
> > 
> > It's not required, I mistook where that "-d" goes -- -d as an argument
> > to xfs_io is necessary, but -d as an argument to the pwrite subcommand
> > is not.  It's also benign since we don't pass -i.
> > 
> > Curiously the version of this patch in my tree doesn't have the extra
> > -d... I wonder if I made that change and forgot to send it out.
> 
> Hmm, it might have been from an old patch on my branch
> that I forgot to update when I sent this out. Just to clarify,
> this should just be 
> 
> pwrite_opts+="-V 1 -b 4k”
> 
> right?

Yep.

--D

> > --D
> > 
> >>>   fi
> >>>   testio=`$XFS_IO_PROG -f $opts -c \
> >>>           "pwrite $pwrite_opts $param 0 4k" $testfile 2>&1`
> >>> diff --git a/tests/generic/765 b/tests/generic/765
> >>> index 9bab3b8a..8695a306 100755
> >>> --- a/tests/generic/765
> >>> +++ b/tests/generic/765
> >>> @@ -28,7 +28,7 @@ get_supported_bsize()
> >>>          ;;
> >>>      "ext4")
> >>>          min_bsize=1024
> >>> -        max_bsize=4096
> >>> +        max_bsize=$(_get_page_size)
> >> 
> >> looks ok
> >> 
> >>>          ;;
> >>>      *)
> >>>          _notrun "$FSTYP does not support atomic writes"
> >>> @@ -73,7 +73,7 @@ test_atomic_writes()
> >>>      # Check that atomic min/max = FS block size
> >>>      test $file_min_write -eq $bsize || \
> >>>          echo "atomic write min $file_min_write, should be fs block size $bsize"
> >>> -    test $file_min_write -eq $bsize || \
> >>> +    test $file_max_write -eq $bsize || \
> >> 
> >> looks ok
> >> 
> >>>          echo "atomic write max $file_max_write, should be fs block size $bsize"
> >>>      test $file_max_segments -eq 1 || \
> >>>          echo "atomic write max segments $file_max_segments, should be 1"
> >> 
> >> 
> >> Thanks,
> >> John
> 
> 
