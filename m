Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C228AC74A5B
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Mar 2023 22:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbjCQWS3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 18:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjCQWS2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 18:18:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1171FED
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 15:18:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAC3660B5C
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 22:18:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25B0C433EF;
        Fri, 17 Mar 2023 22:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679091506;
        bh=SboTpDL3WhlxdiLuBzap2jAwIX2g0a+6GhBGOy+goxE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vk7RmbjmG4IgTglRbXBD9atd/xFRB9d0rnA5k5PS+9vkseAKBWCeoAbX1DikkUvql
         1OweL+kX3NEFSvMNsNMMxUz27LgUIFfhatviNzey9ry5ne1y3tZRlCITylzdDdO1nJ
         tymEJSyCE5E/6fRDAsuvSMKxMsw1BcI8KU+EHgVsJ5MPPYFok6CvaQGsGLJgohrC+1
         cCFzCpi0MmQOE/kooDcvU7DYwXjeJHZ1Zn01PhvCOYN+McoNyXDRPN0GqhlPE3+r3K
         SN72mQMkPf3ksFOYJohCBgRD7v/08RV28NKSmHTgNCzmamD5FKY1yvTyaXWgzoAKVi
         MP4mJH+WdDMDQ==
Date:   Fri, 17 Mar 2023 23:18:21 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5.10 CANDIDATE 00/15] xfs backports for 5.10.y (from
 v5.15.103)
Message-ID: <20230317221821.aoxpmii7jbp274px@wittgenstein>
References: <20230317110817.1226324-1-amir73il@gmail.com>
 <20230317155130.GP11376@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230317155130.GP11376@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 17, 2023 at 08:51:30AM -0700, Darrick J. Wong wrote:
> On Fri, Mar 17, 2023 at 01:08:02PM +0200, Amir Goldstein wrote:
> > Darrick,
> > 
> > Following backports catch up with recent 5.15.y backports.
> > 
> > Patches 1-3 are the backports from the previous 5.15 round
> > that Chandan requested for 5.4 [1].
> > 
> > Patches 4-14 are the SGID fixes that I collaborated with Leah [2].
> > Christian has reviewed the backports of his vfs patches to 5.10.
> > 
> > Patch 15 is a fix for a build warning caused by one of the SGID fixes.
> > 
> > This series has gone through the usual kdevops testing routine.
> > 
> > Thanks,
> > Amir.
> 
> Looks good to me, with the same caveat I gave Leah wherein I'm assuming
> Christian's ok with his setgid changes ending up in 5.10 too. :)

I think consistency between LTS kernels is good. Worst case we have to
revert the setgid changes. That'll be unpleasant but hopefully doable.

On the other hand, this could very well be me nodding happily along on
my way to the guillotine. :)
