Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4ABF27F55
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2014 11:29:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DAB7AAC009
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2014 09:29:22 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id cOpkcAVAFESjQdzm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 Oct 2014 09:29:21 -0700 (PDT)
Date: Wed, 22 Oct 2014 18:29:15 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/12] quota: Allow each filesystem to specify which
	quota types it supports
Message-ID: <20141022162915.GB18443@lst.de>
References: <1413902316-17997-1-git-send-email-jack@suse.cz>
	<1413902316-17997-3-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1413902316-17997-3-git-send-email-jack@suse.cz>
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, hch@lst.de, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Tue, Oct 21, 2014 at 04:38:26PM +0200, Jan Kara wrote:
> Currently all filesystems supporting VFS quota support user and group
> quotas. With introduction of project quotas this is going to change so
> make sure filesystem isn't called for quota type it doesn't support by
> introduction of a bitmask determining which quota types each filesystem
> supports.

Why don't you keep this bitmask in the dquot.c instead of pushing it
to the caller?  So far usage of s_dquot is mostly confined to dquot.c
(with a few leaks to the filesystems using it), so keeping it that
way seems like a good idea.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
