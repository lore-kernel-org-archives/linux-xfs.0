Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B573C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 13:37:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 643C920936
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 13:37:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LDsfAU8k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgHaNhm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 09:37:42 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27821 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726121AbgHaNhl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 09:37:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598881059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=huIc2brJ2Y87/fvIX9rpSMlVmVaCtQdQPkXWsAobIjk=;
        b=LDsfAU8k9HMeLz3GPlogEUFnnEO3qD0gje76nwLS4xjwGY+4hM8OQI2N1jsKa17BZhNROR
        5nC9ykAz86BSQNwauKDxRJRRZgDoDDss3FXgrbXTY60Y7CN6wFRI98xbT/vrC3GtSmw/zm
        R8rxT5tSJAEPdsKgSNke3YL7kbYrfj0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-709N_SKFNSO0ifmKW_Ep-A-1; Mon, 31 Aug 2020 09:37:35 -0400
X-MC-Unique: 709N_SKFNSO0ifmKW_Ep-A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEB108030A5;
        Mon, 31 Aug 2020 13:37:34 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C8518658E;
        Mon, 31 Aug 2020 13:37:34 +0000 (UTC)
Date:   Mon, 31 Aug 2020 09:37:32 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] generic: disable dmlogwrites tests on XFS
Message-ID: <20200831133732.GB2667@bfoster>
References: <20200827145329.435398-1-bfoster@redhat.com>
 <20200829064850.GC29069@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200829064850.GC29069@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Aug 29, 2020 at 07:48:50AM +0100, Christoph Hellwig wrote:
> On Thu, Aug 27, 2020 at 10:53:29AM -0400, Brian Foster wrote:
> > Several generic fstests use dm-log-writes to test the filesystem for
> > consistency at various crash recovery points. dm-log-writes and the
> > associated replay mechanism rely on discard to clear stale blocks
> > when moving to various points in time of the fs. If the storage
> > doesn't provide discard zeroing or the discard requests exceed the
> > hardcoded maximum (128MB) of the fallback solution to physically
> > write zeroes, stale blocks are left around in the target fs. This
> > causes issues on XFS if recovery observes metadata from a future
> > version of an fs that has been replayed to an older point in time.
> > This corrupts the filesystem and leads to spurious test failures
> > that are nontrivial to diagnose.
> > 
> > Disable the generic dmlogwrites tests on XFS for the time being.
> > This is intended to be a temporary change until a solution is found
> > that allows these tests to predictably clear stale data while still
> > allowing them to run in a reasonable amount of time.
> 
> As said in the other discussion I don't think this is correct.  The
> intent of the tests is to ensure the data can't be read.  You just
> happen to trigger over that with XFS, but it also means that tests
> don't work correctly on other file systems in that configuration.
> 

Yes, but the goal of this patch is not to completely fix the dmlogwrites
infrastructure and set of tests. The goal is to disable a subset of
tests that are known to produce spurious corruptions on XFS until that
issue can be addressed, so it doesn't result in continued bug reports in
the meantime. I don't run these tests routinely on other fs', so it's
not really my place to decide that the tradeoff between this problem and
the ability of the test to reproduce legitimate bugs justifies disabling
the test on those configs.

Brian

