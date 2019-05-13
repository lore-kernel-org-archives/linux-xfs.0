Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56196 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728142AbfEMPog (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 May 2019 11:44:36 -0400
Date: Mon, 13 May 2019 11:44:34 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/6] xfs: refactor small allocation helper to skip cntbt
 attempt
Message-ID: <20190513154433.GD61135@bfoster>
References: <20190509165839.44329-1-bfoster@redhat.com>
 <20190509165839.44329-2-bfoster@redhat.com>
 <20190510172446.GA18992@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190510172446.GA18992@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Fri, May 10, 2019 at 10:24:46AM -0700, Christoph Hellwig wrote:
> This looks pretty sensible to me.  What confuses me a bit is that
> the patch is much more (good!) refactoring than the actual change.
> 
> If you have to respin it maybe split it up, making the actual
> behavior change even more obvious.
> 

The only functional change was basically to check for ccur before using
it and initializing i to zero. It just seemed to make sense to clean up
the surrounding code while there, but I can either split out the
aesthetic cleanup or defer that stuff to the broader rework at the end
of the series (where the cursor stuff just gets ripped out anyways) if
either of those is cleaner..

Brian

> Otherwise:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
