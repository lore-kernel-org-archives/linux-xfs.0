Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 21:27:33 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6P4RTlC011047
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 21:27:30 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: [PATCH] use generic posix ACL code, enable ACL caching
References: <20080614160127.GA15404@lst.de> <20080723201940.GA7908@lst.de>
Date: Fri, 25 Jul 2008 14:28:30 +1000
In-Reply-To: <20080723201940.GA7908@lst.de> (Christoph Hellwig's message of
	"Wed, 23 Jul 2008 22:19:40 +0200")
Message-ID: <ncctzeetwnl.fsf@itchy.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig <hch@lst.de> writes:

> On Sat, Jun 14, 2008 at 06:01:27PM +0200, Christoph Hellwig wrote:
>> Switch XFS to use the generic ACL code and enable caching the ACL values
>> in the XFS inode.
>> 
>> Compared to the last post various bugs have been fixed and a locking
>> strategy has been designed and implemented.  This now passes XFSQA.
>> 
>> You'll need my various attr-related patches applies before this one.
>
> With various recent changes going in it needed another rediff.  I also
> moved the xfs_acl_chmod call into xfs_setattr from xfs_vn_setattr
> because we would miss it for updates from dmapi.  While doing this
> I found out that xfs_acl_chmod is non-atomic vs the setattr which is
> probably a bad thing, but also done that way in all other filesystems.
>
> Maybe we want to delay this patch until Niv's infrastructure to
> piggy-back an attr_set ontop of an existing transaction is done so
> that this issue could be solved.

I like the patch, and don't think we need to wait for the trans aware
attr code to get it in (it's not attomic now and nobody cares as you
pointed out) that said, it's pretty big, and I'm did not review it
carefully enough, and'd be *much* more comfortable if someone that knows
the code more (like tes) could have a look at it before putting it in.

Cheers,
-- 
Niv Sardi
