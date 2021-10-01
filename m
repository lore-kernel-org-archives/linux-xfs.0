Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C03C433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Oct 2021 19:10:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 779066137A
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Oct 2021 19:10:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355661AbhJATMC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Oct 2021 15:12:02 -0400
Received: from sandeen.net ([63.231.237.45]:49114 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355587AbhJATMA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Oct 2021 15:12:00 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 5719414A18;
        Fri,  1 Oct 2021 14:09:35 -0500 (CDT)
Subject: Re: [PATCH 07/61] misc: convert utilities to use "fallthrough;"
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
 <163174723300.350433.15350947081757255516.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0de79a2a-5ab3-2d61-c8f0-7debbd42ec61@sandeen.net>
Date:   Fri, 1 Oct 2021 14:10:13 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <163174723300.350433.15350947081757255516.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/15/21 6:07 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we have a macro to virtualize switch statement fallthroughs for
> lazy compiler linters, we might as well spread it elsewhere.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
