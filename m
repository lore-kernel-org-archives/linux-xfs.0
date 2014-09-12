Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AD85C7FA7
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2014 15:53:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8D5A78F8037
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2014 13:53:13 -0700 (PDT)
Date: Fri, 12 Sep 2014 13:53:11 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] Unicode/UTF-8 support for XFS
Message-ID: <20140912205311.GA11717@infradead.org>
References: <20140911203735.GA19952@sgi.com>
 <20140912100230.GB4267@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140912100230.GB4267@dastard>
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
Cc: Ben Myers <bpm@sgi.com>, tinguely@sgi.com, olaf@sgi.com, xfs@oss.sgi.com

On Fri, Sep 12, 2014 at 08:02:30PM +1000, Dave Chinner wrote:
> > Implementation notes.
> > 
> > Strings are normalized using a trie that stores the relevant information.
> > The trie itself is part of the XFS module, and about 250kB in size. The
> > trie is not checked in: instead we add the source files from the Unicode
> > Character Database and a program that creates the header containing the
> > trie.
> 
> This is rather unappealing. Distros would have to take this code
> size penalty if they decide one user needs that support. The other
> millions of users pay that cost even if they don't want it.  And
> then there's validation - how are we supposed to validate that a
> 250k binary blob is correct and free of issues on every compiler and
> architecture that the kernel is built on?

The way this needs to be done is to have a separate module for the
tables, which XFS or other users then can symbol_get if and only if
a mount requires it.  The unicode tables should defintively be outside
of fs/xfs.

And please run this past lkml or -fsdevel, as people who actually
understand unicode and related issues are much more likely to be found
there than on the XFS list.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
