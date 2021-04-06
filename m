Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24F86C433B4
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 13:48:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E19A4613C7
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 13:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbhDFNsv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Apr 2021 09:48:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46784 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232452AbhDFNsv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Apr 2021 09:48:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617716923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ee8rjFcbiMXX513SPOnO6pLoWIY9xGaUTWx6oZ4clWg=;
        b=UZXMy8um+RCbetx1y61d+UnXqP1kflAWO1Fma28vCcETWekrMI/q0+W6O0WSOWtVRp9azB
        5Ru14OoAb91iGPTJai6xKZWP7dzOdADuzfLDjt6qRwEEIKFtMIG04Di60eowAHpKSzTB3V
        Cr0w920C0SDmkj+hy9QzZpwGwrw20M8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-cwtH-DHUOSi3CM432kkHLg-1; Tue, 06 Apr 2021 09:48:39 -0400
X-MC-Unique: cwtH-DHUOSi3CM432kkHLg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 705CD10866A3;
        Tue,  6 Apr 2021 13:48:38 +0000 (UTC)
Received: from bfoster (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E6F51893C;
        Tue,  6 Apr 2021 13:48:38 +0000 (UTC)
Date:   Tue, 6 Apr 2021 09:48:36 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/4 v2] xfs: fix eager attr fork init regressions
Message-ID: <YGxmtKiUcvz+s+zC@bfoster>
References: <20210406115923.1738753-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406115923.1738753-1-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 06, 2021 at 09:59:19PM +1000, Dave Chinner wrote:
> Hi Folks,
> 
> Update to the fixup patch set first posted here:
> 
> https://lore.kernel.org/linux-xfs/20210330053059.1339949-1-david@fromorbit.com/
> 
> Really the only change is to patch 2, which has had the commit
> message reworked just to state the problem being fixed, along with a
> change in implementation that Christoph suggested.
> 
> This version has passed through fstests on a SELinux enabled test
> machine without issues.
> 

This series seems to resolve the issues I was hitting previously. FWIW,
for the set:

Tested-by: Brian Foster <bfoster@redhat.com>

> Cheers,
> 
> Dave.
> 

