Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03FBBC77B7C
	for <linux-xfs@archiver.kernel.org>; Sun, 28 May 2023 07:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbjE1HB1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 May 2023 03:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjE1HBY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 May 2023 03:01:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84187AD;
        Sun, 28 May 2023 00:01:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19CAB60BA0;
        Sun, 28 May 2023 07:01:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34713C433D2;
        Sun, 28 May 2023 07:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1685257282;
        bh=uO8kTig4AI0uJWG+0pQ2RAJ2v9OJQ3j51WavEA8SKEM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vIJ5Vdg7uo5zD8duhlbKdyasp0Lm7h7iD0qbCGJT5iEdy8y4zx3aK2oTTOcWxv5sC
         CDTJ5oi/ki6JyivZp44sf4gUKX+KHQ9AAtyw5zZ8/T6E7PlViwQaGc+yzjwHzeM5Nv
         vG7iC3hiBUYI3FetTqcS2zZJIF1aC49HboUljKuU=
Date:   Sun, 28 May 2023 08:01:20 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH, STABLE 6.3.x] xfs: fix livelock in delayed allocation at
 ENOSPC
Message-ID: <2023052807-chasing-same-5643@gregkh>
References: <ZHKB/KD1yyx77fop@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHKB/KD1yyx77fop@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 28, 2023 at 08:19:40AM +1000, Dave Chinner wrote:
> Hi Greg,
> 
> A regression in 6.3.0 has been identified in XFS that causes
> filesystem corruption.  It has been seen in the wild by a number of
> users, and bisected down to an issued we'd already fixed in 6.4-rc1
> with commit:
> 
> 9419092fb263 ("xfs: fix livelock in delayed allocation at ENOSPC")
> 
> This was reported with much less harmful symptoms (alloctor
> livelock) and it wasn't realised that it could have other, more
> impactful symptoms. A reproducer for the corruption was found
> yesterday and, soon after than, the cause of the corruption reports
> was identified.
> 
> The commit applies cleanly to a 6.3.0 kernel here, so it should also
> apply cleanly to a current 6.3.x kernel. I've included the entire
> commit below in case that's easier for you.
> 
> Can you please pull this commit into the next 6.3.x release as a
> matter of priority?

Now queued up, thanks.

greg k-h
