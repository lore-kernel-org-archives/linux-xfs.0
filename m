Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 04B137F37
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 01:46:44 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E6AB630405F
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 23:46:43 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id bIc3SqUI3NbKzoLg (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2016 23:46:42 -0800 (PST)
Date: Tue, 12 Jan 2016 23:46:40 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_db: check on-disk structure sizes
Message-ID: <20160113074640.GA21939@infradead.org>
References: <20160111234644.GB7831@birch.djwong.org>
	<20160112140122.GC12156@bfoster.bfoster>
	<20160113012945.GC2455@birch.djwong.org>
	<5695C01F.7030807@sandeen.net> <20160113054730.GQ10456@dastard>
	<10021348-43A2-465E-BC00-E0A0882FFD22@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <10021348-43A2-465E-BC00-E0A0882FFD22@sandeen.net>
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
Cc: xfs@oss.sgi.com

On Wed, Jan 13, 2016 at 12:02:36AM -0600, Eric Sandeen wrote:
> > As I've pointed out previously to Darrick: xfstests:/tests/xfs/122
> > 
> > Make that build again, update it.
> > 
> Oh, I went looking for that and missed it somehow, thought it had been removed.   Ok then!

The real issue is that build environment change alignments.  32 vs 64
bit builds are obvious, but on some architectures different ABIs have
different alignments (we had some fun with ARM in that regard),
nevermind the equivalents to IRIX n32 popping up everywhere these days
that make things complicated.

I'd really love to have Darrick's check in xfs_format.h as an opt-in
if a build time assert is provided - that way every user can check it
doesn't screw up the structures.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
