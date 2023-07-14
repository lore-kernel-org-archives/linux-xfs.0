Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E7B4C0015E
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Jul 2023 14:55:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236171AbjGNOzC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Jul 2023 10:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235943AbjGNOzB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2023 10:55:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729CB35AF
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 07:54:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0765D61D42
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 14:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602E8C433C7;
        Fri, 14 Jul 2023 14:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689346480;
        bh=Ort8b/JRJcCMSuenBgRiNhmp3hA7osvTAMCTN6e3yW0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e17ioByVY1XYLemPWsJA+JC1nmz7E5cLU/SRP58Vp/jjTD7dKbNtlPqXqya17lVa5
         1/g/5w9UclJjjubc2CxBugj2kMJT6Wu3mnyxpVGJ5QBLo5+/QE1uZKW+1sxF6q+OoJ
         zGDs2l/mchkIG21FoxHScpDb81mqpeAj+sExiPbV/hFjyQJaSwDv+y5xZ5KL8Yl2dh
         y0OMNHj7r1IP4sRGRMQIz4RsRd3TswYUZ4LLhxcnVVbYwQhPwJLphORyEh2kO4FZPW
         iO7lfClZzuG+7QXOaqYKf/hPtJVRt5r/oIPjWCiD409sXoUSVUET506buljIr2vVPl
         EAY75AVQ3KhhQ==
Date:   Fri, 14 Jul 2023 07:54:39 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org, keescook@chromium.org,
        david@fromorbit.com
Subject: Re: [PATCH 1/3] xfs: convert flex-array declarations in struct
 xfs_attrlist*
Message-ID: <20230714145439.GY108251@frogsfrogsfrogs>
References: <168934590524.3368057.8686152348214871657.stgit@frogsfrogsfrogs>
 <168934591095.3368057.15849162788748534581.stgit@frogsfrogsfrogs>
 <20230714144638.GA3628@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230714144638.GA3628@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 14, 2023 at 04:46:38PM +0200, Christoph Hellwig wrote:
> The change itself looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> But as mentioned in the last thread leaving these out in the UAPI
> is a bit dangerous, and at the same time they really shouldn't
> be in the uapi.  Do you want me to send an incremental patch for
> that?

Yes please. :)

FWIW I tried removing the attrlist ioctl structs, but I couldn't find
anywhere else in the kernel uapi headers that defines them so that the
ioctl code can actually format the buffer.

--D
