Return-Path: <SRS0=b91c=A3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 530BBC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 10:41:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DB302074B
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 10:41:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bbEgkTbt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgGPKlJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 06:41:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57863 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726239AbgGPKlJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 06:41:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594896068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pZ5EMU19qEf35eipHTMSRQm6G+LmxuNeUhtj5NeVFsg=;
        b=bbEgkTbtl4a/f05hBpt6BFDbmKZfjd9CDg6+3oZN36LwgjUIP/LwUawQpngFTSNBeRFNND
        qDw3miKm0rM8knQWLeQufFHyYbqDbXycfztf2TP0foUs/h4lnJdV7YDQfuAnwcX9pVLdrY
        TJpAaKXc0UW5hL6Nkbd9q32vWEW7his=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-V9UHuqALMuywkVglMsd-Fw-1; Thu, 16 Jul 2020 06:41:06 -0400
X-MC-Unique: V9UHuqALMuywkVglMsd-Fw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 362DE8027ED;
        Thu, 16 Jul 2020 10:41:05 +0000 (UTC)
Received: from bfoster (ovpn-113-214.rdu2.redhat.com [10.10.113.214])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CDEC95FC2C;
        Thu, 16 Jul 2020 10:41:04 +0000 (UTC)
Date:   Thu, 16 Jul 2020 06:41:03 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] repair: use fs root ino for dummy parent value
 instead of zero
Message-ID: <20200716104103.GB26218@bfoster>
References: <20200715140836.10197-1-bfoster@redhat.com>
 <20200715140836.10197-4-bfoster@redhat.com>
 <20200715222216.GH2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715222216.GH2005@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 16, 2020 at 08:22:16AM +1000, Dave Chinner wrote:
> On Wed, Jul 15, 2020 at 10:08:35AM -0400, Brian Foster wrote:
> > If a directory inode has an invalid parent ino on disk, repair
> > replaces the invalid value with a dummy value of zero in the buffer
> > and NULLFSINO in the in-core parent tracking. The zero value serves
> > no functional purpose as it is still an invalid value and the parent
> > must be repaired by phase 6 based on the in-core state before the
> > buffer can be written out.  Instead, use the root fs inode number as
> > a catch all for invalid parent values so phase 6 doesn't have to
> > create custom verifier infrastructure just to work around this
> > behavior.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> Reasonale, but wouldn't it be better to use lost+found as the dummy
> parent inode (i.e. the orphanage inode)? Because if the parent can't
> be found and the inode reconnected correctly, we're going to put it
> in lost+found, anyway?
> 

That was my first thought when I originally wrote this, but there's
several reasons I didn't end up doing that. The orphanage isn't created
until much later in repair and only if we end up with orphaned inodes.
We'd have to change that in order to use a dummy parent inode number
that corresponds to a valid orphanage, and TBH I'm not even sure if it's
always going to be safe to expect an inode allocation to work at this
point in repair.

Further, it's still too early to tell whether these directories are
orphaned because the directory scan in phase 6 can easily repair
missing/broken parent information. The scenarios I used to test this
functionality didn't involve the orphanage at all, so now we not only
need to change when/how the orphanage is created, but need to free it if
it ends up unused before we exit (which could be via any number of
do_error() calls before we ever get close to phase 6).

If you consider all of that with the facts that this is a dummy value
and so has no real functional effect on repair, and that the purpose of
this series is simply to remove some custom verifier code to facilitate
libxfs synchronization, it seems to me this just adds a bunch of code
and testing complexity for no tangible benefit.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

