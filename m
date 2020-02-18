Return-Path: <SRS0=Vmdp=4G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73F3FC34031
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Feb 2020 04:39:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DB9B206EF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Feb 2020 04:39:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A23b9Dej"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgBREjZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 23:39:25 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30810 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbgBREjZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 23:39:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582000764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+fty7zVYrz/BkkQhX/l5UJqwhY7OxI3ialsYngVbkhI=;
        b=A23b9Dej+mUhhZDeGFYaUBYC+qC6YFzlyWyPRjzWOdeMZDhE4UA7z8YxP+mix15oTrWCFf
        wExQu6YlcewSQg6yvG9cPKOJB86JmVFSUnYJVWi36noEZatoMmtr7p1fKwrXR+ld7YhNC5
        1xCzx4R6Qcv/pYTiUuLguezDXgVPTrI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-2z-JYhRIMW68DSY71yteRw-1; Mon, 17 Feb 2020 23:39:20 -0500
X-MC-Unique: 2z-JYhRIMW68DSY71yteRw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 210B2107ACC4
        for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2020 04:39:19 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D416385;
        Tue, 18 Feb 2020 04:39:15 +0000 (UTC)
Date:   Tue, 18 Feb 2020 12:49:34 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 0/4] xfs: enable per-type quota timers and warn limits
Message-ID: <20200218044934.GA14282@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <333ea747-8b45-52ae-006e-a1804e14de32@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <333ea747-8b45-52ae-006e-a1804e14de32@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Feb 08, 2020 at 03:09:19PM -0600, Eric Sandeen wrote:
> Quota timers are currently a mess.  Right now, at mount time,
> we pick up the first enabled type and use that for the single
> timer in mp->m_quotainfo.
> 
> Interestingly, if we set a timer on a different type, /that/
> gets set into mp->m_quotainfo where it stays in effect until
> the next mount, when we pick the first enabled type again.
> 
> We actually write the timer values to each type of quota inode,
> but only one is ever in force, according to the interesting behavior
> described above.
> 
> This series allows quota timers & warn limits to be independently
> set and enforced for each quota type.
> 
> All the action is in the last patch, the first 3 are cleanups to
> help.

This patchset looks good, but the testing for xfs quota timers looks
not so well. Please check the emails(test case) I sent to fstests@:
  [PATCH 1/2] generic: per-type quota timers set/get test
  [PATCH 2/2] generic: test per-type quota softlimit enforcement timeout

Why xfs has such different test results? Please feel free to tell me,
if the case is wrong.

Thanks,
Zorro

> 
> -Eric
> 

