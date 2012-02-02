Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q129DZx5041413 for <xfs@oss.sgi.com>; Thu, 2 Feb 2012 03:13:35 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	2lp24AOr0YkkK2Nn (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Feb 2012 01:13:31 -0800 (PST)
Date: Thu, 2 Feb 2012 04:13:30 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Inode lockdep problem observed on 2.6.37.6 xfs with RT subvolume
Message-ID: <20120202091330.GA31203@infradead.org>
References: <CAC=U0a1huHVULfMObyH_XNcQi5aTZtrbpcciNhw=92PE96f4cg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAC=U0a1huHVULfMObyH_XNcQi5aTZtrbpcciNhw=92PE96f4cg@mail.gmail.com>
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
To: Kamal Dasu <kdasu.kdev@gmail.com>
Cc: cernekee@gmail.com, xfs@oss.sgi.com

On Wed, Feb 01, 2012 at 07:44:13PM -0500, Kamal Dasu wrote:
> Need some help understanding the state of xfs with rt subvolume
> support on 2.6.37.
> 
> When using xfs rt subvolume on a harddisk partition with kernel
> 2.6.37.6,and normal r/w/delete file operations? causes deadlock
> like hangs .? Failure? symptoms are lockups and mount failure on reboot.
> 
> On further investigation it was found that one of the changes could be
> the cause.
> The same tests seem to pass with xfs in 2.6.31 kernel.
> 
> xfs: simplify xfs_trans_iget? : aa72a5cf00001d0b952c7c755be404b9118ceb2e
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commitdiff;h=aa72a5cf00001d0b952c7c755be404b9118ceb2e
> 
> Reverting the change and forward porting to the xfs_trans_inode() seems to
> get rid of the deadlock and mount issues .
> 
> Below is the change

Please just upgrade to Linux 2.6.39 or better Linux 3.0 which is the
long term support release. RT subvolume support has been fixed in 2.6.39
by the following changes:

  xfs: only lock the rt bitmap inode once per allocation
  xfs: fix xfs_get_extsz_hint for a zero extent size hint
  xfs: add lockdep annotations for the rt inodes

But in general the RT subvolume code is not regularly tested and only
fixed when issues arise.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
