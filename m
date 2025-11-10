Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC142F49E9
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 21:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762809161; cv=none; b=dRWOM26ii8wzfeprbRY+ZsEolIv0otGak/uQuIAt3oozwoP0K0c/UtBcqTMRz8Lr5fNcT4X8f6G2eXtbZ8RwQXpq+YDo3eDLC009Nu+fmdKOO4qU/A+LvwayaXHyt2kz5zS5MEKcsQBdmV4LRmVE2rnP2RNYKm6cs0LPyCuUkvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762809161; c=relaxed/simple;
	bh=ascmBzq8IgInsm94aE6YfSKrZSFl5nPTKrwchtTUmws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QuvkOXz+36eM3urMOc/1fRQPlN/gtPRiXyvH9tzY/jx2Tfz5JN7P8L98+6BAlzVNgr+5ADRgQMT19swCHL4Xdtss4FHkYu+u8tpypWWzboyFWBnCfWxfkN87gVAyUCfLqE3HmUd6P7kezd0upmXAvWUvC8p5RE4iNfNckjx7Z5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XOeU8nzq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XOeU8nzq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5098C4CEF5;
	Mon, 10 Nov 2025 21:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762809160;
	bh=ascmBzq8IgInsm94aE6YfSKrZSFl5nPTKrwchtTUmws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XOeU8nzq4X2B25F1kvKNVT1w7N1eYwy3ojUNJFJCUwcV22vluunw/4AFjUn/k3nAe
	 hJyvK7YZH9qbN7MATA3w0ZQ++jGiTQPZ0B5q5WZAYHLQFMxVfTRMd8hxS2MACob1aw
	 FinpddAFeXg7SoRWaE7ic0iEV1RRGXGFc1Crhz1Q1WEvJZkTGJtKaPHuKcUcle40hV
	 Xr3DsJeSziXD99NM8jzbyoLR0jcYlpFwPB8wdYSrIim6j65ggHYYuL3b82V6eFuKrt
	 1JKGQAvHzHY3eRIzW9bFgW8egLuKbvWbVhCvVKE9D+FLc7apT+ZfUSqcd5NN41M3+c
	 EGvXP3H9H+VEQ==
Date: Mon, 10 Nov 2025 13:12:40 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	John Garry <john.g.garry@oracle.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [WARNING: UNSCANNABLE EXTRACTION FAILED]Re: [bug report] fstests
 generic/774 hang
Message-ID: <20251110211240.GX196370@frogsfrogsfrogs>
References: <cmk52aqexackyz65phxgme55a3tdrermo3o4skr4lo4pwvvvcp@jmcblnfikbp2>
 <20251105003315.GZ196370@frogsfrogsfrogs>
 <mx6gzhhkvcdnadmmxziu77cuywq4ql5u2hp6fd673vorhx35pz@jmyv74f236ka>
 <c5cff4c3-cf0a-47cc-9ae5-20d7316b3c09@oracle.com>
 <2c4d144b-81fd-4e4c-90a8-fd3c2082246c@oracle.com>
 <6xn2324slfvddlzwydjxigijdfu7gbpzk77iumjiubolirqzd3@fbuqjbbirtc4>
 <coeibafpki7dasbxwom36kwjpfiv4urshmderxovgyuefx22pv@jiyp3ll44kyr>
 <aRCC5lFFkWuL0Lph@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <gefhyxokf7l2kbwy4fazphvh3dlodztngje7r4n76zmvylpgri@kca45isrne2e>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gefhyxokf7l2kbwy4fazphvh3dlodztngje7r4n76zmvylpgri@kca45isrne2e>

On Mon, Nov 10, 2025 at 12:46:19PM +0000, Shinichiro Kawasaki wrote:
> On Nov 09, 2025 / 17:32, Ojaswin Mujoo wrote:
> > On Thu, Nov 06, 2025 at 08:19:12AM +0000, Shinichiro Kawasaki wrote:
> [...]
> > > I tried the other "atomicwrites" test. I found g778 took very long time.
> > > I think it implies that g778 may have similar problem as g774.
> > > 
> > >   g765: [not run] write atomic not supported by this block device
> > >   g767: 11s
> > >   g768: 13s
> > >   g769: 13s
> > >   g770: 35s
> > >   g773: [not run] write atomic not supported by this block device
> > >   g774: did not completed after 3 hours run (and kernel reported the INFO messages)
> > >   g775: 48s
> > >   g776: [not run] write atomic not supported by this block device
> > >   g778: did not completed after 50 minutes run
> > 
> > Hi Shinichiro
> > 
> > Hmm that's strange, g/778 should tune itself to the speed of the device
> > ideally. Will you be able to share the results/generic/778.full file.
> > That might give some hints.
> 
> Please find the attached 778.full.gz, which I copied about 50 minutes after
> the test case start. The test case was still running at that time. Near the end
> of the full file, I find "Iteration 13". It looks like the test case is not
> hanging, but just taking long time to complete the 20 iterations.

<nod> 778 invokes xfs_io and fallocate a few tens of thousands of times,
which makes the test runtime really slow if fork/exec() aren't fast.  I
try to fix that here:

https://lore.kernel.org/fstests/176279908967.605950.2192923313361120314.stgit@frogsfrogsfrogs/T/#t

As well as reducing the test file size for 774, per everyone's comments.

--D
