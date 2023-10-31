Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27580C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Oct 2023 17:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344126AbjJaRHn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Oct 2023 13:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236519AbjJaRH2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2023 13:07:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F2AD55
        for <linux-xfs@vger.kernel.org>; Tue, 31 Oct 2023 10:07:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D148C433C9;
        Tue, 31 Oct 2023 17:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698772030;
        bh=5yk+2vvRHUvd55yUpZ3bi/j82qm7dQEJfyStX1WSi+w=;
        h=References:From:To:Cc:Subject:Date:In-reply-to:From;
        b=I1+KHOYHit7M+lnfCavY+JOsoZt/pemQfqwdH2dYRGmN2oPNqgj4OOF7/JHk0OrqR
         G5hSP7hcV7PU9JQoJ44IDl9tR9TYp2aTsTRZ3kQQVLaVV3b4vyJ3PhgSXiugunX1wn
         mGk3NI7je/cVK79eYHZkksfcFi7z+RAW1TsWKnn8ZsaCJUqBhjz+0SXtGa0PtP61Pm
         ApdUUHHyb3/YH5k6Th+tjXS/m/t2Ev3mvYfVaiAy5L81YaDA6sdyX/0vryv7KeTC7a
         l6x246CCRdoqT3oieFOJ+pJ2oGaQxyWtoKsAr3pVgEQxXbMhWWag5IXq4bAG/Jc3Yd
         prUNOB4ztdxmQ==
References: <87fs1s3bk6.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20231031090242.GA25889@lst.de> <20231031164359.GA1041814@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandanbabu@kernel.org>
To:     ruansy.fnst@fujitsu.com
Cc:     Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
        cheng.lin130@zte.com.cn, dan.j.williams@intel.com,
        dchinner@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, osandov@fb.com,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to 22c2699cb068
Date:   Tue, 31 Oct 2023 22:32:30 +0530
In-reply-to: <20231031164359.GA1041814@frogsfrogsfrogs>
Message-ID: <875y2mk9fo.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 31, 2023 at 09:43:59 AM -0700, Darrick J. Wong wrote:
> On Tue, Oct 31, 2023 at 10:02:42AM +0100, Christoph Hellwig wrote:
>> Can you also pick up:
>> 
>> "xfs: only remap the written blocks in xfs_reflink_end_cow_extent"
>> 
>> ?
>> 
>> Also this seems to a bit of a mix of fixes for 6.7 and big stuff that
>> is too late for the merge window.
>
> If by 'big stuff' you mean the MF_MEM_PRE_REMOVE patch, then yes, I
> agree that it's too late to be changing code outside xfs.  Bumping that
> to 6.8 will disappoint Shiyang, regrettably.
>

I am sorry Shiyang, I will have to postpone your "mm, pmem, xfs: Introduce
MF_MEM_PRE_REMOVE for unbind" patch for v6.8. The delay was my
mistake. Apologies once again.

I have updated xfs-linux's for-next branch and I will be sending an
announcement shortly.

-- 
Chandan
