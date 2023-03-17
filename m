Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD786C6FD1D
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Mar 2023 20:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjCQUaI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 16:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjCQUaG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 16:30:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E84A279
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 13:29:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FD1261731
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 20:29:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD5FC433D2;
        Fri, 17 Mar 2023 20:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679084960;
        bh=VTalCe5hTRChUfz9djok16NsRktOIeNIyiq4jDsse+E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s77YRYxFtz+RLzkryj8+fE5RAIbSOkKsep+Ll9h0FnERkqwJ3shQ7i9R+e4oArFoh
         af/NzW7l+bRgaQYOIMDnJZmah1mIa0DHHpZslg6QH3i2NjeKFp2Qan0saaVy3fwGpc
         JPdmSePqD3J5fFJXhL9HHbvBTKYY8v+uKvIogdAdQ02Ayq7GQtnqqXNTN2zhwq7m6B
         E1KiM4SbVzcO3vfM3ElJnehKD4HytmZW+wZ/fcN7byPOqTzxY/HzjhghvfCoGXlEnh
         2Fx5/ILZue9J9gP7NAisWpWcahkBOT/RhqUjbzgHkPrYAz5ieC9Niz0bLYPjS8R8Ip
         q27FcWKzixGeQ==
Date:   Fri, 17 Mar 2023 13:29:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Alan Huang <mmpgouride@gmail.com>
Cc:     Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_db: fix complaints about unsigned char casting
Message-ID: <20230317202920.GJ11394@frogsfrogsfrogs>
References: <yd5KB_VD7Oe2M-1JTpW8yKsKQ7SaQV9hnFIguCvPI-CuHqrQHOECUVh2Ar9oGpOi5jLK1LKpQ0D_NqN-kz5eyw==@protonmail.internalid>
 <20230315010110.GD11376@frogsfrogsfrogs>
 <20230317102559.agpsaa2fmgd32mc6@andromeda>
 <BCCAE5EE-0A38-42B7-B60E-8C60814FE286@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BCCAE5EE-0A38-42B7-B60E-8C60814FE286@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 17, 2023 at 06:43:40PM +0800, Alan Huang wrote:
> Is there any reason keep these definition with different types?  Question from a newbie...

Probably not, but char* handling in C is a mess if you don't specify
signedness -- on some arches gcc interprets "char" as "signed char", and
on others it uses "unsigned char".  The C library string functions all
operate on "char *", so if you start changing types you quickly end up
in compiler warning hell over that.

libxfs seems to use "unsigned char*" and "uint8_t *".  I don't know if
that was just an SGI thing, or merely a quirk of the codebase?  The
Linux VFS code all take "char *", though as of 6.2 the makefiles force
those to unsigned everywhere.  As far as directory entry and extended
attribute names go, all eight bits are allowed.

UTF8 encoding uses the upper bit of a char, which means that we really
want unsigned to avoid problems with sign extension when computing
hashes and things like that, because emoji and kanji characters are in
use around the world.

IOWS: it's a giant auditing headache to research what parts use the type
declarations they do, figure out what subtleties go with them, and
decide on appropriate fixes.  And in the end... the system still behaves
the same way it did.

--D

> Thanks,
> Alan
> 
> > 2023年3月17日 下午6:25，Carlos Maiolino <cem@kernel.org> 写道：
> > 
> > On Tue, Mar 14, 2023 at 06:01:10PM -0700, Darrick J. Wong wrote:
> >> From: Darrick J. Wong <djwong@kernel.org>
> >> 
> >> Make the warnings about signed/unsigned char pointer casting go away.
> >> For printing dirent names it doesn't matter at all.
> >> 
> >> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > 
> > Looks good, will test.
> > 
> > Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> > 
> >> ---
> >> db/namei.c |    4 ++--
> >> 1 file changed, 2 insertions(+), 2 deletions(-)
> >> 
> >> diff --git a/db/namei.c b/db/namei.c
> >> index 00e8c8dc6d5..063721ca98f 100644
> >> --- a/db/namei.c
> >> +++ b/db/namei.c
> >> @@ -98,7 +98,7 @@ path_navigate(
> >> 
> >> 	for (i = 0; i < dirpath->depth; i++) {
> >> 		struct xfs_name	xname = {
> >> -			.name	= dirpath->path[i],
> >> +			.name	= (unsigned char *)dirpath->path[i],
> >> 			.len	= strlen(dirpath->path[i]),
> >> 		};
> >> 
> >> @@ -250,7 +250,7 @@ dir_emit(
> >> 	uint8_t			dtype)
> >> {
> >> 	char			*display_name;
> >> -	struct xfs_name		xname = { .name = name };
> >> +	struct xfs_name		xname = { .name = (unsigned char *)name };
> >> 	const char		*dstr = get_dstr(mp, dtype);
> >> 	xfs_dahash_t		hash;
> >> 	bool			good;
> > 
> > -- 
> > Carlos Maiolino
> 
