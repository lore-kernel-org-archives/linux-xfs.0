Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159C137D1A
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 16:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PAYeXIcJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79CD0C433C7;
	Tue, 28 Nov 2023 16:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701188346;
	bh=0Ag4qaJaVJYeZsmD/Ziq5NjmMiyUyZLsJEveoMz3LW4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PAYeXIcJISUhsgXkvRPJciIHAtJiy3JURj2WtelWdRE52/+33R7yA289mOzSTFPpQ
	 rwvSp+PNfOUOBQH1Ul7Wq1jJD8+OUCi5IgdB99002hA2VEMI461EJ2V1gIkysFpu7N
	 RN3Cf+ilnB3KDSbC3/FaJDuxPCLYlXHUqx26VNbazKoqVS66CESKEjBCMq9aE6UcyS
	 jnrgswmoFSERvHBfI0edS+Js8eB/OusESfzc2lAjul9+/Vs2DD0TrnfSTAUaVMWRlr
	 mKuXnagpjChGo5xeaRCgDhalBQ+0P1TRId5VxBUD9yZLQTTYvJfZ8lRIYJIrVLVAzO
	 wQFQHbq2qH0ng==
Date: Tue, 28 Nov 2023 08:19:05 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Brian Foster <bfoster@redhat.com>, Ben Myers <bpm@sgi.com>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	xieyongji@bytedance.com, me@jcix.top
Subject: Re: [PATCH 1/2] xfs: ensure tmp_logflags is initialized in
 xfs_bmap_del_extent_real
Message-ID: <20231128161905.GT2766956@frogsfrogsfrogs>
References: <20231128053202.29007-1-zhangjiachen.jaycee@bytedance.com>
 <20231128053202.29007-2-zhangjiachen.jaycee@bytedance.com>
 <ZWWii6HhlfkWXSq8@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWWii6HhlfkWXSq8@infradead.org>

On Tue, Nov 28, 2023 at 12:19:23AM -0800, Christoph Hellwig wrote:
> On Tue, Nov 28, 2023 at 01:32:01PM +0800, Jiachen Zhang wrote:
> > In the case of returning -ENOSPC, ensure tmp_logflags is initialized by 0.
> > Otherwise the caller __xfs_bunmapi will set uninitialized illegal
> > tmp_logflags value into xfs log, which might cause unpredictable error
> > in the log recovery procedure.
> 
> This looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> But I wonder if removing the local flags variable and always directly
> assigning to *logflagsp might be more robust in the long run.

Yes, I think it's better to eliminate opportunities for subtle logic
bombs by not open-coding variable aliasing.  Perhaps this function
should set *logflagsp = 0 at the start of the function so that we don't
have to deal with uninitialized outparams, especially since the caller
uses it even on an error return.

--D
