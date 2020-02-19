Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C5EC34047
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 13:57:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE80624670
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 13:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582120638;
	bh=ayrpZpIsm6GvE0VtmPlrJG36O5WNs/PCCRtsLoDtFAM=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=Soogdg+SejvvYvT2qgGuNzBcoUlx5DvoMZsObjkGsDVidQ7Unq0Cjxa46HqduWZac
	 yMbxerymkaqWwgQFN1f0XrM7WA5+yfxtd7lVCsrQn5YZSmzvTDzYuLUk/HvYC7FZEv
	 i6bCIFriLnrr4ri0VSaH8sMw5V53VTff8rhOZeZ0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgBSN5S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 08:57:18 -0500
Received: from mail-pl1-f173.google.com ([209.85.214.173]:45084 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgBSN5S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 08:57:18 -0500
Received: by mail-pl1-f173.google.com with SMTP id b22so99813pls.12
        for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2020 05:57:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=vdEY4pdlpf2LTc5DQrrVh4SQuAyE2Qz4h7P/aiiLSLQ=;
        b=buB0Ly1yTTu5HtujF4E06zyRmFVZqg+D1rtaATHEsh8ani8KwHzsU1KLt59QB5LtV/
         B3XA8yGIyHqEzd8wSTBDIK+IMgH5sFoETeD9YxqR9OWc8rKWw6RlGbZyZE3XrBtgNWqk
         km+r/EtPmL24GE7ACrYnu26C4FUtBBV/kk63aGwijefuJKVTX7Weie1YiifsTnOXqnMz
         JY9Lip+OA2tC2K9Wm7xq3BmXHv1Bq2WQ4JEEvFaWTgZH6gcORpKAICfsVO7gnScgZaWT
         LeuAnfdFCjZWUKxIY4L3PxfrCalhqHzqtIVKWDFCbrC06SVM5k32DyrtBQDh9fub8/EC
         rMhQ==
X-Gm-Message-State: APjAAAVWe81xd3cOEbB0s/Z+iH3w164LfVhHlndPHCrhC4waTaKTRUAn
        A0020EIMz9zRtyLi1LkXtPM=
X-Google-Smtp-Source: APXvYqw9OnnpjvGO/C5v4BiCwC12oAYSRj5ZqFlZJcmBHZzzPzA9RhvyvZ+HSAZGxHO344Q7Zm63+g==
X-Received: by 2002:a17:902:ba93:: with SMTP id k19mr26764897pls.197.1582120637348;
        Wed, 19 Feb 2020 05:57:17 -0800 (PST)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id a10sm2980481pgm.81.2020.02.19.05.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 05:57:16 -0800 (PST)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 58F49402D7; Wed, 19 Feb 2020 13:57:15 +0000 (UTC)
Date:   Wed, 19 Feb 2020 13:57:15 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Richard Wareing <rwareing@fb.com>
Cc:     linux-xfs@vger.kernel.org, Anthony Iliopoulos <ailiopoulos@suse.de>
Subject: Modern uses of CONFIG_XFS_RT
Message-ID: <20200219135715.GZ30113@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I hear some folks still use CONFIG_XFS_RT, I was curious what was the
actual modern typical use case for it. I thought this was somewhat
realted to DAX use but upon a quick code inspection I see direct
realtionship.

  Luis
