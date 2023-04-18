Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F9A3C77B76
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Apr 2023 10:53:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjDRKxa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Apr 2023 06:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjDRKx3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Apr 2023 06:53:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E940E2696;
        Tue, 18 Apr 2023 03:53:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73F5D624E4;
        Tue, 18 Apr 2023 10:53:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A45C433EF;
        Tue, 18 Apr 2023 10:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681815207;
        bh=WxkptfxAzgFCOaCxoIVhdLEKJtkMFDosAKLKAvc1Ip0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QmVeeISUBfC5RInvP/iEFZiJFi7/oMFmGDvsnCHyMgwEzq1Zc0pf51xz8aC7DEmRA
         5b72PIwns7zA29C52JMSf0vT1+XYXXCkajXCUC8Mt4l39BXhNayCUMh4rdgfN5uYvo
         awqLHBZzxJtYLmtqtETrHiL+/+K9wnSZiEYryrpQ=
Date:   Tue, 18 Apr 2023 12:53:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 00/17] xfs stable candidate patches for 5.4.y (from
 v5.11 & v5.12)
Message-ID: <2023041814-conclude-herring-f2dd@gregkh>
References: <20230412042624.600511-1-chandan.babu@oracle.com>
 <2023041853-plow-shiny-22f3@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023041853-plow-shiny-22f3@gregkh>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 18, 2023 at 11:49:04AM +0200, Greg KH wrote:
> On Wed, Apr 12, 2023 at 09:56:07AM +0530, Chandan Babu R wrote:
> > Hi Greg,
> > 
> > This 5.4.y backport series contains XFS fixes from v5.11 & v5.12. The
> > patchset has been acked by Darrick.
> > 
> > As a side note, where applicable, patches have been cherry picked from
> > 5.10.y rather than from v5.11/v5.12.
> 
> all now queued up, thanks.

Wait, did you miss commit ada49d64fb35 ("xfs: fix forkoff miscalculation
related to XFS_LITINO(mp)")?
