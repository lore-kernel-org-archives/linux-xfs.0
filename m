Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3J5OI25022998 for <xfs@oss.sgi.com>; Tue, 19 Apr 2011 00:24:20 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E20C61E0FF7A
	for <xfs@oss.sgi.com>; Mon, 18 Apr 2011 22:27:44 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id RCpzW5O8jMOqTk3k for
	<xfs@oss.sgi.com>; Mon, 18 Apr 2011 22:27:44 -0700 (PDT)
Date: Tue, 19 Apr 2011 01:27:32 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Message-ID: <20110419052732.GA19952@infradead.org>
References: <4DA7836A.5040604@draigBrady.com> <20110415000940.GL21395@dastard>
	<76FFF648-CA02-494B-A862-566C66A8CB82@dilger.ca>
	<20110416005040.GP21395@dastard>
	<E7438588-5C5A-42B9-9B6C-FADF7CAC6D3A@dilger.ca>
	<4EEEA16E-1FDB-4430-A372-8F8701196E4C@mit.edu>
	<20110418004040.GS21395@dastard>
	<6C89E159-A5F6-4A06-A3D2-273BE4CFB9B5@dilger.ca>
	<BANLkTin=WEpSf6ddiOMNMOpCPP-wiEttSw@mail.gmail.com>
	<20110419025949.GA3030@thunk.org>
MIME-Version: 1.0
In-Reply-To: <20110419025949.GA3030@thunk.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5770914219193217563=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ted Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@dilger.ca>, Eric Sandeen <sandeen@sandeen.net>, Yongqiang Yang <xiaoqiangnk@gmail.com>, xfs-oss <xfs@oss.sgi.com>, "coreutils@gnu.org" <coreutils@gnu.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, P?draig Brady <P@draigbrady.com>, Markus Trippelsdorf <markus@trippelsdorf.de>

--===============5770914219193217563==
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Apr 18, 2011 at 10:59:49PM -0400, Ted Ts'o wrote:
> Maybe coreutils will need to use FIEMAP_FLAG_SYNC initially, since
> it's the only way to guarantee correct behaviour for XFS.  But I would
> really rather that be the long-term way we leave things!

As Eric pointed out both ext4 and XFS have the same behaviour when
writing into unwritten extent.  I think you are a bit confused because
ext4 also got basic handling of delalloc extents wrong before commit
6d9c85eb700bd3ac59e63bb9de463dea1aca084c, which never was a problem with
XFS.  It would be nice if ext4 developers had sent the included
regression test for xfs so that everyone could verify this behaviour,
btw.

To report written to but not synced unwritten extents properly we'd
need to move fiemap away from the onðdisk state reporting done so far
and do something that is purely in-memory.  It would be doable by
walking the pagecache and checking for the buffer unwritten flag
in a loop over the pages, but I'm honestly not sure it's going to
help much.  In fact given that unwritten extent were specifically
allocated before it doesn't seem like an overly smart idea to skip
them in a copy - yes it will save space but it also undoes the
previous explicit preallocation.  If people want it they should rather
add a new option to cp to turn zeroes into holes.


--===============5770914219193217563==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5770914219193217563==--
