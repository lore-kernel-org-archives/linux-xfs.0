Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2505DC433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 16:20:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA063206FA
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 16:20:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ceALvEGB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgHZQUG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 12:20:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35820 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726995AbgHZQUF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 12:20:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598458804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dMp4EyAH61CAx8MFvykIUs0GXkZGL9jFa6kU3sdcKJE=;
        b=ceALvEGBum4OtsHw/D7XNecc6yd8tya+Q0zasg6NSWnTFydN+0lcVqbCVJa52MNbyoofsE
        NjETIeEOAx5SObJAnFNCz9kX4U/iz/VGc0rx1qgvZ2iEMaNHaoq0M9ELduINDdNIJHV+xC
        S0kq0Gg5Hfz8q/iLYvhXtD0AqDbHTfk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-97R9C8RhPXKzN9OUEjSuTQ-1; Wed, 26 Aug 2020 12:19:55 -0400
X-MC-Unique: 97R9C8RhPXKzN9OUEjSuTQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBB181902EA1
        for <linux-xfs@vger.kernel.org>; Wed, 26 Aug 2020 16:19:54 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A3EA919C78
        for <linux-xfs@vger.kernel.org>; Wed, 26 Aug 2020 16:19:54 +0000 (UTC)
Subject: [PATCH V2] xfs: fix boundary test in xfs_attr_shortform_verify
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs@vger.kernel.org
References: <63722af5-2d8d-2455-17ee-988defd3126f@redhat.com>
Message-ID: <689c4eda-dd80-c1bd-843f-1b485bfddc5a@redhat.com>
Date:   Wed, 26 Aug 2020 11:19:54 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <63722af5-2d8d-2455-17ee-988defd3126f@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The boundary test for the fixed-offset parts of xfs_attr_sf_entry in
xfs_attr_shortform_verify is off by one, because the variable array
at the end is defined as nameval[1] not nameval[].
Hence we need to subtract 1 from the calculation.

This can be shown by:

# touch file
# setfattr -n root.a file

and verifications will fail when it's written to disk.

This only matters for a last attribute which has a single-byte name
and no value, otherwise the combination of namelen & valuelen will
push endp further out and this test won't fail.

Fixes: 1e1bbd8e7ee06 ("xfs: create structure verifier function for shortform xattrs")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Add whitespace and comments, tweak commit log.

Note: as Darrick points out, this should be made consistent w/ the dir2 arrays
by making the nameval variable size array [] not [1], and then we can lose all
the -1 magic sprinkled around.  At that time we should probably also make the
macros into proper functions, as was done for dir2.

For now, this is just the least invasive fixup for the problem at hand.

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 8623c815164a..383b08f2ac61 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1036,8 +1036,10 @@ xfs_attr_shortform_verify(
 		 * struct xfs_attr_sf_entry has a variable length.
 		 * Check the fixed-offset parts of the structure are
 		 * within the data buffer.
+		 * xfs_attr_sf_entry is defined with a 1-byte variable
+		 * array at the end, so we must subtract that off.
 		 */
-		if (((char *)sfep + sizeof(*sfep)) >= endp)
+		if (((char *)sfep + sizeof(*sfep) - 1) >= endp)
 			return __this_address;
 
 		/* Don't allow names with known bad length. */

