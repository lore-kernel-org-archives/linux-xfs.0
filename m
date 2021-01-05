Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 053F6C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 11:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A752122AAA
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 11:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729794AbhAELzw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jan 2021 06:55:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37182 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727535AbhAELzv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jan 2021 06:55:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609847665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e0nONi74seQQ3/73G+C+XNciKPevj4MghrVkajqoFas=;
        b=Stb777CWPyOBpOP/CIvmbUkXIcHyfjTN65CWrtWA8E/LLRl6kVOWER05Je/5FJ+gto68xq
        jNkRfVLQ8g74YyadK2eDFnMoZxLlUxufIpwWl0yqQ/0UWwFXBIzcIwP5pDu/G75TxYy2dd
        Z18Y3mjAhulc0VjUhK8idHUJk/ucOSQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-zY1xJOWzOrCSIIba8gIWsw-1; Tue, 05 Jan 2021 06:54:23 -0500
X-MC-Unique: zY1xJOWzOrCSIIba8gIWsw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 871C6873117;
        Tue,  5 Jan 2021 11:54:22 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 180431001281;
        Tue,  5 Jan 2021 11:54:22 +0000 (UTC)
Date:   Tue, 5 Jan 2021 06:54:20 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic/388: randomly recover via read-only mounts
Message-ID: <20210105115420.GA286564@bfoster>
References: <20201217145941.2513069-1-bfoster@redhat.com>
 <20210104183424.GA6919@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104183424.GA6919@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 04, 2021 at 10:34:24AM -0800, Darrick J. Wong wrote:
> On Thu, Dec 17, 2020 at 09:59:41AM -0500, Brian Foster wrote:
> > XFS has an issue where superblock counters may not be properly
> > synced when recovery occurs via a read-only mount. This causes the
> > filesystem to become inconsistent after unmount. To cover this test
> > case, update generic/388 to switch between read-only and read-write
> > mounts to perform log recovery.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > I didn't think it was worth duplicating generic/388 to a whole new test
> > just to invoke log recovery from a read-only mount. generic/388 is a
> > rather general log recovery test and this preserves historical behavior
> > of the test.
> > 
> > A prospective fix for the issue this reproduces on XFS is posted here:
> > 
> > https://lore.kernel.org/linux-xfs/20201217145334.2512475-1-bfoster@redhat.com/
> > 
> > Brian
> > 
> >  tests/generic/388 | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tests/generic/388 b/tests/generic/388
> > index 451a6be2..cdd547f4 100755
> > --- a/tests/generic/388
> > +++ b/tests/generic/388
> > @@ -66,8 +66,14 @@ for i in $(seq 1 $((50 * TIME_FACTOR)) ); do
> >  		ps -e | grep fsstress > /dev/null 2>&1
> >  	done
> >  
> > -	# quit if mount fails so we don't shutdown the host fs
> > -	_scratch_cycle_mount || _fail "cycle mount failed"
> > +	# Toggle between rw and ro mounts for recovery. Quit if any mount
> > +	# attempt fails so we don't shutdown the host fs.
> > +	if [ $((RANDOM % 2)) -eq 0 ]; then
> > +		_scratch_cycle_mount || _fail "cycle mount failed"
> > +	else
> > +		_scratch_cycle_mount "ro" || _fail "cycle ro mount failed"
> > +		_scratch_cycle_mount || _fail "cycle mount failed"
> 
> I would change that third failure message to something distinct, like:
> 
> _fail "cycle remount failed"
> 
> To give us extra clues as to which branch encountered failure.
> This looks like a fun way to find new bugs. :)
> 

Sure.. I tweaked it to "cycle rw mount failed" so it's distinct, yet
more consistent with the preceding ro cycle.

Brian

> --D
> 
> > +	fi
> >  done
> >  
> >  # success, all done
> > -- 
> > 2.26.2
> > 
> 

