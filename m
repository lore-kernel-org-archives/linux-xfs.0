Return-Path: <SRS0=myhp=BJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 882D6C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jul 2020 17:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D60E2083B
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jul 2020 17:52:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ReyECiPQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgG3Rwb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jul 2020 13:52:31 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46019 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgG3Rwa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jul 2020 13:52:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596131549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aeQQ8tS8xTgZEZL00ONp+I1ZSzaCApELKLGdSud+FCQ=;
        b=ReyECiPQlbGMPfWPS8giTlwge6IvVNeq41JWR8ZMXK7YRJNuGtK+0tprydN2OujgaEEp3r
        tWu/LMtc28jndbXTSG35Y+eBjD21GAxx7Z+iCpE5Oz/YyKu2Mk+h8Sshu3FtrQ6i0QZh2j
        KOQe1jIUdbzH73ZKjKXjP8qQtp3wuKI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-GP6maEBHNeW-14M1xmeK5Q-1; Thu, 30 Jul 2020 13:52:24 -0400
X-MC-Unique: GP6maEBHNeW-14M1xmeK5Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 25E9A800465;
        Thu, 30 Jul 2020 17:52:23 +0000 (UTC)
Received: from redhat.com (ovpn-116-244.rdu2.redhat.com [10.10.116.244])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D64C87B0E;
        Thu, 30 Jul 2020 17:52:22 +0000 (UTC)
Date:   Thu, 30 Jul 2020 12:52:20 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: Re: [PATCH 0/3] xfsprogs: xfs_quota error message and state
 reporting improvement
Message-ID: <20200730175220.GA306320@redhat.com>
References: <20200715201253.171356-1-billodo@redhat.com>
 <910cf53e-62fe-c4b4-2892-5b5cd0821ac3@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <910cf53e-62fe-c4b4-2892-5b5cd0821ac3@sandeen.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 30, 2020 at 10:46:18AM -0700, Eric Sandeen wrote:
> On 7/15/20 1:12 PM, Bill O'Donnell wrote:
> > 
> > This patchset improves xfs_quota command error message output as well as
> > adding reporting for grace times and warning limits for state (u,g,p).
> > 
> > Note that patches to xfstests to handle these changes will be forthcoming.
> > Also, patch 1 was originally submitted separately:
> >   (xfsprogs: xfs_quota command error message improvement)
> > 
> > patch 1 contains the command error message improvements.
> > patch 2 contains the warning limit reporting (originally SoB Darrick Wong).
> > patch 3 contains the additional state reporting of grace times for u,g,p.
> > 
> > Comments appreciated. Thanks-
> > Bill
> 
> Hi Bill - 
> 
> These look good and have reviews, but we need xfstests fixed up with filters
> now, multiple tests now have output that doesn't match expected, causing
> failures:

I'll work on it. Thanks for the reminder.
-Bill

> 
> xfs/106	- output mismatch (see /root/xfstests-dev/results//xfs/106.out.bad)
>     --- tests/xfs/106.out	2017-08-28 12:17:34.950134054 -0400
>     +++ /root/xfstests-dev/results//xfs/106.out.bad	2020-07-30 13:34:26.889836623 -0400
>     @@ -102,7 +102,9 @@
>       Enforcement: OFF
>       Inode: #[INO] (X blocks, Y extents)
>      Blocks grace time: [3 days]
>     +Blocks max warnings: 5
>      Inodes grace time: [3 days]
>     +Inodes max warnings: 5
>      Realtime Blocks grace time: [7 days]
> 
> 
> Thanks,
> -Eric
> 

