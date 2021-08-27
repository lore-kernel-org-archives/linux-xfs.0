Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0B21C432BE
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Aug 2021 15:39:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A155461002
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Aug 2021 15:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234197AbhH0PkN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Aug 2021 11:40:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21660 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233461AbhH0PkN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Aug 2021 11:40:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630078763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=T8Gr+eC3u/vOBsEw4I/S3NgF/STUmHTk28HgNxOY/kg=;
        b=OROcWOyLh7P2gjsqvBjO/7nUY5zuA6UC13gSfLnZZYjEjCmGRV03p/VWD6LBPxkVriPDOC
        vSqMc0K0dt6UJzCVhQzoTH7OScmZkGM2KeYs00OS/KNpMHzDygWnm5nYmk1JPcRYxXWikl
        IK8EKAlkbVS8Cc+mf4d0YHiMLoD7acc=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-9EoQA0YyPWGgU-ks2q2DAA-1; Fri, 27 Aug 2021 11:39:20 -0400
X-MC-Unique: 9EoQA0YyPWGgU-ks2q2DAA-1
Received: by mail-il1-f200.google.com with SMTP id c4-20020a056e020cc4b02902242bd90889so4408372ilj.20
        for <linux-xfs@vger.kernel.org>; Fri, 27 Aug 2021 08:39:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=T8Gr+eC3u/vOBsEw4I/S3NgF/STUmHTk28HgNxOY/kg=;
        b=nMOISGvYqlcJTnUkRLPRixk2XgBISus9zYSUqIcqDEV/ZdJXGTAD7AiymPCyOFDpen
         PJ3NpzD2HkXX9jmPh0EgvpoSbE/DwxANiqrqdvNU2MD3Nzbq2W3GtXRN4aAu+lbwH9E4
         HCBw98lggjYLOD8RgrruNE5zFsW34mU6SZJUsuN3HIe9OQC+Lj/nTL8PLs7Uok+cDTVF
         FMD7PiTl+EmkgX/KSPGiFhOsazwJl1/jfJOz2RC2UVdcSQfTFz1EXw9HmrBVBvf2QPX2
         G+xGX+yAkTIee5nj2gAvVR7F1xOXC6346e+M70NH+BRZOStcUtGzq9tMRUDWheyZXvT3
         mAXw==
X-Gm-Message-State: AOAM532dVbORID/AcTJ1Ty0Veblv9SaNekhknAtkapWpizSHudbTa+Vs
        hElevSHBlHlH8vaTlBe6kWbgl2sM/5pzWAnsxWTNo84Htow34oqlYCYHtNZLdR1jz/iUoYkh7Dh
        qhAQZEmREvnaH06OyxqU9
X-Received: by 2002:a92:c90a:: with SMTP id t10mr7258812ilp.188.1630078759470;
        Fri, 27 Aug 2021 08:39:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5XVSyoK30zJCxEmTzA9kbzjeDcsOqKqi+sZ+DpbtjYizYQNwL1vtH5Pxk/TlAZkjj2e5EUw==
X-Received: by 2002:a92:c90a:: with SMTP id t10mr7258796ilp.188.1630078759215;
        Fri, 27 Aug 2021 08:39:19 -0700 (PDT)
Received: from liberator.sandeen.net (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id r16sm320355ile.66.2021.08.27.08.39.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 08:39:18 -0700 (PDT)
From:   Eric Sandeen <esandeen@redhat.com>
X-Google-Original-From: Eric Sandeen <sandeen@redhat.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] mkfs.xfs.8: clarify DAX-vs-reflink restrictions in the
 mkfs.xfs man page
Cc:     Bill O'Donnell <bodonnel@redhat.com>
Message-ID: <59ebcf23-9e32-e219-ef8b-9aa7ab2444c2@redhat.com>
Date:   Fri, 27 Aug 2021 10:39:18 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Now that we have the tristate dax mount options, it is possible
to enable DAX mode for non-reflinked files on a reflink-capable
filesystem.  Clarify this in the mkfs.xfs manpage.

Reported-by: Bill O'Donnell <bodonnel@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index a7f70285..84ac50e8 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -316,12 +316,20 @@ option set. When the option
  is used, the reference count btree feature is not supported and reflink is
  disabled.
  .IP
-Note: the filesystem DAX mount option (
+Note: the filesystem-wide DAX mount options (
  .B \-o dax
-) is incompatible with
-reflink-enabled XFS filesystems.  To use filesystem DAX with XFS, specify the
+and
+.B \-o dax=always
+) are incompatible with
+reflink-enabled XFS filesystems.  To use filesystem-wide DAX with XFS, specify the
  .B \-m reflink=0
  option to mkfs.xfs to disable the reflink feature.
+Alternatey, use the
+.B \-o dax=inode
+mount option to selectively enable DAX mode on non-reflinked files.
+See
+.BR xfs (5)
+for more information.
  .RE
  .PP
  .PD 0

