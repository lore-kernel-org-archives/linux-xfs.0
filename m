Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793960857;
	b=t5O0paP3hDAu+GPGQTPbwQ86HZ4yREfdqRLulSx49JPlSIW+zvuNf5IBNx7ru7UOniTm
	 W7ih7wPfSnZ0kIay38I6wbCL4iAv7OedHzXskCzFJeEGHpEUeIbpq0xrVmq3r6g5PGsm5
	 gg4uIfjplWxeS5w+x0YV01e7B508lrWgTrkonK/lrSvazV8fQ9b1NNILI9C9zDxzuNWJf
	 lyCbelfCcOw/t6D7ERVg/VQFlaEiHTozC0+JEDU9w+R/tAJ3wNmIBQS0vj3D9RZ0qabN+
	 kkIiWf3kgXiBLpeLK55/vTg5QPb6US13shez2GPb5QGX3j9fJsJhPpgyVQKQA0D84jA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793960857;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=Ng4EmQmVugyqJk+SkgZfhDd1lWc8URaGhyumeNdQoGs=;
	b=Rtey9b+84vu+Yhhpgnwy0X+fUYoJEl4vMoHDAwLs5xc0zYYk2eEkNZkyiWafddTgLrZZ
	 38zX3CfW3y5NJ4eRT6/Oal+Lyw+3LQLrkVutFQi4rwLKqt8qvQDJNC1jAVXGL0joA+WLd
	 Y6dkPNRYJnZJkojwpk5Vv07R2/gRujnQOAid6GZubcYv79wfo0Icp4sct+p4mlUZJDjhk
	 VZzFZ682PKXpYRBy/SPBXjDf2/6RSlu7UXxrcq+wDuozNTB0TmZ5E1Oa/0JfNoYFk2mni
	 7YtyFjOlpaogYVSYDTOD9wovojegt9N53kOsUE+ggU2flVmAivNSJQEdjrxKCPQ1roA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A17606A32C;
	Fri,  6 Nov 2026 10:27:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72A17606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3CFD468BEB; Fri,  6 Nov 2026 11:27:34 +0100 (CET)
Date: Fri, 6 Nov 2026 11:27:34 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: ebiggers@kernel.org, hch@lst.de, fsverity@lists.linux.dev,
	dsterba@suse.com, linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jaegeuk@kernel.org,
	chao@kernel.org, tytso@mit.edu
Subject: Re: [PATCH v2 5/5] f2fs: use I_VERITY_BUILDING instead of private
 flags
Message-ID: <20261106102734.GE5319@lst.de>
References: <20261105115532.613467-1-aalbersh@kernel.org> <20261105115532.613467-6-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105115532.613467-6-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

This looks good to me, but given the conflict with the f2fs tree maybe
delay this until after the current merge window?

