Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26F819CD08
	for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2024 11:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731671683; cv=none; b=pqMvbuLLuCBbIge0wsu8ORdzH5VbUf/G24YlUsxm3I4ePjW5xnEUMzmfIgAGkYF1r5UEjpSgcxUfuPH35+LpIj6S08WWWZp66wAc4zwz+DyzyiVqaz0JG5EBWcCD5twPlr46WqK7zz7Ni0+rDL4qoF+O39TB5Ohj8K6RQxvD+Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731671683; c=relaxed/simple;
	bh=MvOdPp1ronZydSC8y25QvcapUdG38ZBA7fohyWadj7o=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C2YkwxCjs1z0eIjuytG4H1fhZmIaoEK1B6VuPVtoMRKiYmqrpwCK4ie9bYfUMFZ9l/M15lwJ5weSfO/1FBJJ19OpJ997IBW8JgavQVYM/y6b34HQfABBs92EG0BsishafQi1HJceZDuq1gLeQ5uMBUDOrmgKSasX3l4Xai54xd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Xqb4w6xXfz21lBq;
	Fri, 15 Nov 2024 19:53:20 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id B58D61A0188;
	Fri, 15 Nov 2024 19:54:37 +0800 (CST)
Received: from localhost (10.175.112.188) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 15 Nov
 2024 19:54:37 +0800
Date: Fri, 15 Nov 2024 19:53:17 +0800
From: Long Li <leo.lilong@huawei.com>
To: Brian Foster <bfoster@redhat.com>
CC: <brauner@kernel.org>, <djwong@kernel.org>, <cem@kernel.org>,
	<linux-xfs@vger.kernel.org>, <yi.zhang@huawei.com>, <houtao1@huawei.com>,
	<yangerkun@huawei.com>
Subject: Re: [PATCH v2 1/2] iomap: fix zero padding data issue in concurrent
 append writes
Message-ID: <Zzc2LcUqCPqMjjxr@localhost.localdomain>
References: <20241113091907.56937-1-leo.lilong@huawei.com>
 <ZzTQPdE5V155Soui@bfoster>
 <ZzVhsvyFQu01PnHl@localhost.localdomain>
 <ZzY7r1l5dpBw7UsY@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <ZzY7r1l5dpBw7UsY@bfoster>
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemf500017.china.huawei.com (7.185.36.126)

On Thu, Nov 14, 2024 at 01:04:31PM -0500, Brian Foster wrote:
> On Thu, Nov 14, 2024 at 10:34:26AM +0800, Long Li wrote:
> > On Wed, Nov 13, 2024 at 11:13:49AM -0500, Brian Foster wrote:
> > > FYI, you probably want to include linux-fsdevel on iomap patches.
> > > 
> > > On Wed, Nov 13, 2024 at 05:19:06PM +0800, Long Li wrote:
> > > > During concurrent append writes to XFS filesystem, zero padding data
> > > > may appear in the file after power failure. This happens due to imprecise
> > > > disk size updates when handling write completion.
> > > > 
> > > > Consider this scenario with concurrent append writes same file:
> > > > 
> > > >   Thread 1:                  Thread 2:
> > > >   ------------               -----------
> > > >   write [A, A+B]
> > > >   update inode size to A+B
> > > >   submit I/O [A, A+BS]
> > > >                              write [A+B, A+B+C]
> > > >                              update inode size to A+B+C
> > > >   <I/O completes, updates disk size to A+B+C>
> > > >   <power failure>
> > > > 
> > > > After reboot, file has zero padding in range [A+B, A+B+C]:
> > > > 
> > > >   |<         Block Size (BS)      >|
> > > >   |DDDDDDDDDDDDDDDD0000000000000000|
> > > >   ^               ^        ^
> > > >   A              A+B      A+B+C (EOF)
> > > > 
> > > 
> > > Thanks for the diagram. FWIW, I found the description a little confusing
> > > because A+B+C to me implies that we'd update i_size to the end of the
> > > write from thread 2, but it seems that is only true up to the end of the
> > > block.
> > > 
> > > I.e., with 4k FSB and if thread 1 writes [0, 2k], then thread 2 writes
> > > from [2, 16k], the write completion from the thread 1 write will set
> > > i_size to 4k, not 16k, right?
> > > 
> > 
> > Not right, the problem I'm trying to describe is:
> > 
> >   1) thread 1 writes [0, 2k]
> >   2) thread 2 writes [2k, 3k]
> >   3) write completion from the thread 1 write set i_size to 3K
> >   4) power failure
> >   5) after reboot,  [2k, 3K] of the file filled with zero and the file size is 3k
> >      
> 
> Yeah, I get the subblock case. What I am saying above is it seems like
> "update inode size to A+B+C" is only true for certain, select values
> that describe the subblock case. I.e., what is the resulting i_size if
> we replace C=1k in the example above with something >= FSB size, like
> C=4k?
> 
> Note this isn't all that important. I was just trying to say that the
> overly general description made this a little more confusing to grok at
> first than it needed to be, because to me it subtly implies there is
> logic around somewhere that explicitly writes in-core i_size to disk,
> when that is not actually what is happening.
> 
> > 

Sorry for my previous misunderstanding. You are correct - my commit
message description didn't cover the case where A+B+C > block size.
In such scenarios, the final file size might end up being 4K, which
is not what we would expect. Initially, I incorrectly thought this
wasn't a significant issue and thus overlooked this case. Let me
update the diagram to address this.

  Thread 1:                  Thread 2:
  ------------               -----------
  write [A, A+B]
  update inode size to A+B
  submit I/O [A, A+BS]
                             write [A+B, A+B+C]
                             update inode size to A+B+C
  <I/O completes, updates disk size to A+B+C>
  <power failure>

After reboot:
  1) The file has zero padding in the range [A+B, A+BS]
  2) The file size is unexpectedly set to A+BS

  |<         Block Size (BS)      >|<           Block Size (BS)    >|
  |DDDDDDDDDDDDDDDD0000000000000000|00000000000000000000000000000000|
  ^               ^                ^               ^
  A              A+B              A+BS (EOF)     A+B+C


It will be update in the next version.


Thanks,
Long Li
