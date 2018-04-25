Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33186 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750862AbeDYFUp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Apr 2018 01:20:45 -0400
Date: Tue, 24 Apr 2018 22:20:40 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] iomap: Use FUA for pure data O_DSYNC DIO writes
Message-ID: <20180425052040.GA28512@infradead.org>
References: <20180418040828.18165-1-david@fromorbit.com>
 <20180418040828.18165-5-david@fromorbit.com>
 <20180421125405.hyx3bbkohdgvducq@quack2.suse.cz>
 <20180424173444.GA25233@infradead.org>
 <2fb29b95-a39d-3ee7-249b-86614a8dcbb4@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2fb29b95-a39d-3ee7-249b-86614a8dcbb4@applied-asynchrony.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de, rdorr@microsoft.com

On Wed, Apr 25, 2018 at 12:07:07AM +0200, Holger Hoffstätte wrote:
> The above line just gives parenthesis salad errors, so why not compromise
> on:
> 
> 	if ((iocb->ki_flags & (IOCB_DSYNC | IOCB_SYNC)) == IOCB_DSYNC) {
> 
> Unless my bit twiddling has completely left me I think this is what was
> intended, and it actually compiles too.

Yes, that is what was intended :)
