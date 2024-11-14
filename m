Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6591AA7A5
	for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 20:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731614894; cv=none; b=VXEDrpJLf3i9zsw0/ZrW52HznPRxpcnzvn7eXt9OzVpHYv05wg1+ZS1PW/N4iASB0VrHPlVJf+ADCcoPGIob4ywQDU552aHdWUktdjM2atCLhtFRaP+vUXjS4t1aaJQL/GUmsWou9l6lqvoYha/enJKPI6rerDhNRvGQYDjF9ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731614894; c=relaxed/simple;
	bh=BNP6Erz1GZnIHdSIFkt5kahGRartdA7o1PMQyYbCMa8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LBH81mIphDbxllc+8VdzeGY/uT+CVhvh9fziTgQ3hFoNQwEIqutF2eeYHERqixydoQ4/9Du1wR+cKLL7wGKoQL8jHuPuZmwbXkr2ZAK3QJviIo/1FaqelwyYoXufRxwDBAzUycxjbuAZP2clNi/JLe6ihu9xo3ESa2+wivDkFdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h2q4Gdhf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h2q4Gdhf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731614891;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yOQfcgwhrW1JHcUt1mkxeR2HzNswqmadBnglMvkxsD4=;
	b=h2q4GdhfjwHy2zzZkkJg6UbLyO9gIpfLzxVmfBJR5fKE7Zq8beTzEj3gD5lAf9fMxjjjjy
	tU+NE+mdgJdaVq6vKNPcXXZ6DRYNKZjGo6eXpBvT+B7gIFgN5+/xbY3O2pH9ypd/xvnuNO
	pfZlESE4xNHixB1hG7m2LoEUTqR2D4g=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-63-tybY3d_8OZClyCFyv3CyhA-1; Thu,
 14 Nov 2024 15:08:06 -0500
X-MC-Unique: tybY3d_8OZClyCFyv3CyhA-1
X-Mimecast-MFC-AGG-ID: tybY3d_8OZClyCFyv3CyhA
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E3E2119560AB;
	Thu, 14 Nov 2024 20:08:01 +0000 (UTC)
Received: from rh (unknown [10.64.138.2])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A6BF61955F3E;
	Thu, 14 Nov 2024 20:08:00 +0000 (UTC)
Received: from localhost ([::1] helo=rh)
	by rh with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <dchinner@redhat.com>)
	id 1tBg8B-00000006in9-2XUs;
	Fri, 15 Nov 2024 07:07:55 +1100
Date: Fri, 15 Nov 2024 07:07:53 +1100
From: Dave Chinner <dchinner@redhat.com>
To: Long Li <leo.lilong@huawei.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	Ritesh Harjani <ritesh.list@gmail.com>, chandan.babu@oracle.com,
	djwong@kernel.org, hch@lst.de, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	catherine.hoang@oracle.com, martin.petersen@oracle.com
Subject: Re: [PATCH v4 00/14] forcealign for xfs
Message-ID: <ZzZYmTuSsHN-M0Of@rh>
References: <79e22c54-04bd-4b89-b20c-3f80a9f84f6b@oracle.com>
 <Ztom6uI0L4uEmDjT@dread.disaster.area>
 <ce87e4fb-ab5f-4218-aeb8-dd60c48c67cb@oracle.com>
 <Zt4qCLL6gBQ1kOFj@dread.disaster.area>
 <84b68068-e159-4e28-bf06-767ea7858d79@oracle.com>
 <ZufBMioqpwjSFul+@dread.disaster.area>
 <0e9dc6f8-df1b-48f3-a9e0-f5f5507d92c1@oracle.com>
 <ZuoCafOAVqSN6AIK@dread.disaster.area>
 <1394ceeb-ce8c-4d0f-aec8-ba93bf1afb90@oracle.com>
 <ZzXxlf6RWeX3e-3x@localhost.localdomain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZzXxlf6RWeX3e-3x@localhost.localdomain>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Thu, Nov 14, 2024 at 08:48:21PM +0800, Long Li wrote:
> On Wed, Sep 18, 2024 at 11:12:47AM +0100, John Garry wrote:
> > On 17/09/2024 23:27, Dave Chinner wrote:
> > > > # xfs_bmap -vvp  mnt/file
> > > > mnt/file:
> > > > EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
> > > >    0: [0..15]:         384..399          0 (384..399)          16 010000
> > > >    1: [16..31]:        400..415          0 (400..415)          16 000000
> > > >    2: [32..127]:       416..511          0 (416..511)          96 010000
> > > >    3: [128..255]:      256..383          0 (256..383)         128 000000
> > > > FLAG Values:
> > > >     0010000 Unwritten preallocated extent
> > > > 
> > > > Here we have unaligned extents wrt extsize.
> > > > 
> > > > The sub-alloc unit zeroing would solve that - is that what you would still
> > > > advocate (to solve that issue)?
> > > Yes, I thought that was already implemented for force-align with the
> > > DIO code via the extsize zero-around changes in the iomap code. Why
> > > isn't that zero-around code ensuring the correct extent layout here?
> > 
> > I just have not included the extsize zero-around changes here. They were
> > just grouped with the atomic writes support, as they were added specifically
> > for the atomic writes support. Indeed - to me at least - it is strange that
> > the DIO code changes are required for XFS forcealign implementation. And,
> > even if we use extsize zero-around changes for DIO path, what about buffered
> > IO?
> 
> 
> I've been reviewing and testing the XFS atomic write patch series. Since
> there haven't been any new responses to the previous discussions on this
> issue, I'd like to inquire about the buffered IO problem with force-aligned
> files, which is a scenario we might encounter.
> 
> Consider a case where the file supports force-alignment with a 64K extent size,
> and the system page size is 4K. Take the following commands as an example:
> 
> xfs_io  -c "pwrite 64k 64k" mnt/file
> xfs_io  -c "pwrite 8k 8k" mnt/file
> 
> If unaligned unwritten extents are not permitted, we need to zero out the
> sub-allocation units for ranges [0, 8K] and [16K, 64K] to prevent stale
> data. While this can be handled relatively easily in direct I/O scenarios,
> it presents significant challenges in buffered I/O operations. The main
> difficulty arises because the extent size (64K) is larger than the page
> size (4K), and our current code base has substantial limitations in handling
> such cases.
> 
> Any thoughts on this?

Large folios in the page cache solve this problem. i.e. it's the
same problem that block size > page size support had to solve.

-Dave.
-- 
Dave Chinner
dchinner@redhat.com

