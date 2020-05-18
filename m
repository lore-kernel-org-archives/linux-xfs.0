Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93875C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 18:54:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75CBE207F5
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 18:54:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AyrofD3I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730141AbgERSyX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 14:54:23 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53267 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729960AbgERSyW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 14:54:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589828061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TeshP/qTuYkLUbUJIEI+W3t1QpB06X5Ss0dlWvOZpbA=;
        b=AyrofD3IS6+HJFHDMyOQSxpDQ+5AQ4fNoIbS0GzO0QHkf3Ih5iWNAXlgVZFwYkIU25HH4M
        kvlM9Zg/GyqjU4H02S/1G+j0fZ2VnvZRZo85bgaNNf78q+Stkc3678nhRFRh3uMj2ZEZoh
        JBgov1x0DfKWaHYXVwgBqPiDYPc5nJE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-y37M3wqpOy-hKTNcPzh3qg-1; Mon, 18 May 2020 14:54:17 -0400
X-MC-Unique: y37M3wqpOy-hKTNcPzh3qg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E07C818FF660;
        Mon, 18 May 2020 18:54:16 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D3F306297D;
        Mon, 18 May 2020 18:54:13 +0000 (UTC)
Date:   Mon, 18 May 2020 14:54:12 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH, RFCRAP] xfs: handle ENOSPC quota return in
 xfs_file_buffered_aio_write
Message-ID: <20200518185412.GA19081@bfoster>
References: <e6b9090b-722a-c9d1-6c82-0dcb3f0be5a2@redhat.com>
 <20200518123454.GB10938@bfoster>
 <20200518170112.GB18061@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200518170112.GB18061@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 10:01:12AM -0700, Christoph Hellwig wrote:
> On Mon, May 18, 2020 at 08:34:54AM -0400, Brian Foster wrote:
> > Christoph's comment aside, note that the quota helpers here are filtered
> > scans based on the dquots attached to the inode. It's basically an
> > optimized scan when we know the failure was due to quota, so I don't
> > think there should ever be a need to run a quota scan after running the
> > -ENOSPC handling above. For project quota, it might make more sense to
> > check if a pdquot is attached, check xfs_dquot_lowsp() and conditionally
> > update the eofb to do a filtered pquota scan if appropriate (since
> > calling the quota helper above would also affect other dquots attached
> > to the inode, which I don't think we want to do). Then we can fall back
> > to the global scan if the pquota optimization is not relevant or still
> > returns -ENOSPC on the subsequent retry.
> 
> That's what I've implemented.  But it turns out -ENOSPC can of course
> still mean a real -ENOSPC even with project quotas attached.  So back
> to the drawing board - I think I basically need to replace the enospc
> with a tristate saying what kind of scan we've tried.  Or we just ignore
> the issue and keep the current global scan after a potential project
> quota -ENOSPC, because all that cruft isn't worth it after all.
> 

Sure, that's why I was suggesting to check the quota for low free space
conditions. One one hand, a quota scan might be worth it under low quota
space conditions to avoid the heavy handed impact (i.e. flush
everything) on an fs that otherwise might have plenty of free space.
OTOH, it might be pointless if permanent -ENOSPC (due to project quota)
is imminent and we always fall back to the global scan.

Brian

