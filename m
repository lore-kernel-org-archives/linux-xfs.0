Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7AACC1
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 11:44:48 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id EBF22227A8E; Mon,  4 Dec 2023 20:44:45 +0100 (CET)
Date: Mon, 4 Dec 2023 20:44:45 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, chandanbabu@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: don't set XFS_TRANS_HAS_INTENT_DONE when
 there's no ATTRD log item
Message-ID: <20231204194445.GA17769@lst.de>
References: <170162990150.3037772.1562521806690622168.stgit@frogsfrogsfrogs> <170162990183.3037772.16569536668272771929.stgit@frogsfrogsfrogs> <20231204050803.GI26073@lst.de> <20231204184348.GY361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231204184348.GY361584@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 04, 2023 at 10:43:48AM -0800, Darrick J. Wong wrote:
> Dave and Allison and I at some point realized that the defer ops
> machinery works even if ->create_intent and ->create_done return NULL.
> You'd lose the ability to restart the operation after a crash, but if
> the upper layers can tolerate a half-finished operation
> (e.g.  ATTR_INCOMPLETE) then that should be ok.
> 
> Obviously you wouldn't touch any such *existing* code except as part of
> adapting it to be capable of using log items, and that's exactly what
> Allison did.  She refactor the old xattr code to track the state of the
> operation explicitly, then moved all that into the ->finish_item
> implementation.  Now, if the setattr operation does not set the LOGGED
> flag (the default), the behavior should be exactly the same as before.
> If they do set LOGGED (either because the debug knob is set; or because
> the caller is parent pointers) then ->create_{intent,done} actually
> create log intent and done items.
> 
> It should never create an intent item and not the done item or the other
> way 'round, obviously.  Either both functions return NULL, or they both
> return non-NULL.

It would be really good to document this, the name LARP and why it is
considered a debug feature somewhere in the tree.  No need to hold
up this series for that of course.
