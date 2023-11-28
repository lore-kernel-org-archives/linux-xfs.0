Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7437910F6
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 09:13:05 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 314BB227A87; Tue, 28 Nov 2023 18:13:02 +0100 (CET)
Date: Tue, 28 Nov 2023 18:13:01 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: Re: XBF_DONE semantics
Message-ID: <20231128171301.GA27293@lst.de>
References: <20231128153808.GA19360@lst.de> <20231128165831.GW2766956@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128165831.GW2766956@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 28, 2023 at 08:58:31AM -0800, Darrick J. Wong wrote:
> > The way we currently set and check XBF_DONE seems a bit undefined.  The
> > one clear use case is that read uses it to see if a buffer was read in.
> > But places that use buf_get and manually fill in data only use it in a
> > few cases.  Do we need to define clear semantics for it?  Or maybe
> > replace with an XBF_READ_DONE flag for that main read use case and
> > then think what do do with the rest?
> 
> I thought XBF_DONE meant "contents have been read in from disk and
> have passed/will pass verifiers"

That's what I though too.  But there's clearly code that treats it
differently..

> Dave and I wondered if xfs_inode_item_precommit should be grabbing the
> buffer at all when ISTALE is set, since xfs_ifree_cluster should have
> staled (and invalidated) the buffer after setting ISTALE.

That does sound reasonable.

> > +++ b/fs/xfs/xfs_trans_buf.c
> > @@ -253,7 +253,6 @@ xfs_trans_read_buf_map(
> >  		ASSERT(bp->b_transp == tp);
> >  		ASSERT(bp->b_log_item != NULL);
> >  		ASSERT(!bp->b_error);
> > -		ASSERT(bp->b_flags & XBF_DONE);
> 
> I don't think this is the right thing to do here -- if the buffer is
> attached to a transaction, it ought to be XBF_DONE.  I think every
> transaction that calls _get_buf and rewrites the buffer contents will
> set XBF_DONE via xfs_trans_dirty_buf, right?
> 
> Hmm.  Maybe I'm wrong -- a transaction could bjoin a buffer and then
> call xfs_trans_read_buf_map before dirtying it.  That strikes me as a
> suspicious thing to do, though.

I suspect it's happening here somehow.  I can try to find some more
time pinning it down.
