Return-Path: <SRS0+c22dbaa8f4a16b90267d+1486+infradead.org+hch@pentafluge.srs.infradead.org>
Date: Tue, 18 Sep 2007 15:36:44 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] refactor xfs_mountfs for clarity & stack savings
Message-ID: <20070918143644.GB12870@infradead.org>
References: <46D37A82.2080608@sandeen.net> <20070828195221.GA7237@infradead.org> <46D48BDE.5000903@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D48BDE.5000903@sandeen.net>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>
List-ID: <xfs>

On Tue, Aug 28, 2007 at 03:55:58PM -0500, Eric Sandeen wrote:
> Refactoring xfs_mountfs() to call sub-functions for logical
> chunks can help save a bit of stack, and can make it easier to
> read this long function.
> 
> The mount path is one of the longest common callchains, easily
> getting to within a few bytes of the end of a 4k stack when
> over lvm, quotas are enabled, and quotacheck must be done.
> 
> With this change on top of the other stack-related changes
> I've sent, I can get xfs to survive a normal xfsqa run on
> 4k stacks over lvm.

Any chance to get this in?
