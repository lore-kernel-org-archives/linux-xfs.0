Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D073AE92FE0
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Oct 2023 18:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233318AbjJFSx6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 14:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233291AbjJFSxy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2023 14:53:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6575AD6
        for <linux-xfs@vger.kernel.org>; Fri,  6 Oct 2023 11:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696618345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g1rGIaFOcgzEDtbNfKOICnouTJvfDrh5OEfl1tH6mXc=;
        b=SPYklz2aqNHLcWMfSrv4w7F7UPuLUWWM7TnkUkjwxYIRN8Y6Iwtq4oghk3nHdE9A2yflb1
        rmT4jFxWndXPCm0H2mbK0koShjcJdX2cJUXw9B3bHsu4sz4lsz4YCan612c7hZqtjA3mHG
        TeQQn7cfPRJgJVRkhqAivfVNLeLQjc4=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-stbjjSpqMhWa1BKVWD_i8w-1; Fri, 06 Oct 2023 14:52:24 -0400
X-MC-Unique: stbjjSpqMhWa1BKVWD_i8w-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-9ae70250ef5so395938266b.0
        for <linux-xfs@vger.kernel.org>; Fri, 06 Oct 2023 11:52:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696618343; x=1697223143;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g1rGIaFOcgzEDtbNfKOICnouTJvfDrh5OEfl1tH6mXc=;
        b=S9TFLOxtbJva2px20JBrXMk1PxIJ2GAO0BqgwSPXzpg18M52rqBxOZaAElkL0zVQ4j
         RQYjZIYIS8MDLM2SlJwymW7ZNJt3vdXWL7pznFs/9mMjblncmQbfT4Kr++lROH3L8qEW
         HtejAbBxjbllXC656HNKXGeM0dXogg38EZqm9/nTyYVrMhNk5eCtIxXB6AqrYnSOo6EW
         Ngj1gUy6swhqaIR7w+uU+4kxjeuJvX0ipMN+IzQ+sSp5iyOpZbNo/K5r2TmDMNClWTxD
         uyY4NOKfnnR5kixR+irM/fMRymQ9Wvi8vQtk/neLp/+8Iowbgqw/dbJgJQSWj1X6gyeY
         qj0A==
X-Gm-Message-State: AOJu0YzDOKMsKsSa8aKnpfaAbhnNlrowgozhUFlbzO+B8hBQWrTjj8gG
        YbqvGrcK9LTlEYb4dg8VoL53Ih42ypwnthO/a+z4KkoJI+s04nmrtLYfhodJxGU6Xa6RE3oPHbY
        ER7AGWILXlnImx7IPtdHuyfMPISUXQA5usKUSM/q69HAM4oQP2j4oz9mlC5mcnTfTBaT8bJPSa9
        sjK9Y=
X-Received: by 2002:a17:907:9491:b0:9a5:962c:cb6c with SMTP id dm17-20020a170907949100b009a5962ccb6cmr5175905ejc.31.1696618343005;
        Fri, 06 Oct 2023 11:52:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH17nmROYKxmyjF7xwhLbMraoHotdEHwmzzX8X0FXNpicq6vdW0N2QZENxJT12qGNrH88Nkhg==
X-Received: by 2002:a17:907:9491:b0:9a5:962c:cb6c with SMTP id dm17-20020a170907949100b009a5962ccb6cmr5175890ejc.31.1696618342685;
        Fri, 06 Oct 2023 11:52:22 -0700 (PDT)
Received: from localhost.localdomain ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id os5-20020a170906af6500b009b947f81c4asm3304741ejb.155.2023.10.06.11.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 11:52:22 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev
Cc:     djwong@kernel.org, ebiggers@kernel.org, david@fromorbit.com,
        dchinner@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v3 05/28] fs: add FS_XFLAG_VERITY for fs-verity sealed inodes
Date:   Fri,  6 Oct 2023 20:48:59 +0200
Message-Id: <20231006184922.252188-6-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231006184922.252188-1-aalbersh@redhat.com>
References: <20231006184922.252188-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add extended file attribute FS_XFLAG_VERITY for inodes sealed with
fs-verity.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 Documentation/filesystems/fsverity.rst | 9 +++++++++
 include/uapi/linux/fs.h                | 1 +
 2 files changed, 10 insertions(+)

diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
index 13e4b18e5dbb..af889512c6ac 100644
--- a/Documentation/filesystems/fsverity.rst
+++ b/Documentation/filesystems/fsverity.rst
@@ -326,6 +326,15 @@ the file has fs-verity enabled.  This can perform better than
 FS_IOC_GETFLAGS and FS_IOC_MEASURE_VERITY because it doesn't require
 opening the file, and opening verity files can be expensive.
 
+Extended file attributes
+------------------------
+
+For fs-verity sealed files the FS_XFLAG_VERITY extended file
+attribute is set. The attribute can be observed via lsattr.
+
+    [root@vm:~]# lsattr /mnt/test/foo
+    --------------------V- /mnt/test/foo
+
 .. _accessing_verity_files:
 
 Accessing verity files
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index b7b56871029c..5172a2eb902c 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -140,6 +140,7 @@ struct fsxattr {
 #define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
 #define FS_XFLAG_DAX		0x00008000	/* use DAX for IO */
 #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
+#define FS_XFLAG_VERITY		0x00020000	/* fs-verity sealed inode */
 #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
 
 /* the read-only stuff doesn't really belong here, but any other place is
-- 
2.40.1

