Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 12:15:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m39JFB1u007878
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 12:15:13 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 12AD39845FC
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2008 12:15:49 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 6rDpTA5qfQaOw4bF for <xfs@oss.sgi.com>; Wed, 09 Apr 2008 12:15:49 -0700 (PDT)
Date: Wed, 9 Apr 2008 15:15:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: TAKE 979087 - Test 091 fails on sector size != 512 bytes
Message-ID: <20080409191518.GA18486@infradead.org>
References: <20080408022933.170C258C4C0F@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080408022933.170C258C4C0F@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

On Tue, Apr 08, 2008 at 12:29:32PM +1000, David Chinner wrote:
> Test 091 fails on sector size != 512 bytes
> 
> Test 091 assumes a direct I/O alignment of 512 bytes,
> a hold over from 2.4 kernels. On 2.6. kernels, direct
> I/O needs to be aligned to the sector size the filesystem
> was mkfs'd with.

Actually this makes 091 fail in my kvm test setup now:

091 49s ... - output mismatch (see 091.out.bad)
1a2,7
> meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
> data     = bsize=XXX blocks=XXX, imaxpct=PCT
>          = sunit=XXX swidth=XXX, unwritten=X
> naming   =VERN bsize=XXX
> log      =LDEV bsize=XXX blocks=XXX
> realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
