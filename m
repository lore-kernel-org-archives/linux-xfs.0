Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Sep 2007 20:27:21 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8F3RG4p006152
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2007 20:27:17 -0700
Message-ID: <46EB5115.3050808@sandeen.net>
Date: Fri, 14 Sep 2007 22:27:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 5/4] simplify xfs_create/mknod/symlink prototype
References: <20070914163041.GG7110@lst.de> <46EAD364.7060305@sandeen.net> <46EAD432.1030704@sandeen.net> <20070914220520.GA19567@lst.de>
In-Reply-To: <20070914220520.GA19567@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Fri, Sep 14, 2007 at 01:34:26PM -0500, Eric Sandeen wrote:
>>> -xfs_symlink [xfs]: 240
>>> +xfs_symlink [xfs]: 256
>> Although, that one is a little unfortunate ;)
> 
> and rather odd.  16 bytes more stack for passing in a 32bit scalar
> instead of a 32/64bit pointer, huh?  Then again we could just kill
> that parameter because symlinks always get the same mode..

it's a short on x86...  *shrug* I dunno, ask Jakub ;-)

-Eric
