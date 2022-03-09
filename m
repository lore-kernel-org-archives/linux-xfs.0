Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45137C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 23:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235238AbiCIXMX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 18:12:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236672AbiCIXMW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 18:12:22 -0500
Received: from server.atrad.com.au (server.atrad.com.au [150.101.241.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCE482D1D
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 15:11:19 -0800 (PST)
Received: from marvin.atrad.com.au (IDENT:1008@marvin.atrad.com.au [192.168.0.2])
        by server.atrad.com.au (8.17.1/8.17.1) with ESMTPS id 229NB0Dr014237
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Thu, 10 Mar 2022 09:41:01 +1030
Date:   Thu, 10 Mar 2022 09:41:00 +1030
From:   Jonathan Woithe <jwoithe@just42.net>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Clarifying XFS behaviour for dates before 1901 and after 2038
Message-ID: <20220309231100.GB11763@marvin.atrad.com.au>
References: <20220309072303.GE12332@marvin.atrad.com.au>
 <20220309160019.GB8224@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309160019.GB8224@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-MIMEDefang-action: accept
X-Scanned-By: MIMEDefang 2.86 on 192.168.0.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick

On Wed, Mar 09, 2022 at 08:00:19AM -0800, Darrick J. Wong wrote:
> On Wed, Mar 09, 2022 at 05:53:03PM +1030, Jonathan Woithe wrote:
> > Since the kernel on PC-2 is way earlier than 5.10 and its xfs filesystems
> > predate bigtime, I would have expected the times to be clamped between
> > 1901 and 2038.  However, it seems that the system somehow manages to store
> > the out-of-bound years.  Doing so has an interesting effect on the timezone
> > offset for the pre-1901 years, but for years beyond 2038 there is no
> > directly observable problem. ...
> > :
> > This isn't what I expected.  Given an old userspace with an old kernel and
> > old xfs filesystem, dates outside the 1901-2038 range should not be
> > possible.  Given the apparent corruption of the timezone field when a year
> > before 1901 is set, one naive thought is that the apparent success of these
> > extended years on PC-2 (the old system) is due to a lack of bounds checking
> > on the time value and (presumedly) some overflow within on-disc structures
> > as a result.  This would have been noticed way before now though.
> > 
> > I am therefore curious about the reason for the above behaviour.  What
> > subtlety am I missing?
> 
> Older kernels (pre-5.4 I think?) permitted userspace to store arbitrary
> 64-bit timestamps in the in-memory inode.  The fs would truncate (== rip
> off the upper bits) them when writing them to disk, and then you'd get
> the shattered remnants the next time the inode got reloaded from disk.
> 
> Nowadays, filesystems advertise the timestamp range they support, and
> the VFS clamps the in-memory timestamp to that range.

Thanks so much for taking the time to respond.  That all makes sense and is
useful information to keep in mind.

Regards
  jonathan
