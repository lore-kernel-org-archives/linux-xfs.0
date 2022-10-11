Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2F4EC4167B
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Oct 2022 23:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiJKXCm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Oct 2022 19:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiJKXCj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Oct 2022 19:02:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C5167C8A;
        Tue, 11 Oct 2022 16:02:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31B14B817BB;
        Tue, 11 Oct 2022 23:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8717FC433D6;
        Tue, 11 Oct 2022 23:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665529355;
        bh=y4Ano1StaiQUYrKYxW/krjKkHKYUUCVRriaLSIOEAic=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hZIFsAjLpJlnbBWUJKuBh0F5S/GKgabGfqQTZt8SwwkP/J7rmJxFBmdvyxWpJY1Y9
         3QW5uMvFKuAe9HRFYlHKD4pi0/xv9MO0iWOnIf2AaqjytVfWJr8aVejJeLExJ/5KZ3
         FrlFesvrqUYR/3JbrOA9OamXCfJjwQ/ne2rrxCnn7+JkgnaUtxq8jzzju5lNX9VZMj
         OGx/bWnGyw+FFs/AoVq28SHVdUyPbpIo9h4hq6hcEOD4KPNhe0MRYfhZxFJTCExz4F
         W36vvHtVIwfEG0+ZL+Eohic99c9jg9AxKCclN8amYinpbZSG2RDhRYsGaXHRgXP5kM
         kAk+ZlelP4YYA==
Date:   Tue, 11 Oct 2022 16:02:33 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alejandro Colomar <alx.manpages@gmail.com>
Cc:     linux-man@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-xfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-block@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [man-pages PATCH v3] statx.2, open.2: document STATX_DIOALIGN
Message-ID: <Y0X2CbXstn8qojPF@sol.localdomain>
References: <20221004174307.6022-1-ebiggers@kernel.org>
 <26cafc28-e63a-6f13-df70-8ccec85a4ef0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <26cafc28-e63a-6f13-df70-8ccec85a4ef0@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Alejandro,

On Sat, Oct 08, 2022 at 03:56:22AM +0200, Alejandro Colomar wrote:
> > +If none of the above is available, then direct I/O support and alignment
> 
> Please use semantic newlines.
> 
> See man-pages(7):
>    Use semantic newlines
>        In the source of a manual page, new sentences  should  be
>        started on new lines, long sentences should be split into
>        lines  at  clause breaks (commas, semicolons, colons, and
>        so on), and long clauses should be split at phrase bound‐
>        aries.  This convention,  sometimes  known  as  "semantic
>        newlines",  makes it easier to see the effect of patches,
>        which often operate at the level of individual sentences,
>        clauses, or phrases.

I tried to do this in v4.  It seems very arbitrary, though, so if you want
further changes to the newlines I recommend just making them when committing the
patch.

Note that a better way to review changes to text is to do a word diff instead of
a line diff.

- Eric
