Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NO_RDNS_DOTCOM_HELO,RCVD_FAKE_HELO_DOTCOM,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C367C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 15:34:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A7F161944
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 15:34:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhCSPeD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Mar 2021 11:34:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60599 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230272AbhCSPd6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Mar 2021 11:33:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616168038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HrI03RYjUkbaS6FPXiWzMNdZzvk2lFYMVmwPiGjsIaA=;
        b=TTWSIBuPaj6rexWTfkV2fWcrRKRsmFThMy+JDm+11Y3By/yT8gbyDwlsj6w4hFEThew+Nr
        HfamO68K2d8FpS8/k32D7AGTaDpgPUmO61D5k1mXtjtfDCuw3ebDQ97TnTWNNKeXiv8tPe
        8kmw9+UDgc18ie/EspMzOwgCn0n/jjU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-FLIaF923MxaCTAR2W1I6iQ-1; Fri, 19 Mar 2021 11:33:56 -0400
X-MC-Unique: FLIaF923MxaCTAR2W1I6iQ-1
Received: by mail-wr1-f72.google.com with SMTP id h5so21937028wrr.17
        for <linux-xfs@vger.kernel.org>; Fri, 19 Mar 2021 08:33:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HrI03RYjUkbaS6FPXiWzMNdZzvk2lFYMVmwPiGjsIaA=;
        b=U8SdR/6YtKa/9F5USmT0wAg6k7o1vdk5GYqt1Cphtk2njWAL9FIpjau1VNynxSFNjF
         EVaM8nPclElWZ1YZO2F6u6RJxBTKCC8+6X72xinOTVolOL12RP4p1VWLXtDhLiRbYbds
         bhHO8BWhrXO3CO+BTztHuOSCodbg2fRRtNRKG5CSOrz3fQqNH1s/Nk9AazoKngMQmKMq
         xeCvWMBDQoxb1nMaZxb6s9KzMszX9fLCfcPYwEKiDFaG1yYB9+YduIgsi+RdvLL5Cgfm
         Wcx8GYvJ6mcEvISIo4H51FLuW4eHi2x0o+ShkWYJkWbV4XezCSNUxcXp74WiS+EY5CXw
         9UGw==
X-Gm-Message-State: AOAM532ORZj3Xqj72QPBuGvK/7RcoeQx8NJYG0pori7D9YMm+QRlGt/T
        cAVmd6otIjG/pkPxaMfPAUqnQMkpvdJYIQklYJHhskoZNts41+63EP2trskRNEZC6RBfMNz0F1I
        SYw6Ws8lo5/sN38loPkMaYqK6AtcIRTrlK0ID20oris8+TojDh1fWBPU3Nzh5/s2AucOKlgw=
X-Received: by 2002:a1c:a916:: with SMTP id s22mr4411997wme.82.1616168034936;
        Fri, 19 Mar 2021 08:33:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3p5z/2+AvJyQFAQ+cgh3/Mb8+RnSomw7mLXwzbklUZdDtDBHNSUWz2T2/cb7V9fI1FErP+w==
X-Received: by 2002:a1c:a916:: with SMTP id s22mr4411984wme.82.1616168034716;
        Fri, 19 Mar 2021 08:33:54 -0700 (PDT)
Received: from localhost.com ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id g9sm8842791wrp.14.2021.03.19.08.33.54
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 08:33:54 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 0/2] xfs: Skip repetitive warnings about mount options
Date:   Fri, 19 Mar 2021 16:32:49 +0100
Message-Id: <20210319153251.476606-1-preichl@redhat.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

I belive that this patch set was missed in recent for-next branch update.

Patches are the same as before I just added the reviewed-by tags.

Thanks!

...
At least some version of mount will look in /proc/mounts and send in all of the 
options that it finds as part of a remount command. We also /do/ still emit
"attr2" in /proc/mounts (as we probably should), so remount passes that back
in, and we emit a warning, which is not great.

In other words mount passes in "attr2" and the kernel emits a deprecation
warning for attr2, even though the user/admin never explicitly asked for the
option.

So, lets skip the warning if (we are remounting && deprecated option
state is not changing).

I also attached test for xfstests that I used for testing (the test
will be proposed on xfstests-list after/if this patch is merged).

V2 vs. V1

* Added new patch that renames mp to parsing_mp in xfs_fs_parse_param()
* Added new function xfs_fs_warn_deprecated() to encapsulate the logic for displaying the deprecation warning.
* Fixed some white space issues.

Pavel Reichl (2):
  xfs: rename variable mp to parsing_mp
  xfs: Skip repetitive warnings about mount options

 fs/xfs/xfs_super.c | 118 +++++++++++++++++++++++++--------------------
 1 file changed, 67 insertions(+), 51 deletions(-)

-- 
2.30.2

