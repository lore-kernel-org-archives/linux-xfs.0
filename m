Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E132FC3815B
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 16:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE6A6206F6
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 16:20:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bmv1fOWI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgDTQU3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 12:20:29 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40829 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726878AbgDTQU3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 12:20:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587399628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o11cjvM9YUOfnijryPSEZzeYNsYb2ijjD/webktusQA=;
        b=bmv1fOWIy3rCBYNk8ejcrNfsU/ILLVxlkXSeLF0SI1y0QWBgMpaje2xIcOBJKx6rxm2EwZ
        m/eX9LUjCFaYcOXx2mdBpLJ1SxoHHupdEKB2ZQrsW6Y8Pc+UHU+JD0hPPITiBkIqJgCDia
        XuN0aXrVKwjrM01B8yFpW76TaWhRdIM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-UkgAzfG4PGemRKYFcTvZkw-1; Mon, 20 Apr 2020 12:20:22 -0400
X-MC-Unique: UkgAzfG4PGemRKYFcTvZkw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24FDC800D53;
        Mon, 20 Apr 2020 16:20:21 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A3C3F5C1B5;
        Mon, 20 Apr 2020 16:20:20 +0000 (UTC)
Date:   Mon, 20 Apr 2020 12:20:18 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     Allison Collins <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 19/20] xfs: Add delay ready attr set routines
Message-ID: <20200420162018.GB27216@bfoster>
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-20-allison.henderson@oracle.com>
 <3903108.UdAzE1QFjl@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3903108.UdAzE1QFjl@localhost.localdomain>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 20, 2020 at 05:15:08PM +0530, Chandan Rajendra wrote:
> On Saturday, April 4, 2020 3:42 AM Allison Collins wrote: 
...
> > Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c        | 384 +++++++++++++++++++++++++++-------------
> >  fs/xfs/libxfs/xfs_attr.h        |  16 ++
> >  fs/xfs/libxfs/xfs_attr_leaf.c   |   1 +
> >  fs/xfs/libxfs/xfs_attr_remote.c | 111 +++++++-----
> >  fs/xfs/libxfs/xfs_attr_remote.h |   4 +
> >  fs/xfs/xfs_attr_inactive.c      |   1 +
> >  fs/xfs/xfs_trace.h              |   1 -
> >  7 files changed, 351 insertions(+), 167 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index f700976..c160b7a 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
...
> > @@ -765,22 +873,25 @@ xfs_attr_leaf_addname(
> >  		error = xfs_attr3_leaf_flipflags(args);
> >  		if (error)
> >  			return error;
> > -		/*
> > -		 * Commit the flag value change and start the next trans in
> > -		 * series.
> > -		 */
> > -		error = xfs_trans_roll_inode(&args->trans, args->dp);
> > -		if (error)
> > -			return error;
> > -
> > +		dac->dela_state = XFS_DAS_FLIP_LFLAG;
> > +		return -EAGAIN;
> > +das_flip_flag:
> >  		/*
> >  		 * Dismantle the "old" attribute/value pair by removing
> >  		 * a "remote" value (if it exists).
> >  		 */
> >  		xfs_attr_restore_rmt_blk(args);
> >  
> > +		xfs_attr_rmtval_invalidate(args);
> > +das_rm_lblk:
> >  		if (args->rmtblkno) {
> > -			error = xfs_attr_rmtval_remove(args);
> > +			error = __xfs_attr_rmtval_remove(args);
> > +
> > +			if (error == -EAGAIN) {
> > +				dac->dela_state = XFS_DAS_RM_LBLK;
> 
> Similar to what I had observed in the patch "Add delay ready attr remove
> routines",
> 
> Shouldn't XFS_DAC_DEFER_FINISH be set in dac->flags?
> __xfs_attr_rmtval_remove() calls __xfs_bunmapi() which would
> have added items to the deferred list.
> 

Just note that transaction rolls don't currently finish deferred ops. So
from the perspective of preserving current behavior it might make sense
to set the flag here if there was an explicit xfs_defer_finish() that's
been factored out, but not so if it was just a transaction roll.

Brian

> -- 
> chandan
> 
> 
> 

