Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C9B047F51
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2014 03:53:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4D39FAC004
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2014 01:53:56 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id uhxA3ZPeUXkGtB6u (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 Oct 2014 01:53:54 -0700 (PDT)
Date: Thu, 23 Oct 2014 10:53:50 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/12] quota: Allow each filesystem to specify which
	quota types it supports
Message-ID: <20141023085349.GA30381@lst.de>
References: <1413902316-17997-1-git-send-email-jack@suse.cz>
	<1413902316-17997-3-git-send-email-jack@suse.cz>
	<20141022162915.GB18443@lst.de>
	<20141022165150.GA12809@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141022165150.GA12809@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Wed, Oct 22, 2014 at 06:51:50PM +0200, Jan Kara wrote:
>   So there are two reasons:
> 1) Currently if you call quotactl() with invalid quota type you'll get
> EINVAL. To maintain this with addition of project quotas you need to check
> the types early before calling check_quotactl_permission() and other
> checks.
> 
> 2) I didn't want filesystem quotactl callbacks to deal with quota types
> they don't support. Sure each fs could do a type check in the callback but
> this looked easier.
> 
> Now I see your point about s_dquot and I can move allowed_types out of
> s_dquot if that makes you happier. But otherwise what I did still seems as
> the best solution to me.

Moving it out of s_dquot seems very sensible to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
