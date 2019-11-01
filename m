Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F763CA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 10:46:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D16D82086D
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 10:46:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XQbez7cM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729671AbfKAKqC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 06:46:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52133 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728293AbfKAKqC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 06:46:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572605160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g3CstVfKS/R53xJq1ADgby1thFJlKRzIMnNklfsUwrA=;
        b=XQbez7cMXm8sOxHVMQSkE++VqCv3MgnKpU6rmoXhqeaW/aRlS1GRGPFEtIluE0K4TWIp2/
        e+YlXsZ2JPWPvCnmMB0gfWflJauXDUwTVIdn9ELqvdjhc/YOy23k+Uebw8tjJv0SnW3TOR
        V+kX7ZiFumXzbTXAKjb5t1ob0wdgwyU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-jNvYGXlDNsWQ013yA8mYjw-1; Fri, 01 Nov 2019 06:45:54 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D658C107ACC0;
        Fri,  1 Nov 2019 10:45:53 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 80588166B8;
        Fri,  1 Nov 2019 10:45:53 +0000 (UTC)
Date:   Fri, 1 Nov 2019 06:45:51 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Emmanuel Florac <eflorac@intellique.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: xfs_repair keeps reporting errors
Message-ID: <20191101104551.GB59146@bfoster>
References: <20191031154049.166549a3@harpe.intellique.com>
MIME-Version: 1.0
In-Reply-To: <20191031154049.166549a3@harpe.intellique.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: jNvYGXlDNsWQ013yA8mYjw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 31, 2019 at 03:40:49PM +0100, Emmanuel Florac wrote:
> Hi,
>=20
> I just had a problem with a RAID array, now that the rebuild process
> is complete, as I run xfs_repair (v 5.0) again and again it keeps
> reporting problems (here running xfs_repair for the 3rd time in a row):
>=20

Problems with the same inodes or the same general issue with different
inodes after repeated repair runs?

What kind of RAID event was involved? Was the filesystem known healthy
prior to the event?

>=20
> bad CRC for inode 861144976062
> bad magic number 0x0 on inode 861144976062
> bad magic number 0x0 on inode 217316006460
> bad version number 0x0 on inode 217316006460
> inode identifier 0 mismatch on inode 217316006460
> bad version number 0x0 on inode 861144976062
> bad CRC for inode 217316006461
> bad magic number 0x0 on inode 217316006461
> inode identifier 0 mismatch on inode 861144976062
> bad version number 0x0 on inode 217316006461
> inode identifier 0 mismatch on inode 217316006461
> bad CRC for inode 217316006462
> bad magic number 0x0 on inode 217316006462
> bad CRC for inode 861144976063
> bad magic number 0x0 on inode 861144976063
> bad version number 0x0 on inode 861144976063
> bad version number 0x0 on inode 217316006462
> inode identifier 0 mismatch on inode 217316006462
> bad CRC for inode 217316006463
> bad magic number 0x0 on inode 217316006463
> inode identifier 0 mismatch on inode 861144976063
> bad version number 0x0 on inode 217316006463
> inode identifier 0 mismatch on inode 217316006463
>=20
> Is there anything else to do?
>=20

I think it's hard to say what might be going on here without some view
into the state of the fs. Perhaps some large chunk of the fs has been
zeroed given all of the zeroed out on-disk inode fields? We'd probably
want to see a metadump of the fs to get a closer look.

Brian

> --=20
> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                     |   Intellique
>                     |=09<eflorac@intellique.com>
>                     |   +33 1 78 94 84 02
> ------------------------------------------------------------------------


