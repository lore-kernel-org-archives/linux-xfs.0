Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F21C47086
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 22:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 017E5610A8
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 22:48:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhEYWth (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 18:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbhEYWtg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 May 2021 18:49:36 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59141C061756
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 15:48:05 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 27so22633975pgy.3
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 15:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=lQU/mw2gew9Xsu/0BklV7sCPI0gkzm5yQeyxIIbvBKw=;
        b=HMjd6r8WAvXPNaQI4bYAP8fKI8dQWuW89LsVrprrgTOuU5+BFUxRmFqVp3hgOAxagR
         cfNBC4uv3kNMsqzqoimFA4P0hBzrScP7tZDugDdtQRaMCIsp83d7eP4aRFgdjTOAkqaY
         EcBySS5OB1Jp1RM9rOIeg4vGNuAodjB8ioNpZliXG5YHvgOI5vg6YkAsh8UlVfEUorgi
         tooZ04Fa4XmOI54vufP3tUNGpQ/vItEuv5AaKv2Kz04lqJiQQJioKi7vXh+7NeFtpPl8
         PrkJ7Fh3n+1xNy+RRz0AlWzBWRZxgnKN90n8tN2vGcjphifpsmzNuElKDbcfnWwdUmZI
         T4tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=lQU/mw2gew9Xsu/0BklV7sCPI0gkzm5yQeyxIIbvBKw=;
        b=tnR2X7ErK8Z9ebdRXDHzMpbNtWz350NVlszOmsDuzdU8RJqtVxkhHbZNMdtO2lM0cM
         5s5GyLaO9t8ZMo4bsDk02i3sj62uMgV6fWMqHu8k5Gz+CS/+1sllRWc7W21bc3LGXzTx
         L+zgR+ZwT6ZpxTKfXqmPtijqcpSu16QnESETVLs0EqoOjpWDW3po8yH3KVFcG86Ztm7Y
         zfJLu1f2BYmhdGXWsii80niloVNmtb4rjg/3KvzfsEP83IHz5jh8J4Ax6rXgqmpB/d5E
         bFpF5qkeF6wy+mNmdYG2cF9h+iwmUomt8RJxVpQPij2CBW1dt+WRloKZoAcCWpEaivLp
         jvig==
X-Gm-Message-State: AOAM531hEwCRY2u3F7qz/dvZIh1dWMH+HP4V5dKAuQTDezrE0HoYBUdQ
        pmGF8F9vfHMsOZtnqufPTp5Hpw==
X-Google-Smtp-Source: ABdhPJxAQ+fotSqwe8faCf5H7a8xb5y1avK/VcXmLBYp/UuZVxScgxz1HlQG03JVDuAyVp0hpf2MdQ==
X-Received: by 2002:a05:6a00:882:b029:2de:b01d:755a with SMTP id q2-20020a056a000882b02902deb01d755amr32457813pfj.43.1621982884571;
        Tue, 25 May 2021 15:48:04 -0700 (PDT)
Received: from cabot.adilger.int (S01061cabc081bf83.cg.shawcable.net. [70.77.221.9])
        by smtp.gmail.com with ESMTPSA id n30sm15459221pgd.8.2021.05.25.15.48.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 May 2021 15:48:03 -0700 (PDT)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <59253C17-3155-4ADF-B965-CEA375230483@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_47C6E327-64C0-41DB-8EFA-2AED6EDE9B5E";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: How capacious and well-indexed are ext4, xfs and btrfs
 directories?
Date:   Tue, 25 May 2021 16:48:01 -0600
In-Reply-To: <YK1rebI5vZKCeLlp@casper.infradead.org>
Cc:     Josh Triplett <josh@joshtriplett.org>,
        David Howells <dhowells@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>,
        "Darrick J. Wong" <djwong@kernel.org>, Chris Mason <clm@fb.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-cachefs@redhat.com,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        NeilBrown <neilb@suse.com>
To:     Matthew Wilcox <willy@infradead.org>
References: <206078.1621264018@warthog.procyon.org.uk>
 <6E4DE257-4220-4B5B-B3D0-B67C7BC69BB5@dilger.ca> <YKntRtEUoxTEFBOM@localhost>
 <B70B57ED-6F11-45CC-B99F-86BBDE36ACA4@dilger.ca>
 <YK1rebI5vZKCeLlp@casper.infradead.org>
X-Mailer: Apple Mail (2.3273)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


--Apple-Mail=_47C6E327-64C0-41DB-8EFA-2AED6EDE9B5E
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On May 25, 2021, at 3:26 PM, Matthew Wilcox <willy@infradead.org> wrote:
> 
> On Tue, May 25, 2021 at 03:13:52PM -0600, Andreas Dilger wrote:
>> Definitely "-o discard" is known to have a measurable performance impact,
>> simply because it ends up sending a lot more requests to the block device,
>> and those requests can be slow/block the queue, depending on underlying
>> storage behavior.
>> 
>> There was a patch pushed recently that targets "-o discard" performance:
>> https://patchwork.ozlabs.org/project/linux-ext4/list/?series=244091
>> that needs a bit more work, but may be worthwhile to test if it improves
>> your workload, and help put some weight behind landing it?
> 
> This all seems very complicated.  I have chosen with my current laptop
> to "short stroke" the drive.  That is, I discarded the entire bdev,
> then partitioned it roughly in half.  The second half has never seen
> any writes.  This effectively achieves the purpose of TRIM/discard;
> there are a lot of unused LBAs, so the underlying flash translation layer
> always has plenty of spare space when it needs to empty an erase block.
> 
> Since the steady state of hard drives is full, I have to type 'make clean'
> in my build trees more often than otherwise and remember to delete iso
> images after i've had them lying around for a year, but I'd rather clean
> up a little more often than get these weird performance glitches.
> 
> And if I really do need half a terabyte of space temporarily, I can
> always choose to use the fallow range for a while, then discard it again.

Sure, that's one solution for a 1TB laptop, but not large filesystems
that may be hundreds of TB per device.  I don't think the owners of
Perlmutter (https://www.nersc.gov/systems/perlmutter/) could be convinced
to avoid using 17PB of their flash to avoid the need for TRIM to work. :-)

Cheers, Andreas






--Apple-Mail=_47C6E327-64C0-41DB-8EFA-2AED6EDE9B5E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAmCtfqEACgkQcqXauRfM
H+Dr7RAAv/S5K9b+d4nIh2CHohXKTdMiaX/wu1fLb671uTS1hPABVL+GTVxJlMnQ
J9zXWz0qOxR3XpjlaoaaDd4bp8sOvdiNyKCVspYt3dA2+70OXY0b3NCNoETx/xC+
MI8Bfe9nOvPd5mNq9RYLL1TmlLlEdYPkEgqQhlFSd2j5YFbTx91KQyIlGpmYJozy
wyQsEDLx68e/m8mVl4uDgycqVaR7ECzxDqntELWDD94pR9lecScZszOirZUdRWfy
o9/QuHI0GRsGH1ttenK00MvV2mtiHR4cB891nx63lrOKrQ6xW5dvu0/xGvWqtHUw
CGeWDC/ROL8cN1tAmD22z9cs+lgopez/ISysUW6GxhZn2z65vTw66ooBymT1PTHE
J3ZDVtnBW9lRDeCpAY0mTEvTc9OesBc8YiEB+Tz3XQnIk2eEKCvVWbio8OR+mPWs
32GVJHVc+jZDVUxDuV5HdWjErLndLIkfgylEZm0BHz6+se/beBTvfgZsY60o1VvL
sZGrITkdaGbTwb+FlQnNZd2Nj7/t1BqWm8uIYrORjGJshsct3N8lXH5MmBJlwenA
wezCKjE5kjCUjhVkpd31lSZQM/Jjycm1SWFt/YyZaiNA7C6MvvqzV327hvDUTwt7
LOMQ8MOtgO2/cRKta6uMOOmYnDaR9U07t8W/taStu+i8mvVvwVk=
=SSE/
-----END PGP SIGNATURE-----

--Apple-Mail=_47C6E327-64C0-41DB-8EFA-2AED6EDE9B5E--
