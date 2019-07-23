Return-Path: <SRS0=q3sy=VU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FEFAC7618B
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jul 2019 14:52:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1BD0218EA
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jul 2019 14:52:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aukX6NjY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731109AbfGWOwL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Jul 2019 10:52:11 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43708 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729058AbfGWOwL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jul 2019 10:52:11 -0400
Received: by mail-wr1-f68.google.com with SMTP id p13so43484972wru.10;
        Tue, 23 Jul 2019 07:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kYSaq/H0a1K5O6GgVQzeldJnwoS+ik7bLUeJy2mAJ1A=;
        b=aukX6NjY5vGXcUMBB7dCljUvzTQzh3KCQ2SsVn4v4prgUDICht9MtYvmKH0taCJILB
         Qx7krhdvRr84zDCfJ0YoBYkHbyFxT9T7R+0390Ib53rvGYIVdAoU4ukd6T54zwDgFhXf
         kURlWc2HSpFdNz0eW+lDZ5c+PqgGo8CKmHpO5GL4TZGiyTql3rylP4hDxUWcObDdeeao
         /AG6a+NawBkABpAV71zqHa4SErX4S9AzbJWlObwK+3R4P3vn/p2zMIgDwHzdwi5tR2JY
         MCX3OIjhTDn5/sMtwm3fmWWZEu6J1nNF2JpNROAUXgRDGtxt789Kmc2H4lZTbCDqIf+E
         teIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kYSaq/H0a1K5O6GgVQzeldJnwoS+ik7bLUeJy2mAJ1A=;
        b=Ke+/BGvX+a+5W1Cd+PLjbvdoSP8DLclhYo+Zwc1aytp0EaiSbkt2Gp5yXf+CBeFyAs
         y/RUFv0d/hr44TIFD6clc6wn4rAqUn8m1PGpPSCDAfbRv2AIUumkAlYZM3il8gr2y9qb
         IqLoWbHuviv9DBXpwiAaAxNTXvM92Ua0iZsu2DFKHeNSMgSYogPQlkax4V0Zdc8URWT3
         zCWwL0GNoPZ5PPlCtXawUnJlU9a2ecP/QZLPf2UfxtBfYNvKOGZfGssQ4D+b4wKHZ5pV
         DFWJNtqazxeOTUdhysRpr0vdCcecKsmvdz5NUEz3cLKMy34WrYH7qqL/vLkuRvScFQJr
         Veow==
X-Gm-Message-State: APjAAAXHGrgD+vsIIS6Np8cHRrzj2zUu5DbDl0oU1ii9o9j3ZIs2jF9+
        ilfEXgVWJoLEv4j2BWAg7VvIZuGLYwQ=
X-Google-Smtp-Source: APXvYqwq0DLfDr/GEx8Ioo9rXYOVzEw+HqTLlypdVOTwN/scxJ1hlwnITW1gc8tynJDxNVNwzem68Q==
X-Received: by 2002:a5d:4090:: with SMTP id o16mr7929232wrp.292.1563893529374;
        Tue, 23 Jul 2019 07:52:09 -0700 (PDT)
Received: from localhost ([197.211.57.129])
        by smtp.gmail.com with ESMTPSA id c78sm62424451wmd.16.2019.07.23.07.52.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 07:52:08 -0700 (PDT)
Date:   Tue, 23 Jul 2019 15:52:01 +0100
From:   Sheriff Esseson <sheriffesseson@gmail.com>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        "supporter:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] Documentation: filesystem: fix "Removed Sysctls" table
Message-ID: <20190723145201.GA20658@localhost>
References: <20190723114813.GA14870@localhost>
 <20190723074218.4532737f@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <20190723074218.4532737f@lwn.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
Message-ID: <20190723145201.X0pzY4paLiPAc3AYbKMoYJZ6-GGGN4dbD4CsHb8t1eI@z>

On Tue, Jul 23, 2019 at 07:42:18AM -0600, Jonathan Corbet wrote:
> On Tue, 23 Jul 2019 12:48:13 +0100
> Sheriff Esseson <sheriffesseson@gmail.com> wrote:
> 
> > the "Removed Sysctls" section is a table - bring it alive with ReST.
> > 
> > Signed-off-by: Sheriff Esseson <sheriffesseson@gmail.com>
> 
> So this appears to be identical to the patch you sent three days ago; is
> there a reason why you are sending it again now?
> 
> Thanks,
> 
> jon

Sorry, I was think the patch went unnoticed during the merge window - I could
not find a response.
