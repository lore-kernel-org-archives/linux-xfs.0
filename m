Return-Path: <SRS0=b91c=A3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 997ADC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 10:39:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 740C92074B
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 10:39:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Glx7iSp9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbgGPKjr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 06:39:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23036 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726239AbgGPKjq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 06:39:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594895985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B3C5L0IdmyJAVuEFqWJF6DtIwfW7xnPsEcp+akF4VIQ=;
        b=Glx7iSp98KFLd+VzEx9qKj9i7NAgdUF9CypBV5sduhAkg0kyhmYC8Q0n7tzQVg013r4l1Q
        kulRkTkCHA3wx2eoEkX5Uh5XjA68xMVXI5I2am11CmRTVy6tbch5mzJJdlmaa/LRS5MIbn
        SGvksYc36BFRv9aBeOOrKxsfbk0ZAJQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-LmSGS1MoOrCc8La004HSxw-1; Thu, 16 Jul 2020 06:39:43 -0400
X-MC-Unique: LmSGS1MoOrCc8La004HSxw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F382100CCC5;
        Thu, 16 Jul 2020 10:39:42 +0000 (UTC)
Received: from bfoster (ovpn-113-214.rdu2.redhat.com [10.10.113.214])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E50AF72ACF;
        Thu, 16 Jul 2020 10:39:41 +0000 (UTC)
Date:   Thu, 16 Jul 2020 06:39:40 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] repair: don't double check dir2 sf parent in phase 4
Message-ID: <20200716103940.GA26218@bfoster>
References: <20200715140836.10197-1-bfoster@redhat.com>
 <20200715140836.10197-3-bfoster@redhat.com>
 <20200715184350.GB23618@infradead.org>
 <20200715235414.GF3151642@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715235414.GF3151642@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 04:54:14PM -0700, Darrick J. Wong wrote:
> On Wed, Jul 15, 2020 at 07:43:50PM +0100, Christoph Hellwig wrote:
> > On Wed, Jul 15, 2020 at 10:08:34AM -0400, Brian Foster wrote:
> > > The shortform parent ino verification code runs once in phase 3
> > > (ino_discovery == true) and once in phase 4 (ino_discovery ==
> > > false). This is unnecessary and leads to duplicate error messages if
> > > repair replaces an invalid parent value with zero because zero is
> > > still an invalid value. Skip the check in phase 4.
> > 
> > This looks good,
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> > As far as the existing code is concerned:  Does anyone else find the
> > ino_discovery booleand passed as int as annoying as I do?  An
> > "enum repair_phase phase" would be much more descriptive in my opinion.
> 
> I can never remember what "ino_discovery" actually means.  true means
> phase2 (looking at inodes for the first time) and false means phase4
> (looking for crosslinked data and whatnot)?
> 

Same.. I agree with Christoph on not just ino_discovery, but the various
boolean parameters to some of the common scanning functions that are
reused across multiple phases. It's confusing to track when reading the
code as well as to identify intent and whether certain hunks of
idempotent code are running multiple times, etc.

That said, I'm not necessarily convinced that replacing the booleans
with a phase enum is a huge benefit. That just changes the interface so
it's easier to determine what phase we're in vs. why certain bits of
logic are executed. I.e., 'if (ino_discovery) { do_discovery_stuff(); }'
confuses what phase we're in when reading the lower level code, but 'if
(phase == PHASE_3) { do_discovery_stuff() }' doesn't really clarify how
do_discovery_stuff() might interact with other behaviors that are part
of the same phase.

I'm not sure what the right answer is but if we're going to look at
refactoring things, I'd rather see us start with considering something
more fundamental. For example, could we perhaps factor out the the phase
specific functionality into phase specific functions via an approach
like Darrick's recent log recovery rework?  That way it might be easier
to read through each phase and understand the core repair logic vs.
having to troll through scanning infrastructure multiple times trying to
keep track of where you are in the grand scheme of things. Of course if
that is too much of a mess then perhaps the phase enum thing makes more
sense..

Brian

> --D
> 

