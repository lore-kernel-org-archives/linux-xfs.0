Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C91435535;
	Tue, 28 Jul 2026 14:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785248879; cv=none; b=axFl5JwiKOgpHuWemn6kMpuHOhUXAky+t3peQ/PBQ/RO1+75Zqnjbk3wZVSFdPsLopc7pq9oU+naunl1UbrVpKUVvajgavoJ0rBsoKRIxKScHfpGB372EeaDVg4fDARij08pcl2Qu6MShabRhMDRMJpjt2xtkSp7kK/lAQ+GNng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785248879; c=relaxed/simple;
	bh=rBvNqNavzbrrcbT2nZJt/thsxq3mPh0j+0mjEtTQk2I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Oj1LvOgoqlKglPiwmXa4XJEpmhDcY4ZV7VQiiYz41iIwFk5zHvfCXhihfsOQdV2hLrjoskbzZ6B0OD+XzGhRJjkxuRxiDDyuncynDDjauQeThAfbs3Di3hI4oWE97p7I7SZ/FI4UpIzJfamV2VLj7vzSVUv3WgEYcJVnMVIIwRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jl21fUpQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jl21fUpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 404761F000E9;
	Tue, 28 Jul 2026 14:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785248877;
	bh=ipPVpKqDsUNPrwwl0/LqgIlIDX4NZ+f3Dn1SHjvbxLU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=jl21fUpQ9TLOIa90lgXJhTcM9ZnGL6RLSJFDOOnggmhSieefvX4ru1EerT+kIcsfW
	 Jg8xIie9e8BA9f72djNqWrkWjrtU/futoXGB7lurzYiHySGoplgN4kV4c7EDoAHzTa
	 RLRlyCGgcjFlkaqFG7mv8iFqAIR9+m2XxaINcT3TPONLCNLXK2yTqLOijLx7A8OXhx
	 Mv2UhFkaJdHdCMgnJOKt6YM24HtkwlZjzxdyFWw62as3Llm3vAwFPTYdXFgl3xtbKZ
	 fJ3fT/pvfIqh3Dz9+SaR9ZfcNtpUA/ARTatxh4zCtFrr+5x0ADDOmS31Y8my1tzGwE
	 QdG3dBgIT6JsQ==
Date: Tue, 28 Jul 2026 07:27:56 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Theodore Tso <tytso@mit.edu>, "Darrick
 J. Wong" <djwong@kernel.org>, Joanne Koong <joannelkoong@gmail.com>,
 changfengnan@bytedance.com, Christian Brauner <brauner@kernel.org>,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, workflows@vger.kernel.org
Subject: Re: selective Sashiko replies, was: Re: [PATCH 2/3] iomap: decouple
 simple direct I/O reads from iomap_dio_rw
Message-ID: <20260728072756.7ddc9fdd@kernel.org>
In-Reply-To: <20260728040120.GA19400@lst.de>
References: <20260722124931.3159664-1-hch@lst.de>
	<20260722124931.3159664-3-hch@lst.de>
	<CAJnrk1a_cc55HcpRAi+H-mqOn7XUt_BxKJTre=Mw=xaE-5A5Rg@mail.gmail.com>
	<20260723045347.GA6641@lst.de>
	<20260723151021.GC7380@frogsfrogsfrogs>
	<amI3Kf3lFz4FMqXh@mit.edu>
	<amNerp4LwjSkHS5t@andromeda.toxiclabs.cc>
	<20260728040120.GA19400@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 28 Jul 2026 06:01:20 +0200 Christoph Hellwig wrote:
> > IIRC the discussion we had a while back was to keep the reviews emailed
> > to authors only...
> > 
> > Now I wonder how feasible would be to have a "linux-xfs-review" list to
> > send sashiko reviews to, then people opt-in to it? Would it be overkill?  
> 
> The main problem is that reducing the recipient list for replies is
> incredibly stupid.

+1, maybe perhaps someone wants the off-list option, dunno. 
But trimming the CC list of the on-list reply is a really weird idea.
Submissions often CC multiple vger lists, and the bot only replies to one.
