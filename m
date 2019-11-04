Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B348C47E49
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 01:49:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01C17222C6
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 01:49:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XZffH1wn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728812AbfKDBtq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Nov 2019 20:49:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53628 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728822AbfKDBtq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Nov 2019 20:49:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572832185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LKwjEx3F+8yVd3sbD3qWcd2xtXeFJuRdOn/qJPJ+bX4=;
        b=XZffH1wnPiaN2BrSJSl94nqp3roeOH8pbI2pG6VP1m1dNKVLylR6e4LJyg2EOAFw4ATrRb
        SC9mHw3KR6uqiGOjxctX8zOT9Yt0jyxVFZOP2UFb5dMOKb69f6ZN+ofz6FYpcIq9jAholE
        SQP+3v3VmoZ7vFfjmLnKeOq+9Hhj8iQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-FmzZZY6bPxesMNrF4hQ6Bg-1; Sun, 03 Nov 2019 20:49:41 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D7F5800A1A;
        Mon,  4 Nov 2019 01:49:40 +0000 (UTC)
Received: from Liberator-6.local (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 52D901001B23;
        Mon,  4 Nov 2019 01:49:40 +0000 (UTC)
Subject: Re: [PATCH] fstests: verify that xfs_growfs can operate on mounted
 device node
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <1253fd24-a0ef-26ca-6ff9-b3b7a451e78a@redhat.com>
 <20191103152446.GA8664@desktop>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <fc635655-1feb-6a31-197b-cea9d0daf855@redhat.com>
Date:   Sun, 3 Nov 2019 19:49:39 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191103152446.GA8664@desktop>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: FmzZZY6bPxesMNrF4hQ6Bg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/3/19 9:24 AM, Eryu Guan wrote:
> On Tue, Oct 29, 2019 at 12:53:48PM -0500, Eric Sandeen wrote:
>> The ability to use a mounted device node as the primary argument
>> to xfs_growfs will be added back in, because it was an undocumented
>> behavior that some userspace depended on.  This test exercises that
>> functionality.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/tests/xfs/148 b/tests/xfs/148
>> new file mode 100755
>> index 00000000..357ae01c
>> --- /dev/null
>> +++ b/tests/xfs/148
>> @@ -0,0 +1,100 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
>> +#
>> +# FS QA Test 148
>> +#
>> +# Test to ensure xfs_growfs command accepts device nodes if & only
>> +# if they are mounted.
>> +# This functionality, though undocumented, worked until xfsprogs v4.12
>> +# It was added back and documented after xfsprogs v5.2
>=20
> I'm testing with xfsprogs from for-next branch, which is v5.3.0-rc1
> based xfs_growfs, but I still see failures like
>=20
>      =3D=3D=3D xfs_growfs - check device node =3D=3D=3D
>     +xfs_growfs: /dev/loop0 is not a mounted XFS filesystem
>      =3D=3D=3D xfs_growfs - check device symlink =3D=3D=3D
>     +xfs_growfs: /mnt/test/loop_symlink.21781 is not a mounted XFS filesy=
stem
>      =3D=3D=3D unmount =3D=3D=3D
>=20
> If it's already fixed, would you please list the related commits in
> commit log as well?

I haven't merged the fix yet.

If you like I can resend the test when it's merged.

