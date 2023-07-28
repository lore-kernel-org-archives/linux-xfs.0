Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80562C001E0
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Jul 2023 15:53:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237213AbjG1Pxb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Jul 2023 11:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236228AbjG1PxT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jul 2023 11:53:19 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE9A3C31
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jul 2023 08:53:17 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-113-23.bstnma.fios.verizon.net [173.48.113.23])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 36SFr7sF026396
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jul 2023 11:53:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1690559589; bh=Qqr/MU18MyiS/ezQUTMOrC0+9lxvD/2nk4bpVh/aU9U=;
        h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
        b=XceItTv+6uvH7UkuLNNLE/UI72UWqcEpGCUt/cQIVpXjzsOZXHtHQ0vD+STo3ERg8
         VKHOl6T1930uk5IHi9VEty2VR+EQWxqFhYu812IjlztDy3TdX7+D682Fdcg2HVAOPF
         e/v486+97EFeQMYxm+sW9Wvb7TAg9VITJoeiYkvzAybRnWxOggP902yYoT4wbYySG1
         c3iJG0xaMbCanNoQgUkHndM7xvaboF54JbIqDSlXHmwQGYi2BxFARXC38JGw8JmdI0
         sI4afatl6fTdXF/1IDOxu7uTeQ3Av+8mc+assLBxDfijWXTpG7DWPebMJ8jznR6Npw
         8YYE4KdPZMp8g==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id B772015C04EF; Fri, 28 Jul 2023 11:53:07 -0400 (EDT)
Date:   Fri, 28 Jul 2023 11:53:07 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Zorro Lang <zlang@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] check: add a -smoketest option
Message-ID: <20230728155307.GB606216@mit.edu>
References: <20230719161115.byva7tvwoafkesga@zlang-mailbox>
 <20230720022756.GH11352@frogsfrogsfrogs>
 <20230720143433.n5gkhukdkz7s5ab7@zlang-mailbox>
 <20230726000524.GG11340@frogsfrogsfrogs>
 <20230726060102.GB30264@mit.edu>
 <20230726145441.lbzzokwigrztimyq@zlang-mailbox>
 <20230726205930.GC30264@mit.edu>
 <20230727032537.hyqyuvemnwmh25d5@zlang-mailbox>
 <20230727143326.GG30264@mit.edu>
 <20230727153046.dl4palugnyidxoe7@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230727153046.dl4palugnyidxoe7@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 27, 2023 at 11:30:46PM +0800, Zorro Lang wrote:
> 
> Yeah, I'd like to tidy the ./check, include the option names. But change the
> check option format will affect many users, cause most of their scripts go
> wrong suddently, then they need to check and use new option format. That's
> why I still not touch this part.

What if we add support for the double-hyphen variant for those options
that use a syingle-hyphen, and then wait say, a year or so, and then
add a deprecation warning to the single hyphen options, and then a
year latter drop support the single-hypen variant?

I can send a patch for the first part of the process if you think that
makes sense....

      	     	       	    	   - Ted
