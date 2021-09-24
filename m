Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD0A5C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 23:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF6D1610C9
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 23:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345801AbhIXXEe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Sep 2021 19:04:34 -0400
Received: from sandeen.net ([63.231.237.45]:39878 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232123AbhIXXEe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 Sep 2021 19:04:34 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id C574947753B;
        Fri, 24 Sep 2021 18:02:30 -0500 (CDT)
To:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, david@fromorbit.com,
        djwong@kernel.org
References: <20210924140912.201481-1-chandan.babu@oracle.com>
 <20210924140912.201481-5-chandan.babu@oracle.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH V2 4/5] libxfs: add kernel-compatible completion API
Message-ID: <a268ae0e-01c4-c0cc-5144-adb9128d5d3a@sandeen.net>
Date:   Fri, 24 Sep 2021 18:02:57 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210924140912.201481-5-chandan.babu@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/24/21 9:09 AM, Chandan Babu R wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This is needed for the kernel buffer cache conversion to be able
> to wait on IO synchrnously. It is implemented with pthread mutexes
> and conditional variables.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

I am inclined to not merge patches 4 or 5 until there's something that
uses it. It can be merged and tested together with consumers, rather
than adding unused code at this point.  Thoughts?

-Eric
