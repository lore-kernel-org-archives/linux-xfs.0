Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C898F7F69
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 05:57:45 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9A3F58F8037
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 03:57:42 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id U23wJaji4KxkaTzA (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Nov 2014 03:57:40 -0800 (PST)
Date: Mon, 24 Nov 2014 06:57:27 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH-v2 0/5] add support for a lazytime mount option
Message-ID: <20141124115727.GA19918@thunk.org>
References: <1416675267-2191-1-git-send-email-tytso@mit.edu>
	<20141124090755.GA28534@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141124090755.GA28534@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Nov 24, 2014 at 01:07:55AM -0800, Christoph Hellwig wrote:
> What's the test coverage for this?  xfstest generic/192 tests that
> atime is persisted over remounts, which we had a bug with when XFS
> used to have a lazy atime implementation somewhat similar to the
> proposal.
> 
> We should have something similar for c/mtime as well.  Also a test to
> ensure timestamps are persisted afer a fsync, although right now I can't
> imagine how to do that genericly as no other filesystem seems to have
> an equivaent to XFS_IOC_GOINGDOWN.

generic/003 will show up problems if there are any [acm]time
persistences across remounts, so we have it already.  An earlier
(buggy) version of this patch actually tripped generic/003, so I can
attest that it works.

As far as testing to make sure timestamps are persisted after an
fsync, we should be able to do something genericly using dm_flaky, I
would imagine.  We'll need to suppress this in some circumstances
where we know that the file system doesn't have a journal enabled (and
thus has no such guarantees) but I have that issue today with the
various dm_flaky tests, and what I would probably suggest doing is
putting all of the dm_flaky tests in a separate xfstests group, so
that when I test file system configurations in nojournal mode, I can
suppress all of the dm_flakey tests very easily.

> It seems you also handle i_version updates lazily. although that's
> not mentioned anywhere.  I actually have a clarification request out on
> the IETF NFSv4 list about the persistance requirements for the change
> counter but I've not seen an answer to it yet.

If we want to be paranoid, we handle i_version updates non-lazily; I
can see arguments in favor of that.

Ext4 only enables MS_I_VERSION if the user asks for it explicitly, so
it wouldn't cause me any problems.  However, xfs and btrfs enables it
by default, so that means xfs and btrfs wouldn't see the benefits of
lazytime (if you're going to have to push I_VERSION to disk, you might
as well update the [acm]time while you're at it).  I've always thought
that we *should* do is to only enable it if nfsv4 is serving the file
system, and not otherwise, though, which would also give us
consistency across all the file systems.

What do folks think?

					- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
