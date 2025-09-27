Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501372BD5B4;
	Sat, 27 Sep 2025 07:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758958195; cv=none; b=Q+AF15oDSeuccLfKd8bJZBLZeq/Yt2/Wi02h3O5nCDqniRex4LXvbAPX8ar+hUxeKAQjVgtA7A+BBlW0f8Gj0r/xEdTzk/H9DDJcQhpG1nWdcJMierJCWUePI6Oh1QuEohRu/u7joOSmU3QYs0dYH11/UWTvVa/IxzCk/uVB8NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758958195; c=relaxed/simple;
	bh=i5j9A6ESg8DfRnWdVB3iU78jwZichx9L7FZuCUl1jvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ep0Rr4g8QxbLz5Q7rPXIKPs1/s3LfZgyGikLsdXHnwgc+P2q20E9iICVvYu93WIEjp3mMQpKNIn3Xh5DLdz35Ty7uNO+lPubnoB3XJ9+9VFUmrQDn7vp3RiLxBfVObnwJPzPkkH97MV3Cy7Uhb050CaQNU8inHnZVcLLy0kfG0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=apYzxSbs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="apYzxSbs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C38C4CEE7;
	Sat, 27 Sep 2025 07:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758958194;
	bh=i5j9A6ESg8DfRnWdVB3iU78jwZichx9L7FZuCUl1jvQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=apYzxSbsn9h3n5fLfTFxTtxCWavDhH66GQghHGt2OMBeHnbVZzbXTESAnxzazXKbV
	 0t2pDB/gvUK9hYjZEa8cCyUfEzbe7X8VFFalsy7pS06ZSOVcvHpcLbz3AtSUpHo7Q8
	 RUk9sMpYSh4Falzb8G6TrusN9BtAssIQYyElMZBuoRQZvyMzabVMUQfL9lhgNmCRhs
	 J0uyXH1S1nrwhSyPTMo7gyenQB6a/xbnNw50k51j2kGKWo8Fx7FLEXuYnierPQSvh9
	 uk5hz9tqrlQLFFv928aWS9uzWtfvPRTfhbveeRs6w3zXivBq1+4Tv/xkoOKHO9/Nhc
	 B7HiVGI+pDxzA==
Date: Sat, 27 Sep 2025 09:29:50 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs/513: remove attr2 and ikeep tests
Message-ID: <apyibmyaeixj7my7c36ljib3sqkmjvttnpfyderar6erhq6qhx@xdox3y22d4pr>
References: <20250925093005.198090-1-cem@kernel.org>
 <20250925093005.198090-2-cem@kernel.org>
 <U0YSQNAPJPxdjhRuMKtVrn5xeRxslOHWmqaK5CBJVb8e4kouZQJMwV5DuEzY7FXc_H284GanCX6ODMEH3OKxdg==@protonmail.internalid>
 <20250926153237.ahnp3bgdffsvz7qg@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926153237.ahnp3bgdffsvz7qg@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Fri, Sep 26, 2025 at 11:32:37PM +0800, Zorro Lang wrote:
> On Thu, Sep 25, 2025 at 11:29:24AM +0200, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> >
> > Linux kernel commit b9a176e54162 removes several deprecated options
>                       ^^^^^^^^^^^^
> 
> I think this's a commit id of xfs-linux, not mainline linux. Anyway,
> this patch makes sense to me.

Yes, because these patches are not in Linus's tree yet, I'll send them
on 6.18 merge window. I just thought it would make sense to send them to
fstests ASAP.


> 
> Reviewed-by: Zorro Lang <zlang@redhat.com>
> 
> 
> 
> > from XFS, causing this test to fail.
> >
> > Giving the options have been removed from Linux for good, just stop
> > testing these options here.
> >
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  tests/xfs/513     | 11 -----------
> >  tests/xfs/513.out |  7 -------
> >  2 files changed, 18 deletions(-)
> >
> > diff --git a/tests/xfs/513 b/tests/xfs/513
> > index d3be3ced68a1..7dbd2626d9e2 100755
> > --- a/tests/xfs/513
> > +++ b/tests/xfs/513
> > @@ -182,12 +182,6 @@ do_test "-o allocsize=1048576k" pass "allocsize=1048576k" "true"
> >  do_test "-o allocsize=$((dbsize / 2))" fail
> >  do_test "-o allocsize=2g" fail
> >
> > -# Test attr2
> > -do_mkfs -m crc=1
> > -do_test "" pass "attr2" "true"
> > -do_test "-o attr2" pass "attr2" "true"
> > -do_test "-o noattr2" fail
> > -
> >  # Test discard
> >  do_mkfs
> >  do_test "" pass "discard" "false"
> > @@ -205,11 +199,6 @@ do_test "-o sysvgroups" pass "grpid" "false"
> >  do_test "" pass "filestreams" "false"
> >  do_test "-o filestreams" pass "filestreams" "true"
> >
> > -# Test ikeep
> > -do_test "" pass "ikeep" "false"
> > -do_test "-o ikeep" pass "ikeep" "true"
> > -do_test "-o noikeep" pass "ikeep" "false"
> > -
> >  # Test inode32|inode64
> >  do_test "" pass "inode64" "true"
> >  do_test "-o inode32" pass "inode32" "true"
> > diff --git a/tests/xfs/513.out b/tests/xfs/513.out
> > index 39945907140b..127f1681f979 100644
> > --- a/tests/xfs/513.out
> > +++ b/tests/xfs/513.out
> > @@ -9,10 +9,6 @@ TEST: "-o allocsize=PAGESIZE" "pass" "allocsize=PAGESIZE" "true"
> >  TEST: "-o allocsize=1048576k" "pass" "allocsize=1048576k" "true"
> >  TEST: "-o allocsize=2048" "fail"
> >  TEST: "-o allocsize=2g" "fail"
> > -FORMAT: -m crc=1
> > -TEST: "" "pass" "attr2" "true"
> > -TEST: "-o attr2" "pass" "attr2" "true"
> > -TEST: "-o noattr2" "fail"
> >  FORMAT:
> >  TEST: "" "pass" "discard" "false"
> >  TEST: "-o discard" "pass" "discard" "true"
> > @@ -24,9 +20,6 @@ TEST: "-o nogrpid" "pass" "grpid" "false"
> >  TEST: "-o sysvgroups" "pass" "grpid" "false"
> >  TEST: "" "pass" "filestreams" "false"
> >  TEST: "-o filestreams" "pass" "filestreams" "true"
> > -TEST: "" "pass" "ikeep" "false"
> > -TEST: "-o ikeep" "pass" "ikeep" "true"
> > -TEST: "-o noikeep" "pass" "ikeep" "false"
> >  TEST: "" "pass" "inode64" "true"
> >  TEST: "-o inode32" "pass" "inode32" "true"
> >  TEST: "-o inode64" "pass" "inode64" "true"
> > --
> > 2.51.0
> >
> 
