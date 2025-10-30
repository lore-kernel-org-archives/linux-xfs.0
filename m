Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A4C128819;
	Thu, 30 Oct 2025 16:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761842040; cv=none; b=XDhjWckip/oUsP8ZvSembVYqha5m0pZnWvj4JHkqsKNG9Bm7La/OvaY5yzngdLo3JCZJdrHl3DwcfYC4F+TruBECx4lf/kEXrcyciLMfRWB4QwpPRDZBaJen5Vwo5CdI+0d1ipMwvDoW3A7nYpoFENjVTw5zYQBiKq3yrFJ0/7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761842040; c=relaxed/simple;
	bh=B1Ong3CGomALkVypuyJKZOkLdF1a05mBKw1ZbjoLGEU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fxfZNYTBOgvZ2ZJi0FyadwVtgqR75KTxK+OhKszo3WIHfuOregT123M8y0V+lKowyx6zA5MN46ysXPwBLWLiy4VXb9xXkLKIaumT6HjesSWDRsqbX0+MqBP7cnTBhsPg7Uhz7hF39ZeCDeIceVvlTj70iHF2oxKEaolNSjaBlic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iKtUa3xu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iKtUa3xu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB07C4CEF1;
	Thu, 30 Oct 2025 16:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761842039;
	bh=B1Ong3CGomALkVypuyJKZOkLdF1a05mBKw1ZbjoLGEU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iKtUa3xun6kPoZHhPqP6P3NF5VPqVO+Rdo7o+YZyaTibD24ySoKOTo2xIJyCK5hyk
	 Je8EtFwJHKxicMpJ86oeoSzkW3wZFeKexKpjMqKCNkSWwRjmvvORiktXhr6BQE9VXl
	 h0FmpCXKzsp6bh3HsLxeBpwj0HtKRXuUlI74KuYF/fmnreWHBD/DLsrQaw4UekZl10
	 YNb6drTG9rjyKYU+VA6PF8+PaWtX0u2uJ0j4Tw+mA6AUofbcBVED63pE4qrsCuvKgX
	 Ilci4i9um7eEn7bXaa1uHML/SceuI5xZ8B2UR4GQAuM7odRPzORYjhfcBtdGaYwrjT
	 ONL3XSvBeBdIg==
Date: Thu, 30 Oct 2025 09:33:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] generic/772: actually check for file_getattr special
 file support
Message-ID: <20251030163359.GM3356773@frogsfrogsfrogs>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054617988.2391029.18130416327249525205.stgit@frogsfrogsfrogs>
 <68e2839c0a7848a95fa5b2b8f6107b1e941636a4.camel@gmail.com>
 <20251024221047.GU6178@frogsfrogsfrogs>
 <29bde62f-344e-4f5e-bfa7-43daaa8d5c49@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29bde62f-344e-4f5e-bfa7-43daaa8d5c49@gmail.com>

On Thu, Oct 30, 2025 at 11:35:33AM +0530, Nirjhar Roy (IBM) wrote:
> 
> On 10/25/25 03:40, Darrick J. Wong wrote:
> > On Fri, Oct 24, 2025 at 01:14:29PM +0530, Nirjhar Roy (IBM) wrote:
> > > On Wed, 2025-10-15 at 09:38 -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > On XFS in 6.17, this test fails with:
> > > > 
> > > >   --- /run/fstests/bin/tests/generic/772.out	2025-10-06 08:27:10.834318149 -0700
> > > >   +++ /var/tmp/fstests/generic/772.out.bad	2025-10-08 18:00:34.713388178 -0700
> > > >   @@ -9,29 +9,34 @@ Can not get fsxattr on ./foo: Invalid ar
> > > >    Can not set fsxattr on ./foo: Invalid argument
> > > >    Initial attributes state
> > > >    ----------------- SCRATCH_MNT/prj
> > > >   ------------------ ./fifo
> > > >   ------------------ ./chardev
> > > >   ------------------ ./blockdev
> > > >   ------------------ ./socket
> > > >   ------------------ ./foo
> > > >   ------------------ ./symlink
> > > >   +Can not get fsxattr on ./fifo: Inappropriate ioctl for device
> > > >   +Can not get fsxattr on ./chardev: Inappropriate ioctl for device
> > > >   +Can not get fsxattr on ./blockdev: Inappropriate ioctl for device
> > > >   +Can not get fsxattr on ./socket: Inappropriate ioctl for device
> > > > 
> > > > This is a result of XFS' file_getattr implementation rejecting special
> > > > files prior to 6.18.  Therefore, skip this new test on old kernels.
> > > > 
> > > > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > > > ---
> > > >   tests/generic/772 |    3 +++
> > > >   tests/xfs/648     |    3 +++
> > > >   2 files changed, 6 insertions(+)
> > > > 
> > > > 
> > > > diff --git a/tests/generic/772 b/tests/generic/772
> > > > index cc1a1bb5bf655c..e68a6724654450 100755
> > > > --- a/tests/generic/772
> > > > +++ b/tests/generic/772
> > > > @@ -43,6 +43,9 @@ touch $projectdir/bar
> > > >   ln -s $projectdir/bar $projectdir/broken-symlink
> > > >   rm -f $projectdir/bar
> > > > +file_attr --get $projectdir ./fifo &>/dev/null || \
> > > > +	_notrun "file_getattr not supported on $FSTYP"
> > > > +
> > > Shouldn't we use $here/src/file_attr like we have done later (maybe just for consistency)?
> > Probably, but this test has (for now) a wrapper so I used that.
> 
> Sorry, which wrapper are you referring to?

Look about 10 lines up, there's a file_attr() function that calls
$here/src/file_attr "$@"

--D

> > 
> > > Also, I am wondering if we can have something like
> > > _require_get_attr_for_special_files() helper kind of a thing?
> > Andrey's working on that.
> 
> Okay, thanks.
> 
> --NR
> 
> > 
> > --D
> > 
> > > --NR
> > > >   echo "Error codes"
> > > >   # wrong AT_ flags
> > > >   file_attr --get --invalid-at $projectdir ./foo
> > > > diff --git a/tests/xfs/648 b/tests/xfs/648
> > > > index 215c809887b609..e3c2fbe00b666a 100755
> > > > --- a/tests/xfs/648
> > > > +++ b/tests/xfs/648
> > > > @@ -47,6 +47,9 @@ touch $projectdir/bar
> > > >   ln -s $projectdir/bar $projectdir/broken-symlink
> > > >   rm -f $projectdir/bar
> > > > +$here/src/file_attr --get $projectdir ./fifo &>/dev/null || \
> > > > +	_notrun "file_getattr not supported on $FSTYP"
> > > > +
> > > >   $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> > > >   	-c "project -sp $projectdir $id" $SCRATCH_DEV | filter_quota
> > > >   $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> > > > 
> > > 
> -- 
> Nirjhar Roy
> Linux Kernel Developer
> IBM, Bangalore
> 
> 
