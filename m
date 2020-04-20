Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C2EC3815B
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 14:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4188C20722
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 14:04:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HlFIauxs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729639AbgDTOEt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 10:04:49 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37572 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729547AbgDTOEt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 10:04:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587391488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ll368xm3Ru6vwW8T0zdw6KPXORqFFmDeudEQS8UzU6Q=;
        b=HlFIauxseHvgSWF9IJxmtKeCIMZ4amfJe9FClhO7h5tOduIhenHBarOTMvFkvxQEBK8lxP
        xUN02Hekuskp4s2aaiTfp1PI5S5aVfxIiqm4277Hsd9Gx8AxDWKeu7RId9Nv8sWY/72KAT
        0fF9sKK2eLGdK5fhzMR2Ymi6nBmi2HE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-DbuHsbDlPm2cnwT1tKP7SA-1; Mon, 20 Apr 2020 10:04:46 -0400
X-MC-Unique: DbuHsbDlPm2cnwT1tKP7SA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C871918C35CB;
        Mon, 20 Apr 2020 14:04:45 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 610F85C1C5;
        Mon, 20 Apr 2020 14:04:45 +0000 (UTC)
Date:   Mon, 20 Apr 2020 10:04:43 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/12] xfs: random buffer write failure errortag
Message-ID: <20200420140443.GI27516@bfoster>
References: <20200417150859.14734-1-bfoster@redhat.com>
 <20200417150859.14734-13-bfoster@redhat.com>
 <20200420043717.GN9800@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420043717.GN9800@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 20, 2020 at 02:37:17PM +1000, Dave Chinner wrote:
> On Fri, Apr 17, 2020 at 11:08:59AM -0400, Brian Foster wrote:
> > Introduce an error tag to randomly fail async buffer writes. This is
> > primarily to facilitate testing of the XFS error configuration
> > mechanism.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> Isn't this what XFS_ERRTAG_IODONE_IOERR and XFS_RANDOM_IODONE_IOERR
> is for?
> 

That one triggers log I/O errors, which is an imminent shutdown error
scenario. I'm not aware of a clean way to combine the two, though the
above could probably use a better name. TBH, I wasn't sure about the
name for the buffer one either. I wonder if XFS_ERRTAG_LOG_IOERROR and
XFS_ERRTAG_METADATA_IOERROR would be more usable..? That's assuming
we're Ok with changing existing error tag names. The IODONE one appears
to have been around forever...

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

