Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488F0E6
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 21:10:46 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5B5B168AFE; Mon,  4 Dec 2023 06:10:43 +0100 (CET)
Date: Mon, 4 Dec 2023 06:10:43 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: chandanbabu@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: hoist intent done flag setting to
 ->finish_item callsite
Message-ID: <20231204051043.GJ26073@lst.de>
References: <170162990150.3037772.1562521806690622168.stgit@frogsfrogsfrogs> <170162990199.3037772.1720511950494662143.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <170162990199.3037772.1720511950494662143.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Dec 03, 2023 at 11:03:13AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Each log intent item's ->finish_item call chain inevitably includes some
> code to set the dirty flag of the transaction.  If there's an associated
> log intent done item, it also sets the item's dirty flag and the
> transaction's INTENT_DONE flag.  This is repeated throughout the
> codebase.
> 
> Reduce the LOC by moving all that to xfs_defer_finish_one.

Heh, I've started doing this a few time and ran into the attr
іnconsistencies every time.  With that sorted out this looks nice now:

Reviewed-by: Christoph Hellwig <hch@lst.de>
