Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C73BC433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Feb 2022 02:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiBZCjW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Feb 2022 21:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiBZCjV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Feb 2022 21:39:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4506518FAFD
        for <linux-xfs@vger.kernel.org>; Fri, 25 Feb 2022 18:38:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BA3EB833C8
        for <linux-xfs@vger.kernel.org>; Sat, 26 Feb 2022 02:38:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3729DC340E7;
        Sat, 26 Feb 2022 02:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645843124;
        bh=/nrP1QwfcUxjdpnOhEdwbQ2h66jzYc6fP8uT51hJTpI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mFiiBsJ0acKY+2Y7vRuCBJNFVqDq2Xgs8Oeo88ga7vcyjBpHai+ojIlXFU/HdeHKy
         yw28G8waSefmufAk0MJ5JDgTHlLG+s8POK9FZ/0CVf2NBSoFM8NTcN5AmidFis4HIj
         HL290ZqOePiu2EaT4TyXPebqvBuvTzJ0Ek+HqjE1eJskrpz8Xm4XXQpuUHB0C+FH7v
         U/E34w1DrPsIKh/IpF9sxmmA1DayXp6Gcr6iAmZjDFF9/TbtyWpRPOl1ecuAZmFiX6
         ixII3povM12fExwp+LUacNE8LkDKilUlK229AWiFoSoWeK9hhoM29KFl9YHbSvaGpD
         /t4APNQ90mSiA==
Date:   Fri, 25 Feb 2022 18:38:43 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 16/17] mkfs: add a config file for x86_64 pmem filesystems
Message-ID: <20220226023843.GU8313@magnolia>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
 <164263818283.863810.4750810429299999067.stgit@magnolia>
 <ec4fef64-cc49-2f7e-069c-50d7a32610d4@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec4fef64-cc49-2f7e-069c-50d7a32610d4@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 25, 2022 at 04:21:59PM -0600, Eric Sandeen wrote:
> On 1/19/22 6:23 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > We have a handful of users who continually ping the maintainer with
> > questions about why pmem and dax don't work quite the way they want
> > (which is to say 2MB extents and PMD mappings) because they copy-pasted
> > some garbage from Google that's wrong.  Encode the correct defaults into
> > a mkfs config file and ship that.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  mkfs/Makefile        |    1 +
> >  mkfs/dax_x86_64.conf |   19 +++++++++++++++++++
> >  2 files changed, 20 insertions(+)
> >  create mode 100644 mkfs/dax_x86_64.conf
> > 
> > 
> > diff --git a/mkfs/Makefile b/mkfs/Makefile
> > index 0aaf9d06..55d9362f 100644
> > --- a/mkfs/Makefile
> > +++ b/mkfs/Makefile
> > @@ -10,6 +10,7 @@ LTCOMMAND = mkfs.xfs
> >  HFILES =
> >  CFILES = proto.c xfs_mkfs.c
> >  CFGFILES = \
> > +	dax_x86_64.conf \
> >  	lts_4.19.conf \
> >  	lts_5.4.conf \
> >  	lts_5.10.conf \
> > diff --git a/mkfs/dax_x86_64.conf b/mkfs/dax_x86_64.conf
> > new file mode 100644
> > index 00000000..bc3f3c9a
> > --- /dev/null
> > +++ b/mkfs/dax_x86_64.conf
> > @@ -0,0 +1,19 @@
> > +# mkfs.xfs configuration file for persistent memory on x86_64.
> > +# Block size must match page size (4K) and we require V5 for the DAX inode
> > +# flag.  Set extent size hints and stripe units to encourage the filesystem to
> > +# allocate PMD sized (2MB) blocks.
> > +
> > +[block]
> > +size=4096
> > +
> > +[metadata]
> > +crc=1
> > +
> > +[data]
> > +sunit=4096
> > +swidth=4096
> 
> How would you feel about:
> 
> su=2m
> sw=1
> 
> instead, because I think that explicit units are far more obvious than
> "4096 <handwave> 512-byte units" ?

Fine with me. :)

> > +extszinherit=512
> 
> ... though I guess this can only be specified in fsblocks, LOLZ :(
> 
> > +daxinherit=1
> > +
> > +[realtime]
> > +extsize=2097152
> 
> Pretty weird to set this if you don't have a realtime device but I guess
> it works.

Yeah, everything rt is weird. :)

--D

> 
> -Eric
