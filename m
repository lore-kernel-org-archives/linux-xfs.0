Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB5FE57D
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 01:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731980243; cv=none; b=LH2wUHCOF5Ep+bE4PL8SSu4fTOl8GkFMOhxlRmd9pBAB6RheHENWVGPzLgi7hNXcYSQpE/37+ssL+oSFyNaeiHYzkMf+bI5JSClXPlSjiXLpQscDVdXXr+RJSrrUI2jGsKKGBS7D5IhpMiRGPZLEMU5t9mWuXubcYU4rBm3vhw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731980243; c=relaxed/simple;
	bh=8ifwJz8D0JzPJr2S84obVi+LZkspH6QRYBsG5ZYUM1M=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IFRkaEKLPSDP4j7N35p9AWe7JlDXPYExMO8Gcd/USU7Anf1Eq1u8gjDONaRYE09cFraegYT2zfZYhfIaFOusVInf14iKAQ6+MnhAkp1N/YmDh6mDPms9hCi7R4zaB/4yIkW/MagRmwe4LrFzx3/ye8A+NOG1wJ7/jGV6FKQ+jd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Xsn9p13g7z10W9J;
	Tue, 19 Nov 2024 09:35:10 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 8BDD1180064;
	Tue, 19 Nov 2024 09:37:10 +0800 (CST)
Received: from localhost (10.175.112.188) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 19 Nov
 2024 09:37:10 +0800
Date: Tue, 19 Nov 2024 09:35:38 +0800
From: Long Li <leo.lilong@huawei.com>
To: Brian Foster <bfoster@redhat.com>
CC: <brauner@kernel.org>, <djwong@kernel.org>, <cem@kernel.org>,
	<linux-xfs@vger.kernel.org>, <yi.zhang@huawei.com>, <houtao1@huawei.com>,
	<yangerkun@huawei.com>
Subject: Re: [PATCH v2 1/2] iomap: fix zero padding data issue in concurrent
 append writes
Message-ID: <ZzvratqVo-ll6NOY@localhost.localdomain>
References: <20241113091907.56937-1-leo.lilong@huawei.com>
 <ZzTQPdE5V155Soui@bfoster>
 <ZzVhsvyFQu01PnHl@localhost.localdomain>
 <ZzY7r1l5dpBw7UsY@bfoster>
 <Zzc2LcUqCPqMjjxr@localhost.localdomain>
 <ZzdQpXyVNHaT7MGv@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <ZzdQpXyVNHaT7MGv@bfoster>
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemf500017.china.huawei.com (7.185.36.126)

On Fri, Nov 15, 2024 at 08:46:13AM -0500, Brian Foster wrote:
> On Fri, Nov 15, 2024 at 07:53:17PM +0800, Long Li wrote:
> > On Thu, Nov 14, 2024 at 01:04:31PM -0500, Brian Foster wrote:
> > > On Thu, Nov 14, 2024 at 10:34:26AM +0800, Long Li wrote:
> > > > On Wed, Nov 13, 2024 at 11:13:49AM -0500, Brian Foster wrote:
> > > > > FYI, you probably want to include linux-fsdevel on iomap patches.
> > > > > 
> > > > > On Wed, Nov 13, 2024 at 05:19:06PM +0800, Long Li wrote:
> > > > > > During concurrent append writes to XFS filesystem, zero padding data
> > > > > > may appear in the file after power failure. This happens due to imprecise
> > > > > > disk size updates when handling write completion.
> > > > > > 
> > > > > > Consider this scenario with concurrent append writes same file:
> > > > > > 
> > > > > >   Thread 1:                  Thread 2:
> > > > > >   ------------               -----------
> > > > > >   write [A, A+B]
> > > > > >   update inode size to A+B
> > > > > >   submit I/O [A, A+BS]
> > > > > >                              write [A+B, A+B+C]
> > > > > >                              update inode size to A+B+C
> > > > > >   <I/O completes, updates disk size to A+B+C>
> > > > > >   <power failure>
> > > > > > 
> > > > > > After reboot, file has zero padding in range [A+B, A+B+C]:
> > > > > > 
> > > > > >   |<         Block Size (BS)      >|
> > > > > >   |DDDDDDDDDDDDDDDD0000000000000000|
> > > > > >   ^               ^        ^
> > > > > >   A              A+B      A+B+C (EOF)
> > > > > > 
> > > > > 
> > > > > Thanks for the diagram. FWIW, I found the description a little confusing
> > > > > because A+B+C to me implies that we'd update i_size to the end of the
> > > > > write from thread 2, but it seems that is only true up to the end of the
> > > > > block.
> > > > > 
> > > > > I.e., with 4k FSB and if thread 1 writes [0, 2k], then thread 2 writes
> > > > > from [2, 16k], the write completion from the thread 1 write will set
> > > > > i_size to 4k, not 16k, right?
> > > > > 
> > > > 
> > > > Not right, the problem I'm trying to describe is:
> > > > 
> > > >   1) thread 1 writes [0, 2k]
> > > >   2) thread 2 writes [2k, 3k]
> > > >   3) write completion from the thread 1 write set i_size to 3K
> > > >   4) power failure
> > > >   5) after reboot,  [2k, 3K] of the file filled with zero and the file size is 3k
> > > >      
> > > 
> > > Yeah, I get the subblock case. What I am saying above is it seems like
> > > "update inode size to A+B+C" is only true for certain, select values
> > > that describe the subblock case. I.e., what is the resulting i_size if
> > > we replace C=1k in the example above with something >= FSB size, like
> > > C=4k?
> > > 
> > > Note this isn't all that important. I was just trying to say that the
> > > overly general description made this a little more confusing to grok at
> > > first than it needed to be, because to me it subtly implies there is
> > > logic around somewhere that explicitly writes in-core i_size to disk,
> > > when that is not actually what is happening.
> > > 
> > > > 
> > 
> > Sorry for my previous misunderstanding. You are correct - my commit
> > message description didn't cover the case where A+B+C > block size.
> > In such scenarios, the final file size might end up being 4K, which
> > is not what we would expect. Initially, I incorrectly thought this
> > wasn't a significant issue and thus overlooked this case. Let me
> > update the diagram to address this.
> > 
> 
> Ok no problem.. like I said, just a minor nit. ;)
> 
> >   Thread 1:                  Thread 2:
> >   ------------               -----------
> >   write [A, A+B]
> >   update inode size to A+B
> >   submit I/O [A, A+BS]
> >                              write [A+B, A+B+C]
> >                              update inode size to A+B+C
> >   <I/O completes, updates disk size to A+B+C>
> >   <power failure>
> > 
> > After reboot:
> >   1) The file has zero padding in the range [A+B, A+BS]
> >   2) The file size is unexpectedly set to A+BS
> > 
> >   |<         Block Size (BS)      >|<           Block Size (BS)    >|
> >   |DDDDDDDDDDDDDDDD0000000000000000|00000000000000000000000000000000|
> >   ^               ^                ^               ^
> >   A              A+B              A+BS (EOF)     A+B+C
> > 
> > 
> > It will be update in the next version.
> > 
> 
> The text above still says "updates disk size to A+B+C." I'm not sure if
> you intended to change that to A+BS as well, but regardless LGTM.
> Thanks.
> 

Yes, forgot to update here.

Thanks,
Long Li
