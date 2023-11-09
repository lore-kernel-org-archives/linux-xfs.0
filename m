Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 917B2C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Nov 2023 00:32:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjKIAdA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Nov 2023 19:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjKIAc7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2023 19:32:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2EF268F
        for <linux-xfs@vger.kernel.org>; Wed,  8 Nov 2023 16:32:57 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025C3C433C8;
        Thu,  9 Nov 2023 00:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699489977;
        bh=bfI2AqMi7I334jy8o/whK4gnJeGP27NZJzFjZ9ZL/vo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MsAQY0zrk3mnM2zyXlzvMJheKztyNC6epkO1KAN+udHlg91DmkLTGz5Frt0s0Ovie
         flAjgCiNb040UFuQMg03V7crkzbULb3FSpFYL/F01AkPcUgl7fnkn1qMQTQoYlXmEB
         ciP2IRbD4Pbof7EVQu1gdiLXpYWzJjoL5X+KvdIsX45qaKXt2ff6FcQp3T/ITZ5xTe
         WlwoKeJ8pe5LCYWzy7Ra4dhPhlo6aagsghPvxNAN0+HVAL2q5XFRbgwFGIyxpPI6Ce
         o6NSJGYkuBSDOmERdg6iDf935VEI73buzu/fjReN0GusnPgAojdGwuQofeCZhPpPiP
         5vplHmXEFfY1w==
Date:   Wed, 8 Nov 2023 16:32:56 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs_scrub: tighten up the security on the background
 systemd service
Message-ID: <20231109003256.GA1205143@frogsfrogsfrogs>
References: <168506074508.3746099.18021671464566915249.stgit@frogsfrogsfrogs>
 <168506074549.3746099.6129822996056625257.stgit@frogsfrogsfrogs>
 <ZUn60XdaxeY4+1I8@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUn60XdaxeY4+1I8@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 07, 2023 at 12:52:33AM -0800, Christoph Hellwig wrote:
> On Thu, May 25, 2023 at 06:55:34PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Currently, xfs_scrub has to run with some elevated privileges.  Minimize
> > the risk of xfs_scrub escaping its service container or contaminating
> > the rest of the system by using systemd's sandboxing controls to
> > prohibit as much access as possible.
> > 
> > The directives added by this patch were recommended by the command
> > 'systemd-analyze security xfs_scrub@.service' in systemd 249.
> 
> All the additional lockdowns look good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Maybe you can split the dynamic user change out as a small standalone
> fix, though?

I'll do that, and credit the person who asked us to do that.  Thanks for
the review, systemd directives are overwhelming. :)

--D
