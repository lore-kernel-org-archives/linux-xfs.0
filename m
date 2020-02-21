Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 156EFC35647
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 12:15:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF265222C4
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 12:15:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gy5tdnf/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgBUMPX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 07:15:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38547 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726909AbgBUMPX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 07:15:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582287321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2zkyJk5uoU9rubh3bseyVONl8avnSmvXY7c0mwPNLt8=;
        b=Gy5tdnf/qrHrj34sNquYxGxN4Nzyk4s9s+7DeFd5yH9lYNpVx2E47VafOUiqneGXks9KkN
        7spQayrdQYEo59aJ93CyzgUPXhgKgx59YLxRjxzY1X3G6/WJdLGwCA4vRW8ruIZUSflGNU
        SJlHHWKOHylNlg94CAAeZqOSAstZa2U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-115-C7gZr6mtO_CpdFNMcNeXIA-1; Fri, 21 Feb 2020 07:15:13 -0500
X-MC-Unique: C7gZr6mtO_CpdFNMcNeXIA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6AEED18C35A4;
        Fri, 21 Feb 2020 12:15:12 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B29A01001281;
        Fri, 21 Feb 2020 12:15:11 +0000 (UTC)
Date:   Fri, 21 Feb 2020 07:15:09 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Richard Wareing <rwareing@fb.com>, linux-xfs@vger.kernel.org,
        Anthony Iliopoulos <ailiopoulos@suse.de>
Subject: Re: Modern uses of CONFIG_XFS_RT
Message-ID: <20200221121509.GA2053@bfoster>
References: <20200219135715.GZ30113@42.do-not-panic.com>
 <20200220034106.GO10776@dread.disaster.area>
 <20200220142520.GF48977@bfoster>
 <20200220220652.GP10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220220652.GP10776@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 21, 2020 at 09:06:52AM +1100, Dave Chinner wrote:
> On Thu, Feb 20, 2020 at 09:25:20AM -0500, Brian Foster wrote:
> > On Thu, Feb 20, 2020 at 02:41:06PM +1100, Dave Chinner wrote:
> > > On Wed, Feb 19, 2020 at 01:57:15PM +0000, Luis Chamberlain wrote:
> > > > I hear some folks still use CONFIG_XFS_RT, I was curious what was the
> > > > actual modern typical use case for it. I thought this was somewhat
> > > > realted to DAX use but upon a quick code inspection I see direct
> > > > realtionship.
> > > 
> > > Facebook use it in production systems to separate large file data
> > > from metadata and small files. i.e. they use a small SSD based
> > > partition for the filesytem metadata and a spinning disk for
> > > the large scale data storage. Essentially simple teired storage.
> > > 
> > 
> > Didn't this involve custom functionality? I thought they had posted
> > something at one point that wasn't seen through to merge, but I could be
> > misremembering (or maybe that was something else RT related). It doesn't
> 
> Yes, but that is largely irrelevant. It requires the RT device to
> function, and the RT device functionality is entirely unchanged. All
> that changed was the initial data allocation policy to select
> whether the RT or data device would be used, and that really isn't
> that controversial as we've always suggested this is a potential use
> of the RT device (fast and slow storage in the one filesystem
> namespace).
> 

Ok, then we should be able to get those changes upstream.

> > matter that much as there are probably other users out there, but I'm
> > not sure this serves as a great example use case if it did require
> > downstream customizations
> 
> There are almost always downstream modifications in private cloud
> storage kernels, even if it is just bug fixes. They aren't shipping
> the code to anyone, so they don't have to publish those changes.
> However, the presence of downstream changes doesn't mean the
> upstreram functionality should be considered unused and can be
> removed....
> 

Well that's not what I said. ;P I'm pointing out that as of right now
this is a downstream only use case. I know there was upstream
communication and patches posted, etc., but that was a while ago and it
wasn't clear to me if there was still intent to get things merged
upstream. If not, then the only real outcome here for anybody outside of
FB is bitrot.

> > that aren't going to be generalized/supported
> > for the community.. Richard..?
> 
> IIRC, we were simply waiting on an updated patchset to address
> review comments...
> 

I'm not sure if I'm digging out the right mails... it appears there was
decent upstream activity at first (up to a v7 [1] across a period of
months). Since then, I don't see any updates in over two years..

Brian

[1] https://lore.kernel.org/linux-xfs/20171128215527.2510350-1-rwareing@fb.com/

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

