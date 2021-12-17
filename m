Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5960C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Dec 2021 02:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbhLQC7F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Dec 2021 21:59:05 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:56661 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229471AbhLQC7E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Dec 2021 21:59:04 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 623423201E4C;
        Thu, 16 Dec 2021 21:59:03 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 16 Dec 2021 21:59:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm2; bh=
        NuNxwxs65yJhqNj+SK6LJonq2I+vhfD/m1CzQnW5/1s=; b=CjyuFmAJoeL++G6R
        ZnKcwHAkh1NJGAvy2p3QuWlrBB2rCPdNhBpLJwU7c5+vd2N8B+rGMoo6yyS8bTlC
        rEJtGxbYAxb1udcwTdQ0DHXd0VzQExxeMGyFulWIlexqvfD7EVGefTcWm7/vCItw
        OYt6V9IT52vEee1EY1shVU49dlt6HFecJXQ0SsRvmrJSnloBeQ52aCBwselNpA5m
        HB6219/zYhKTLoFKHSAvIo7yPirHqRzyhwOMELRJk96A7fFYsPJm2XnAS/JpjQxA
        xkuw1I2yhUwoLXJdqpGRYDPU0Iq3NNSVobuBAS3ZPbGBcRXEKI5hd1uuobYGZbwx
        n1XqyA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=NuNxwxs65yJhqNj+SK6LJonq2I+vhfD/m1CzQnW5/
        1s=; b=J07pZu4iiF3zSdYBwyr5ICAHBOJBGnjPA+QkxI+TtCQnP+lmx5EQ3HSyk
        zuxdgS7uTClfvrPRD9nBrPnbWZR/y7yZ0/6uVBijK3M+19djrCmvr1XNC10PhEYN
        TxreQuKVy0Qjn6MceQ1K7T5MWJ3Pp3z6dJBPNt2fPGDEOueUO1r6SY8JBqVeeVFY
        J+EYki5H3AKrUJn/oGr3ENtjURt5FKHwKIWwBcvz4HR6lyIxGCpRFS5bs2QnQZU9
        DulPhGnq/SQcr8iO1k2Eid2QOhpVTZVAWXscbRY5ED9gBiJ7GN9rM40BH9F9X4Yv
        M+4QuK1URRP+9LUX4Fv5/9M7YPi2Q==
X-ME-Sender: <xms:9vy7YSPD8XpzK7qqeXYHTVqYo-qSpHtyXeujrQkNY188NswOaHeoNg>
    <xme:9vy7YQ-kexTymPUUJzvoz5u79ULFwSiDQLTqMvaW8n9plCWrXWG1UekRsAjKyizea
    8_WNFULJ8f2>
X-ME-Received: <xmr:9vy7YZSsPgW5vbLcY3uktjWxsT_scpXlibR5oOrbZygK4EwiItpM0fDGAkEF_PRy_SNAtsOqeZvv8uoRUtWjysQv6UdpyeamDsSh8c-4CW3snXc3yaG19Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrleehgdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtkeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecuggftrfgrthhtvghrnhepgf
    elleekteehleegheeujeeuudfhueffgfelhefgvedthefhhffhhfdtudfgfeehnecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesth
    hhvghmrgifrdhnvght
X-ME-Proxy: <xmx:9vy7YSvfD0A6UuZVkr7LCaufhJq_JXQ78V1UfEcSNBpvvAmFKAFZvg>
    <xmx:9vy7YadrKstEj3iAV9181QasMY0qsneFrYdJ6Q75J1HYagYgzKhRWw>
    <xmx:9vy7YW18oi4nvwLiPtKyTduz7JZmYnFd3G2iPWo26qsqK2ddV0UtJA>
    <xmx:9vy7YSlI9Z_c6I6brFJ_CXWE1NLPtvvJjkYbTkCqNwN7RjUbd9_dOw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 16 Dec 2021 21:59:00 -0500 (EST)
Message-ID: <6e03d852484b04acb8f516c91aa1ac983f2574c3.camel@themaw.net>
Subject: Re: [PATCH 6/7] xfs: don't expose internal symlink metadata buffers
 to the vfs
From:   Ian Kent <raven@themaw.net>
To:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 17 Dec 2021 10:58:56 +0800
In-Reply-To: <20211216051123.GC449541@dread.disaster.area>
References: <163961695502.3129691.3496134437073533141.stgit@magnolia>
         <163961698851.3129691.1262560189729839928.stgit@magnolia>
         <20211216051123.GC449541@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2021-12-16 at 16:11 +1100, Dave Chinner wrote:
> On Wed, Dec 15, 2021 at 05:09:48PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Ian Kent reported that for inline symlinks, it's possible for
> > vfs_readlink to hang on to the target buffer returned by
> > _vn_get_link_inline long after it's been freed by xfs inode
> > reclaim.
> > This is a layering violation -- we should never expose XFS
> > internals to
> > the VFS.
> > 
> > When the symlink has a remote target, we allocate a separate
> > buffer,
> > copy the internal information, and let the VFS manage the new
> > buffer's
> > lifetime.  Let's adapt the inline code paths to do this too.  It's
> > less efficient, but fixes the layering violation and avoids the
> > need to
> > adapt the if_data lifetime to rcu rules.  Clearly I don't care
> > about
> > readlink benchmarks.
> > 
> > As a side note, this fixes the minor locking violation where we can
> > access the inode data fork without taking any locks; proper locking
> > (and
> > eliminating the possibility of having to switch inode_operations on
> > a
> > live inode) is essential to online repair coordinating repairs
> > correctly.
> > 
> > Reported-by: Ian Kent <raven@themaw.net>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> Looks fine, nicely avoids all the nasty RCU interactions trying to
> handle this after the fact.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 

Yes, I like it too and that original rcu gymnastics was always due
to the unclear ownership and lifetime of the link path buffer.

And I don't think needing to switch to ref-walk mode (due to the
memory allocation possibly blocking) is such a big performance
drawback as might be thought.

Acked-by: Ian Kent <raven@themaw.net>


