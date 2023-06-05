Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E430C7EE2D
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 17:09:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbjFERJv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 13:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235416AbjFERJu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 13:09:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF74AF
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 10:09:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72A6C61827
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 17:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA804C433EF;
        Mon,  5 Jun 2023 17:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685984988;
        bh=LMB+KGwk4s3nW8UsIggRKG2Yy4CzQP52ppaTYaQJjsA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YNZHvYDD7dKPShCvSui06fiT89oaW05TlwjDVxUBj31ilAFeystZ37YMUEXJD4qLy
         1m8XFJZQVuFRZu7K78h10F344wJ5Yx0vNORTUMq9Bf8o892ZNvAv/7dEGibmr3FJHD
         l6E8RoCXXc9NOILY1KbfRGUKNpnKltWJwSc8S36U0+kPm2DLS9g8gkBAX8HYOMw7ez
         0UaVXmC4beChzB7Pibe4/5wSOiXrZNO6F4lJBjDlHPbSZ9wHpLSwHX7nqRCX+P9Ib7
         FNpwvRaqfqvZefa5xDoJOq/+Bwzm10Z30tdtY2FodUWmvHa7tpNkNlufuxHU2WPuxa
         9YPcZXHxXyb2Q==
Date:   Mon, 5 Jun 2023 10:09:48 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
        hch@infradead.org
Subject: Re: [PATCH 3/5] xfs_db: fix metadump name obfuscation for ascii-ci
 filesystems
Message-ID: <20230605170948.GL72241@frogsfrogsfrogs>
References: <168597938725.1226098.18077307069307502725.stgit@frogsfrogsfrogs>
 <168597940416.1226098.14610650380180437820.stgit@frogsfrogsfrogs>
 <99cf8b71-3c8a-7114-c7d1-7078242b9dff@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99cf8b71-3c8a-7114-c7d1-7078242b9dff@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 05, 2023 at 11:59:45AM -0500, Eric Sandeen wrote:
> On 6/5/23 10:36 AM, Darrick J. Wong wrote:
> > @@ -1205,9 +1264,9 @@ generate_obfuscated_name(
> >   	/* Obfuscate the name (if possible) */
> > -	hash = libxfs_da_hashname(name, namelen);
> > -	obfuscate_name(hash, namelen, name);
> > -	ASSERT(hash == libxfs_da_hashname(name, namelen));
> > +	hash = dirattr_hashname(ino != 0, name, namelen);
> > +	obfuscate_name(hash, namelen, name, ino != 0);
> > +	ASSERT(hash == dirattr_hashname(ino != 0, name, namelen));
> 
> This makes sense to me - comments above here remind us that "inode == 0"
> means we're obfuscating an xattr value, not a filename or path name, but ...
> 
> >   	/*
> >   	 * Make sure the name is not something already seen.  If we
> > @@ -1320,7 +1379,7 @@ obfuscate_path_components(
> >   			/* last (or single) component */
> >   			namelen = strnlen((char *)comp, len);
> >   			hash = libxfs_da_hashname(comp, namelen);
> > -			obfuscate_name(hash, namelen, comp);
> > +			obfuscate_name(hash, namelen, comp, false);
> >   			ASSERT(hash == libxfs_da_hashname(comp, namelen));
> >   			break;
> >   		}
> > @@ -1332,7 +1391,7 @@ obfuscate_path_components(
> >   			continue;
> >   		}
> >   		hash = libxfs_da_hashname(comp, namelen);
> > -		obfuscate_name(hash, namelen, comp);
> > +		obfuscate_name(hash, namelen, comp, false);
> >   		ASSERT(hash == libxfs_da_hashname(comp, namelen));
> >   		comp += namelen + 1;
> >   		len -= namelen + 1;
> > 
> 
> here, why is "is_dirent" false? Shouldn't a symlink path component match the
> associated dirents, and be obsucated the same way?

Name obfuscation replaces every byte except for the last five bytes with
a random printable character, and then flips bits in those last five
bytes to make the hash match.  Chances are good that calling
obfuscate_name() twice on the same name will return different results,
which means that symlink targets won't point anywhere useful after the
obfuscation.

One could make metadump remember the (input -> output) pairs instead of
regenerating the names every time, but this comes at a cost of higher
memory consumption.  I actually did this for parent pointers so that
obfuscated dumped pptrs are still verifiable by xfs_repair.

However, symlink targets aren't required to point to a valid path, so
there doesn't seem to be much reason to add that overhead.

--D

> -Eric
