Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DF4437F3F
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 11:33:11 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6C78BAC00B
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 09:33:11 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id GMPMKKEtRuIWt6w6 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 20 Jan 2015 09:33:09 -0800 (PST)
Date: Tue, 20 Jan 2015 18:33:07 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 12/17] xfs: Convert to using ->get_state callback
Message-ID: <20150120173307.GH3648@quack.suse.cz>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
	<1421412471-4747-13-git-send-email-jack@suse.cz>
	<20150119093810.GA16484@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150119093810.GA16484@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

On Mon 19-01-15 01:38:10, Christoph Hellwig wrote:
> > +static void xfs_qm_fill_state(struct qc_type_state *tstate,
> 
> Normal xfs style would be to keep the "static void " on a separate line,
> as well as the arguments, e.g.
  OK, will change it to conform to the XFS coding style.

> static void
> xfs_qm_fill_state(
> 	struct qc_type_state	*tstate,
> 
> >
> > +			      struct xfs_mount *mp,
> > +			      struct xfs_inode *ip,
> > +			      xfs_ino_t ino)
> 
> No need to pass mp, as it can be derived as ip->i_mount.
  Good point.

> Btw, I think this code should move into xfs_quotaops.c now
> that it ties into the Linux quota interface, and xfs_qm_scall_getstate
> should be folded into xfs_fs_get_quota_state.
  OK, will do.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
