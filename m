Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 19:38:48 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F2caEB011180
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 19:38:36 -0700
Date: Tue, 14 Oct 2008 22:40:15 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: TAKE 988141 - Fix build error - use VFS_I() to access linux
	inode from xfs inode
Message-ID: <20081015024014.GA21790@infradead.org>
References: <20081015021055.6B76358FA1E9@chook.melbourne.sgi.com> <20081015022106.GA22939@infradead.org> <48F5654E.3080900@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F5654E.3080900@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

On Wed, Oct 15, 2008 at 01:36:46PM +1000, Lachlan McIlroy wrote:
> Sorry Christoph.  I just don't have time to read all posts.
>
> I expect fixes to be in the same patch series that breaks the code - it
> didn't occur to me to go looking for a fix on OSS.

Well, Daven unfortunately can't be bothered to use the same tree as
everyone else.  But I made it pretty clear in the patch that it is
needed for the series when using a ptools/cvs style tree, and that it's
harmless to apply it ASAP even without those bits.
