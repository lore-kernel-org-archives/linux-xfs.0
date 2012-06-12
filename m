Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5CEWOc3252068 for <xfs@oss.sgi.com>; Tue, 12 Jun 2012 09:32:25 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id XWAO7HRlPPHsbqsK (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 12 Jun 2012 07:32:23 -0700 (PDT)
Date: Tue, 12 Jun 2012 16:32:20 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 18/27] xfs: Convert to new freezing code
Message-ID: <20120612143220.GG6021@quack.suse.cz>
References: <1339510848-16992-1-git-send-email-jack@suse.cz>
	<1339510848-16992-19-git-send-email-jack@suse.cz>
	<20120612142346.GA25132@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120612142346.GA25132@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Alex Elder <elder@kernel.org>, Jan Kara <jack@suse.cz>, linux-fsdevel@suse.cz, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Al Viro <viro@ZenIV.linux.org.uk>

On Tue 12-06-12 10:23:47, Christoph Hellwig wrote:
> > +	 * We will pass freeze protection with a transaction.  So tell lockdep
> > +	 * we released it.
> > +	 */
> > +	rwsem_release(&ioend->io_inode->i_sb->s_writers.lock_map[SB_FREEZE_FS-1],
> > +		      1, _THIS_IP_);
> 
> I'll need some time to get through the whole series, but repeated use
> of constructs like this really screams for a helper abstracting it out
> and documenting it.
  It's there twice and only in XFS because XFS needs to pass the freeze
protection (along with a transaction) to a worker thread. I'm not against a
helper but then it should probably be in a form to allow easy
instrumentation of lockdep that we are passing a state of lock together
with a work struct?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
