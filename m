Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F145F7F4E
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 15:04:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8C13FAC001
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 13:04:25 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 9KbK3Kq1RQnnXk8f (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Mar 2014 13:04:20 -0800 (PST)
Date: Tue, 4 Mar 2014 13:04:17 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: add a test for unlinked inodes due to O_TMPFILE
Message-ID: <20140304210417.GA10628@infradead.org>
References: <20140304172103.GA24528@infradead.org>
	<20140304172148.GC24528@infradead.org>
	<20140304203927.GG6851@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140304203927.GG6851@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, Zhi Yong Wu <zwu.kernel@gmail.com>, xfs@oss.sgi.com

On Wed, Mar 05, 2014 at 07:39:27AM +1100, Dave Chinner wrote:
> > +_supported_fs generic
> 
> XFS only.

Hmm.  I remember fixing this up, but for some reason it didn't make it
into the final patch.

> > +# test creating a r/w tmpfile, do I/O and link it into the namespace
> > +$XFS_IO_PROG -x -T \
> > +	-c "pwrite 0 4096" \
> > +	-c "pread 0 4096" \
> > +	-c "freeze" \
> > +	-c "thaw" \
> > +	-c "shutdown" \
> > +	${SCRATCH_MNT} | _filter_xfs_io
> 
> $testfile?

No, O_TMPFILE doesn't take an actual file name but a "virtual" parent
directory.  It's a reall creative abuse of the open ABI..

> Also, I don't see the file being linked into the namespace, so the
> comment is probably wrong. Also, please add a comment as to
> why the freeze/thaw is necessary.

Yes, we don't want to link it so that we have it on the unlinke dinode
list.  The freeze/thaw is to make sure the log has been cleaned, I'll
add a comment explaining it.

> There it is, but is moving it to lost+found the right thing to do,
> given that it was on the unlinked list and should have had a zero
> link count? i.e. aren't we supposed to free unlinked inodes with a
> zero link count, not recover them to lost+found?

> Yeah, that seems like the wrong behaviour to have for an anonymous
> O_TMPFILE file - it's making it visible because we moved it to
> lost+found in phase 6....

Good question.  I thought about this a little and decided that it wasn't
worth special casing O_TMPFILE inodes in repair, but thinking about it a
bit more this also happens for normal unlinked but open files.  I can
look into this if you want, and would create another test for that case.

> 
> Also, I don't see any icount mismatch, so the comment above in the
> test is probably wrong.

We do have an icount mismatch, but _filter_repair filters it away.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
