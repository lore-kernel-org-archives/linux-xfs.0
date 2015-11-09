Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4CD787F37
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 01:59:45 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2D6CA8F8033
	for <xfs@oss.sgi.com>; Sun,  8 Nov 2015 23:59:42 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id AGrnRdgNH3sWJaRj (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 08 Nov 2015 23:59:33 -0800 (PST)
Date: Sun, 8 Nov 2015 23:59:26 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFCv3 00/12] xfstests: test the btrfs/xfs reflink/dedupe ioctls
Message-ID: <20151109075926.GB17974@infradead.org>
References: <20151007051257.3260.73072.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151007051257.3260.73072.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org

On Tue, Oct 06, 2015 at 10:12:57PM -0700, Darrick J. Wong wrote:
>  * I don't have any interesting NFS/CIFS setups for test. :(

I have a banrch with client and server support for NFSv4.2 CLONE
support:

http://git.infradead.org/users/hch/pnfs.git/shortlog/refs/heads/reflink+clone

For now you want to use btrfs on the server, as using reflinks on XFS
seems to be a little unstable over NFS.

> If you're going to start using this mess, you probably ought to just
> pull from my github trees for kernel[1], xfsprogs[2], and xfstests[3].
> They should just work with the btrfs that's in 4.3.
> 
> Comments and questions are, as always, welcome.

Any reason the groups are called clone?  I don't really have an opinion
on clone vs reflink but given that the xfs_io command is reflink I'd
rather be consistent.

Otherwise I'd say get it merged ASAP, we can still fix up various
details later.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
