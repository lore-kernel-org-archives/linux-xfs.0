Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31630CA
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 21:04:29 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id AAE31227A8E; Mon,  4 Dec 2023 06:04:26 +0100 (CET)
Date: Mon, 4 Dec 2023 06:04:26 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: chandanbabu@kernel.org, hch@lst.de, leo.lilong@huawei.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: pass the xfs_defer_pending object to
 iop_recover
Message-ID: <20231204050426.GE26073@lst.de>
References: <170162989691.3037528.5056861908451814336.stgit@frogsfrogsfrogs> <170162989753.3037528.15154705573817500020.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170162989753.3037528.15154705573817500020.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Not sure if I missed it in my first round of review, or if this is new
in this version, but this now generats a warning when asserts are
disabled, given that the lip variable in xlog_recover_process_intents
is only used in asserts.  We'll need to remove it and just open code
the dereference in the two asserts that use it.

