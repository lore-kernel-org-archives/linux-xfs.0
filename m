Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEB128468E;
	Tue, 10 Mar 2026 05:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773120341; cv=none; b=Orw65FWLbf//Vrb7Q5ZfLU3QSoFUiX/OO7gviQmzD57LxSAvNq4jb+FgtOK6tmH2/RGFzek5IFhhCox0idQqRw3Q+eh7D2ZF8VXRzO32nZ7tHch4x2Z6wVJeDINnIS+311yTJ7gdlDfOs7cBlW1KA2W9Ph/zbRYGK5qZU1OZVzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773120341; c=relaxed/simple;
	bh=5I38SsuA26SHexDAcaLUC+zhqCpO76PO36SQrHpQVU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h9X1ni8+4vzpmERInOuYIGTAZe8yt6n3wTI42nPDL1efQMpVa+zhNUwL/a4gMZNyM7NrryDKPf4FWp4r/g+QmZ2vcH6IveqlasqTx31nsrtAjctSuc3jHnty+/7+UOFqBc+Smkwhedrr+OmelU6M9MOKwcQ2cqsbphNt7iggJbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DVJnME18; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DVJnME18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F670C19423;
	Tue, 10 Mar 2026 05:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773120341;
	bh=5I38SsuA26SHexDAcaLUC+zhqCpO76PO36SQrHpQVU8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DVJnME188ECxhV/zFHgqy6BkcgPFxqAA2HiMW28a7J+wxo6gUfu3mWDMwJZAFL3jY
	 6ofYsPzwVCfphqAfEMXm+hRLHRB9tD0G3RzEDqriKbFHNlYzdJ6D59WxksdpCACxkE
	 6mfOCbIs/NNgw3gIDyEeRGk32W2/PyP28dOL8+U+vJJ5d2Y/jj2N1ndvs5SRCS0IAk
	 YnO9qXiqnEqwADE+wTkkwDEjxYyT4SmpzLUCbJzBKImAsLp1c4qvqPGWDKMHinyUxz
	 XFe4cRNf5wTDR1xO3PDxjZNzmy2KaATbObOQUN5cYQiJIdOj6EEcz3UU+U777UBkMB
	 JnI/xnRvZAsZw==
Date: Tue, 10 Mar 2026 16:25:34 +1100
From: Dave Chinner <dgc@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Yuto Ohnuki <ytohnuki@amazon.com>, Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <darrick.wong@oracle.com>,
	Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 3/4] xfs: avoid dereferencing log items after push
 callbacks
Message-ID: <aa-rTmOyWSsiEaa7@dread>
References: <20260308182804.33127-6-ytohnuki@amazon.com>
 <20260308182804.33127-9-ytohnuki@amazon.com>
 <20260309162710.GC6033@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309162710.GC6033@frogsfrogsfrogs>

On Mon, Mar 09, 2026 at 09:27:10AM -0700, Darrick J. Wong wrote:
> On Sun, Mar 08, 2026 at 06:28:08PM +0000, Yuto Ohnuki wrote:
> > After xfsaild_push_item() calls iop_push(), the log item may have been
> > freed if the AIL lock was dropped during the push. The tracepoints in
> > the switch statement dereference the log item after iop_push() returns,
> > which can result in a use-after-free.
> 
> How difficult would it be to add a refcount to xfs_log_item so that any
> other code walking through the AIL's log item list can't accidentally
> suffer from this UAF?  I keep seeing periodic log item UAF bugfixes on
> the list, which (to me anyway) suggests we ought to think about a
> struct(ural) fix to this problem.
> 
> I /think/ the answer to that is "sort of nasty" because of things like
> xfs_dquot embedding its own log item.  The other log item types might
> not be so bad because at least they're allocated separately.  However,
> refcount_t accesses also aren't free.

It's nasty for many reasons. The biggest one is that the log item
isn't valid as a stand-alone object. Once the owner item has been
freed, any attempt to use the log item requires dereferencing back
to the owner object, and now we have a different set of UAF
problems.

For example, we can't leave log items in the AIL after freeing the
owner object because we have to write the owner object to disk to
remove the log item from the AIL. The log item has to be removed
from the AIL before we free the high level item the log item belongs
to.

Hence the life time of a log item must always be a subset of the
owner object. That is where log item reference counting becomes an
issue - for it to work the log item has to hold a reference to the
owner object.

We already have log items that do this: the BLI is one example.

However, other UAF issues on log items come from using reference
counts and the needing references and (potentially) locks on the
owner object. Those complexities end up causing - you guessed it -
UAF problems...

For example: the BLI keeps a reference count for all accesses to the
BLI *except* for the AIL reference, because the AIL can't keep
active references to dirty high level objects.

For example: releasing the last reference to some high level objects
(e.g. inodes) can result in them being journalled, and hence the
journalling subsystem now has to be able to track and process those
dirty high level items without holding an active reference to them.

For example: The BLI reference count/buffer locking model is all the
complexity in freeing metadata extents (stale buffers) comes from.
At transaction completion, the transaction reference to the BLI and
the buffer lock is transferred to the CIL (the journal) and is only
then released on completion of the journal IO. This is how we
prevent a buffer from being reused whilst the transaction freeing
underlying storage is in flight - the buffer needs to remain locked
until the freeing transaction(s) is stable in the journal. This
complexity is where all the UAF in the BLI unpinning operations come
from.

Normally, the transaction reference and buffer lock are released
when the transaction context is torn down after the commit
completes. The problems with UAFs in this BLI code comes from the
fact that stale, pinned buffers have been transferred to the CIL and
the transaction no longer owns the BLI reference...

And then, of course, is the fact that the AIL cannot rely on log
items with referenced owner objects.  Hence the high level items
tracked in the AIL are, at times, tracking otherwise unreferenced
items.

IOWs, we have problems with UAF w.r.t. buffers and BLIs because of
the mess of the BLI reference counting model. And we have problems
with ILI/inode life times because the ILI does not take references
to the inode and it is assumed it is never freed until the inode
itself is torn down. And neither buffers, inodes, BLIs nor ILIs are
reference counted when they are on the AIL.

The impact of this is two-fold:

1. it requires high level object reclaim to be aware of dirty items
and to be able to skip over them; and
2. unmount requires explicitly AIL pushing because the AIL
might be the only remaining subsystem that tracks the unreferenced
object that we need to reclaim before unmount can progress. This is
especially true for shutdown filesystems.

Ideally xfs_reclaim_inode() would not be trying to abort dirty
inodes on shutdown. Historically speaking, this functionality has
been necessary because there were times without other mechanisms to
abort and clean dirty, unreferenced inodes and this would result in
unount on shutdown filesystems hanging.

I suspect those times are long since passed - all dirty inodes are
tracked in the journal and unmount pushes all dirty objects - so
maybe the lesson here is that we could be carrying historic code
that worked around shutdown bugs that ino longer occur and so we no
longer need...

So, yeah, I agree that it would be be great to untangle all this
mess, but my experience qwith trying to untangle it over the years
is that the a can of worms it opens gets all tangled up in the
ball of string I'm trying to untangle....

-Dave.
-- 
Dave Chinner
dgc@kernel.org
