Return-Path: <SRS0=Wnnb=7W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 111DDC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Jun 2020 02:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE092207ED
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Jun 2020 02:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591668624;
	bh=A72458j4sJI/JLoJmbyObVzh04yEecl6cOD+0q9SGAs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Dtom2keam8SMLLjwlGZAk5BNyfaztxjRS9Bw0ziHcWrtKvCXy/LvJ8A3H6W1ZvoqW
	 382pBNYurGjI7qHkY1337dV1qdsrAbhcua3NawqkpwtE4H/a2Ze4E5tRbNDWqcwO3r
	 CbvHx5oLff6XVsaCv2dnIUcrYC3Mz7Bey3rtymlQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgFICKY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Jun 2020 22:10:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726749AbgFICKW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Jun 2020 22:10:22 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13EC0206D5;
        Tue,  9 Jun 2020 02:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591668622;
        bh=A72458j4sJI/JLoJmbyObVzh04yEecl6cOD+0q9SGAs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mqjyTnRp1evL7EEwUP8D4GIlw4oP2hD357uU64QsaQI0Ux4QdtR4v30gbwofDo8Z/
         ZnS/TzthsT45G0wnO6RtSoRk1QEs8VraNiG0HQCk8yuMYqE6iu9koqRudUcrEJe9mV
         nbWEnqKRwePK4WJcQhQmLJlQGOasKGNn73e6ZAeA=
Date:   Mon, 8 Jun 2020 22:10:21 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.7 244/274] xfs: force writes to delalloc
 regions to unwritten
Message-ID: <20200609021021.GU1407771@sasha-vm>
References: <20200608230607.3361041-1-sashal@kernel.org>
 <20200608230607.3361041-244-sashal@kernel.org>
 <20200609010727.GN1334206@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200609010727.GN1334206@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 08, 2020 at 06:07:27PM -0700, Darrick J. Wong wrote:
>On Mon, Jun 08, 2020 at 07:05:37PM -0400, Sasha Levin wrote:
>> From: "Darrick J. Wong" <darrick.wong@oracle.com>
>>
>> [ Upstream commit a5949d3faedf492fa7863b914da408047ab46eb0 ]
>>
>> When writing to a delalloc region in the data fork, commit the new
>> allocations (of the da reservation) as unwritten so that the mappings
>> are only marked written once writeback completes successfully.  This
>> fixes the problem of stale data exposure if the system goes down during
>> targeted writeback of a specific region of a file, as tested by
>> generic/042.
>>
>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Err, this doesn't have a Fixes: tag attached to it.  Does it pass
>fstests?  Because it doesn't look like you've pulled in "xfs: don't fail
>unwritten extent conversion on writeback due to edquot", which is needed
>to avoid regressing fstests...
>
>...waitaminute, that whole series lacks Fixes: tags because it wasn't
>considered a good enough candidate for automatic backport.

AUTOSEL doesn't look just at the Fixes tag :)

>Ummm, does the autosel fstests driver turn on quotas? ;)

Uh, apparently not :/ Is it okay to just enable it across all tests?

While I go fix that up, would you rather drop the series, or pick up
1edd2c055dff ("xfs: don't fail unwritten extent conversion on writeback
due to edquot")?`

-- 
Thanks,
Sasha
