Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F3D3C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 11:45:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3904D60E78
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 11:45:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238628AbhHSLqb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Aug 2021 07:46:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51288 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238210AbhHSLqb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Aug 2021 07:46:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629373554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xy9fQdYH/CWWjTkiJVrYMWdAWzRO+jPrbKbkYk2d8uM=;
        b=XKyVk4V6nfMalYCr8/lnizDRW/HY23lBavmbXSZoFASn9wmfjUVsmyqZVD63Xff8HASC1U
        tB3Xy5xiR1gmNDSal2MeycsZH8JQVL4Z4eqzOHFbm07B/752yVu6GwXdDCJXBxVvsY8KWS
        wQ0pmRHrguPNpn6wk/ynIbm5DNlAfYc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-523-D7fZMcRmPlG9V8DF2v54vQ-1; Thu, 19 Aug 2021 07:45:53 -0400
X-MC-Unique: D7fZMcRmPlG9V8DF2v54vQ-1
Received: by mail-ed1-f71.google.com with SMTP id bx23-20020a0564020b5700b003bf2eb11718so2658979edb.20
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 04:45:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=xy9fQdYH/CWWjTkiJVrYMWdAWzRO+jPrbKbkYk2d8uM=;
        b=D90Kh6bSVWBFb+j3we55XtSdzl90n/32J9fILayN3EHxlXOTIfzWLI1h9vWxN4XrsA
         TzjC5Ov2PvypPzTgh/dqEshzwPznN1u932eS42PNA6HzvsUXwLEjyV+u1eJImIg9Q67l
         8vekqVIa7Mz0HOZ9yCjlLpE7IxmHf2bg6nT2ejrjCktDFNKUxnduaURG3YKwnNSrgPmU
         eZRL5QvAC6g2xqRo5WqSdVfr1Irxt01jVOUghIk1IefA/3Xs+BUaLNFgnlLz/9b6H+s4
         8iJR71IrJ6eEuYSAD3KoeTNhfXgOwCCxENfFreMZwMB5kxXadTDdqcaxZhloJERuxU9i
         GLSw==
X-Gm-Message-State: AOAM533pttBGwUorrgtX/QHCICjkKu7lINOQSUAL/reRQ13kkmhYEFX3
        SBjjeHtj54jzY9ZLhZNRCIwnUq34KaRKG60p7iDXCtCF3xhn1HY46oSY5yMXtKwUa6M0ntpXJQr
        o6KgYFx6pBoQkIhPuMIsg
X-Received: by 2002:a17:906:89a3:: with SMTP id gg35mr15486237ejc.476.1629373552326;
        Thu, 19 Aug 2021 04:45:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzm5FxC9u0OJI9LygdMsDBxjqz5vVbXwv0Jd9+/eops2//rtCch/+S1CVjZHhmQG0EYEvKj+Q==
X-Received: by 2002:a17:906:89a3:: with SMTP id gg35mr15486227ejc.476.1629373552177;
        Thu, 19 Aug 2021 04:45:52 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id bs13sm1138117ejb.98.2021.08.19.04.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 04:45:51 -0700 (PDT)
Date:   Thu, 19 Aug 2021 13:45:50 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/15] xfs: disambiguate units for ftrace fields tagged
 "offset"
Message-ID: <20210819114550.sthqbckcam4flrik@omega.lan>
Mail-Followup-To: Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <162924377603.761813.4113528501236797725.stgit@magnolia>
 <20210819025117.GY3657114@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210819025117.GY3657114@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 19, 2021 at 12:51:17PM +1000, Dave Chinner wrote:
> On Tue, Aug 17, 2021 at 04:42:56PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Some of our tracepoints describe fields as "offset".  That name doesn't
> > describe any units, which makes the fields not very useful.  Rename the
> > fields to capture units and ensure the format is hexadecimal.
> > 
> > "fileoff" means file offset, in units of fs blocks
> > "pos" means file offset, in bytes
> > "forkoff" means inode fork offset, in bytes
> > 
> > The one remaining "offset" value is for iclogs, since that's the byte
> > offset of the end of where we've written into the current iclog.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---

Just realized Dave already spotted it, sorry the redundancy :(

> >  fs/xfs/scrub/trace.h |    6 +++---
> >  fs/xfs/xfs_trace.h   |   29 ++++++++++++++---------------
> >  2 files changed, 17 insertions(+), 18 deletions(-)
> 
> ....
> 
> > @@ -2145,7 +2145,7 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
> >  		__entry->fork_off = XFS_IFORK_BOFF(ip);
> >  	),
> >  	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, num_extents %d, "
> > -		  "broot size %d, fork offset %d",
> > +		  "broot size %d, forkoff %d",
> >  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> >  		  __entry->ino,
> >  		  __print_symbolic(__entry->which, XFS_SWAPEXT_INODES),
> 
> Format should be 0x%x?
> 
> Otherwise looks fine. With that fixed,
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> -- 
> Dave Chinner
> david@fromorbit.com
> 

-- 
Carlos

