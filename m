Return-Path: <SRS0=BKGZ=5R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36732C2D0F3
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 13:54:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BD2E2078B
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 13:54:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lca.pw header.i=@lca.pw header.b="MoVaM7Bi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732804AbgDANyM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Apr 2020 09:54:12 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36816 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732803AbgDANyM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Apr 2020 09:54:12 -0400
Received: by mail-qk1-f196.google.com with SMTP id d11so27071093qko.3
        for <linux-xfs@vger.kernel.org>; Wed, 01 Apr 2020 06:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=XyZ3y86nfsmDXFF8XUBauwm0oy2rui9ajkMLkCrCOD0=;
        b=MoVaM7BiG6iJBWAcLqIRXlcNH6vcPCGLa+UMnQd1EGajH3A5syrCWN7OSZBA1I0QuZ
         r9GPfW8xGWVa9Yvih2IhZ45IDCsfoA+aPy9EwpbmVIfscXW8PRnXh5UjxeifHKZQTga6
         xKuvcHDwhiNUivNJMdyAlNDJDzGYkKM4xuVQVj6zsd6Mc393MAAKaCGb7x7LCQIBbYkn
         tZKSt6iKD/AOA+an7PqqJ5DM2g+akXvthum3lqoa326l+vW1jHrsDbqs/pyHxOg2b4sd
         A3LMGsbzfDWBmLHOzKURMYGCJ69HW/tlgFttnDKo4Auv+A0+/zj6anYb0Xs9lNIC75gE
         igcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=XyZ3y86nfsmDXFF8XUBauwm0oy2rui9ajkMLkCrCOD0=;
        b=FCU3awqdJGEiX9dCYC6ZbNO00oPcEsFbtf/6D+KtTNjCmoX121N+g0ebsnG/kU+vRZ
         VpZyv6cD0QEo4yaE1AbS3Pw312FSDt6yQBqFSnkM0gmISrAptmbqmcVoNSFcBBv0nADY
         jylb5oAVqarAEO+Qznxo+mLi2enUhv4OrYO5Kr88XMBEWVWo13ETRah49DDZFM8jGDoY
         15AE8VwJl0be4X+3RdjpVAlyAeJwig3xfO1M9X8wLhC5IWx58PKTZkhv972mP30Ei3y/
         bpWaeJB0iE8dw7rTQBoe7vfDAK8SdBZqIkitE1cP9/ovSQXVABXCan0tPLdtrdzuqYdU
         OYbA==
X-Gm-Message-State: AGi0Pubyyz4qB4148JRE6XbZGlpg62kFKUcKnB9EOXkHpglPex9JzlO+
        tOwG0dKvKu9oRTmzUsO7Yjp2nTDyxaR4vg==
X-Google-Smtp-Source: APiQypLOtwMzbmojdZdj4/Wcv9pWizIl94daik5jVK3yT2cZyP1OALvwBFvIt4APLU7E04iF3NnUPA==
X-Received: by 2002:a37:4c4d:: with SMTP id z74mr5268669qka.53.1585749250005;
        Wed, 01 Apr 2020 06:54:10 -0700 (PDT)
Received: from [192.168.1.153] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id n46sm1531701qtb.48.2020.04.01.06.54.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Apr 2020 06:54:09 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: linux-next: xfs metadata corruption since 30 March
From:   Qian Cai <cai@lca.pw>
In-Reply-To: <20200401044528.GE56958@magnolia>
Date:   Wed, 1 Apr 2020 09:54:08 -0400
Cc:     Chandan Rajendra <chandan@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <969A3A42-E2FC-4A41-95C7-3F37AB30F61F@lca.pw>
References: <990EDC4E-1A4E-4AC3-84D9-078ACF5EB9CC@lca.pw>
 <11749734.KdfBBZeIvc@localhost.localdomain>
 <FDCFF269-C30C-42A8-B926-A8731E110848@lca.pw>
 <20200401044528.GE56958@magnolia>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



> On Apr 1, 2020, at 12:45 AM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>=20
> On Wed, Apr 01, 2020 at 12:15:32AM -0400, Qian Cai wrote:
>>=20
>>=20
>>> On Apr 1, 2020, at 12:14 AM, Chandan Rajendra =
<chandan@linux.ibm.com> wrote:
>>>=20
>>> On Wednesday, April 1, 2020 3:27 AM Qian Cai wrote:=20
>>>> Ever since two days ago, linux-next starts to trigger xfs metadata =
corruption
>>>> during compilation workloads on both powerpc and arm64,
>>>=20
>>> Can you please provide the filesystem geometry information?
>>> You can get that by executing "xfs_info <mount-point>" command.
>>>=20
>=20
> Hmm.   Do the arm/ppc systems have 64k pages?  kconfigs might be a =
good
> starting place.  Also, does the xfs for-next branch exhibit this

Yes, 64k pages. The configs are in,

https://github.com/cailca/linux-mm

> problem, or is it just the big -next branch that Stephen Rothwell puts
> out?

The later.

>=20
> --D
>=20
>> =3D=3D arm64 =3D=3D
>> # xfs_info /home/
>> meta-data=3D/dev/mapper/rhel_hpe--apollo--cn99xx--11-home isize=3D512 =
   agcount=3D4, agsize=3D113568256 blks
>>         =3D                       sectsz=3D4096  attr=3D2, =
projid32bit=3D1
>>         =3D                       crc=3D1        finobt=3D1, =
sparse=3D1, rmapbt=3D0
>>         =3D                       reflink=3D1
>> data     =3D                       bsize=3D4096   blocks=3D454273024, =
imaxpct=3D5
>>         =3D                       sunit=3D0      swidth=3D0 blks
>> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, =
ftype=3D1
>> log      =3Dinternal log           bsize=3D4096   blocks=3D221813, =
version=3D2
>>         =3D                       sectsz=3D4096  sunit=3D1 blks, =
lazy-count=3D1
>> realtime =3Dnone                   extsz=3D4096   blocks=3D0, =
rtextents=3D0
>>=20
>>=20
>> =3D=3D powerpc =3D=3D
>> # xfs_info /home/
>> meta-data=3D/dev/mapper/rhel_ibm--p9wr--01-home isize=3D512    =
agcount=3D4, agsize=3D118489856 blks
>>         =3D                       sectsz=3D4096  attr=3D2, =
projid32bit=3D1
>>         =3D                       crc=3D1        finobt=3D1, =
sparse=3D1, rmapbt=3D0
>>         =3D                       reflink=3D1
>> data     =3D                       bsize=3D4096   blocks=3D473959424, =
imaxpct=3D5
>>         =3D                       sunit=3D0      swidth=3D0 blks
>> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, =
ftype=3D1
>> log      =3Dinternal log           bsize=3D4096   blocks=3D231425, =
version=3D2
>>         =3D                       sectsz=3D4096  sunit=3D1 blks, =
lazy-count=3D1
>> realtime =3Dnone                   extsz=3D4096   blocks=3D0, =
rtextents=3D0
>>=20
>> =3D=3D x86 (not yet reproduced)  =3D=3D
>> meta-data=3D/dev/mapper/rhel_hpe--dl380gen9--01-home isize=3D512    =
agcount=3D16, agsize=3D3283776 blks
>>         =3D                       sectsz=3D512   attr=3D2, =
projid32bit=3D1
>>         =3D                       crc=3D1        finobt=3D1, =
sparse=3D1, rmapbt=3D0
>>         =3D                       reflink=3D1
>> data     =3D                       bsize=3D4096   blocks=3D52540416, =
imaxpct=3D25
>>         =3D                       sunit=3D64     swidth=3D64 blks
>> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, =
ftype=3D1
>> log      =3Dinternal log           bsize=3D4096   blocks=3D25664, =
version=3D2
>>         =3D                       sectsz=3D512   sunit=3D0 blks, =
lazy-count=3D1
>> realtime =3Dnone                   extsz=3D4096   blocks=3D0, =
rtextents=3D0

