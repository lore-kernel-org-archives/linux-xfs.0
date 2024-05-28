Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB492171677
	for <linux-xfs@vger.kernel.org>; Tue, 28 May 2024 15:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716911466; cv=none; b=YxHchiPYPjd8x1r8F0ZrxS9D0C5xLo5BcF1KBt2Bd0HNB4mhnSWQUGQX5P0Ofafy0haUEXgqPBTARhyBg/mJNPpzMH5kjAMhrdG/shOOMQHDo1bqHfCf+BK3VnvWKynchleZdpl1omhl0erX1fMstf/DlZvE7SR8r2/HGouA8rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716911466; c=relaxed/simple;
	bh=EsuAXj29O+A7D2Yq63v/k2ReVfMNPbSziJmqL69L+ZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tjEqjqp3Ev9RqG3Tq15U4FiKFXn7sfLowSuNnrPGesNED7y2yNT4rNuv/87U3BXDdLCL8DTkKdNXt0L7sNfmhRpNRRO3YsjxI58vP9wZbdbrRbpWPgTbeJZJHkPw/4vd9FXYeos6XnxZkl/tLNunFrNTYep1IRo/dpKPBNC9fPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TD15jYOO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TD15jYOO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716911463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Db4jeQfAuJeAuTAzkEFGx+iVhFxBjZsEszGlU/2S9xY=;
	b=TD15jYOOJfira3GC4LEAtqtdEz54FInIGIc0dWe/Zsf40aC3YlGyk10fAuIZ+4rO6bEJlm
	Vn+85611S9hyZe8tecBne7PhGsUk1gRFgSJHfSscZnaVuT64dLgLImk7O2/2Eru6WslPZe
	jLnbkJ/Be8RiCmbkSgwq/K1q52hBJNg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-r4sb2m8pMiWCF7Az_LrRCw-1; Tue, 28 May 2024 11:51:00 -0400
X-MC-Unique: r4sb2m8pMiWCF7Az_LrRCw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A81D2800169;
	Tue, 28 May 2024 15:50:59 +0000 (UTC)
Received: from bfoster (unknown [10.22.8.96])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E3C2E2026D68;
	Tue, 28 May 2024 15:50:58 +0000 (UTC)
Date: Tue, 28 May 2024 11:51:17 -0400
From: Brian Foster <bfoster@redhat.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ian Kent <raven@themaw.net>, "Darrick J. Wong" <djwong@kernel.org>,
	Jinliang Zheng <alexjlzheng@gmail.com>, alexjlzheng@tencent.com,
	david@fromorbit.com, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, rcu@vger.kernel.org
Subject: Re: About the conflict between XFS inode recycle and VFS rcu-walk
Message-ID: <ZlX9dWHyUj56apwj@bfoster>
References: <20240515155441.2788093-1-alexjlzheng@tencent.com>
 <20240516045655.40122-1-alexjlzheng@tencent.com>
 <7f744bf5-5f6d-4031-8a4f-91be2cd45147@themaw.net>
 <3545f78c-5e1c-4328-8ab0-19227005f4b7@themaw.net>
 <20240520173638.GB25518@frogsfrogsfrogs>
 <9a123c02-f88d-47dd-b8ef-dea136b01dc1@themaw.net>
 <dd7cdc06-9829-4519-9873-ea9d661a8c45@themaw.net>
 <d2d010ce-51eb-4e99-b717-162e88f8d3fc@themaw.net>
 <20240527001823.GC2118490@ZenIV>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240527001823.GC2118490@ZenIV>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Mon, May 27, 2024 at 01:18:23AM +0100, Al Viro wrote:
> On Mon, May 27, 2024 at 07:51:39AM +0800, Ian Kent wrote:
> 
> > Indeed, that's what I found when I had a quick look.
> > 
> > 
> > Maybe a dentry (since that's part of the subject of the path walk and inode
> > is readily
> > 
> > accessible) flag could be used since there's opportunity to set it in vfs
> > callbacks that
> > 
> > are done as a matter of course.
> 
> You might recheck ->d_seq after fetching ->get_link there; with XFS
> ->get_link() unconditionlly failing in RCU mode that would prevent
> this particular problem.  But it would obviously have to be done
> in pick_link() itself (and I refuse to touch that area in 5.4 -
> carrying those changes across the e.g. 5.6 changes in pathwalk
> machinery is too much).
> 

Ian sent a patch along those lines a couple years or so ago:

https://lore.kernel.org/linux-fsdevel/164180589176.86426.501271559065590169.stgit@mickey.themaw.net/

I'm still not quite sure why we didn't merge this, at least as a bandaid
fix for the symlink variant of this particular problem..?

Brian

> And it's really just the tip of the iceberg - e.g. I'd expect a massive
> headache in ACL-related part of permission checks, etc.
> 

