Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59620C04A95
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Nov 2023 18:07:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235260AbjKJSHZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Nov 2023 13:07:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345816AbjKJSG4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Nov 2023 13:06:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2D68263
        for <linux-xfs@vger.kernel.org>; Thu,  9 Nov 2023 23:12:17 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89307C433CB;
        Fri, 10 Nov 2023 04:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699591607;
        bh=fzEvcDCi184fWZaY5x5VLkkRZ1aAYGSc82ksbTAfnQg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s1LgXS+FMKnAlk+lJtac8ywK/+e5SgxtAHthRYe6uoUngwImNs+DpZ1NtWpE86IFr
         eGDMYfN8JV+g71tAUK+DD6Thpn+ap7E1tD8FNQyXnv1xva0O0//OocGI5ME2hyh+YR
         oSmBcYKQOGOzzabZOQIFWbBrjbVkvpwICnec0lzCsZeaWt6J3VTY9Coe4QJjFw7CMk
         LAqQGRDChndMKdEKYhNMSY99dqmlUIeufjgaBRwtsgXjl7eJ4FU4kqqGLjAT5wDUCU
         8sYov1lh1HpY14SuAfTw+VoiQ4j1AwZiKFy8wB8Rmi7qBnJIVOcohVRf4NEtZBgnzD
         Iz0oBkB3bvBkw==
Date:   Thu, 9 Nov 2023 20:46:46 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     zlang@redhat.com, guan@eryu.me, david@fromorbit.com,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: test unlinked inode list repair on demand
Message-ID: <20231110044646.GE1203404@frogsfrogsfrogs>
References: <169947894813.203694.3337426306300447087.stgit@frogsfrogsfrogs>
 <169947895967.203694.8763078075817732328.stgit@frogsfrogsfrogs>
 <ZUxwoLoy2D/CIUbE@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUxwoLoy2D/CIUbE@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 08, 2023 at 09:39:44PM -0800, Christoph Hellwig wrote:
> > +# Modify as appropriate.
> 
> Btw, why do we keep adding this pointless boilerplate everywhere?

Oops.  It comes from the ./new output, but I guess I am a bit lazy about
removing it. :(

> > +_supported_fs generic
> 
> I think this should be xfs only.

Changed.

> > +source ./common/filter
> > +source ./common/fuzzy
> > +source ./common/quota
> 
> When did we switch from using . to source other shell files
> to "source"?  Just curious.

Habit of mine.  vim colors and bolds "source" nicely, which it doesn't
do for dot.

> > +
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> 
> xfs again.

Changed again.

--D
