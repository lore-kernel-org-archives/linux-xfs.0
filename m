Return-Path: <SRS0=I2eC=74=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C0B8C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Jun 2020 14:32:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2271C206B7
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Jun 2020 14:32:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cfMnq8OE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgFOOc1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Jun 2020 10:32:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37843 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728304AbgFOOc0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jun 2020 10:32:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592231544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+e0vcThfzTts6S3eIRs8aOtZDU8sba/dbrLmjLmO/Pc=;
        b=cfMnq8OEB+cB3O1ZbK15qWUaSriczalev7pLHu3QO3iVcb1zB0HTaX7TTGgGSvWWWmfUL+
        aSH/ob2froQzhS6X99ITZMq98iHcZQFZHIxl2GwuQsOwxPD2ACYTb6Z3zV4Jf+C81jlCWR
        e3yHxX+aXLAmvkYjZ6OcMXdjQh0+CI4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-g3weaOzlMgu-gMJZ6mbqog-1; Mon, 15 Jun 2020 10:32:20 -0400
X-MC-Unique: g3weaOzlMgu-gMJZ6mbqog-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BAEC18FE893;
        Mon, 15 Jun 2020 14:31:23 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D7332C24D;
        Mon, 15 Jun 2020 14:31:23 +0000 (UTC)
Date:   Mon, 15 Jun 2020 10:31:21 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/30] xfs: factor xfs_iflush_done
Message-ID: <20200615143121.GB12452@bfoster>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-30-david@fromorbit.com>
 <20200609131249.GC40899@bfoster>
 <20200609221431.GK2040@dread.disaster.area>
 <20200610130833.GB50747@bfoster>
 <20200611001622.GN2040@dread.disaster.area>
 <20200611140709.GB56572@bfoster>
 <20200615014957.GU2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200615014957.GU2040@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 15, 2020 at 11:49:57AM +1000, Dave Chinner wrote:
> On Thu, Jun 11, 2020 at 10:07:09AM -0400, Brian Foster wrote:
> > 
> > TBH, I think this patch should probably be broken down into two or three
> > independent patches anyways.
> 
> To what end? The patch is already small, it's simple to understand
> and it's been tested. What does breaking it up into a bunch more
> smaller patches actually gain us?
> 

I think you overestimate the simplicity to somebody who doesn't have
context on whatever upcoming changes you have. I spent more time staring
at this wondering what the list filtering logic was for than I would
have needed to review the entire patch were those changes not included.

> It means hours more work on my side without any change in the end
> result. It's -completely wasted effort- if all I'm doing this for is
> to get you to issue a RVB on it. Fine grained patches do not come
> for free, and in a patch series that is already 30 patches long
> making it even longer just increases the time and resources it costs
> *me* to maintian it until it is merged.
> 

Note that I said "two or three" and then sent you a diff that breaks it
down into two. That addresses my concern.

> > What's the issue with something like the
> > appended diff (on top of this patch) in the meantime? If the multiple
> > list logic is truly necessary, reintroduce it when it's used so it's
> > actually reviewable..
> 
> Nothing. Except it causes conflicts further through my patch set
> which do the work of removing this AIL specific code. IOWs, it just
> *increases the amount of work I have to do* without actually
> providing any benefit to anyone...
> 

Reapply the list filtering logic (reverting the same diff I already
sent) at the beginning of your upcoming series that uses it. I sent the
diff as a courtesy because you seem to be rather frustrated wrt to any
suggestion to change this series, but this seems like a standard case of
misplaced code to me with a simple fix. The fact that this is used
somehow or another in a series that is so far unposted and unreviewed is
not a valid justification IMO. I really don't understand what the issue
is here wrt to moving the changes to where they're used.

Brian

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

