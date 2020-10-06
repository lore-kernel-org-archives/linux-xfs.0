Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D997C4363D
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 14:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C58602078E
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 14:22:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="evRNOKOf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgJFOWi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 10:22:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30565 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725947AbgJFOWi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 10:22:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601994157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=WkEFBinxnr8CX8hdXOd+EI1pXc3lgvNXkf9x3eFKRo8=;
        b=evRNOKOf020EzjlEG/RDjn5febsutcJmHlsklZCUREba1GuuMa0S6pe1eiC2qsE12GX591
        pDlQ8T8B0tPauSa5tbqXaL6UooY1FOa1DXKhqGosPPlqiNMVsuP2A5pZdz/3++tWP/z2nM
        fnIQ1My0tH7M5FlOzmKpXVUVLg9viS0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-ZrwmgZSjPiSgCSUXunlvZQ-1; Tue, 06 Oct 2020 10:22:35 -0400
X-MC-Unique: ZrwmgZSjPiSgCSUXunlvZQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A362C802EDA;
        Tue,  6 Oct 2020 14:22:34 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2B34210001B3;
        Tue,  6 Oct 2020 14:22:34 +0000 (UTC)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfsprogs: fix ioctl_xfs_geometry manpage naming
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>
Message-ID: <e0379d8e-ada3-0ca7-18f8-511114d6af52@redhat.com>
Date:   Tue, 6 Oct 2020 09:22:33 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Somehow "fsop_/FSOP_" snuck into this manpage's name, filename, and
ioctl name.  It's not XFS_IOC_FSOP_GEOMETRY, it's XFS_IOC_FSGEOMETRY
so change all references, including the man page name, filename, and
references from xfsctl(3).

(the structure and flags do have the fsop_ string, which certainly
makes this a bit confusing)

Fixes: b427c816847e ("man: create a separate GEOMETRY ioctl manpage")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Note the file rename below

Do we need to install symlink from the old name or can we just wing this one
and let "apropos" et al find it ...


diff --git a/man/man2/ioctl_xfs_fsop_geometry.2 b/man/man2/ioctl_xfs_geometry.2
similarity index 95%
rename from man/man2/ioctl_xfs_fsop_geometry.2
rename to man/man2/ioctl_xfs_geometry.2
index a35bbaeb..d4fcef6d 100644
--- a/man/man2/ioctl_xfs_fsop_geometry.2
+++ b/man/man2/ioctl_xfs_geometry.2
@@ -3,18 +3,18 @@
 .\" %%%LICENSE_START(GPLv2+_DOC_FULL)
 .\" SPDX-License-Identifier: GPL-2.0+
 .\" %%%LICENSE_END
-.TH IOCTL-XFS-FSOP-GEOMETRY 2 2019-06-17 "XFS"
+.TH IOCTL-XFS-GEOMETRY 2 2019-06-17 "XFS"
 .SH NAME
-ioctl_xfs_fsop_geometry \- report XFS filesystem layout and features 
+ioctl_xfs_geometry \- report XFS filesystem layout and features
 .SH SYNOPSIS
 .br
 .B #include <xfs/xfs_fs.h>
 .PP
-.BI "int ioctl(int " fd ", XFS_IOC_FSOP_GEOMETRY, struct xfs_fsop_geom*" arg );
+.BI "int ioctl(int " fd ", XFS_IOC_FSGEOMETRY, struct xfs_fsop_geom *" arg );
 .br
-.BI "int ioctl(int " fd ", XFS_IOC_FSOP_GEOMETRY_V4, struct xfs_fsop_geom_v4 *" arg );
+.BI "int ioctl(int " fd ", XFS_IOC_FSGEOMETRY_V4, struct xfs_fsop_geom_v4 *" arg );
 .br
-.BI "int ioctl(int " fd ", XFS_IOC_FSOP_GEOMETRY_V1, struct xfs_fsop_geom_v1 *" arg );
+.BI "int ioctl(int " fd ", XFS_IOC_FSGEOMETRY_V1, struct xfs_fsop_geom_v1 *" arg );
 .SH DESCRIPTION
 Report the details of an XFS filesystem layout, features, and other descriptive items.
 This information is conveyed in a structure of the following form:
diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
index dfebd12d..d7635329 100644
--- a/man/man3/xfsctl.3
+++ b/man/man3/xfsctl.3
@@ -333,7 +333,7 @@ for more information.
 .TP
 .B XFS_IOC_FSGEOMETRY
 See
-.BR ioctl_xfs_fsop_geometry (2)
+.BR ioctl_xfs_geometry (2)
 for more information.
 
 .TP
@@ -393,7 +393,7 @@ as they are not of general use to applications.
 
 .SH SEE ALSO
 .BR ioctl_xfs_fsgetxattr (2),
-.BR ioctl_xfs_fsop_geometry (2),
+.BR ioctl_xfs_geometry (2),
 .BR ioctl_xfs_fsbulkstat (2),
 .BR ioctl_xfs_scrub_metadata (2),
 .BR ioctl_xfs_fsinumbers (2),

