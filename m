Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0821938DD6;
	Tue,  5 Nov 2024 15:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730821633; cv=none; b=mbfaGwTl4MDswF5j4YmCuyi8Ql3OPF7yddGr18oaVjrNjoElQ8JqSp9x6++l5wwDuQ+/RwlSkVvHJQAzPAz9T0wxjWnca6fpRDM9WVF3rK4RlSm2jCz1oEp+ysUAYONZ31iFS5RULJD4EyY+SoeQ/+7kxEUQ94XBTIHBKFLyc0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730821633; c=relaxed/simple;
	bh=MbfMqicoVND210xPefvKj4Or8axemSXVpn10XDx9OfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XOmqAZB1lSAzitfzM0l86zHMFIjjxkqweuxNT8u+U1fvt5o08xvPlCUxz1pkXUmM4F4KnX5kg2AMuC9MqHIeCDLKuvwp4eHRoI6Dms7hh0Bskcd208Kn2Wm7/uV9JLtCo0CKWt9RMfnQKH5yjO0Dx3v7qa5ZIv+UUV2GCMBkOGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CHMaHPdN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CHMaHPdN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCDACC4CECF;
	Tue,  5 Nov 2024 15:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730821632;
	bh=MbfMqicoVND210xPefvKj4Or8axemSXVpn10XDx9OfA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CHMaHPdN7NPUzkurYtysNrgPNp0XvNUGV1mwOtSn40mQdzpWxf3A6qQ7HCiel++4H
	 ITklxCdMzZP/OG1jTSX2Qe/bE1ta3YiusttoqFQ8/L16XhGteYMmX4U1GXWJBrYD+U
	 ri/nVMDnctyCP1iVeWYyaP69+uzmEez+4zTZSLfIWMV9rcWYRk8OK4plIVC8+tFll2
	 AetuQCCtfeuuuhTYhl5siA47WYSO8dhfPpTZ/aLhD65h3Qu2NI4dtwE23YMzZG70Us
	 IQhwVbWSsWCEfQdrEvMDnwtdk7SyBDFCk7dRnFtJx5l0+5pABZVcd/gTkZvJnGcu7J
	 hn9mv7pIUdtaw==
Date: Tue, 5 Nov 2024 07:47:12 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Zorro Lang <zlang@redhat.com>,
	Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/157: mkfs does not need a specific fssize
Message-ID: <20241105154712.GJ2386201@frogsfrogsfrogs>
References: <20241031193552.1171855-1-zlang@kernel.org>
 <20241031220821.GA2386201@frogsfrogsfrogs>
 <20241101054810.cu6zsjrxgfzdrnia@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241101214926.GW2578692@frogsfrogsfrogs>
 <Zyh8yP-FJUHKt2fK@infradead.org>
 <20241104130437.mutcy5mqzcqrbqf2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241104233426.GW21840@frogsfrogsfrogs>
 <ZynB+0hF1Bo6p0Df@dread.disaster.area>
 <Zyozgri3aa5DoAEN@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zyozgri3aa5DoAEN@infradead.org>

On Tue, Nov 05, 2024 at 07:02:26AM -0800, Christoph Hellwig wrote:
> On Tue, Nov 05, 2024 at 05:58:03PM +1100, Dave Chinner wrote:
> > When the two conflict, _scratch_mkfs drops the global MKFS_OPTIONS
> > and uses only the local parameters so the filesystem is set up with
> > the configuration the test expects.
> > 
> > In this case, MKFS_OPTIONS="-m rmapbt=1" which conflicts with the
> > local RTDEV/USE_EXTERNAL test setup. Because the test icurrently
> > overloads the global MKFS_OPTIONS with local test options, the local
> > test parameters are dropped along with the global paramters when
> > there is a conflict. Hence the mkfs_scratch call fails to set the
> > filesystem up the way the test expects.
> 
> But the rmapbt can be default on, in which case it does not get
> removed.  And then without the _sized we'll run into the problem that
> Hans' patches fixed once again.

Well we /could/ make _scratch_mkfs_sized pass options through to the
underlying _scratch_mkfs.

--D
