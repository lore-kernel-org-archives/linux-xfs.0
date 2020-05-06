Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1849BC38A24
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 11:04:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8C672068E
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 11:04:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SUgerR8a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgEFLEI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 07:04:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54283 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727893AbgEFLEH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 07:04:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588763045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9piJfAJeMa+GWNI2Saw38Xe7RYjEfAu0Yul4joDxQ70=;
        b=SUgerR8ak0VKgPs1mg6CPNn5bqKzfzGTVHr0/34m6FQ3aiAkFW51OU6gZ6VuTisAfG1xSt
        0RqBv+PIEKvOX9t7TGZW8AlSLatelIykwmjj7TIjMX5z21i9U3kvqylKrtJ2xxTM2plQaE
        79Dd/LPXwH5838GJvdxk4QbpBAEU8Ww=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-O0szw47kOVanKiF5goVpSA-1; Wed, 06 May 2020 07:04:04 -0400
X-MC-Unique: O0szw47kOVanKiF5goVpSA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24B4D7BB1;
        Wed,  6 May 2020 11:04:03 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A5B9260BEC;
        Wed,  6 May 2020 11:04:02 +0000 (UTC)
Date:   Wed, 6 May 2020 07:04:00 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 00/17] xfs: flush related error handling cleanups
Message-ID: <20200506110400.GA64810@bfoster>
References: <20200504141154.55887-1-bfoster@redhat.com>
 <20200504215307.GL2040@dread.disaster.area>
 <20200505115810.GA60048@bfoster>
 <20200505223643.GO2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505223643.GO2040@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 06, 2020 at 08:36:43AM +1000, Dave Chinner wrote:
> On Tue, May 05, 2020 at 07:58:10AM -0400, Brian Foster wrote:
> > On Tue, May 05, 2020 at 07:53:07AM +1000, Dave Chinner wrote:
> > > On Mon, May 04, 2020 at 10:11:37AM -0400, Brian Foster wrote:
> > > > Hi all,
> > > > 
> > > > I think everything has been reviewed to this point. Only minor changes
> > > > noted below in this release. A git repo is available here[1].
> > > > 
> > > > The only outstanding feedback that I'm aware of is Dave's comment on
> > > > patch 7 of v3 [2] regarding the shutdown assert check. I'm not aware of
> > > > any means to get through xfs_wait_buftarg() with a dirty buffer that
> > > > hasn't undergone the permanant error sequence and thus shut down the fs.
> > > 
> > > # echo 0 > /sys/fs/xfs/<dev>/fail_at_unmount
> > > 
> > > And now any error with a "retry forever" config (the default) will
> > > be collected by xfs_buftarg_wait() without a preceeding shutdown as
> > > xfs_buf_iodone_callback_error() will not treat it as a permanent
> > > error during unmount. i.e. this doesn't trigger:
> > > 
> > >         /* At unmount we may treat errors differently */
> > >         if ((mp->m_flags & XFS_MOUNT_UNMOUNTING) && mp->m_fail_unmount)
> > >                 goto permanent_error;
> > > 
> > > and so the error handling just marks it with a write error and lets
> > > it go for a write retry in future. These are then collected in
> > > xfs_buftarg_wait() as nothing is going to retry them once unmount
> > > gets to this point...
> > > 
> > 
> > That doesn't accurately describe the behavior of that configuration,
> > though. "Retry forever" means that dirty buffers are going to cycle
> > through submission retries and the unmount is going to hang indefinitely
> > (on pushing the AIL). Indeed, preventing this unmount hang is the
> > original purpose of the fail at unmount knob (commit here[1]).
> 
> So this patch is relying on something else hanging before we get to
> xfs_wait_buftarg and hence "we don't have to handle that here".
> 

Yes, though it's the existing code that relies on the external push to
block until everything is written back or a permanent error is issued.
This patch just splits up and rate limits a warning message. I added the
assert because of the previous discussion around making sure this
situation is handled properly and because that error processing
dependency is not obvious.

> Please document that assumption along with the ASSERT, because if we
> change AIL behaviour to prevent retry-forever hangs with freeze
> and/or remount-ro we're going to hit this assert...
> 

Sure, I'll add a comment..

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

