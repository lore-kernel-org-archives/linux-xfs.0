Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Apr 2008 16:26:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m33NQA00021313
	for <xfs@oss.sgi.com>; Thu, 3 Apr 2008 16:26:11 -0700
Received: from filer.fsl.cs.sunysb.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5CF3A904751
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2008 11:09:24 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2]) by cuda.sgi.com with ESMTP id 2u2NGh6WNF0zLYwM for <xfs@oss.sgi.com>; Thu, 03 Apr 2008 11:09:24 -0700 (PDT)
Date: Thu, 3 Apr 2008 14:09:18 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH 5/7] XFS: Unicode case-insensitive lookup implementation
Message-ID: <20080403180918.GA30189@josefsipek.net>
References: <20080402062508.017738664@chook.melbourne.sgi.com> <20080402062709.011126702@chook.melbourne.sgi.com> <20080403171450.GB22385@infradead.org> <20080403172400.GC22812@samba1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080403172400.GC22812@samba1>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeremy Allison <jra@samba.org>
Cc: Christoph Hellwig <hch@infradead.org>, Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Thu, Apr 03, 2008 at 10:24:00AM -0700, Jeremy Allison wrote:
> On Thu, Apr 03, 2008 at 01:14:50PM -0400, Christoph Hellwig wrote:
> > Validating file names is not the filesystem job.  In fact it's utterly
> > stupid, a unix filename is a sequence of bytes without special meaning
> > except for ., .., / and \0
> 
> This patch will be extremely useful for users who are serving
> Windows clients using Samba. It allow admins to turn off the
> userspace case insensitivity we have to emulate and be a significant
> speed increase.

IIRC, the last version of this patch series didn't help on the performance
scale.  Any updates as to whether that got fixed up?

Josef 'Jeff' Sipek.

-- 
In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like
that.
		- Linus Torvalds
