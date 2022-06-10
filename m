Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4469CCA47B
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jun 2022 11:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239722AbiFJLuQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 07:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240208AbiFJLuQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 07:50:16 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1416F2E21B8;
        Fri, 10 Jun 2022 04:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7600ECE34AE;
        Fri, 10 Jun 2022 11:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00535C34114;
        Fri, 10 Jun 2022 11:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654861811;
        bh=PQwsQhJX3FDQ+c0v5vfFzwighvQlskFJ/gfNw45nUcc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EMd/nOruivdks5YIWxLa7Zr3zomXoPaCNWGfO2KTP0JTfHL4VbRSDgI6xA92+LsBe
         ysAMc4LoMduI5cZF1pGOHLtMRtHZ2kcZiiwfOtUVOtFlHhsTlr4OjglGTNMVdGbJBX
         Ufpmcq8NF84DbTdF0rd6Updgwrsk+iMMU/W4tUlbi8c3HTArD6/4s45PmM4SKC/su2
         9s+/mP3jz+5jEh2SJbdUdj1+A+2MXXiQmAVD6Z3ZxkPx5Hik+rnBYMUdqthxPR8Zaf
         rc0fwr1zaNCZ6cO8IwDYw9x8Gu2aJ/9WIywuizhtsq1xoHE/dQxHXQoyGFbnbFHXTw
         CTm95pFRz4Ufg==
Date:   Fri, 10 Jun 2022 13:50:05 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v8 07/14] fs: Add check for async buffered writes to
 generic_write_checks
Message-ID: <20220610115005.k7rfh2zhgn3fguv7@wittgenstein>
References: <20220608171741.3875418-1-shr@fb.com>
 <20220608171741.3875418-8-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220608171741.3875418-8-shr@fb.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 08, 2022 at 10:17:34AM -0700, Stefan Roesch wrote:
> This introduces the flag FMODE_BUF_WASYNC. If devices support async
> buffered writes, this flag can be set. It also modifies the check in
> generic_write_checks to take async buffered writes into consideration.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good to me,
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
