Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD43E1
	for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 21:30:52 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6997067373; Tue, 28 Nov 2023 06:30:49 +0100 (CET)
Date: Tue, 28 Nov 2023 06:30:49 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: clean up the XFS_IOC_FSCOUNTS handler
Message-ID: <20231128053049.GA16579@lst.de>
References: <20231126130124.1251467-1-hch@lst.de> <20231126130124.1251467-3-hch@lst.de> <20231128015812.GR2766956@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128015812.GR2766956@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 27, 2023 at 05:58:12PM -0800, Darrick J. Wong wrote:
> 	struct xfs_fsop_counts	out = {
> 		.allocino = percpu_counter_read_positive(&mp->m_icount),
> 		.freeino  = percpu_counter_read_positive(&mp->m_ifree),
> 		.freedata = percpu_counter_read_positive(&mp->m_fdblocks) -
> 						xfs_fdblocks_unavailable(mp),
> 		.freertx  = percpu_counter_read_positive(&mp->m_frextents),
> 	};
> 
> Nit: Would you mind lining up the columns?

Sure.  I need to respin for the __user annotation anyway.

