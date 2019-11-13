Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92092C43331
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 06:16:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B661222CD
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 06:16:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jUkHh1it"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbfKMGQy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 01:16:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55457 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725866AbfKMGQy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 01:16:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573625813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AIZp9yHBFDUruuXW0JJC83eKv9Q2/zaGLYS7xvC/kAM=;
        b=jUkHh1itCo4BL6/EbwjcAJCGt/lqqW5SfAfiyWwbtH0EV4g8tqUWQZ9KlaCKOYTBj9BbxK
        nBAgSlpVWpERaQUZiPI/C2yOHXx8ptodERZCA2IqbwfvuyWoCUiJo2JESwqnmc77YoJf76
        Lnc2WMSp7JVdqvhB0642IBa+BIbcg7A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-BJZpVlNKOnKu364uHqvsJw-1; Wed, 13 Nov 2019 01:16:47 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51A1718B5F71;
        Wed, 13 Nov 2019 06:16:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 13C164D751;
        Wed, 13 Nov 2019 06:16:46 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id A90E34BB5C;
        Wed, 13 Nov 2019 06:16:45 +0000 (UTC)
Date:   Wed, 13 Nov 2019 01:16:45 -0500 (EST)
From:   Jan Stancek <jstancek@redhat.com>
To:     Ian Kent <raven@themaw.net>,
        kernel test robot <rong.a.chen@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org,
        lkp@lists.01.org, ltp@lists.linux.it,
        DavidHowells <dhowells@redhat.com>,
        AlViro <viro@ZenIV.linux.org.uk>
Message-ID: <975334005.11814790.1573625805426.JavaMail.zimbra@redhat.com>
In-Reply-To: <e38bc7a8505571bbb750fc0198ec85c892ac7b3a.camel@themaw.net>
References: <20191111010022.GH29418@shao2-debian> <3fb8b1b04dd7808b45caf5262ee629c09c71e0b6.camel@themaw.net> <1108442397.11662343.1573560143066.JavaMail.zimbra@redhat.com> <20191112120818.GA8858@lst.de> <5f758be455bb8f761d028ea078b3e2a618dfd4b1.camel@themaw.net> <e38bc7a8505571bbb750fc0198ec85c892ac7b3a.camel@themaw.net>
Subject: Re: [LTP] [xfs] 73e5fff98b: kmsg.dev/zero:Can't_open_blockdev
MIME-Version: 1.0
X-Originating-IP: [10.43.17.163, 10.4.195.20]
Thread-Topic: 73e5fff98b: kmsg.dev/zero:Can't_open_blockdev
Thread-Index: AzWavxd/8PGGbt3Ud1LytMdxvpbGqQ==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: BJZpVlNKOnKu364uHqvsJw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



----- Original Message -----
> > > > # mount -t xfs /dev/zero /mnt/xfs
> >=20
> > Assuming that is what is being done ...
>=20
> Arrrh, of course, a difference between get_tree_bdev() and
> mount_bdev() is that get_tree_bdev() prints this message when
> blkdev_get_by_path() fails whereas mount_bdev() doesn't.
>=20
> Both however do return an error in this case so the behaviour
> is the same.
>=20
> So I'm calling this not a problem with the subject patch.
>=20
> What needs to be done to resolve this in ltp I don't know?

I think that's question for kernel test robot, which has this extra
check built on top. ltp itself doesn't treat this extra message as FAIL.

Jan

