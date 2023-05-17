Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81DC8C7EE24
	for <linux-xfs@archiver.kernel.org>; Wed, 17 May 2023 00:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjEQAFD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 May 2023 20:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbjEQAFB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 May 2023 20:05:01 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F76855A6
        for <linux-xfs@vger.kernel.org>; Tue, 16 May 2023 17:04:58 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 41be03b00d2f7-5144a9c11c7so35665a12.2
        for <linux-xfs@vger.kernel.org>; Tue, 16 May 2023 17:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1684281897; x=1686873897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cGRPXriTHoruV5u7Fe4fLt3NBFa/8AVPi5tbP43yaAg=;
        b=2oPHvI+IcHO4NigNaoVBKWQrk7gjcRyNrVOq/+GMuUkKQjM34wZy8TRyQomIAq1oql
         tP1Q95f0AI4ADGzLuSbbx/vH6kiAKA4L7nRtUc89/LzruK92MNwy17VF+9di6tuGOMMa
         P0bU0Zxa2io3eZtN+kAATMhkJod7dCA29n5IqgsPckvkW7yBTsSW5C3uy31lyVDyE1tq
         2QfpwGmETe+UwAtkLp3ORdBN4k8WUFgbC/2egKdVYf1/yPGTSCAEmoIiRsx1+cvRNr7Z
         vqBpO2nbRNIuvVSYv7e25uC76FH2dhO7lWeYQqevn6wDStDpZT0f9rCMVOAl0i4H+X1g
         L7vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684281897; x=1686873897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cGRPXriTHoruV5u7Fe4fLt3NBFa/8AVPi5tbP43yaAg=;
        b=WCIxK4hDAF9VGwmik8Ge78Ea13Z2EYlYngAbNOybzUZhiSXW6KTTp2kVM2hWBJ7bII
         LG/P65QzYNY08fNstHkOnuhPqjwTfQ/KCj4gX3d0mS4S9AuIgFRIicxQRx110eVdoKpM
         kigQgSTMEITjcIZxBXleyC6HrehOJUlOA4x0ZYNnjM7v66iLjGPWNiwB5/B4V3+vRnbp
         giEpZP5dUq/xrsDuJZ3vhO2kjbfW5iUzELTWMDFHx9fjDfD5byTl8MsVNqaKAVx40fg2
         ZKo4oDsT2B1x1XLojf6DiGH07skrqmQSnHg1cwbUWB1AiryCp8sPXJPLKgFX3qM9Nvf6
         /eEQ==
X-Gm-Message-State: AC+VfDzXN1DxDWXDqTfbnn4Rf10Du9N2rZ7NBQty+2BV+IerH92bHcLp
        gEiSHzKuVi5JNz/becBlyml0V1+MT5D+lh/9woA=
X-Google-Smtp-Source: ACHHUZ43PFAMbu0Bq8no1xCstjuKdYGQYNNY8imc/6ZPlL7zdjGiowQey5aRcMkp8wHtJOkBkTn5Ug==
X-Received: by 2002:a05:6a20:394a:b0:101:9344:bf89 with SMTP id r10-20020a056a20394a00b001019344bf89mr33981824pzg.49.1684281897608;
        Tue, 16 May 2023 17:04:57 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id n32-20020a635920000000b0053051d50a48sm12638507pgb.79.2023.05.16.17.04.55
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 17:04:56 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1pz4ez-000Lbv-0D
        for linux-xfs@vger.kernel.org;
        Wed, 17 May 2023 10:04:52 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pz4ey-00Gu8D-1p
        for linux-xfs@vger.kernel.org;
        Wed, 17 May 2023 10:04:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] xfs: defered work could create precommits
Date:   Wed, 17 May 2023 10:04:48 +1000
Message-Id: <20230517000449.3997582-4-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230517000449.3997582-1-david@fromorbit.com>
References: <20230517000449.3997582-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To fix a AGI-AGF-inode cluster buffer deadlock, we need to move
inode cluster buffer oeprations to the ->iop_precommit() method.
However, this means that deferred operations can require precommits
to be run on the final transaction that the deferred ops pass back
to xfs_trans_commit() context. This will be exposed by attribute
handling, in that the last changes to the inode in the attr set
state machine "disappear" because the precommit operation is not run.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 8afc0c080861..664084509af5 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -970,6 +970,11 @@ __xfs_trans_commit(
 		error = xfs_defer_finish_noroll(&tp);
 		if (error)
 			goto out_unreserve;
+
+		/* Run precomits from final tx in defer chain */
+		error = xfs_trans_run_precommits(tp);
+		if (error)
+			goto out_unreserve;
 	}
 
 	/*
-- 
2.40.1

