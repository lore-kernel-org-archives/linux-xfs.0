Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 627F9EB64DD
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 02:17:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbjGLCRQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jul 2023 22:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjGLCRP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jul 2023 22:17:15 -0400
Received: from smtp2.onthe.net.au (smtp2.onthe.net.au [203.22.196.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED5BF1722
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 19:17:14 -0700 (PDT)
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp2.onthe.net.au (Postfix) with ESMTP id 11B64783;
        Wed, 12 Jul 2023 12:17:14 +1000 (AEST)
Received: from smtp2.onthe.net.au ([10.200.63.13])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10024)
        with ESMTP id Xn66DcSfjU6P; Wed, 12 Jul 2023 12:17:13 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp2.onthe.net.au (Postfix) with ESMTP id E85CC71A;
        Wed, 12 Jul 2023 12:17:13 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=onthe.net.au;
        s=default; t=1689128233;
        bh=V2o8i+GNoaQB/djysTE1LRUykNNTcv5xps+U+pS1xYI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PH+SK6+R6aK5BuFPWyRj6lSItmkL+nIx91FCsY3wdFWCYodxhSN7PSVp+qJbHbgrL
         Eu/IVnN/1/dU6VpKLuW7jGwysy/Octt2EiIk/Ejw+powd5XYs3BMuq7uOqTub/c3sZ
         GZfmq7YbO57oNjea75gv8RPNPyPSLyt48hg03TkJy6mpirGhoCHqD4bxXc8fCSDwPf
         4WCgSb5ntOzSKHFS7lKITryE06fahcnS16YikoOAW0Lj6kwMUavLgud5pVnFu7zeuD
         KBRcXIri167h1Z2rgPDdiNdngGFeM8nd1TMD6wgeKA4fmWrQ5hrOTENUQyJsKnjzYe
         vvwFgKOFD0KgQ==
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id CC51468061B; Wed, 12 Jul 2023 12:17:13 +1000 (AEST)
Date:   Wed, 12 Jul 2023 12:17:13 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     Leah Rumancik <lrumancik@google.com>, Theodore Ts'o <tytso@mit.edu>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Subject: v5.15 backport - 5e672cd69f0a xfs: non-blocking inodegc
 pushes
Message-ID: <20230712021713.GA902741@onthe.net.au>
References: <20230710215354.GA679018@onthe.net.au>
 <20230711001331.GA683098@onthe.net.au>
 <20230711015716.GA687252@onthe.net.au>
 <ZKzIE6m+iCEd+ZWk@dread.disaster.area>
 <20230711070530.GA761114@onthe.net.au>
 <ZK3V1wQ6jQCxtTZJ@dread.disaster.area>
 <20230712011356.GB886834@onthe.net.au>
 <ZK4E/gGuaBu+qvKL@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZK4E/gGuaBu+qvKL@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Request for backport to v5.15:

5e672cd69f0a xfs: non-blocking inodegc pushes

Reference:

https://lore.kernel.org/all/ZK4E%2FgGuaBu+qvKL@dread.disaster.area/
---------------------------------------------------------------------
From: Dave Chinner <david@fromorbit.com>
To: Chris Dunlop <chris@onthe.net.au>
Cc: linux-xfs@vger.kernel.org
Subject: Re: rm hanging, v6.1.35

On Wed, Jul 12, 2023 at 11:13:56AM +1000, Chris Dunlop wrote:
>> On Tue, Jul 11, 2023 at 05:05:30PM +1000, Chris Dunlop wrote:
>>> In particular, could "5e672cd69f0a xfs: non-blocking inodegc pushes"
>>> cause a significantly greater write load on the cache?
...
> Or could / should it be considered for an official backport?  Looks like it
> applies cleanly to current v5.15.120.

I thought that had already been done - there's supposed to be
someone taking care of 5.15 LTS backports for XFS....
---------------------------------------------------------------------

Thanks,

Chris
