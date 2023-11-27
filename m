Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D54136;
	Mon, 27 Nov 2023 05:51:21 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id A04A367373; Mon, 27 Nov 2023 14:51:17 +0100 (CET)
Date: Mon, 27 Nov 2023 14:51:17 +0100
From: Christoph Hellwig <hch@lst.de>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Ritesh Harjani <ritesh.list@gmail.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 09/13] iomap: don't chain bios
Message-ID: <20231127135117.GB23428@lst.de>
References: <20231126124720.1249310-1-hch@lst.de> <20231126124720.1249310-10-hch@lst.de> <0f136350-3242-3e20-3b8a-56a39c66b001@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f136350-3242-3e20-3b8a-56a39c66b001@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 27, 2023 at 08:53:22PM +0800, Zhang Yi wrote:
> A nice cleanup! I'm just a little curious about the writeback performance
> impact of this patch. Do you have any actual test data on xfs?

I've only tested the entire series, not this patch specifically.  The
throughput doesn't change at all in my testing, and cpu usage goes
down a tiny amount, although it's probably below the measurement
tolerance.

