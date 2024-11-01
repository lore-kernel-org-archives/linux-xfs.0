Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8068D1E5718;
	Fri,  1 Nov 2024 21:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730497767; cv=none; b=ZJYxylb0er/5LTKCTFyzqNiowc+C8mgUiS5oOLyvLyGXY0dWqegf3rqMnWTft+dXytrRtGfhCESKUJhGLLSwXVkI1QiKZgf4wpzatHUynTxS1iOl44IdNAeUJEtnuj9AykamJzig2jTUW3f6vIkahX1Mi/gYhtHbUecm9rKOekM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730497767; c=relaxed/simple;
	bh=gwDTACfE4vZ3t2HT0azgqvbCv5QVaoIa6ZpWNSBvOSw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qDLE/Yh6UdsrM2CXnbkIEGGjN2LT4ripO0qlVYET+vHNgLmPVajRGm6zYT+/MLPVugJxlNxJP/j1s687ZHUPTs5mXEnszOrQFy8F8mW7HTKMEjA4WdLbecvTUl1yJk2gfYnfUYSd6HLdVYyGC9wqPknag7QHxdpYW9EwzzoesHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EOt7L5mq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EOt7L5mq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5F4C4CECD;
	Fri,  1 Nov 2024 21:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730497767;
	bh=gwDTACfE4vZ3t2HT0azgqvbCv5QVaoIa6ZpWNSBvOSw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EOt7L5mqw6QvAT0TJurwG0OmGuSmUbFB+aJWV7O18+xqEN+3THrMbC4GpeW4JmVHl
	 zqK9Lwv5KQ+S65+ec4yIyEeMkqSYG8P56ze0JuyVj2jc8SMp1Q1PmGvG3n4qYnqS3S
	 V7MgB4qfiSh0+HaaXnNeVhjD8Bf5cicG4flo09gG+aRYUZ6/d5kYlLG5R5KACenCFQ
	 XvNW+C0eg1Aaa/so+zH3WoMlpVXoVMZk5Mg2OHYLuCrsg3fPdV0mn0hmXxyeJ7DihW
	 EN2AhjCIi4IdnCXeszSgroAQQc/U2c/M+8Y608hjp0NAYUi7tLbqj1hjvXq0sejo8J
	 9ku3EOiYBeHMA==
Date: Fri, 1 Nov 2024 14:49:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/157: mkfs does not need a specific fssize
Message-ID: <20241101214926.GW2578692@frogsfrogsfrogs>
References: <20241031193552.1171855-1-zlang@kernel.org>
 <20241031220821.GA2386201@frogsfrogsfrogs>
 <20241101054810.cu6zsjrxgfzdrnia@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241101054810.cu6zsjrxgfzdrnia@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Fri, Nov 01, 2024 at 01:48:10PM +0800, Zorro Lang wrote:
> On Thu, Oct 31, 2024 at 03:08:21PM -0700, Darrick J. Wong wrote:
> > On Fri, Nov 01, 2024 at 03:35:52AM +0800, Zorro Lang wrote:
> > > The xfs/157 doesn't need to do a "sized" mkfs, the image file is
> > > 500MiB, don't need to do _scratch_mkfs_sized with a 500MiB fssize
> > > argument, a general _scratch_mkfs is good enough.
> > > 
> > > Besides that, if we do:
> > > 
> > >   MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size
> > > 
> > > the _scratch_mkfs_sized trys to keep the $fs_size, when mkfs fails
> > > with incompatible $MKFS_OPTIONS options, likes this:
> > > 
> > >   ** mkfs failed with extra mkfs options added to "-L oldlabel -m rmapbt=1" by test 157 **
> > >   ** attempting to mkfs using only test 157 options: -d size=524288000 -b size=4096 **
> > > 
> > > But if we do:
> > > 
> > >   _scratch_mkfs -L oldlabel
> > > 
> > > the _scratch_mkfs trys to keep the "-L oldlabel", when mkfs fails
> > > with incompatible $MKFS_OPTIONS options, likes this:
> > > 
> > >   ** mkfs failed with extra mkfs options added to "-m rmapbt=1" by test 157 **
> > >   ** attempting to mkfs using only test 157 options: -L oldlabel **
> > > 
> > > that's actually what we need.
> > > 
> > > Signed-off-by: Zorro Lang <zlang@kernel.org>
> > > ---
> > > 
> > > This test started to fail since 2f7e1b8a6f09 ("xfs/157,xfs/547,xfs/548: switch to
> > > using _scratch_mkfs_sized") was merged.
> > > 
> > >   FSTYP         -- xfs (non-debug)
> > >   PLATFORM      -- Linux/x86_64
> > >   MKFS_OPTIONS  -- -f -m rmapbt=1 /dev/sda3
> > >   MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sda3 /mnt/scratch
> > > 
> > >   xfs/157 7s ... - output mismatch (see /root/git/xfstests/results//xfs/157.out.bad)
> > >       --- tests/xfs/157.out       2024-11-01 01:05:03.664543576 +0800
> > >       +++ /root/git/xfstests/results//xfs/157.out.bad     2024-11-01 02:56:47.994007900 +0800
> > >       @@ -6,10 +6,10 @@
> > >        label = "oldlabel"
> > >        label = "newlabel"
> > >        S3: Check that setting with rtdev works
> > >       -label = "oldlabel"
> > >       +label = ""
> > >        label = "newlabel"
> > >        S4: Check that setting with rtdev + logdev works
> > >       ...
> > >       (Run 'diff -u /root/git/xfstests/tests/xfs/157.out /root/git/xfstests/results//xfs/157.out.bad'  to see the entire diff)
> > >   Ran: xfs/157
> > >   Failures: xfs/157
> > >   Failed 1 of 1 tests
> > > 
> > > Before that change, the _scratch_mkfs can drop "rmapbt=1" option from $MKFS_OPTIONS,
> > > only keep the "-L label" option. That's why this test never failed before.
> > > 
> > > Now it fails on xfs, if MKFS_OPTIONS contains "-m rmapbt=1", the reason as I
> > > explained above.
> > > 
> > > Thanks,
> > > Zorro
> > > 
> > >  tests/xfs/157 | 3 +--
> > >  1 file changed, 1 insertion(+), 2 deletions(-)
> > > 
> > > diff --git a/tests/xfs/157 b/tests/xfs/157
> > > index 9b5badbae..459c6de7c 100755
> > > --- a/tests/xfs/157
> > > +++ b/tests/xfs/157
> > > @@ -66,8 +66,7 @@ scenario() {
> > >  }
> > >  
> > >  check_label() {
> > > -	MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size \
> > > -		>> $seqres.full
> > > +	_scratch_mkfs -L oldlabel >> $seqres.full 2>&1
> > 
> > Hans Holmberg discovered that this mkfs fails if the SCRATCH_RTDEV is
> > very large and SCRATCH_DEV is set to the 500M fake_datafile because the
> > rtbitmap is larger than the datadev.
> > 
> > I wonder if there's a way to pass the -L argument through in the
> > "attempting to mkfs using only" case?
> 
> As I know mkfs.xfs can disable rmapbt automatically if "-r rtdevt=xxx" is
> used.

That's not going to last forever, rmap support is coming for realtime,
hopefully for 6.14.

> How about unset the MKFS_OPTIONS for this test? As it already tests rtdev
> and logdev by itself. Or call _notrun if MKFS_OPTIONS has "rmapbt=1"?

That will exclude quite a few configurations.  Also, how many people
actually turn on rmapbt explicitly now?

> Any better idea?

I'm afraid not.  Maybe I should restructure the test to force the rt
device to be 500MB even when we're not using the fake rtdev?

--D

> Thanks,
> Zorro
> 
> > 
> > --D
> > 
> > >  	_scratch_xfs_db -c label
> > >  	_scratch_xfs_admin -L newlabel "$@" >> $seqres.full
> > >  	_scratch_xfs_db -c label
> > > -- 
> > > 2.45.2
> > > 
> > > 
> > 
> 
