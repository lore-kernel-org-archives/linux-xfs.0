Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66830C77B6F
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 23:23:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbjDKXXv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 19:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjDKXXt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 19:23:49 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5660030C7
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 16:23:48 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id y6so8382935plp.2
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 16:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1681255428;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=mRqYkrVHtizK9RyqpwuQ2xpLDUj7g7Bs19jHh7X7e9I=;
        b=RuZylLUeuvFqUHnJmMyfJHqLj0UpxO/6YJoo62aZpo5v9KprluLvubO8TSvCcsIOQa
         0ObqTAIZzESQ8ux23GzbUKSuYUyXeijWwNmnzfdR3M3yLHHT7oFJqopNtUAYpcOhzY4B
         SZ1eMV6/Q5ve3j8lq9kNlPOyiDZSBdKPI4dwS2USfOJK2QMcAsWThrjmi5LLB06s5nLq
         YOuBxILyyvcz+xj5+UygGdloeTfpL5BeOgqpD2N9LpZ7itgI5M9ijbEs6Y630Vt4NpGp
         soga90EacVIZBxFca6DUHFcHFVH8tdyv31meI6tLC6c0BS5XunhhVOWq64b++n/PB764
         9afw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681255428;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mRqYkrVHtizK9RyqpwuQ2xpLDUj7g7Bs19jHh7X7e9I=;
        b=5WO6nTulHN3gXmGPqNZhXTMeguiDlRHSY4S84eH44cBPtmyW2sLXJEfO/tz23ySQj+
         jputUDIIBRzFJZTqyc2cLdWlRBaPTYXxBCsryGIFC3QNt3YloJ6XDDsWvfrYhjN1OSuc
         tMHNCm09M89bDwwD4iEIvSTnc2Gnq9+pu0NX7ptGKwhMrM0MgfL0Pw3hdDdKI2bpkkFb
         pXHJ9dclTUPIJ0l0Q5mZsJMnWysYvUvLuZo6tcdujPsofXcbzd53+wXKtqx0nrqZetFk
         20LbE4/ZjW8aDou8NHN9BkKNEI2EOepXa2xCIMUmx5IBMf2msHks23pl5/UhwIHm3eWI
         /1Nw==
X-Gm-Message-State: AAQBX9ekvznvvQWV+2QQpTsjUVVLtAfpjc2hbiFpbWvGSHBKMMoKQYek
        JlP8rx3f6faf51+IRuY4A1JTK5N7n6Lo3BAxFLgykjBL
X-Google-Smtp-Source: AKy350a48jB2S1xbIOpqVygxnb00wwdnkn+ee4ZuMaYi2RH785c0e198jDrWw3K3uI7Tp+2DIg8kiQ==
X-Received: by 2002:a17:902:e392:b0:1a3:d5af:9b73 with SMTP id g18-20020a170902e39200b001a3d5af9b73mr3993448ple.58.1681255427886;
        Tue, 11 Apr 2023 16:23:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id l14-20020a63ea4e000000b004fab4455748sm9355314pgk.75.2023.04.11.16.23.47
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 16:23:47 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pmNKy-002H7i-9K
        for linux-xfs@vger.kernel.org; Wed, 12 Apr 2023 09:23:44 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pmNKy-000ykm-0g
        for linux-xfs@vger.kernel.org;
        Wed, 12 Apr 2023 09:23:44 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/2] xfs: a couple of syzbot fixes
Date:   Wed, 12 Apr 2023 09:23:40 +1000
Message-Id: <20230411232342.233433-1-david@fromorbit.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

Here are a couple of simple patches that reduce the syzbot noise
we've been getting. The superblock version verifier change is cc'd
for stable so that it gets back to stable kernels and distros
so they behave consistently with upstream w.r.t. future on-disk
format versions.

-Dave.


