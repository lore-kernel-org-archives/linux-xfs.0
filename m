Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 694ECC2D0A8
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 22:37:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 047BD23600
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 22:37:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bm7e49tw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgIWWho (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 18:37:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44305 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726199AbgIWWho (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 18:37:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600900663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RSv82tAKb98m5gBauyU9NGj+xfHb2xJ09JEh4qiIRwk=;
        b=Bm7e49twPCxUuqYraPmFHvpTpIeQ7ljofj1rYZW4Gijc1wdk8U1uezEQTuNeCATcWB6WgD
        OxvjmvPKjwSc2rIq32UTLH1Qlgjxz+X6CA03aBCAhYrf2hf2kMXPfmPJJRyBApRlRZs7vG
        8yTUZUyNsy/ClHmitnWvcYzdhgYODPw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-lt-1VtjwMcu7nXyxidsP_Q-1; Wed, 23 Sep 2020 18:37:41 -0400
X-MC-Unique: lt-1VtjwMcu7nXyxidsP_Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32566186DD2C;
        Wed, 23 Sep 2020 22:37:40 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B4E9B73682;
        Wed, 23 Sep 2020 22:37:39 +0000 (UTC)
Subject: Re: [PATCH STABLE] xfs: trim IO to found COW exent limit
From:   Eric Sandeen <sandeen@redhat.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <e7fe7225-4f2b-d13e-bb4b-c7db68f63124@redhat.com>
Message-ID: <34c164fb-d616-1467-c96a-77c99e436421@redhat.com>
Date:   Wed, 23 Sep 2020 17:37:39 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <e7fe7225-4f2b-d13e-bb4b-c7db68f63124@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Here's a reproducer for the bug.

Requires sufficient privs to mount a loopback fs.

======

#!/bin/bash

mkdir -p mnt
umount mnt &>/dev/null

# Create 8g fs image
mkfs.xfs -f -dfile,name=fsfile.img,size=8g &>/dev/null
mount -o loop fsfile.img mnt

# Make all files w/ 1m hints; create original 2m file
xfs_io -c "extsize 1048576" mnt
xfs_io -c "cowextsize 1048576" mnt

echo "Create file mnt/b"
xfs_io -f -c "pwrite -S 0x0 0 2m" -c fsync mnt/b &>/dev/null

# Make a reflinked copy
echo "Reflink copy from mnt/b to mnt/a"
cp --reflink=always mnt/b mnt/a

echo "Contents of mnt/b"
hexdump -C mnt/b

# Cycle mount to get stuff out of cache
umount mnt
mount -o loop fsfile.img mnt

# Create a 1m-hinted IO at offset 0, then
# do another IO that overlaps but extends past the 1m hint
echo "Write to mnt/a"
xfs_io -c "pwrite -S 0xa 0k -b 4k 4k" \
       -c "pwrite -S 0xa 4k -b 1m 1m" \
       mnt/a &>/dev/null

xfs_io -c fsync mnt/a

echo "Contents of mnt/b now:"
hexdump -C mnt/b

umount mnt

