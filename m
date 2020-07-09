Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3EB3C433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 10:47:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8901520708
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 10:47:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VpUlCTdO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgGIKrr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 06:47:47 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50964 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726302AbgGIKrq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 06:47:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594291664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nL0g4w8Yqr71pLUAW67FqREplQcw2jWWEIqTul5BsLc=;
        b=VpUlCTdO/yNFk1KRc2FPpvZi+p5I1phQPMRpP7splPt8bl3wiKW10pTdmUcHHHlNBIMU1u
        NDysfkrC7+CmPMD3VUWGisTPDTf76wz3vxV4JZLejXddkN7xieDjnIp5/xYFZmjb+kVnZS
        P+b22N44/9/rK5uo7zlKX7XsiyBCSso=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-52-GWWkPgiPMOuBCeLn_ZIgmw-1; Thu, 09 Jul 2020 06:47:43 -0400
X-MC-Unique: GWWkPgiPMOuBCeLn_ZIgmw-1
Received: by mail-pf1-f199.google.com with SMTP id c2so1062204pfj.5
        for <linux-xfs@vger.kernel.org>; Thu, 09 Jul 2020 03:47:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nL0g4w8Yqr71pLUAW67FqREplQcw2jWWEIqTul5BsLc=;
        b=Q1S3eDTKeID3jfhFm7g5UlHpBmAjA6/0VLtkVBLSUzIqTlC9jhYHi11g189yR6vzfO
         /5ONjU/tdI2q6fzsBZkyRsjuOzt0nMDVb2AJjW0V7HwIgw3Hu8g76XlQk0hllxOlJME4
         VKy9GYT+fMFGGPAeF11C3wn4DSPO6wyjExuED/nduGu54ycIvdlTVN2DvHJCwFWhAbAQ
         VAOlUgGwuLegl3tiMA+SbvVzRba9OKmjlOZhbd6b1qjHGZsTcXXNswmmE7nvHgCnPRs+
         M6HqKi9piaZ0ycaUTJjEf8VmLDcUJeV2/ZwUPUOinWUU7shiLBNliCOhdXg2jwrKPajZ
         2ywA==
X-Gm-Message-State: AOAM533qaVHxNBDxP0d1EYqRQUBwORlRv3nu2tK0tVCdeM2eZZBoCtim
        MclHzMYaxSrBkyworSyhbOLPxZcxu56tO6CGGRa3mj5p/8um0EnnzeCspHd9xr5X04NldOJC54d
        RPuRAMInMEOO+jxKIb9lN
X-Received: by 2002:a17:90b:1c12:: with SMTP id oc18mr14243621pjb.160.1594291662102;
        Thu, 09 Jul 2020 03:47:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyAKKyEJOn2OPR1TxNLbTNDgTH4NXMUC13a9FYI6AbqaAbQEKGo9clQJtIm07XRvUe3qujU7A==
X-Received: by 2002:a17:90b:1c12:: with SMTP id oc18mr14243598pjb.160.1594291661800;
        Thu, 09 Jul 2020 03:47:41 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f6sm2656158pfe.174.2020.07.09.03.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 03:47:41 -0700 (PDT)
Date:   Thu, 9 Jul 2020 18:47:31 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH 2/2] xfs: don't access AGI on unlinked inodes if it
 can
Message-ID: <20200709104731.GE15249@xiangao.remote.csb>
References: <20200707135741.487-1-hsiangkao@redhat.com>
 <20200707135741.487-3-hsiangkao@redhat.com>
 <20200708233311.GP2005@dread.disaster.area>
 <20200709005526.GC15249@xiangao.remote.csb>
 <20200709023246.GR2005@dread.disaster.area>
 <20200709103621.GD15249@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709103621.GD15249@xiangao.remote.csb>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 09, 2020 at 06:36:21PM +0800, Gao Xiang wrote:
> Hi Dave,
> 
> On Thu, Jul 09, 2020 at 12:32:46PM +1000, Dave Chinner wrote:
> 
> ...
> 
> > > > 	if (trylock AGI)
> > > > 		return;
> > > 
> > > (adding some notes here, this patch doesn't use try lock here
> > >  finally but unlock perag and take AGI and relock and recheck tail_empty....
> > >  since the tail non-empty is rare...)
> > 
> > *nod*
> > 
> > My point was largely that this sort of thing is really obvious and
> > easy to optimise once the locking is cleanly separated. Adding a
> > trylock rather than drop/relock is another patch for the series :P
> 
> I thought trylock way yesterday as well...
> Apart from that we don't have the AGI trylock method yet, it seems
> not work as well...
> 
> Thinking about one thread is holding a AGI lock and wants to lock perag.
> And another thread holds a perag, but the trylock will fail and the second
> wait-lock will cause deadlock... like below:
> 
> Thread 1			Thread 2
>  lock AGI
>                                  lock perag
>  lock perag
>                                  trylock AGI
>                                  lock AGI           <- dead lock here
> 
> And trylock perag instead seems not work well as well, since it fails
> more frequently so we need lock AGI and then lock perag as a fallback.
> 
> So currently, I think it's better to use unlock, do something, regrab,
> recheck method for now...
> 
> And yeah, that can be done in another patch if some better way. (e.g.
> moving modifing AGI into pre-commit, so we can only take one per-ag
> lock here...)

Oh, sorry, I didn't notice the words

> 	/*
> 	 * Slow path, need to lock AGI first. Don't even bother
> 	 * rechecking tail pointers or trying to optimise for
> 	 * minimal AGI lock hold time as racing unlink list mods
> 	 * will all block on the perag lock once we take that. They
> 	 * will then hit the !tail empty fast path and not require
> 	 * the AGI lock at all.
> 	 */

If we'd only try to trylock AGI and release perag and relock again,
and that's fine. Sorry about the noise :)

btw, also add some other notes here. For AGI pre-commits, I'm not
quite sure if some users take another locked buffer first (but
without AGI), so it would have some potential locking order concern
as well... But let us think about them later :)

add agi to precommit
lock other buffers

precommit --- lock AGI


Thanks,
Gao Xiang

> 
> Thanks,
> Gao Xiang
> 
> > 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > 

