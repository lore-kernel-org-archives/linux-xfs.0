Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DEE19A6;
	Tue, 28 Nov 2023 21:40:27 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id C49A3227A87; Wed, 29 Nov 2023 06:40:24 +0100 (CET)
Date: Wed, 29 Nov 2023 06:40:24 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	Ritesh Harjani <ritesh.list@gmail.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 09/13] iomap: don't chain bios
Message-ID: <20231129054024.GC1385@lst.de>
References: <20231126124720.1249310-1-hch@lst.de> <20231126124720.1249310-10-hch@lst.de> <20231129045951.GO4167244@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231129045951.GO4167244@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 28, 2023 at 08:59:51PM -0800, Darrick J. Wong wrote:
> Well that's a nice code deflation!  And if I read this correctly,
> instead of chaining bios together, now we create a new ioend and add it
> to the ioend list, eventually submitting the entire list of them?

Yes. (although that changes a bit again later)

