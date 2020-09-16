Return-Path: <SRS0=KYGq=CZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B90C433E2
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 18:58:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFCDD20809
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 18:58:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M4BZhENe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbgIPRwC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 13:52:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58945 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727611AbgIPRvX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 13:51:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600278671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8ppAddFWBY5GKELxLK2gBWTu6Ghql/eVZT5FuPia91Y=;
        b=M4BZhENeg19q1jAETNHBrRfPB7reAipgGw1cXS9o+WnsXTDF8duKz67VB8+HCdr/bkIXwH
        Kp1XsN6N0ow7pKtc9h/Gs72NQiusY+AaLyWDYn649IROBQjzSuifN9cVBA6nOVqmv3hNDU
        9Rg7O1rpsu3Qs4y+phfEZiqFp/wY4tI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-rK_dmSbDPQmfP_XhM-L4Sw-1; Wed, 16 Sep 2020 07:11:39 -0400
X-MC-Unique: rK_dmSbDPQmfP_XhM-L4Sw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EAD4C8018A7;
        Wed, 16 Sep 2020 11:11:37 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 649E619D61;
        Wed, 16 Sep 2020 11:11:37 +0000 (UTC)
Date:   Wed, 16 Sep 2020 19:25:36 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 09/24] xfs/070: add scratch log device options to direct
 repair invocation
Message-ID: <20200916112536.GE2937@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013423329.2923511.3252823001209034556.stgit@magnolia>
 <20200916024247.GA2937@dhcp-12-102.nay.redhat.com>
 <20200916034201.GC7954@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916034201.GC7954@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 15, 2020 at 08:42:01PM -0700, Darrick J. Wong wrote:
> On Wed, Sep 16, 2020 at 10:42:47AM +0800, Zorro Lang wrote:
> > On Mon, Sep 14, 2020 at 06:43:53PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  tests/xfs/070 |    4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > 
> > > diff --git a/tests/xfs/070 b/tests/xfs/070
> > > index 5d52a830..313864b7 100755
> > > --- a/tests/xfs/070
> > > +++ b/tests/xfs/070
> > > @@ -41,9 +41,11 @@ _cleanup()
> > >  _xfs_repair_noscan()
> > >  {
> > >  	# invoke repair directly so we can kill the process if need be
> > > +	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
> > > +		log_repair_opts="-l $SCRATCH_LOGDEV"
> > >  	[ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_RTDEV" ] && \
> > >  		rt_repair_opts="-r $SCRATCH_RTDEV"
> > > -	$XFS_REPAIR_PROG $rt_repair_opts $SCRATCH_DEV 2>&1 |
> > > +	$XFS_REPAIR_PROG $log_repair_opts $rt_repair_opts $SCRATCH_DEV 2>&1 |
> > >  		tee -a $seqres.full > $tmp.repair &
> > 
> > Why not use _scratch_xfs_repair at here?
> > 
> > Thanks,
> > Zorro
> > 
> > >  	repair_pid=$!
> 
>         ^^^^^^^^^^^^^

Oh, right! That's good to me now.
Reviewed-by: Zorro Lang <zlang@redhat.com>

> Because this test needs to hang on to the pid of the repair process in
> order to kill it, which you can't do if do if you use the wrapper.
> 
> --D
> 
> > >  
> > > 
> > 
> 

