Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFFADC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Nov 2022 09:05:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbiKKJFm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Nov 2022 04:05:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233485AbiKKJFR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Nov 2022 04:05:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA680655A;
        Fri, 11 Nov 2022 01:05:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57C0E61F02;
        Fri, 11 Nov 2022 09:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C14FC433C1;
        Fri, 11 Nov 2022 09:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668157513;
        bh=I9DD/gwIrOrAMx5p9Q0QNz4wiHudLE0e1AOXpHF+OE4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MGGrwqGVE4/tS6CyJ155A4LJWyEVhRlPvPcyzjGCS1SAY/HZF/md8Mr81xQXwG5eq
         A0Vb1p4qoMqM5c/JF71ba68w7UtGP0RFw/GPl4FNp99F+ybUJRYHfsYimkwVpTyK/C
         woE6Kiya5ki+O347kvLsZFB0cJjW0BEo+wcuA2z0=
Date:   Fri, 11 Nov 2022 10:04:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 0/6] xfs stable candidate patches for 5.4.y (from
 v5.9)
Message-ID: <Y24QOy837I6eLxkT@kroah.com>
References: <20221111041025.87704-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221111041025.87704-1-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 11, 2022 at 09:40:19AM +0530, Chandan Babu R wrote:
> Hi Greg,
> 
> This 5.4.y backport series contains XFS fixes from v5.9. The patchset
> has been acked by Darrick.
> 

Now queued up, thanks.

greg k-h
