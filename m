Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bullwinkle.deer-run.com ([50.23.32.3]:58842 "EHLO
        bullwinkle.deer-run.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932815AbeEHQo7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 12:44:59 -0400
Date: Tue, 8 May 2018 11:43:40 -0500
From: hal@deer-run.com
Subject: Re: [PATCH] xfs_db: add -R option
Message-ID: <20180508164340.GB18224@deer-run.com>
References: <20180504140244.GA32161@deer-run.com>
 <db080bb2-a649-fbb3-ec91-d16f00ad30f0@sandeen.net>
 <20180508161353.GA18224@deer-run.com>
 <c542d34d-3afa-c75e-32ba-9ba2df17b8d0@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c542d34d-3afa-c75e-32ba-9ba2df17b8d0@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

> Well, I don't really like either patch for the reasons stated above.
> xfs_db /can/ write to the filesystem, and -r disables that... but -r
> as a modifier to affect the behavior of a read-only command is
> unintuitive.
> 
> "It is only necessary to omit this flag if a command that changes data
> (write, blocktrash, crc) is to be used."
> 
> What are the objections to a blockget modifier option?  That seemed like
> the most direct & obvious solution to me.
> 
> "blockget/check -L : attempt to perform the blockget and check functions
> even if the log contains unreplayed metadata," or something like that?

Ah, OK. I'm getting what you're saying now. Let me poke around with
the code some and produce a patch that does what you're suggesting.

--Hal

