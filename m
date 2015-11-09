Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4928C7CBF
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 12:49:46 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0DC838F8033
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 10:49:45 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 62x1FJCW04zV2akQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 09 Nov 2015 10:49:43 -0800 (PST)
Date: Mon, 9 Nov 2015 10:49:13 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFCv3 00/12] xfstests: test the btrfs/xfs reflink/dedupe ioctls
Message-ID: <20151109184913.GB3255@birch.djwong.org>
References: <20151007051257.3260.73072.stgit@birch.djwong.org>
	<20151109075926.GB17974@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151109075926.GB17974@infradead.org>
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
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org

On Sun, Nov 08, 2015 at 11:59:26PM -0800, Christoph Hellwig wrote:
> On Tue, Oct 06, 2015 at 10:12:57PM -0700, Darrick J. Wong wrote:
> >  * I don't have any interesting NFS/CIFS setups for test. :(
> 
> I have a banrch with client and server support for NFSv4.2 CLONE
> support:
> 
> http://git.infradead.org/users/hch/pnfs.git/shortlog/refs/heads/reflink+clone
> 
> For now you want to use btrfs on the server, as using reflinks on XFS
> seems to be a little unstable over NFS.

I found a few more bugs in the kernel-side implementation, which might explain
that.  I'm about to start working on making CoW less crappy, but I'll push all
the patches out to github.  (I wasn't planning on patchbombing again until
December.)

> > If you're going to start using this mess, you probably ought to just
> > pull from my github trees for kernel[1], xfsprogs[2], and xfstests[3].
> > They should just work with the btrfs that's in 4.3.
> > 
> > Comments and questions are, as always, welcome.
> 
> Any reason the groups are called clone?  I don't really have an opinion
> on clone vs reflink but given that the xfs_io command is reflink I'd
> rather be consistent.

The existing btrfs reflink tests were tagged in the 'clone' group prior to my
patchset.

> Otherwise I'd say get it merged ASAP, we can still fix up various
> details later.

I'll merge your patch and repost the whole pile of tests.  I'm almost ready to
send a pile of updates for the XFS on-disk structure document which add stuff
about the v5 format, rmapbt, and reflink.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
