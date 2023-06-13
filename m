Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF96C7EE2E
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Jun 2023 03:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbjFMDoY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 23:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbjFMDoX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jun 2023 23:44:23 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7A9DF
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 20:44:22 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1b3d29cfb17so14430425ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 20:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686627862; x=1689219862;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0SBh+dCslY6ZxD3FjUT0cO8djtHsktMWLw8bVBoQUu8=;
        b=qhoIhY3c8lIAF4tw//D2wWPLEb4aWawFFft8nsyljzua/2Z6JvWDRaq1P1hz/AJt0h
         KwuK1TUIbt2LwTg3taCyVKUffdsShgFTdaoD8oBfJ9GF9b8KOR01A0Br7lMkH9cnUtfz
         CyPDJ/cIj+S8Nvolh+si7v53e8ctHG0HFE4x+3PTx6MWRWv55o9lHiU1eLNfzKhyaLa5
         uWOTn86MG9NvzUh3zZHx+fzn8mtjPDIn0BFkumweNY0RnYxeULpSnWpFuh9s/TGtHhs9
         ETysRlgOA9Nquv8P88m8s2Zj3Hv1AbZAx82vtEjuSUz8HeM1hqTVt/3JDEL//lzw1oWG
         8U1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686627862; x=1689219862;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0SBh+dCslY6ZxD3FjUT0cO8djtHsktMWLw8bVBoQUu8=;
        b=XCeh4VnL8qAKaPN8eUjVYbXVn2c/9JQhCIj1UC9HJKSxetph4TcVfizscRojTtWx4a
         Tko1sCmRjDIZ5EyQDzKdbBPQXg2kpFO8k/+jyachcH4yfqvB0m1MakQAMnFp/vLFPQpq
         01iOhf/rNG7kpry4oi09eGj/8cLoHiKHyswXjvTolP79pqMQMf87fyMsuK+xPhlc6IdV
         I+LdHxLCQ7zJePYdZnLCCHMg4wMUiE2KtJTmsf/CWZbrSNjQeYbKN8l5DrwdOQDDDV2y
         4jo56TB13E9vL4wivxpAWM8TVjGv5CZDXYQAZzvl9kfzpyghqh1mWjnk4nEWD8UnxB/z
         ReYw==
X-Gm-Message-State: AC+VfDyVYxKLuCnFnZxy1pXPMQ69benL8/1a03tJUVDCJ8M0sJnMrAo5
        /Z+azz3xK5B6aW8swDiEEfSeoQ==
X-Google-Smtp-Source: ACHHUZ63/vLEkBPTo80jRzJD9vK2TJ3/HvyEv3RTiusy6j5kbTqPl08SBDXPQorKCyRFiiz/t6vyww==
X-Received: by 2002:a17:903:124d:b0:1ac:aba5:7885 with SMTP id u13-20020a170903124d00b001acaba57885mr10141233plh.47.1686627861818;
        Mon, 12 Jun 2023 20:44:21 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-79-151.pa.nsw.optusnet.com.au. [49.179.79.151])
        by smtp.gmail.com with ESMTPSA id i5-20020a170902eb4500b001acacff3a70sm5172520pli.125.2023.06.12.20.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 20:44:21 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q8ux8-00B8EV-2g;
        Tue, 13 Jun 2023 13:44:18 +1000
Date:   Tue, 13 Jun 2023 13:44:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Zhang Yi <yi.zhang@huaweicloud.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org, dchinner@redhat.com,
        yi.zhang@huawei.com, leo.lilong@huawei.com, yukuai3@huawei.com
Subject: Re: [PATCH 0/2] xfs: fix an inconsistency issue
Message-ID: <ZIfmEtB5ibbYsIZ8@dread.disaster.area>
References: <20230613030434.2944173-1-yi.zhang@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613030434.2944173-1-yi.zhang@huaweicloud.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 13, 2023 at 11:04:32AM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> This patch set fix a xattr inconsistency issue which lead to clean
> iunlinks failure.

So many questions, so few answers....

What inconsistency?

What's the signature of the failure that occurs?

What is the real world impact of the issue?

How do we reproduce it?

How did you test the fix?

After reading the cover letter for a patch series, I should know
the answers to all these questions (and more).

-Dave.
-- 
Dave Chinner
david@fromorbit.com
