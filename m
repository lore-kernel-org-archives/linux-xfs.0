Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3KFIFe2101040 for <xfs@oss.sgi.com>; Wed, 20 Apr 2011 10:18:15 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 220A250FA52
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2011 08:21:42 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 1iJGiN8DrmXlyNzO for
	<xfs@oss.sgi.com>; Wed, 20 Apr 2011 08:21:42 -0700 (PDT)
Date: Wed, 20 Apr 2011 11:21:31 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Message-ID: <20110420152131.GA7123@infradead.org>
References: <4EEEA16E-1FDB-4430-A372-8F8701196E4C@mit.edu>
	<20110418004040.GS21395@dastard>
	<6C89E159-A5F6-4A06-A3D2-273BE4CFB9B5@dilger.ca>
	<BANLkTin=WEpSf6ddiOMNMOpCPP-wiEttSw@mail.gmail.com>
	<20110419034455.GB23985@dastard>
	<BANLkTinjh968ECqAobQ677hnV5yzke1ncw@mail.gmail.com>
	<20110419074538.GG23985@dastard> <20110419140909.GD3030@thunk.org>
	<4DAD987F.5000506@sandeen.net> <20110419160114.GE3030@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110419160114.GE3030@thunk.org>
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
To: Ted Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@dilger.ca>, Eric Sandeen <sandeen@sandeen.net>, Yongqiang Yang <xiaoqiangnk@gmail.com>, xfs-oss <xfs@oss.sgi.com>, "coreutils@gnu.org" <coreutils@gnu.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, P?draig Brady <P@draigbrady.com>, Markus Trippelsdorf <markus@trippelsdorf.de>

On Tue, Apr 19, 2011 at 12:01:14PM -0400, Ted Ts'o wrote:
> 1) We define it as only reflecting ondisk state, and nuke the delalloc
> flag from orbit.
> 
> 2) We state that if the file is currently has unflushed pages in the
> page cache, and FIEMAP_FLAG_SYNC is not passed, whether or not extents
> return the DELALLOC flag or how they handle the UNWRITTEN flag is
> undefined.

That seems like a weird option, as the pagecache state really has
nothing to do at all with the extent layout, and the existence of dirty
pages really has nothing to do with the unwritten flag.

> 3) We state that FIEMAP is supposed to return information which
> reflects the union of the on-disk and page cache state, with all that
> this implies.

How do you want to union the existance of an extent with a state
on disk, with a pending modification to it that is still in-memory
and not flushed out to disk yet?  This is looking into an uncertain
future, as the extent map might change in various other ways before
the transaction to conver the unwritten extents goes to disk.

And if we do this it would need to be a new option to FIEMAP, as
it changes the semantics from the existing one that returns the
actual state on disk (plus the magic delalloc bit).

And even if you find semantics that take pending unwrittent extent
conversions into account and still make sense how do you plan to
implement them?  For buffered writes into unwritten extents it could
be done by walking the pagecache and buffers after adding a new
flag for an already converted unwritten extent to the buffer head
state.  But there's no easy way to do that for direct I/O.

> In the case of #1 and #2, we really need to implement support for
> SEEK_HOLE/SEEK_DATA for userspace programs like cp who want to know
> this information.

We need to do that anyway, as fiemap is a horrible interface for
tools that just want to skip holes.  

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
