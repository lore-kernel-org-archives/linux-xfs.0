Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6492EC4708D
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Dec 2022 21:48:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiLGVsp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Dec 2022 16:48:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiLGVsh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Dec 2022 16:48:37 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A2AC813BA
        for <linux-xfs@vger.kernel.org>; Wed,  7 Dec 2022 13:48:36 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id 21so18660793pfw.4
        for <linux-xfs@vger.kernel.org>; Wed, 07 Dec 2022 13:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tos5tkBcYyuJlBWEfLnos/GnRiwMSc7BrvTQatB97HE=;
        b=fF/VTroEX5Gye7zG8uW8kbCTCxKy23hRqhwmzv9I2n9oSLXNFx6/4UDEupWp9Ozrb0
         YomPHo9UvVi3XBlCET3Xari18VuJ0jSlaEOmsCyNomnOj4L37TEs3RAcHqW/RDZ2dFWj
         9S9vLZ24cRVWsaqHuSImIVbhTUNRjHfgNgdA3yI+sH0xV0dyXq/4YuEfVOGKYxcHvkqd
         oTW3S0GKbXJyWNAZ0Tj8IqFVZVbOfzAh1UwodoGS6X5TIFLCDl3zo80MOx9gtjjoVTY2
         wdN1GIe4weXSnSAvWUZ1Bl6A4uIKC2yUyxFiu8w+4AG8LijIQGNkuhU209v2cBQ6Jlhy
         N5Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tos5tkBcYyuJlBWEfLnos/GnRiwMSc7BrvTQatB97HE=;
        b=7A2+mzGZMaS3cPH8Teu3dYFKIp1M/sx413AX1kegtIgaAAxXKoe1xn63deIR9fHuY6
         BVoU46ZTSzfb8BPOi7bHhh1+kwDbgM9EafPINbneuSWwx1DSHHIe7hZ3+zwkyJIfJphV
         ONT/gF0i+8IaIWYNsH63zQBDeeMZ5BVDgXocnEIZ4fMdSEbHSU3G0xYkgqIVl8lR0tN1
         OcihChwLHfp6pdpFqlBqW+cF1V77RW8UZgjyeIgAeJj5o1Jty5CsW+w7cltzumwWX/lb
         bDatwXvoPKZ1LBD9Ut0E3SIr/eRSv3S7/RQ4cVezt0jXGqhdV6tKs1M0wHDzA0JMsQcy
         zXsQ==
X-Gm-Message-State: ANoB5pm0GSr1XFiqqu+sudwcimT0TgzJbv8kk+ePaxfYDJjZDulK/Dya
        0FQ/f2eCOckyq7cFCcHNawRMQONc+NDiD3NO
X-Google-Smtp-Source: AA0mqf7Ke5l3ctc3yfIcWEreEp6XeZARPxn97qzPzNJusua5eTiDkOzQEqlsDVdAHgGZZirMk/EqEw==
X-Received: by 2002:a63:500f:0:b0:478:bc19:a510 with SMTP id e15-20020a63500f000000b00478bc19a510mr14061542pgb.288.1670449715568;
        Wed, 07 Dec 2022 13:48:35 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id k9-20020a17090a514900b00218abadb6a8sm1598121pjm.49.2022.12.07.13.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 13:48:35 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p32HH-005jih-5m; Thu, 08 Dec 2022 08:48:31 +1100
Date:   Thu, 8 Dec 2022 08:48:31 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        fstests <fstests@vger.kernel.org>, linux-xfs@vger.kernel.org,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Subject: Re: [PATCH] common/populate: Ensure that S_IFDIR.FMT_BTREE is in
 btree format
Message-ID: <20221207214831.GI2703033@dread.disaster.area>
References: <20221201081208.40147-1-hsiangkao@linux.alibaba.com>
 <Y4jNzE5YJ3wFtsaz@magnolia>
 <Y4lhi+5nJNl0diaj@B-P7TQMD6M-0146.local>
 <20221206233417.GF2703033@dread.disaster.area>
 <Y4/2ZUIm2MKs6UID@B-P7TQMD6M-0146.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4/2ZUIm2MKs6UID@B-P7TQMD6M-0146.local>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 07, 2022 at 10:11:49AM +0800, Gao Xiang wrote:
> On Wed, Dec 07, 2022 at 10:34:17AM +1100, Dave Chinner wrote:
> > On Fri, Dec 02, 2022 at 10:23:07AM +0800, Gao Xiang wrote:
> > > > > +			[ "$nexts" -gt "$(((isize - 176) / 16))" ] && break
> > > > 
> > > > Only need to calculate this once if you declare this at the top:
> > > > 
> > > > 	# We need enough extents to guarantee that the data fork is in
> > > > 	# btree format.  Cycling the mount to use xfs_db is too slow, so
> > > > 	# watch for when the extent count exceeds the space after the
> > > > 	# inode core.
> > > > 	local max_nextents="$(((isize - 176) / 16))"
> > > > 
> > > > and then you can do:
> > > > 
> > > > 			[[ $nexts -gt $max_nextents ]] && break
> > > > 
> > > > Also not a fan of hardcoding 176 around fstests, but I don't know how
> > > > we'd detect that at all.
> > > > 
> > > > # Number of bytes reserved for only the inode record, excluding the
> > > > # immediate fork areas.
> > > > _xfs_inode_core_bytes()
> > > > {
> > > > 	echo 176
> > > > }
> > > > 
> > > > I guess?  Or extract it from tests/xfs/122.out?
> > > 
> > > Thanks for your comments.
> > > 
> > > I guess hard-coded 176 in _xfs_inode_core_bytes() is fine for now
> > > (It seems a bit weird to extract a number from a test expected result..)
> > 
> > Which is wrong when testing a v4 filesystem - in that case the inode
> > core size is 96 bytes and so max extents may be larger on v4
> > filesystems than v5 filesystems....
> 
> Do we really care v4 fs for now since it's deprecated?...

Yes, there are still lots of v4 filesystems in production
environments. There shouldn't be many new ones, but there is a long
tail of existing storage containing v4 filesystems that we must not
break.

We have to support v4 filesystems for another few years yet, hence
we still need solid test coverage on them to ensure we don't
accidentally break something that is going to bite users before they
migrate to newer filesystems....

> Darrick once also 
> suggested using (isize / 16) but it seems it could take unnecessary time to
> prepare.. Or we could just use (isize - 96) / 16 to keep v4 work.

It's taken me longer to write this email than it does to write the
code to make it work properly. e.g.:

	xfs_info $scratch | sed -ne 's/.*crc=\([01]\).*/\1/p'

And now we have 0 = v4, 1 = v5, and it's trivial to return the
correct inode size.

You can even do this trivially with grep:

	xfs_info $scratch | grep -wq "crc=1"
	if [ $? -eq 0 ]; then
		echo 176
	else
		echo 96
	fi

and now the return value tells us if we have a v4 or v5 filesystem.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
