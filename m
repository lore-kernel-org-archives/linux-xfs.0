Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43574 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727247AbeK1SgC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Nov 2018 13:36:02 -0500
Date: Tue, 27 Nov 2018 23:35:20 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1 5/7] xfs: Add device retry
Message-ID: <20181128073520.GA7084@infradead.org>
References: <1543376991-5764-1-git-send-email-allison.henderson@oracle.com>
 <1543376991-5764-6-git-send-email-allison.henderson@oracle.com>
 <20181128050850.GJ6311@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128050850.GJ6311@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, bob.liu@oracle.com

On Wed, Nov 28, 2018 at 04:08:50PM +1100, Dave Chinner wrote:
> So the first time through this loop the block layer devices what
> device to read from, then we iterate devices 1..n on error.
> 
> Whihc means if device 0 is the only one with good information in it,
> we may not ever actually read from it.
> 
> I'd suggest that a hint of "-1" (or equivalent max value) should be
> used for "device selects mirror leg" rather than 0, so we can
> actually read from the first device on command.

Yes.  For one thing I think we really need to split this retry counter
of sorts from the write hints.  I.e. make both u8 types and keep them
separate.  Then start out with (u8)-1 as initialized by the block layer
for the first attempt.  The device then fills out which leg it used
(in the completion path, so that another underlying driver doesn't
override it!), and then the file system just preserves this value on
a resumit, leaving the driver to chose a new value when it gets a
non -1 value.
