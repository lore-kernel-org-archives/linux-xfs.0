Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7EB7468
	for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2023 05:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C47C568C4E; Tue, 19 Dec 2023 06:47:44 +0100 (CET)
Date: Tue, 19 Dec 2023 06:47:44 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Jian Wen <wenjianhn@gmail.com>, linux-xfs@vger.kernel.org,
	djwong@kernel.org, hch@lst.de, dchinner@redhat.com,
	Jian Wen <wenjian1@xiaomi.com>
Subject: Re: [PATCH v2] xfs: improve handling of prjquot ENOSPC
Message-ID: <20231219054744.GA1015@lst.de>
References: <20231214150708.77586-1-wenjianhn@gmail.com> <20231216153522.52767-1-wenjianhn@gmail.com> <ZYDBBmZWabnbd3zq@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZYDBBmZWabnbd3zq@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Dec 19, 2023 at 09:00:38AM +1100, Dave Chinner wrote:
> I'm not convinced this is correct behaviour.
> 
> That is, we can get a real full filesystem ENOSPC even when project
> quotas are on and the the project quota space is low. With this
> change we will only flush project quotas rather than the whole
> filesystem.

Yes.

> quotas are enabled.
> 
> Hence my suggestion that we should be returning -EDQUOT from project
> quotas and only converting it to -ENOSPC once the project quota has
> been flushed and failed with EDQUOT a second time.

FYI, my suggestion of turning cleared_space into a counter and still
falling back to the normal ENOSPC clearing would also work.  But in
the long run moving this pretty messy abuse of ENOSPC for out of qupta
in the low-level code into the highest syscall boudary is probably a
good thing for maintainability.
