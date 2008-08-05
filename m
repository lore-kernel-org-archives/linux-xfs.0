Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Aug 2008 17:48:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m750mAT8020213
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 17:48:11 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3DF8CF02A19
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2008 17:49:23 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id F1VephwCmPrndohj for <xfs@oss.sgi.com>; Mon, 04 Aug 2008 17:49:23 -0700 (PDT)
Date: Tue, 5 Aug 2008 02:49:24 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/26] generic btree implementation, version 3
Message-ID: <20080805004924.GA5002@lst.de>
References: <20080804013158.GA8819@lst.de> <20080804015425.GE6119@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080804015425.GE6119@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, Aug 04, 2008 at 11:54:25AM +1000, Dave Chinner wrote:
> > The alloc and inobt trees were in fact using the almost exact sequence
> > built from ->set_root and ->free_block but the odd way to pass the
> > block to be freed made this non-obvious.  By changing the calling
> > convention to the normal one this one could be unified.  I've left
> > in some nasty asserts to ensure the assumptions about these blocks
> > wasn't wrong.
> 
> Ok. I'll comment on it when the patches come through....

The killroot unification turned out to be buggy, I'll fix it in the
next round of patches.
