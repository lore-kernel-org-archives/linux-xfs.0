Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A0D207CB4
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2016 10:41:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0A8F3AC003
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2016 08:41:31 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id bpzZuAW6UXqPpyOi (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Mar 2016 08:41:29 -0800 (PST)
Date: Wed, 2 Mar 2016 08:41:02 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: block allocations for the refcount btree
Message-ID: <20160302164102.GA20109@birch.djwong.org>
References: <20160210093011.GA19147@infradead.org>
	<20160210095010.GC23904@birch.djwong.org>
	<20160210190738.GA13051@infradead.org>
	<20160210214058.GN14668@dastard>
	<20160212191046.GA28421@infradead.org>
	<20160301181809.GC27973@birch.djwong.org>
	<20160301204013.GA23128@infradead.org>
	<20160302052411.GB1902@birch.djwong.org>
	<20160302095932.GA9141@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160302095932.GA9141@infradead.org>
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
Cc: xfs@oss.sgi.com

On Wed, Mar 02, 2016 at 01:59:32AM -0800, Christoph Hellwig wrote:
> On Tue, Mar 01, 2016 at 09:24:11PM -0800, Darrick J. Wong wrote:
> > I've rebased my trees and pushed them all to github.
> > 
> > The for-dave-for-4.6 kernel and progs branches are the giant piles of patches
> > against Dave's for-next integration trees which (I think) are being reviewed
> > for 4.6.
> > 
> > The for-dave branches are against upstream as they've always been.
> 
> BTW, what's the point of for-dave vs for-dave-for-4.6 for xfsprogs?

for-dave-for-4.6 = all the stuff I'm pushing to Dave for 4.6
for-dave = all the stuff from my dev tree minus the non-XFS stuff

("non XFS stuff" means all the ext4 fixes, etc.)

> > New patches have been added on the end of the patchset.
> > 
> > I noticed that generic/139 crashes for-dave with a 1k block size due something
> > or other sending us bio->bi_bdev == NULL.  This seems to be sorted out somehow
> > in for-next.  Other than that I haven't seen any problems... but I've only
> > run against x64 on bare XFS.  Will run other arches/NFS/etc tonight/tomorrow.
> > 
> > The transaction block reservation complaints should be fixed now, and I
> > think the transaction reservations have been fixed too... or at least they
> > don't show up on the tinydisk test setup.  But all that means is that someone
> > else will find it, probably within the first 3 minutes of testing. :P
> 
> Passes on NFS without hitting the space reservation issue, and passes
> on XFS without new regression.  The odd transaction (not space)
> reservation assert in xfs/140 that I started to myesteriously 100%
> reproduce last week still is around on XFS.  I'll see if I can fix that
> or at least triage it further..

Hmm, I'll give it a spin when I get in later.  Can you send me xfs_info
output so I can try to construct an equivalent reproducer setup?

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
