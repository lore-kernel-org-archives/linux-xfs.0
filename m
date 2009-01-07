Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n07HkfIp017429 for <xfs@oss.sgi.com>; Wed, 7 Jan 2009 11:46:51 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD6851BA1775
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2009 09:46:41 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id QHJweYCmFGUKhjk0 for
	<xfs@oss.sgi.com>; Wed, 07 Jan 2009 09:46:41 -0800 (PST)
Date: Wed, 7 Jan 2009 12:46:09 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_db problem
Message-ID: <20090107174609.GA8915@infradead.org>
References: <4964BD79.20806@poczta.onet.pl> <4964BF7E.6060906@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4964BF7E.6060906@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: aluno <aluno3@poczta.onet.pl>, xfs@oss.sgi.com

On Wed, Jan 07, 2009 at 08:43:10AM -0600, Eric Sandeen wrote:
> The thing is, xfs_db could in theory be used to *fix* the bad magic
> number, so refusing to continue might be a problem.  But perhaps when
> invoked as xfs_admin, it should just bail out.  It would be interesting
> to find where the actual failure is, though...

We have bugzilla open for this, too.  I think it's reasonable to
get a warning, but not the additional problems when calling xfs_db
directly because that's a low-level tool for people that know what
they do.

But when called through wrappers like xfs_admin we should first do
the magic number check.  I think the proper way to implement this
is to add an option to xfs_db to perform the magic number check,
and make sure all the wrapper scripts set it, similar to how they
already use -p <progname>.

Any volunteer to implement this?  It should be fairly simple.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
