Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52712 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932115AbdC1LoU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Mar 2017 07:44:20 -0400
Date: Tue, 28 Mar 2017 13:43:45 +0200
From: Greg KH <greg@kroah.com>
Subject: Re: Request 2aa6ba7b5ad3 ("clear _XBF_PAGES from buffers when
 readahead page") for 4.4 stable inclusion
Message-ID: <20170328114345.GA17359@kroah.com>
References: <20170325074856.GA20773@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170325074856.GA20773@localhost>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ivan Kozik <ivan@ludios.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, bfoster@redhat.com, david@fromorbit.com

On Sat, Mar 25, 2017 at 07:49:00AM +0000, Ivan Kozik wrote:
> Hi,
> 
> I would like to request that this patch be included in the 4.4 stable tree.  It 
> fixes the Bad page state issue discovered at 
> http://oss.sgi.com/archives/xfs/2016-08/msg00617.html ('"Bad page state" errors 
> when calling BULKSTAT under memory pressure?')
> 
> I tested the patch (no changes needed) by applying it to 4.4.52, running a 
> program to use almost all of my free memory, then running xfs_fsr on a 
> filesystem with > 1.5M files.  Before patch: kernel screams with Bad page state 
> / "count:-1" within a minute.  After patch: no complaints from the kernel. 
> I repeated the test several times and on another machine that was affected. 
> I have not seen any problems five days later.

Now queued up, thanks.

greg k-h
