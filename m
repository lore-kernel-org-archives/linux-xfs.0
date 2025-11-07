Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A918F1E5205
	for <linux-xfs@vger.kernel.org>; Fri,  7 Nov 2025 04:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762489721; cv=none; b=afDHm76eAEUQ3l/J4sO2X+DeWogUode41vy6yLs1/2sQO55FS2tWmxE7TJb5NFQUTsz2tI+Vi+WkJafzheKc0I6tOv4MTWWF8qr0/SQyo4Z5W11KaVqWxquqVoB/23IS5q3EFoCBjZrze2WUpulPjUiw+loj94FDN6VvlE9Sm/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762489721; c=relaxed/simple;
	bh=h3W+ShA2I3yzyfcrKmghF+IURXIwrO0AWOmWrPv0elI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aLP3MASy5s9HIhGrWHCdCVC7NfJyl5GIBxYBrtwLr4vt64OYGD7LjNaBzaelh40KI8A+qKTQAWQrUq9ZmENxBivLuvZKuSrv5vHUVLWoe4YeDZSZGdMpczrURkMcbtOMbgfcSnQzdnm7pRtikv41lriM1rxq4ddcZxS9M4NPDHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S3tli5VC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S3tli5VC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E030C4CEF5;
	Fri,  7 Nov 2025 04:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762489721;
	bh=h3W+ShA2I3yzyfcrKmghF+IURXIwrO0AWOmWrPv0elI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S3tli5VC68I1xdQoXdhOQ0JIIKzOnK7pdtUKWsWKb8xUSB68F/BvIB9hcBMM1THEC
	 6CgMFIgb8Zg4k8F4PNCbJcDXAAJTaavuq3u5G5aoKUMYtgLbc/FQ5BbA1qsohQQS+m
	 7idDWpUvY84Ai7w97RY0PdepSuc9VRcUrYX8GY6LcklxgxNq5MZMxBGCOfiLqJRVrh
	 ohgiU25btkMYrcRFQxKmhyjAcYjfl9vF+fzoX4PQSLJubUDl05mLPjFiK9aK0GQ8uT
	 5DNu6k++Oo9CqGUiM6hNqR5asI9xKUgnA46sgTTPRCHEHsW5xN8rGTxjpJzNRo2kya
	 Kd+b0ZgrU5abw==
Date: Thu, 6 Nov 2025 20:28:40 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: John Garry <john.g.garry@oracle.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"ojaswin@linux.ibm.com" <ojaswin@linux.ibm.com>
Subject: Re: [bug report] fstests generic/774 hang
Message-ID: <20251107042840.GK196370@frogsfrogsfrogs>
References: <cmk52aqexackyz65phxgme55a3tdrermo3o4skr4lo4pwvvvcp@jmcblnfikbp2>
 <20251105003315.GZ196370@frogsfrogsfrogs>
 <mx6gzhhkvcdnadmmxziu77cuywq4ql5u2hp6fd673vorhx35pz@jmyv74f236ka>
 <c5cff4c3-cf0a-47cc-9ae5-20d7316b3c09@oracle.com>
 <2c4d144b-81fd-4e4c-90a8-fd3c2082246c@oracle.com>
 <6xn2324slfvddlzwydjxigijdfu7gbpzk77iumjiubolirqzd3@fbuqjbbirtc4>
 <coeibafpki7dasbxwom36kwjpfiv4urshmderxovgyuefx22pv@jiyp3ll44kyr>
 <c690eebb-ad51-4fc4-b542-58d0a9265115@oracle.com>
 <cc5yndgo6enxwtnwvcc26wdoxg3wdnnzie6lvn2mttrzkeez24@6sk5qlhlrozp>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc5yndgo6enxwtnwvcc26wdoxg3wdnnzie6lvn2mttrzkeez24@6sk5qlhlrozp>

On Fri, Nov 07, 2025 at 02:27:50AM +0000, Shinichiro Kawasaki wrote:
> On Nov 06, 2025 / 08:53, John Garry wrote:
> > > > > > 
> > > > > > Shinichiro, do the other atomic writes tests run ok, like 775, 767? You
> > > > > > can check group "atomicwrites" to know which tests they are.
> > > > > > 
> > > > > > 774 is the fio test.
> > > 
> > > I tried the other "atomicwrites" test. I found g778 took very long time.
> > > I think it implies that g778 may have similar problem as g774.
> > > 
> > >    g765: [not run] write atomic not supported by this block device
> > >    g767: 11s
> > >    g768: 13s
> > >    g769: 13s
> > >    g770: 35s
> > >    g773: [not run] write atomic not supported by this block device
> > >    g774: did not completed after 3 hours run (and kernel reported the INFO messages)
> > >    g775: 48s
> > >    g776: [not run] write atomic not supported by this block device
> > >    g778: did not completed after 50 minutes run
> > >    x838: [not run] External volumes not in use, skipped this test
> > >    x839: [not run] XFS error injection requires CONFIG_XFS_DEBUG
> > >    x840: [not run] write atomic not supported by this block device
> > 
> > This is testing software-based atomic writes, and they are just slow. Very
> > slow, relative to HW-based atomic writes. And having bs=1M will make things
> > worse, as we are locking out other threads for longer (when doing the
> > write).
> 
> I see, thanks for the explanation.
> 
> > So I think that we should limit the file size which we try to write.
> 
> This sounds reasonable, and it will make fstests run maintenance work easier.
> 
> > 
> > > 
> > > > > > 
> > > > > > Some things to try:
> > > > > > - use a physical disk for the TEST_DEV
> > > 
> > > I tried using a real HDD for TEST_DEV, but still observed the hang and INFO
> > > messages at g774.
> > > 
> > > > > > - Don't set LOAD_FACTOR (if you were setting it). If not, bodge 774 to
> > > > > > reduce $threads to a low value, say, 2
> > > 
> > > I do not set LOAD_FACTOR. I changed g775 script to set threads=2, then the
> > > test case completed quickly, within a few minutes. I'm suspecting that this
> > > short test time might hide the hang/INFO problem.
> > > 
> > > > > > - trying turning on XFS_DEBUG config
> > > 
> > > I turned on XFS_DEBUG, and still observed the hang and the INFO messages.
> > > 
> > 
> > I don't think that this will help.
> > 
> > > > > > 
> > > > > > BTW, Darrick has posted some xfs atomics fixes @ https://urldefense.com/
> > > > > > v3/__https://urldefense.com/v3/__https://lore.kernel.org/linux-__;!!ACWV5N9M2RV99hQ!J3HKTWLF8Qx-j42OOJ4o1YAttSSoqOCm9ymJtisUYoOtGgOyNNGqHnjjl1Zd9DQXJvCz8zqPMG-kgeVdo9MQuupMlcAo$
> > > > > > xfs/20251105001200.GV196370@frogsfrogsfrogs/T/*t__;Iw!!ACWV5N9M2RV99hQ! IuEPY6yJ1ZEQu7dpfjUplkPJucOHMQ9cpPvIC4fiJhTi_X_7ImN0t6wGqxg9_GM6gWe4B1OBiBjEI8Gz_At0595tIQ$
> > > > > > . I doubt that they will help this, but worth trying.
> > > 
> > > I have not yet tried this. Will try it tomorrow.
> > 
> > Nor this.
> 
> I confirmed it. I applied the patches to v6.18-rc4 kernel. With this kernel, the
> hang and the INFO messages are recreated.
> 
> > 
> > Having a hang - even for the conditions set - should not produce a hang. I
> > can check on whether we can improve the software-based atomic writes in xfs
> > to avoid this.
> 
> Thanks. Will sysrq-t output help? If it helps, I can take it from the hanging
> test node and share.

Yes, anything you can share would be helpful.  FWIW the test runs in 51
seconds here, but I only have 4 CPUs in the VM and fast storage so its
filesize is "only" 800MB.

--D
