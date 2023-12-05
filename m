Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97B410F
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 21:38:45 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id AFAEE68B05; Tue,  5 Dec 2023 06:38:42 +0100 (CET)
Date: Tue, 5 Dec 2023 06:38:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: document what LARP means
Message-ID: <20231205053842.GA30199@lst.de>
References: <170175456196.3910588.9712198406317844529.stgit@frogsfrogsfrogs> <170175456779.3910588.8343836136719400292.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170175456779.3910588.8343836136719400292.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 04, 2023 at 09:36:07PM -0800, Darrick J. Wong wrote:
> +/*
> + * The "LARP" (Logged extended Attribute Recovery Persistence) debugging knob
> + * sets the XFS_DA_OP_LOGGED flag on all xfs_attr_set operations performed on
> + * V5 filesystems.  As a result, the intermediate progress of all setxattr and
> + * removexattr operations are tracked via the log and can be restarted during
> + * recovery.
> + */

Can you also add a sentence on why we even have this code and why you'd
want to set the flag?

