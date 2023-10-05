Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 916C3E92703
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Oct 2023 14:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbjJEOHo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Oct 2023 10:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbjJEOGC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2023 10:06:02 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8F19009
        for <linux-xfs@vger.kernel.org>; Thu,  5 Oct 2023 01:37:46 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-5859e22c7daso453881a12.1
        for <linux-xfs@vger.kernel.org>; Thu, 05 Oct 2023 01:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696495066; x=1697099866; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UpiAVB6r/jBjM5Kags6K1rUU0wk+w6beKM+yA8pSRYc=;
        b=hVEVH6dpuuVZlVPqmF77SFE+GS+evYs0EqgIjMKhYJwiafYjZZGCmdTl7Mg1UnD3/P
         DzhL9cFKtSwaxL4ewm835tE+u2M7nW7BGhCTbDrZ5PmXr3csldP0QWvPT+20rNSyUIvQ
         f7oV9fmT1Jl9T8yKbUlutkLG+5pv62J8WmwOmniav/M+TRBCrzohwDsuQ0AFo5cqqHHs
         rnHDnxQlh6ngFTCXnVi9kh6zcpLleTdErXk/XTq+DIdSsOvlPzmmOLTnLHnrmXCeC2z6
         TPD/UhPWnBqbUvLzGUEOyHEini6hwNwTtiQT6CkzWJUOa1ANcRmSL8iggdcU2gRsBUL6
         6mUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696495066; x=1697099866;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UpiAVB6r/jBjM5Kags6K1rUU0wk+w6beKM+yA8pSRYc=;
        b=aQuX6+2q/yERjq5OYR986hxoeR9yOHNCAFv3oqe8Tm4nURGZpYr9xTWyhpHzYudI4t
         4aF7XqSJoMXSsEOOKW1iGq7USaNXbW/jvUdMj/kPdpezenODYQ5itB0JOYojv82FM8jx
         I0215vLYf84AMS6w9M5tXeDsYpN0LSCbs7Al7FjR1dsRfFtK/INNw4ylyxCgFpCsTe7q
         L4Nz/Q7ZHOfkn9oJHQ/AXz1MJPWz/MydDbFA0CDd05Ywos9NPguSbzcU2fn9VPC4oSQk
         jR8SOjp1PLO0/OzBL7pD0YDWMiXIBA20KlIem7/pxZcZBwbecmM0G0VXHewBhpum3X1j
         h/Jw==
X-Gm-Message-State: AOJu0Ywhy2p3XUIxvjXzjV6fwBTVfBZYtv74uiOQLaJ5Dt+zMxLq0sCT
        ARCxlTddbTwaX61YnS8fcmOkfG1N+/yqRKC/sqboLFA15MQ=
X-Google-Smtp-Source: AGHT+IGwVAW73fEJJ0VwHXsxII35qwx17hkMje2JcF2AIcs7qmh7lYpPdMnUHtnFqYbuEjirWGh99gl3Cfe0tvmXMVI=
X-Received: by 2002:a17:90b:4f44:b0:26d:5cd0:979f with SMTP id
 pj4-20020a17090b4f4400b0026d5cd0979fmr4446071pjb.43.1696495065742; Thu, 05
 Oct 2023 01:37:45 -0700 (PDT)
MIME-Version: 1.0
From:   Daan De Meyer <daan.j.demeyer@gmail.com>
Date:   Thu, 5 Oct 2023 10:37:34 +0200
Message-ID: <CAO8sHc=UYg7SFh8DWYq6wRet2CW2P8tNr-pWRNJ2wN=+_qW17g@mail.gmail.com>
Subject: mkfs.xfs with --protofile does not copy extended attributes into the
 generated filesystem
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

It seems using --protofile ignores any extended attributes set on
source files. I would like to generate an XFS filesystem using
--protofile where extended attributes are copied from the source files
into the generated filesystem. Any way to make this happen with
--protofile?

Cheers,

Daan De Meyer
