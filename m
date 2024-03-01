Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EC716FF5F;
	Fri,  1 Mar 2024 17:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709315421; cv=none; b=j0vlMnDaXg3R3bCYEikuPjoIG9J33phDBC5rJX5lgPGJ2/CA85ZTCbZ4jVDBC427zhjSwN+OyswVlXBcn22oXfJ4rW9EVYFbbJzqzW4lK8odt70+1WkqJoMVo4ycT1ytQ4KJgUZ6DJDpnJTwt6ORPnoSMTt/mhEDRSYJVXd9LLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709315421; c=relaxed/simple;
	bh=s6NXpyFLPmC6iC/tpoBCBDjApP3V+eLZMqgLl+fJ7As=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iCmJ022pUBvtb29/cA1BEkdLeZ8HlEj5OLUfeSYBjTzDWQPgkyDYe1XgWQ8xgoHJkKVEFltAdOQJIzfGXewW5YJt6ociaO74YqRisz9goxlrX87HiQxCgk6Ij/6I1k5Gi0HkfroNzh52KtqjQfUqikRpkmIhi+pAEww5Jo5l0Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c5Virzo+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c5Virzo+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81908C433C7;
	Fri,  1 Mar 2024 17:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709315420;
	bh=s6NXpyFLPmC6iC/tpoBCBDjApP3V+eLZMqgLl+fJ7As=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c5Virzo+dgLwH/ntac6dKyN/qTQzxoQWvwd1SiAO8XQz7RTP+neJ/S+Phg510WVbt
	 qVM9bImGpbIf8Wje8r26mZtEsc+hz2ov7KuAphhg781jqJEEtn/A9dnR34qS4qIrzR
	 LgXV6Ro8xAsBNmEuqEc4mAIOxAnMVjxTiRSjNB9I3uKEWXGPvrv8U3mvF1jeItXcWq
	 pYh4xZbTJORyqoDlXTX+d5EvVsLglaC17hfUVWaqe0DszfsbW3VZz/DNLHvcz7S2/3
	 is56H53SXFhr39Qg7kRa5Wxv9XO5fLQ0G9oSq0zQa2iw20TAxC8iGcnKluqtidCJ88
	 3vjqpVlHwm/4g==
Date: Fri, 1 Mar 2024 09:50:20 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs/122: update test to pick up rtword/suminfo
 ondisk unions
Message-ID: <20240301175020.GI1927156@frogsfrogsfrogs>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915304.896550.17104868811908659798.stgit@frogsfrogsfrogs>
 <Zd33sVBc4GSA5y1I@infradead.org>
 <20240228012704.GU6188@frogsfrogsfrogs>
 <Zd9TsVxjRTXu8sa5@infradead.org>
 <20240229174831.GB1927156@frogsfrogsfrogs>
 <ZeDeD9v9m8C0PsvG@infradead.org>
 <20240301131848.krj2cdt4u6ss74gz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240301131848.krj2cdt4u6ss74gz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Fri, Mar 01, 2024 at 09:18:48PM +0800, Zorro Lang wrote:
> On Thu, Feb 29, 2024 at 11:42:07AM -0800, Christoph Hellwig wrote:
> > On Thu, Feb 29, 2024 at 09:48:31AM -0800, Darrick J. Wong wrote:
> > > It turns out that xfs/122 also captures ioctl structure sizes, and those
> > > are /not/ captured by xfs_ondisk.h.  I think we should add those before
> > > we kill xfs/122.
> > 
> > Sure, I can look into that.
> 
> Hi Darrick,
> 
> Do you still want to have this patch?
> 
> Half of this patchset got RVB. As it's a random fix patchset, we can choose
> merging those reviewed patches at first. Or you'd like to have them together
> in next next release?

I was about to resend the second to last patch.  If you decide to remove
xfs/122 then I'll drop this one.

--D

> Thanks,
> Zorro
> 
> > 
> > 
> 
> 
