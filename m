Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 741E97F3F
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2014 14:26:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 03772AC004
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2014 12:26:29 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 33EtsRY77L1KsxV2 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 18 Oct 2014 12:26:27 -0700 (PDT)
Date: Sat, 18 Oct 2014 21:26:24 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/12 v2] Moving i_dquot out of struct inode
Message-ID: <20141018192624.GA16478@quack.suse.cz>
References: <1412952910-7142-1-git-send-email-jack@suse.cz>
	<20141011133452.GA29004@infradead.org>
	<20141017192428.GA19788@quack.suse.cz>
	<20141018151738.GG30355@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141018151738.GG30355@infradead.org>
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, linux-fsdevel@vger.kernel.org, tytso@mit.edu, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Sat 18-10-14 08:17:38, Christoph Hellwig wrote:
> On Fri, Oct 17, 2014 at 09:24:28PM +0200, Jan Kara wrote:
> >   I don't see the 4-bytes per inode saving, what am I missing? Frankly, I
> > don't see a difference in readability but since you and Al agree on that I
> > concede to your taste :)
> 
> It's the removal of s_inode_fields that saves 4 bytes.
  But that was in the superblock, not in the inode...
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
