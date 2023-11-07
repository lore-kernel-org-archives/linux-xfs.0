Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 919B9C4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 07:15:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjKGHPm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 02:15:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjKGHPl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 02:15:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37820FD
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 23:15:39 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5908AC433C7;
        Tue,  7 Nov 2023 07:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699341338;
        bh=9Qyx1NauleLgHn+g/dTJxnkKTRe0g3PH8O2Bnk/0uVk=;
        h=References:From:To:Cc:Subject:Date:In-reply-to:From;
        b=Huvp6ZkZoL1F8cl5ZeGIkqCDjP09nSyKZK3yzOi5JhR6wvM0h68oTosEIPpVFMWI4
         uUwPaXpk686BwU6WR+FNcAdThybWGJef5IZ+fwAz9Kvtb7M0Lu0OS42UZF2THDNRQF
         1KMst2HGlbxQdg9NwEU4KxBTedQn7fYEnt5M9y/YNmyMF6BzPAofH5+rjIa0tsmJ74
         z5QOofrcM3GLINsDvuRcRYpMsidWoEyc1Egp3Bw2i5fvP5fBj5aIqel6HVvbHiaGmG
         2Ayt89QD5smYGFlJyLCvESgTiuol6WMjvojhVSrC36a8DaedsIpyyrWQmMFFXquMCQ
         UVS6W97Hg55pQ==
References: <20231106131054.143419-1-chandan.babu@oracle.com>
 <20231106131054.143419-18-chandan.babu@oracle.com>
 <20231106221542.GI1205143@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandanbabu@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V4 17/21] mdrestore: Replace metadump header pointer
 argument with a union pointer
Date:   Tue, 07 Nov 2023 12:44:24 +0530
In-reply-to: <20231106221542.GI1205143@frogsfrogsfrogs>
Message-ID: <87a5rq11bd.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 06, 2023 at 02:15:42 PM -0800, Darrick J. Wong wrote:
> On Mon, Nov 06, 2023 at 06:40:50PM +0530, Chandan Babu R wrote:
>> From: Chandan Babu R <chandanbabu@kernel.org>
>> 
>> We will need two variants of read_header(), show_info() and restore() helper
>> functions to support two versions of metadump formats. To this end, A future
>> commit will introduce a vector of function pointers to work with the two
>> metadump formats. To have a common function signature for the function
>> pointers, this commit replaces the first argument of the previously listed
>> function pointers from "struct xfs_metablock *" with "union
>> mdrestore_headers *".
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>
> Looks pretty straightfoward now; thanks for fixing this...
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>

Thanks for reviewing the entire patchset!

-- 
Chandan
