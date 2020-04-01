Return-Path: <SRS0=BKGZ=5R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E172C2D0F3
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 04:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 054B42077D
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 04:15:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lca.pw header.i=@lca.pw header.b="rJs5UtD3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgDAEPg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Apr 2020 00:15:36 -0400
Received: from mail-qk1-f181.google.com ([209.85.222.181]:37126 "EHLO
        mail-qk1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbgDAEPf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Apr 2020 00:15:35 -0400
Received: by mail-qk1-f181.google.com with SMTP id x3so25775239qki.4
        for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2020 21:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ZjcrYW/aDVAKzWpGPbODFCrUFQNHJCyNrGbNk09sdLY=;
        b=rJs5UtD3QTXJ3rqk1LvxnBOXyBiv0BbSm3yZdDWntrkTjoetaxwar2z0AaadTNtytX
         rU+b1NuWvxKjRqUMNGfMVeMQZ/8f0pjp/0z6Z2ya9qTQtibf5E/cYyKLtg9wA6BihAJ3
         Mrlcrxdcrb/zMUmdoXGe4sD5K59FRPthyYjNIlu1pQOmQP3NLB7SxaM6e6AwyXIKVQ32
         gMLrgvotcMgSfvUeY2r2lbnjo6lCtA7MBv5ksjcHdLnIR1zXuDaTwApijiNsjPQRlZpu
         WA1gaQko/rOjMSecuxwLUpci+qQpobWrIRSV8c+6nTwvi3Umfv1mfPMD5xsCzWxWjEMs
         1c9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ZjcrYW/aDVAKzWpGPbODFCrUFQNHJCyNrGbNk09sdLY=;
        b=iJ7Dpx9Ggpte0l1dSapSFHhCGggNepTOlWBziNG+ri7M+U4xrpdY864AhRpR36a3Cp
         BJceiYW9tZozeux1vyeaY05ZyeXkXIeNoGiLq49/1CVz3pk/e533CNHX5W189MyQN5Lg
         ZaulhZzV9t8CRhN3WFKH/ymlXsEVbJqhSiuqTj1fqLx5mwMLtjRejS5rpvzTXXD9iDOI
         E5FRNWKGbqG8UCZIclKrd4C0Zz0TtIGuAypk6rCbtItFNgll2e7+yUr7NpZ/HKEIS2c7
         7yI33mpkna15u1iVtIKkKqQuRdjkkIN7X74B4Y59vhRwJL8t9omrKsiwRf9DOn7o9yN4
         3taA==
X-Gm-Message-State: ANhLgQ0B3W8/goMdyo1Q559+AtqEWYVoj4C3oEhid39QTkWCS3t3ZRyk
        nMLOZQnxfE1pn1ComIP7lI52JA==
X-Google-Smtp-Source: ADFU+vsGU/+YWiqw4a0Mqfe5XtYPrISpqIqQgG13q+CHJ3GKwhtnnawpZF7GXGn5Fa/ywvPA2mJELA==
X-Received: by 2002:a37:ad6:: with SMTP id 205mr7886299qkk.294.1585714534245;
        Tue, 31 Mar 2020 21:15:34 -0700 (PDT)
Received: from [192.168.1.153] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id a136sm750681qkb.15.2020.03.31.21.15.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Mar 2020 21:15:33 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: linux-next: xfs metadata corruption since 30 March
From:   Qian Cai <cai@lca.pw>
In-Reply-To: <11749734.KdfBBZeIvc@localhost.localdomain>
Date:   Wed, 1 Apr 2020 00:15:32 -0400
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FDCFF269-C30C-42A8-B926-A8731E110848@lca.pw>
References: <990EDC4E-1A4E-4AC3-84D9-078ACF5EB9CC@lca.pw>
 <11749734.KdfBBZeIvc@localhost.localdomain>
To:     Chandan Rajendra <chandan@linux.ibm.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



> On Apr 1, 2020, at 12:14 AM, Chandan Rajendra <chandan@linux.ibm.com> =
wrote:
>=20
> On Wednesday, April 1, 2020 3:27 AM Qian Cai wrote:=20
>> Ever since two days ago, linux-next starts to trigger xfs metadata =
corruption
>> during compilation workloads on both powerpc and arm64,
>=20
> Can you please provide the filesystem geometry information?
> You can get that by executing "xfs_info <mount-point>" command.
>=20

=3D=3D arm64 =3D=3D
# xfs_info /home/
meta-data=3D/dev/mapper/rhel_hpe--apollo--cn99xx--11-home isize=3D512    =
agcount=3D4, agsize=3D113568256 blks
         =3D                       sectsz=3D4096  attr=3D2, =
projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, =
rmapbt=3D0
         =3D                       reflink=3D1
data     =3D                       bsize=3D4096   blocks=3D454273024, =
imaxpct=3D5
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D4096   blocks=3D221813, =
version=3D2
         =3D                       sectsz=3D4096  sunit=3D1 blks, =
lazy-count=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, =
rtextents=3D0


=3D=3D powerpc =3D=3D
# xfs_info /home/
meta-data=3D/dev/mapper/rhel_ibm--p9wr--01-home isize=3D512    =
agcount=3D4, agsize=3D118489856 blks
         =3D                       sectsz=3D4096  attr=3D2, =
projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, =
rmapbt=3D0
         =3D                       reflink=3D1
data     =3D                       bsize=3D4096   blocks=3D473959424, =
imaxpct=3D5
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D4096   blocks=3D231425, =
version=3D2
         =3D                       sectsz=3D4096  sunit=3D1 blks, =
lazy-count=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, =
rtextents=3D0

=3D=3D x86 (not yet reproduced)  =3D=3D
meta-data=3D/dev/mapper/rhel_hpe--dl380gen9--01-home isize=3D512    =
agcount=3D16, agsize=3D3283776 blks
         =3D                       sectsz=3D512   attr=3D2, =
projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, =
rmapbt=3D0
         =3D                       reflink=3D1
data     =3D                       bsize=3D4096   blocks=3D52540416, =
imaxpct=3D25
         =3D                       sunit=3D64     swidth=3D64 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D4096   blocks=3D25664, =
version=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, =
lazy-count=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, =
rtextents=3D0=
