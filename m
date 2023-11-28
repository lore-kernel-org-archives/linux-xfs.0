Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F58D1;
	Tue, 28 Nov 2023 05:56:25 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id E6897227A87; Tue, 28 Nov 2023 14:56:19 +0100 (CET)
Date: Tue, 28 Nov 2023 14:56:19 +0100
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, kbusch@kernel.org,
	sagi@grimberg.me, jejb@linux.ibm.com, martin.petersen@oracle.com,
	djwong@kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org,
	chandan.babu@oracle.com, dchinner@redhat.com,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-api@vger.kernel.org
Subject: Re: [PATCH 17/21] fs: xfs: iomap atomic write support
Message-ID: <20231128135619.GA12202@lst.de>
References: <20230929102726.2985188-1-john.g.garry@oracle.com> <20230929102726.2985188-18-john.g.garry@oracle.com> <20231109152615.GB1521@lst.de> <a50a16ca-d4b9-a4d8-4230-833d82752bd2@oracle.com> <c78bcca7-8f09-41c7-adf0-03b42cde70d6@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c78bcca7-8f09-41c7-adf0-03b42cde70d6@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 28, 2023 at 08:56:37AM +0000, John Garry wrote:
> Are you suggesting some sort of hybrid between the atomic write series you 
> had a few years ago and this solution?

Very roughly, yes.

> To me that would be continuing with the following:
> - per-IO RWF_ATOMIC (and not O_ATOMIC semantics of nothing is written until 
> some data sync)

Yes.

> - writes must be a power-of-two and at a naturally-aligned offset

Where offset is offset in the file?  It would not require it.  You
probably want to do it for optimal performance, but requiring it
feeels rather limited.

> - relying on atomic write HW support always

And I think that's where we have different opinions.  I think the hw
offload is a nice optimization and we should use it wherever we can.
But building the entire userspace API around it feels like a mistake.

> BTW, we also have rtvol support which does not use forcealign as it already 
> can guarantee alignment, but still does rely on the same principle of 
> requiring alignment - would you want CoW support there also?

Upstream doesn't have out of place write support for the RT subvolume
yet.  But Darrick has a series for it and we're actively working on
upstreaming it.
