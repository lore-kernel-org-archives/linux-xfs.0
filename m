Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AF69C07E96
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Jul 2021 23:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 405EC61457
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Jul 2021 23:12:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhGHXPA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Jul 2021 19:15:00 -0400
Received: from sandeen.net ([63.231.237.45]:47958 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhGHXO5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Jul 2021 19:14:57 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B6B3C550;
        Thu,  8 Jul 2021 18:11:28 -0500 (CDT)
Subject: Re: [PATCH 1/1] xfs_io: allow callers to dump fs stats individually
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <162528110197.38907.6647015481710886949.stgit@locust>
 <162528110744.38907.9770913472348824425.stgit@locust>
 <b85719a6-ffd0-dfcd-431d-12cf4987bcf7@sandeen.net>
 <20210708224057.GK11588@locust>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <37448098-829a-f706-b7ea-5f5ad7df2109@sandeen.net>
Date:   Thu, 8 Jul 2021 18:12:12 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210708224057.GK11588@locust>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/8/21 5:40 PM, Darrick J. Wong wrote:
> I'll change it to:
> 
>        statfs [ -c ] [ -g ] [ -s ]
>               Report selected statistics on the filesystem  where  the
>               current file resides.  The default behavior is to enable
>               all three reporting options:
>                  -c     Display  XFS_IOC_FSCOUNTERS  summary   counter
>                         data.
>                  -g     Display XFS_IOC_FSGEOMETRY filesystem geometry
>                         data.
>                  -s     Display statfs(2) data.
> 
> If that's ok.  I got rid of -a because it's redundant.

sure, sounds good.

-Eric
