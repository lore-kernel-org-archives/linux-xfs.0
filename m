Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 513A029DF6
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 10:28:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0F2A5304053
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 08:27:59 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id WGJYY3NyxEjonxmo (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Jan 2016 08:27:57 -0800 (PST)
Date: Mon, 11 Jan 2016 17:28:07 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/4] quota: add new quotactl Q_XGETQUOTA2
Message-ID: <20160111162807.GK6262@quack.suse.cz>
References: <568FEA2C.6080708@redhat.com>
	<20160109072600.GA21636@infradead.org>
	<20160111132617.GD6262@quack.suse.cz>
	<5693D33A.5090307@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5693D33A.5090307@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com, Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>

On Mon 11-01-16 10:07:22, Eric Sandeen wrote:
> On 1/11/16 7:26 AM, Jan Kara wrote:
> > On Fri 08-01-16 23:26:00, Christoph Hellwig wrote:
> >> On Fri, Jan 08, 2016 at 10:56:12AM -0600, Eric Sandeen wrote:
> >>> This adds a new quotactl, Q_XGETQUOTA2.
> >>>
> >>> Q_XGETQUOTA2 is exactly like Q_XGETQUOTA, except that it will
> >>> return quota information for the id equal to or greater than
> >>> the id requested.  In other words, if the specified id has
> >>> no quota, the command will return quota information for the
> >>> next higher id which does have a quota set.  If no higher id
> >>> has an active quota, -ESRCH is returned.
> >>
> >> Please add a flags argument to Q_XGETQUOTA2, and then make the
> >> new behavior the first flag.  Keep Q_XGETQUOTA behavior for the
> >> flag-less case.  That way we get future etensibility for free.
> > 
> > So this is what I wanted to suggest at first as well. What I somewhat
> > dislike is that 'addr' must now point to something like:
> > 
> > struct getquota_args {
> > 	__u64 flags;
> > 	struct fs_disk_quota ret;
> > };
> 
> Ok...
> 
> > which is not as nice as passing pointer to fs_disk_quota directly. But
> > probably still OK. So I agree with the flags idea.
> 
> I understand that flags are for future-proofing, for possibly-not-yet-imagined
> scenarios, but on the other hand, I wonder how many different flavors of
> "get me a disk quota" we really expect to have?
> 
> > Another issue is that OCFS2 and ext4 with quota in hidden inodes would need
> > call with these capabilities as well (they have the same problem as xfs).
> > For reporting VFS quota we use bytes for space (since some filesystems need
> > it) and we don't need RT fields (easy so zero-fill) and warning fields
> > (there zeros may be confusing). So we would need something like struct
> > qc_dqblk (currently only internal) extended with ID and maybe flags field
> > XFS is using to return quota type which can contain all the information and
> > tell which info is actually valid as return structure.
> 
> Hohum, yeah - I forgot that ext4 has (can have?) a hidden quota inode.
> And I didn't know about OCFS2.
> 
> And TBH I did the xfs-specific one because it was trivial to extend, with the
> id already in the returned quota struct.
> 
> So ok, it sounds like this needs a more significant overhaul at the vfs
> quota level...

Actually, what I want from you is just an interface which is usable for VFS
quotas as well since I'd like to avoid adding GETQUOTA2 quotactl shortly
after XGETQUOTA2 :). Using id as a cooking is fine for VFS quotas as well so
that part can stay.

I can have a look at implementing the new handler for VFS quota format(s)
which should be pretty easy once the interface part is merged or you can
do it if you're interested in learning more about quota internals.

									Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
