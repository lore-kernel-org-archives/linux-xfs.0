Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E3820B807;
	Mon, 16 Jun 2025 14:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750085423; cv=none; b=iWIPE1OpdChfKv4TXI3b6so9FbBV4B0jYHEQKCC3lR+q007NF2OCjWBJdBlynv0wpnqpSG/46kUZxaKy8Bd9Zk2ZtNyNtHIr5wP6jWCOhgu4AOtRjMp4Cu2SQEw1cqD8JqLaG9LIxSMOXZ9W0TDWC/9jT82MOx3QQN33URQNgo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750085423; c=relaxed/simple;
	bh=eA7YMpGghvvwTSt9K1EZbouO635j9XtsXcoyrP1WGjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EaqXcOGBWYs8n5Y+UbPcRc6LTroF1iLhzvK1dzpOFEBxs2i7ae4zjmCizFDz5FrWQrzzfQSAc2aA+3JBDE79pe2ph9WIKEFF+ezVryK+kltIBi+L0u6XoWoVFYEVJuirjPcE2Aio7eOoxupHLy56zXWH0xOh8fygRgWPlokssL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1589BBA10C;
	Mon, 16 Jun 2025 14:50:14 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf05.hostedemail.com (Postfix) with ESMTPA id 267F120011;
	Mon, 16 Jun 2025 14:50:12 +0000 (UTC)
Date: Mon, 16 Jun 2025 10:50:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, LKML
 <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Carlos Maiolino
 <cem@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: Unused event xfs_growfs_check_rtgeom
Message-ID: <20250616105010.11efd49f@batman.local.home>
In-Reply-To: <aEu-U-va9q0QRuX0@infradead.org>
References: <20250612131021.114e6ec8@batman.local.home>
	<20250612131651.546936be@batman.local.home>
	<20250612174737.GM6179@frogsfrogsfrogs>
	<20250612144608.525860bc@batman.local.home>
	<aEu-U-va9q0QRuX0@infradead.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 267F120011
X-Stat-Signature: ijnqwr669i87ibkrhpcbcwt6q88hjb1s
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18Kh8mRHqt8+6D0roufbHVC8u+e7jwxvSY=
X-HE-Tag: 1750085412-706185
X-HE-Meta: U2FsdGVkX1+of2ah6iD7vqtj+jIarF4Dt0DZpS7dhJfdro+EWaPpnww4gIMEc4ufvhwojCLo5T/yUAyAZecoOcmnYnHhasbTE4aIgkCDl4KDyCWyrTTX2PYfZhI5MhxhlfHLJU95wXyejl6AQ6hH45CHhgbbRMD/oE/wvkdjNHiMlyTK8KE7bgoChDLWOT8jm4OcfDeR6HaLgdrNCkXV4/1gyCwv8PXdOOgz/kgJkDFpN0nribnJap06X0GSL9ymxDgB40iqSdt4NU1f5ydNClUXQqhM9DqutMiizg4LqxdK3A9Be3NhXGL82NcXZKGnZUosZGwKihvJfKbsJv+QO2L3pLju5IlUYq55sP0Jny8YraBrvVuPEzJxM2V/v/H8ql1rxlXazUSjyUyboU8tLg==

On Thu, 12 Jun 2025 22:59:47 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Jun 12, 2025 at 02:46:08PM -0400, Steven Rostedt wrote:
> > On Thu, 12 Jun 2025 10:47:37 -0700
> > "Darrick J. Wong" <djwong@kernel.org> wrote:
> >   
> > > On Thu, Jun 12, 2025 at 01:16:51PM -0400, Steven Rostedt wrote:  
> > > > I also found events: xfs_metadir_link and xfs_metadir_start_link are
> > > > defined in fs/xfs/libxfs/xfs_metadir.c in a #ifndef __KERNEL__ section.
> > > > 
> > > > Are these events ever used? Why are they called in !__KERNEL__ code?    
> > > 
> > > libxfs is shared with userspace, and xfs_repair uses them to relink old
> > > quota files.
> > >  
> > 
> > Does this userspace use these trace events? If so, I think the events
> > need to have an:  
> 
> They have stubs for them.

If user space only has stubs for them, then why do they exist? The call
to this tracepoints are within #ifndef __KERNEL__ so the kernel will
never call them. Or can the user space stubs be replaced by actual content?

Either case, the events in the header file should be hidden from the kernel.

-- Steve
