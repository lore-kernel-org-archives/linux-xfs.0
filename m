Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Dec 2006 00:50:01 -0800 (PST)
Received: from imr2.americas.sgi.com (imr2.americas.sgi.com [198.149.16.18])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBK8ntqw010648
	for <xfs@oss.sgi.com>; Wed, 20 Dec 2006 00:49:56 -0800
Message-ID: <4588F8FD.9020602@sgi.com>
Date: Wed, 20 Dec 2006 08:49:01 +0000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: Review: Fix use after free on forced shutdown
References: <20061219053012.GY33919298@melbourne.sgi.com>
In-Reply-To: <20061219053012.GY33919298@melbourne.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com

Fix looks good to me.

David Chinner wrote:
> As found earlier today trying to reproduce a different use
> after free, a machine with CONFIG_SLAB_DEBUG will panic on
> a forced shutdown if the inode has an assocaited item
> in the AIL.
> 
> Trivial fix is to remove the item from the AIL before
> freeing it.
> 
> Cheers,
> 
> Dave.
