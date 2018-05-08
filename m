Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56768 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754812AbeEHQ7G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 12:59:06 -0400
Date: Tue, 8 May 2018 09:58:19 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_db: add -R option
Message-ID: <20180508165819.GN11261@magnolia>
References: <20180504140244.GA32161@deer-run.com>
 <db080bb2-a649-fbb3-ec91-d16f00ad30f0@sandeen.net>
 <20180508161353.GA18224@deer-run.com>
 <c542d34d-3afa-c75e-32ba-9ba2df17b8d0@sandeen.net>
 <20180508164340.GB18224@deer-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180508164340.GB18224@deer-run.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hal@deer-run.com
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On Tue, May 08, 2018 at 11:43:40AM -0500, hal@deer-run.com wrote:
> > Well, I don't really like either patch for the reasons stated above.
> > xfs_db /can/ write to the filesystem, and -r disables that... but -r
> > as a modifier to affect the behavior of a read-only command is
> > unintuitive.
> > 
> > "It is only necessary to omit this flag if a command that changes data
> > (write, blocktrash, crc) is to be used."
> > 
> > What are the objections to a blockget modifier option?  That seemed like
> > the most direct & obvious solution to me.
> > 
> > "blockget/check -L : attempt to perform the blockget and check functions
> > even if the log contains unreplayed metadata," or something like that?

That also seems fine to me. :)

> Ah, OK. I'm getting what you're saying now. Let me poke around with
> the code some and produce a patch that does what you're suggesting.

<nod>

--D

> --Hal
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
