Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D08EA7F4E
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2015 16:23:24 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AD9188F8040
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2015 14:23:24 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id qdN4guoFuBmAQJB7 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 21 Jan 2015 14:23:23 -0800 (PST)
Date: Wed, 21 Jan 2015 23:23:20 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/17 v3] quota: Unify VFS and XFS quota interfaces
Message-ID: <20150121222320.GA30154@quack.suse.cz>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
	<20150121213826.GL16510@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150121213826.GL16510@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

On Thu 22-01-15 08:38:26, Dave Chinner wrote:
> On Fri, Jan 16, 2015 at 01:47:34PM +0100, Jan Kara wrote:
> >   Hello,
> > 
> >   this is another iteration of patches to unify VFS and XFS quota interfaces so
> > that XFS quotactls work for filesystems with VFS quotas and vice versa.  This
> > is useful so that userspace doesn't have to care that much about which
> > filesystem it is using at least when using basic quota functionality. In
> > particular we should be able to reuse project quota tests in xfstests for ext4.
> > 
> > The patches are based on quota cleanup series [1] and XFS cleanup series [2]
> > I've sent previously and based on 3.19-rc4 + for-next branch of XFS tree.  I
> > could further split this series into per-quotactl series but frankly I don't
> > think it will help reviewers in any way (the patches in the current series are
> > already ordered by quotactl).
> 
> Hi Jan,
> 
> Do you have a this series in a git tree somewhere so it's easy to
> merge and test?
  I've pushed out the series to:
git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git quota_interface

  BTW, I've already implemented suggestions by Christoph so it's not
exactly what was sent to the list (but very close). I'd also welcome your
opinion on usage of BBTOB() and BTOBB() macros in fs/quota/quota.c - to be
able to use them I have to move them out of fs/xfs/libxfs/xfs_fs.h to
somewhere in include/. Christoph doesn't like it much and would prefer
quota code just opencoded these macros. I don't really care but you two
should agree :)

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
