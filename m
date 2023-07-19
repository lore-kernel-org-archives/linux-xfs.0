Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B9F6C0015E
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jul 2023 22:24:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbjGSWYA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jul 2023 18:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjGSWX4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jul 2023 18:23:56 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09CE71FDC
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 15:23:54 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 3BD3232008FF;
        Wed, 19 Jul 2023 18:23:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Jul 2023 18:23:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        cc:cc:content-transfer-encoding:content-type:content-type:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm3; t=
        1689805430; x=1689891830; bh=TYBPMMM/wgrW5pXFfx71za5f09e/38WPHgZ
        KoVzHAxU=; b=pQQVMIJE6me/wvUL7LYJmDjynDOk0bm/PXnEom7OTW2Lojsaw1q
        9/jjNELQ7JMnmfkysm3CCfLcbaz/6q27VwEoK8Cm6ararRnD9VXeRnf/jRGcfvKO
        bYy4214Jb0LRR0FXYsnku/Ed1bMCrSrnKZdVlaFWu1wcWXIcm+b5xnJC6/39O1ll
        SHCZF8VZa1zQQIbndRyNroKCDHZbx7guQX9IH4Qc9Jn+9K7UC5zXVs3lMay+0zUx
        qxwGCmkg5tcKS9i46VSSWLqpche949BR1cS9RzJcKiGgvHBdvEJ5mgntg5dPuKpd
        37UgiMenIBVUufUegtCItAt71yZ9WLU+wjg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:date:feedback-id:feedback-id
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1689805430; x=1689891830; bh=TYBPMMM/wgrW5pXFfx71za5f09e/38WPHgZ
        KoVzHAxU=; b=TfdksECU59v8pQVMHv6JTSrrqkWg9D/vZ71KLkuUCx9CvgQeC91
        Xl1AC/JSkmUWW0+kvH4FDJiZXpgaOR8MpVZpUWVAoDQu5AzZduKqD8BAeMp+EfKo
        lD7nj6+zfQmr70eKqXC1rQE7YcsCNCfXvFQfwYA1upYg4Y3+Z67L9mDTV0B0/XDZ
        6XZs1ZjVgOfERveDrRv2lHj8dvoWx7AfxU5zyVd+mr94shU6rgXv2RnOqVRpnJ0S
        Z8lH7UXU+J/ziBL4DxSRco88CgxHWqf/G6yTladG2cDglfwFeami2Ejj1BPATstE
        NUJle4oENVSlreUJz2h+lKc6EyB7ttJNevg==
X-ME-Sender: <xms:dmK4ZCY-PGr4o2cT96qj9Uv_byd0ZGfbmIY_ZaWZc2fuZsiTZASOBw>
    <xme:dmK4ZFa2euIszb4-jT2V9suJvuMIKyvyBji0t2Q_hbvPEPdKV-7ES07lvmIacGaV2
    q7g7nAF3ckh4cJmhg>
X-ME-Received: <xmr:dmK4ZM8-uVBnReQztXjlHkDPH4FTPF3XU8fQSjrUstH6Rmd5OeFIiNj8vPMk40pI02gBVYhxJcNz83RZtHJosDZOSKQaaTr7IB8rNQhok-Dj3tysvCk64W08kpYT>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrgeelgddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtugfgjgesthekredttddtjeenucfhrhhomheptehnughr
    vghsucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrf
    grthhtvghrnhephfeitefgleevtedtffejvedujeekjedugfdtveffjeelvddtfeekgefg
    jefhgfegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eprghnughrvghssegrnhgrrhgriigvlhdruggv
X-ME-Proxy: <xmx:dmK4ZEokBXvqVaeN3eBFatc0dNb53cLl7LokBywCCRH34x3hgVWPpg>
    <xmx:dmK4ZNqzRtxLL1y_f0ovLZH70w2b0-fN-7Ob9hdqler4v1LegMbUmg>
    <xmx:dmK4ZCQMj6lX0N2B4q4hNCs5R0ZmoxLYxeSFw7qt78YqSTqLRdvR4w>
    <xmx:dmK4ZEVS17bfsfhrxQwgddZOMTj9vgHGvjLSgKJWSS_tbRHTrw7sPA>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 19 Jul 2023 18:23:49 -0400 (EDT)
Date:   Wed, 19 Jul 2023 15:23:48 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     sandeen@redhat.com, Dave Chinner <david@fromorbit.com>,
        Masahiko Sawada <sawada.mshk@gmail.com>,
        linux-xfs@vger.kernel.org
Subject: Re: Question on slow fallocate
Message-ID: <20230719222348.7vku6rfa6s2havlw@awork3.anarazel.de>
References: <ZJTrrwirZqykiVxn@dread.disaster.area>
 <CAD21AoC9=8Q2o3-+ueuP05+8298z--5vgBWtvSxMHHF2jdyr_w@mail.gmail.com>
 <3f604849-877b-f519-8cae-4694c82ac7e4@sandeen.net>
 <CAD21AoBHd35HhFpbh9YBHPsLN+F_TZX5b47iy+-s44jPT+fyZQ@mail.gmail.com>
 <82b74cbc-8a1d-6b6f-fa2f-5f120d958dad@sandeen.net>
 <20230711224911.yd3ns6qcrlepbptq@awork3.anarazel.de>
 <ZLeP8VwYuXGKYC/Z@dread.disaster.area>
 <20230719202917.qkgtvk43scl4rt2m@awork3.anarazel.de>
 <b630989d-1eb5-6285-6e22-9946de8e2ca5@redhat.com>
 <428ab767-98ef-9556-0942-686f41f72700@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <428ab767-98ef-9556-0942-686f41f72700@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

On 2023-07-19 15:49:59 -0500, Eric Sandeen wrote:
> On 7/19/23 3:38 PM, Eric Sandeen wrote:
> > On 7/19/23 3:29 PM, Andres Freund wrote:
> > > Somewhat tangential: I still would like a fallocate() option that
> > > actually
> > > zeroes out new extents (via "write zeroes", if supported), rather
> > > than just
> > > setting them up as unwritten extents. Nor for "data" files, but for
> > > WAL/journal files.
> >
> > Like this?
> >
> > fallocate(2):
> >
> >     Zeroing file space
> >         Specifying  the  FALLOC_FL_ZERO_RANGE  flag  (available  since
> > Linux 3.15) in mode zeros space in the byte range starting at offset and
> > continuing for len bytes.
> >
> > Under the covers, that uses efficient zeroing methods when available.
> >
> > -Eric
> >
>
> Hm sorry, it's been a while. Maybe I'm wrong about this; I know it does
> efficient zeroing when pointed at a block device but I guess I've confused
> myself about what happens on a filesystem like XFS that supports unwritten
> extents.

Yea, it's documented to use unwritten extents:

       Zeroing is done within the filesystem preferably by converting the
       range into unwritten extents.  This approach means that the specified
       range will not be physically zeroed out on the device (except for
       partial blocks at the either end of the range), and I/O is (otherwise)
       required only to update meta‐ data.

and an experiment confirms that:

$ dd if=/dev/zero of=test bs=1MB count=1

$ filefrag -v test
Filesystem type is: 58465342
File size of test is 1000000 (245 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..     244:    6104864..   6105108:    245:             last,eof
test: 1 extent found

$ fallocate -z -o 0 -l $((4096*128)) test
$ filefrag -v test
Filesystem type is: 58465342
File size of test is 1000000 (245 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..     127:    6105210..   6105337:    128:             unwritten
   1:      128..     244:    6104992..   6105108:    117:    6105338: last,eof

Greetings,

Andres Freund
