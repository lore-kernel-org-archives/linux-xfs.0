Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E6FFF7F57
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2014 11:51:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D19DA30404E
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2014 09:51:54 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 1coNKIrGPXSblQnv (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 Oct 2014 09:51:53 -0700 (PDT)
Date: Wed, 22 Oct 2014 18:51:50 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 02/12] quota: Allow each filesystem to specify which
	quota types it supports
Message-ID: <20141022165150.GA12809@quack.suse.cz>
References: <1413902316-17997-1-git-send-email-jack@suse.cz>
	<1413902316-17997-3-git-send-email-jack@suse.cz>
	<20141022162915.GB18443@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141022162915.GB18443@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, linux-fsdevel@vger.kernel.org, tytso@mit.edu, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Wed 22-10-14 18:29:15, Christoph Hellwig wrote:
> On Tue, Oct 21, 2014 at 04:38:26PM +0200, Jan Kara wrote:
> > Currently all filesystems supporting VFS quota support user and group
> > quotas. With introduction of project quotas this is going to change so
> > make sure filesystem isn't called for quota type it doesn't support by
> > introduction of a bitmask determining which quota types each filesystem
> > supports.
> 
> Why don't you keep this bitmask in the dquot.c instead of pushing it
> to the caller?  So far usage of s_dquot is mostly confined to dquot.c
> (with a few leaks to the filesystems using it), so keeping it that
> way seems like a good idea.
  So there are two reasons:
1) Currently if you call quotactl() with invalid quota type you'll get
EINVAL. To maintain this with addition of project quotas you need to check
the types early before calling check_quotactl_permission() and other
checks.

2) I didn't want filesystem quotactl callbacks to deal with quota types
they don't support. Sure each fs could do a type check in the callback but
this looked easier.

Now I see your point about s_dquot and I can move allowed_types out of
s_dquot if that makes you happier. But otherwise what I did still seems as
the best solution to me.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
