Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84952C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jan 2022 13:24:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235121AbiAMNYu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jan 2022 08:24:50 -0500
Received: from c.mx.filmlight.ltd.uk ([54.76.112.217]:50168 "EHLO
        c.mx.filmlight.ltd.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235092AbiAMNYt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jan 2022 08:24:49 -0500
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Jan 2022 08:24:48 EST
Received: from localhost (localhost [127.0.0.1])
        by omni.filmlight.ltd.uk (Postfix) with ESMTP id 808E940004A5;
        Thu, 13 Jan 2022 13:15:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 omni.filmlight.ltd.uk 808E940004A5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=filmlight.ltd.uk;
        s=default; t=1642079724;
        bh=SsvmpGbuxLS0hJDElHHBN0UYCfEqNVwpDnsPWFYV2Do=;
        h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
        b=yDSASWEX15HtifIQZj1kgDNDIJQhXETrAwTtUsv2k1KWng/lksgwq1I8t4fPfIbqk
         Qv+nXoHSorak0vdBuD1wjlNZs9gzJzx1IE6H3LcDgaev8UZF6w9FkvwgjvWtd+RguD
         Ri51r3MNv1Jtg/PdOsNM+7H9pdaeoiMvBZabVmI4=
Received: from smtpclient.apple (cpc122860-stev8-2-0-cust234.9-2.cable.virginm.net [81.111.212.235])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: roger)
        by omni.filmlight.ltd.uk (Postfix) with ESMTPSA id 477848880E1;
        Thu, 13 Jan 2022 13:15:24 +0000 (GMT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH 1/3] xfs: kill the XFS_IOC_{ALLOC,FREE}SP* ioctls
From:   Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <20220113034712.GD3290465@dread.disaster.area>
Date:   Thu, 13 Jan 2022 13:15:23 +0000
Cc:     Roger Willcocks <roger@filmlight.ltd.uk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <49FC71F0-82F4-4852-BF3D-92A755AC8AFA@filmlight.ltd.uk>
References: <164194336019.3069025.16691952615002573445.stgit@magnolia>
 <164194336605.3069025.17152203611076954599.stgit@magnolia>
 <20220113034712.GD3290465@dread.disaster.area>
To:     Dave Chinner <david@fromorbit.com>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I will just mention in passing that we augment the XFS_IOC_ALLOC ioctl =
to perform explicit near-to-block allocation. I=E2=80=99m not suggesting =
you shouldn=E2=80=99t withdraw the ioctls, just referencing xkcd 1172.

=E2=80=94
Roger


> On 13 Jan 2022, at 03:47, Dave Chinner <david@fromorbit.com> wrote:
>=20
> On Tue, Jan 11, 2022 at 03:22:46PM -0800, Darrick J. Wong wrote:
>> From: Darrick J. Wong <djwong@kernel.org>
>>=20
>> According to the glibc compat header for Irix 4, these ioctls =
originated
>> in April 1991 as a (somewhat clunky) way to preallocate space at the =
end
>> of a file on an EFS filesystem.  XFS, which was released in Irix 5.3 =
in
>> December 1993, picked up these ioctls to maintain compatibility and =
they
>> were ported to Linux in the early 2000s.
>>=20
>> Recently it was pointed out to me they still lurk in the kernel, even
>> though the Linux fallocate syscall supplanted the functionality a =
long
>> time ago.  fstests doesn't seem to include any real functional or =
stress
>> tests for these ioctls, which means that the code quality is ... very
>> questionable.  Most notably, it was a stale disk block exposure =
vector
>> for 21 years and nobody noticed or complained.  As mature programmers
>> say, "If you're not testing it, it's broken."
>>=20
>> Given all that, let's withdraw these ioctls from the XFS userspace =
API.
>> Normally we'd set a long deprecation process, but I estimate that =
there
>> aren't any real users, so let's trigger a warning in dmesg and return
>> -ENOTTY.
>>=20
>> See: CVE-2021-4155
>>=20
>> Augments: 983d8e60f508 ("xfs: map unwritten blocks in =
XFS_IOC_{ALLOC,FREE}SP just like fallocate")
>> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>=20
> Looks good now.
>=20
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> --=20
> Dave Chinner
> david@fromorbit.com
>=20

