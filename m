Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from one.firstfloor.org ([193.170.194.197]:35208 "EHLO
        one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728771AbeGYSNG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jul 2018 14:13:06 -0400
Date: Wed, 25 Jul 2018 10:00:31 -0700
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: XFS long delays on disk full
Message-ID: <20180725170031.5r43tgsvxsvrhxyo@two.firstfloor.org>
References: <20180718212240.vxl33543lrh7vgzz@two.firstfloor.org>
 <20180718232533.GC4813@magnolia>
 <20180720175837.wuxhlzhp6e6423cl@two.firstfloor.org>
 <20180724181646.GW4813@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180724181646.GW4813@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-xfs@vger.kernel.org

> Yep, that looks like xfs scraping around trying to find space when the
> fs is nearly full.

Okay. Not sure what it is doing. The disk isn't that large after all,
and it's not clear why it takes that long to check a few AGs.

Can something be done about it?

It would be good enough for me if it was interruptible, so that 
Ctrl-C just worked.

-Andi
