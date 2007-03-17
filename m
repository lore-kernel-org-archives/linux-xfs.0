Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 17 Mar 2007 15:00:56 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2HM0o6p021658
	for <xfs@oss.sgi.com>; Sat, 17 Mar 2007 15:00:51 -0700
Message-ID: <45FC650F.70208@sandeen.net>
Date: Sat, 17 Mar 2007 17:00:47 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: HAVE_FORMAT32 never enabled in mainline
References: <20070317154028.GA18997@lst.de>
In-Reply-To: <20070317154028.GA18997@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: tes@melbourne.sgi.com, xfs@oss.sgi.com

Christoph Hellwig wrote:
> Looks like the code for dealing with x86/amd64 logs is never actually 
> enable in mainline because nothing defines HAVE_FORMAT32.

Actually since it's all #ifndef (note the n) everything under the 
#ifndefs -is- enabled (since it's never defined), so I think it's all 
functional.... structures under the #ifndefs are used outside the 
#ifndefs, so the #ifndefs can probably just be removed...?

-Eric
