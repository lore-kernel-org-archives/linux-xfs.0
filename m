Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0684C43334
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jun 2022 01:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbiFHBLy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jun 2022 21:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391353AbiFHAh4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jun 2022 20:37:56 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E899FC7
        for <linux-xfs@vger.kernel.org>; Tue,  7 Jun 2022 16:59:49 -0700 (PDT)
Subject: Re: xfs/148 fails with 5.19-rc1 kernel
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654646387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3bD6swNr/YrvEEdc3YC9Jvnk/V+r23BYWE6MXqhOrDQ=;
        b=Otg6AZue31mPMGeliIPhcA7+NQnpyQoKw3FobW4N9AJgBay8IoFwLJwPOkcnJJWLPek9j2
        rMyQEsulVTh4Nf7s/rczclphOUnXnk/qYDFkg1HiJKp/E0NZl/abJE5fYrR1eBArkpUNyV
        96XBH0EfXpKZEjKFv1o9Wpef7QmfiI8=
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <f7de0b18-f10b-6b2e-65a2-3c7e1593b096@linux.dev>
 <Yp9tPdZIXHzd+Hct@magnolia>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <95304ea8-1cb1-4807-06ff-ec5265b0c743@linux.dev>
Date:   Wed, 8 Jun 2022 07:59:39 +0800
MIME-Version: 1.0
In-Reply-To: <Yp9tPdZIXHzd+Hct@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/7/22 11:22 PM, Darrick J. Wong wrote:
> On Tue, Jun 07, 2022 at 11:20:12AM +0800, Guoqing Jiang wrote:
>> Hi,
>>
>> The latest 5.19-rc1 kernel failed with xfs/148 test as follows, is it a
>> known issue?
> That depends, have you pulled the 2022-05-22 release of fstests?
> There's a fix for xfs/148 in there.

Thank you! The result is fine after pull latest code.

Thanks,
Guoqing
