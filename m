Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9A120F3D1
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 19:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729884716; cv=none; b=WBf3kkWQHK00Uo7T22LmXZT8a2PKP7MqYiRDTkm1V+bbAA8c4lR82fpdmUpqcTpj3UaEdbEq9ErX0PtEcUwQ0jwUCkRWWZPWoCMsd/oW6MKlwCycBuOoliU2vGM1FM+S0ImZT3rya9Vr6u6g27p9lYgQ/6xPhFV/K0ZpwkOOO6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729884716; c=relaxed/simple;
	bh=jV4nRszg71/Fn0WWoctbBSbMapG7XOFuFMNEFvVonG0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p6thmQ9ZhB9HXq1phc4YrUd0Kor7m7ER1nWDPpKSj/HUy5QzI/o3YmivvQYH3NlZuVQTsBvuLFLwm0jO2/93Z9pl9Lhe5rTynvLUAhffdFRyLYZqmNbMOp5Q7VAtSW8gMwEj6j5BQdry94Fa5VRH3FmiyKicCC3fYUzelVSjXbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NeFJl3UV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NeFJl3UV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729884712;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IuxZjT1Lk5wAEMoixsxA5IaDrCd0ZDCP14jD24Laty0=;
	b=NeFJl3UVdUC7fU/bU+rled/COOOooZguQoODCeBGWMmyUljSXXZ+4ZMhHvP3XA4grLM3W1
	ztZyweljqdUmGbW7sGoGUDAPU35mLKxns+6XWpmdKDSuIBDkHOoUj2p2ppbrCEBUoc8FKZ
	rEVyv7U4G7zc73lprnrtabY/r5Sc0LI=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-465-zMwSZ1uUPmGl1ciBpEuiSA-1; Fri,
 25 Oct 2024 15:31:49 -0400
X-MC-Unique: zMwSZ1uUPmGl1ciBpEuiSA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5D33B19560A7;
	Fri, 25 Oct 2024 19:31:48 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.135])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C7CC01956056;
	Fri, 25 Oct 2024 19:31:47 +0000 (UTC)
Date: Fri, 25 Oct 2024 15:33:14 -0400
From: Brian Foster <bfoster@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/3] xfs: sparse inodes overlap end of filesystem
Message-ID: <ZxvyehycddRL7Kt4@bfoster>
References: <20241024025142.4082218-1-david@fromorbit.com>
 <ZxpJp48vi4NpFVqJ@bfoster>
 <Zxrqz9xMV5PKQ5+f@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zxrqz9xMV5PKQ5+f@dread.disaster.area>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Fri, Oct 25, 2024 at 11:48:15AM +1100, Dave Chinner wrote:
> On Thu, Oct 24, 2024 at 09:20:39AM -0400, Brian Foster wrote:
> > On Thu, Oct 24, 2024 at 01:51:02PM +1100, Dave Chinner wrote:
> > > We have had a large number of recent reports about cloud filesystems
> > > with "corrupt" inode records recently. They are all the same, and
> > > feature a filesystem that has been grown from a small size to a
> > > larger size (to 30G or 50G). In all cases, they have a very small
> > > runt AG at the end of the filesystem.  In the case of the 30GB
> > > filesystems, this is 1031 blocks long.
> > > 
> > > These filesystems start issuing corruption warnings when trying to
> > > allocate an in a sparse cluster at block 1024 of the runt AG. At
> > > this point, there shouldn't be a sparse inode cluster because there
> > > isn't space to fit an entire inode chunk (8 blocks) at block 1024.
> > > i.e. it is only 7 blocks from the end of the AG.
> > > 
> > > Hence the first bug is that we allowed allocation of a sparse inode
> > > cluster in this location when it should not have occurred. The first
> > > patch in the series addresses this.
> > > 
> > > However, there is actually nothing corrupt in the on-disk sparse
> > > inode record or inode cluster at agbno 1024. It is a 32 inode
> > > cluster, which means it is 4 blocks in length, so sits entirely
> > > within the AG and every inode in the record is addressable and
> > > accessible. The only thing we can't do is make the sparse inode
> > > record whole - the inode allocation code cannot allocate another 4
> > > blocks that span beyond the end of the AG. Hence this inode record
> > > and cluster remain sparse until all the inodes in it are freed and
> > > the cluster removed from disk.
> > > 
> > > The second bug is that we don't consider inodes beyond inode cluster
> > > alignment at the end of an AG as being valid. When sparse inode
> > > alignment is in use, we set the in-memory inode cluster alignment to
> > > match the inode chunk alignment, and so the maximum valid inode
> > > number is inode chunk aligned, not inode cluster aligned. Hence when
> > > we have an inode cluster at the end of the AG - so the max inode
> > > number is cluster aligned - we reject that entire cluster as being
> > > invalid. 
> > > 
> > > As stated above, there is nothing corrupt about the sparse inode
> > > cluster at the end of the AG, it just doesn't match an arbitrary
> > > alignment validation restriction for inodes at the end of the AG.
> > > Given we have production filesystems out there with sparse inode
> > > clusters allocated with cluster alignment at the end of the AG, we
> > > need to consider these inodes as valid and not error out with a
> > > corruption report.  The second patch addresses this.
> > > 
> > > The third issue I found is that we never validate the
> > > sb->sb_spino_align valid when we mount the filesystem. It could have
> > > any value and we just blindly use it when calculating inode
> > > allocation geometry. The third patch adds sb->sb_spino_align range
> > > validation to the superblock verifier.
> > > 
> > > There is one question that needs to be resolved in this patchset: if
> > > we take patch 2 to allow sparse inodes at the end of the AG, why
> > > would we need the change in patch 1? Indeed, at this point I have to
> > > ask why we even need the min/max agbno guidelines to the inode chunk
> > > allocation as we end up allowing any aligned location in the AG to
> > > be used by sparse inodes. i.e. if we take patch 2, then patch 1 is
> > > unnecessary and now we can remove a bunch of code (min/max_agbno
> > > constraints) from the allocator paths...
> > > 
> > > I'd prefer that we take the latter path: ignore the first patch.
> > > This results in more flexible behaviour, allows existing filesystems
> > > with this issue to work without needing xfs_repair to fix them, and
> > > we get to remove complexity from the code.
> > > 
> > > Thoughts?
> > > 
> > 
> > This all sounds reasonable on its own if the corruption is essentially
> > artifical and there is a path for code simplification, etc. That said, I
> > think there's a potential counter argument for skipping patch 1 though.
> > A couple things come to mind:
> > 
> > 1. When this corrupted inode chunk allocation does occur, is it possible
> > to actually allocate an inode out of it, or does the error checking
> > logic prevent that?
> 
> The error checking during finobt lookup prevents inode allocation.
> i.e. it fails after finobt lookup via the path:
> 
> xfs_dialloc_ag_finobt_newino()
>   xfs_inobt_get_rec()
>     xfs_inobt_check_irec()
>       if (!xfs_verify_agino(pag, irec->ir_startino))
>          return __this_address;
> 
> Before any modifications are made. hence the transaction is clean
> when cancelled, and the error is propagated cleanly back out to
> userspace.
> 

Ok, so data is not at risk. That is good to know.

> > 2. Would we recommend a user upgrade to a new kernel with a corruption
> > present that causes inode allocation failure?
> 
> I'm not making any sort of recommendations on how downstream distros
> handle system recovery from this issue.  System recovery once the
> problem has manifested is a separate problem - what we are concerned
> about here is modifying the kernel code to:
> 
> a) prevent the issue from happening again; and
> b) ensure that existing filesytsems with this latent issue on disk
>    don't throw corruption errors in future.
> 
> How we get that kernel onto downstream distro systems is largely a
> distro support issue. Downstream distros can:
> 
> - run the gaunlet and upgrade in place, relying on the the
>   transactional upgrade behaviour of the package manager to handle
>   rollbacks when file create failures during installation; or
> - grow the cloud block device and filesystem to put the inode
>   cluster wholly within the bounds of the AG and so pass the
>   alignment checks without any kernel modifications, then do the
>   kernel upgrade; or
> - live patch the running kernel to allow the sparse inode cluster to
>   be considered valid (as per the second patch in this series)
>   so it won't ever fail whilst installing the kernel upgrade; or
> - do some xfs_db magic to remove the finobt record that is
>   problematic and leak the sparse inode cluster so we never try to
>   allocate inode from it, then do the kernel upgrade and run
>   xfs_repair; or
> - do some xfs_db magic to remove the finobt record and shrink the
>   filesystem down a few blocks to inode chunk align it.
> - something else...
> 
> IOWs, there are lots of ways that the downstream distros can
> mitigate the problem sufficiently to install an updated kernel that
> won't have the problem ever again.
> 

IOOW, we agree that something might be necessary on the userspace side
to fully support users/distros out of this problem.

Given the last couple items on the list don't share some of the
constraints or external dependencies of the others, and pretty much
restate the couple of ideas proposed in my previous mail, they seem like
the most broadly useful options to me.

> > My .02: under no circumstances would I run a distro/package upgrade on a
> > filesystem in that state before running repair, nor would I recommend
> > that to anyone else.
> 
> Keep in mind that disallowing distro/package managers to run in this
> situation also rules out shipping a new xfsprogs package to address
> the issue. i.e. if the distro won't allow kernel package upgrades,
> then they won't allow xfsprogs package upgrades, either.
> 

I don't know why you would expect otherwise. I assume this would require
a boot/recovery image or emergency boot mode with binary external to the
filesystem that needs repair.

> There aren't any filesystem level problems with allowing operation
> to continue on the filesystem with a sparse inode chunk like this in
> the runt AG. Yes, file create will fail with an error every so
> often, but there aren't any issues beyond that. The "corruption"
> can't propagate, it wont' shut down the filesystem, and errors are
> returned to userspace when it is hit. There is no danger to
> other filesystem metadata or user data from this issue.
> 
> Hence I don't see any issues with simply installing new packages and
> rebooting to make the problem go away...
> 

Nor do I so long as upgrade doesn't fail and cancel out on inode
allocation failures.

> > The caveat to this is that even after a repair,
> > there's no guarantee an upgrade wouldn't go and realloc the same bad
> > chunk and end up right back in the same state, and thus fail just the
> > same.
> 
> Sure, but this can be said about every single sparse inode enabled
> filesystem that has an unaligned end of the runt AG whether the
> problem has manifested or not. There are going to *lots* of
> filesystems out there with this potential problem just waiting to be
> tripped over.
> 
> i.e. the scope of this latent issue has the potential to affect a
> very large number of filesystems.  Hence saying that we can't
> upgrade -anything- on <some large subset> of sparse inode enable
> filesystems because they *might* fail with this problem doesn't make
> a whole lot of sense to me....
> 

That doesn't make sense to me either. I'd just upgrade in that case. If
the problem hasn't manifested already, it seems unlikely to occur before
the fixed kernel is installed.

> > For example, I assume allocating the last handful of blocks out of the
> > runt AG would prevent the problem. Of course that technically creates
> > another corruption by leaking blocks, but as long repair knows to keep
> > it in place so long as the fs geometry is susceptible, perhaps that
> > would work..?
> 
> I think that would become an implicit change of on-disk format.
> scrub would need to know about it, as would online repair. growfs
> will need to handle the case explicitly (is the trailing runt space
> on this filesystem leaked or not?), and so on. I don't see this as a
> viable solution.
> 

Then just make it stateless and leak the blocks as a transient means to
facilitate upgrade and recovery, as suggested above.

Brian

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

