Return-Path: <SRS0=f2ny=WU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC83AC3A59E
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Aug 2019 18:45:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91BA9206B7
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Aug 2019 18:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1566672305;
	bh=qM7at4WppWcQDvAXqIXMEbLRRsmRG05oyExP5dAUglE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=n38FDq1XVpdQsrJna0eDjZ3DHG6p/tqD3F2SUq3rEkPMLkYv8cEF73PD6ZXhu/5xD
	 gXooyjpAsfVK4J4higuJdthHwq+gYD7BX6RAVnRTeGDPtNvCAy6JEO4F0lTyqZpcAE
	 2eD9tiiLlejn/l6V6+tDV7OvqHQQC7UYZuSQehO8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbfHXSpF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 24 Aug 2019 14:45:05 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37584 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727821AbfHXSpE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Aug 2019 14:45:04 -0400
Received: by mail-lf1-f68.google.com with SMTP id w67so1259539lff.4
        for <linux-xfs@vger.kernel.org>; Sat, 24 Aug 2019 11:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cwTTMvxrYkpYH9HeUUuPzjuINZ2YtKIHc82x5uH4c2E=;
        b=MIEsmsRkYgDx04kFQIs93TlVOhrBh0TVCCzILLs1IVZjNIjLjepdUw7Iths5Wrp5OF
         PWVzCU1aef95bfxz7kIAD027WvFkRmfj3F4eal2/QZElZJRfWxFO8Tvs+aNa/0Nv85KJ
         0zNcJX1GUjaUdw3iOyOidX593h7uYkTkdxkQg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cwTTMvxrYkpYH9HeUUuPzjuINZ2YtKIHc82x5uH4c2E=;
        b=R+38WT0Sw0B3DZOVSwZJOeC+oXybfux2HKZVaBJBPprjQA1tsd95dxyySHFNHNaVt3
         5H4+j3goGYjaogyJsqoTugy6L6uKyKMGSyaxz7Enr5J9hU9NJANOUIU+dSr/ZR94QFi0
         og3FkO4oTdZ3F6n+u5cY2FEvq2VeduKepkaqo6ZCORib0eTAfQGH5kwXShsAoSA4I2gO
         5LnC9ENwgYj1uXON3ULOrFR39nhZGTYekfplkScjGJlLtkIRCoh/My5rEPO0BOGtYebA
         8Yfc2RHQJJJp3DESiu8WIiaAdLYln1gyCYdBl9BO4eBA6oUrY15S7wkVJEiaS1PCZlJt
         xXcQ==
X-Gm-Message-State: APjAAAW+bTIf3r7hBU1iGlx5iAY/gBeRYodmL+L6yTpcVrq29G3xEOvH
        Sq09c3KOSKou3azI6vG9lr/L+4O0+qo=
X-Google-Smtp-Source: APXvYqzFZtRnIsIz6abiA/ZJshjW1rTYzm6rUHMeBB0HThZorlVO52PEU00GgIRlqZ60m13kymMw1A==
X-Received: by 2002:a19:5f1c:: with SMTP id t28mr6334375lfb.34.1566672301573;
        Sat, 24 Aug 2019 11:45:01 -0700 (PDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id u5sm1217093lfg.66.2019.08.24.11.45.00
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Aug 2019 11:45:00 -0700 (PDT)
Received: by mail-lj1-f169.google.com with SMTP id x3so11691681lji.5
        for <linux-xfs@vger.kernel.org>; Sat, 24 Aug 2019 11:45:00 -0700 (PDT)
X-Received: by 2002:a2e:3a0e:: with SMTP id h14mr6303684lja.180.1566672300201;
 Sat, 24 Aug 2019 11:45:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190823035528.GH1037422@magnolia> <20190823192433.GA8736@eldamar.local>
In-Reply-To: <20190823192433.GA8736@eldamar.local>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 24 Aug 2019 11:44:44 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj2hX9Qohd8OFxjsOZEzhp4WwjDvvh3_jRw600xf=KhVw@mail.gmail.com>
Message-ID: <CAHk-=wj2hX9Qohd8OFxjsOZEzhp4WwjDvvh3_jRw600xf=KhVw@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix missing ILOCK unlock when xfs_setattr_nonsize
 fails due to EDQUOT
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Security Officers <security@kernel.org>,
        Debian Security Team <team@security.debian.org>,
        benjamin.moody@gmail.com, Ben Hutchings <benh@debian.org>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 23, 2019 at 12:24 PM Salvatore Bonaccorso <carnil@debian.org> wrote:
>
> Confirmed the fix work.
>
> Feel free to add a Tested-by if wanted.
>
> Can this be backported to the relevant stable versions as well?

It's out there in my tree now. It's not explicitly marked for stable
per se, but it does have the "Fixes:" tag which should mean that Greg
and Sasha will pick it up automatically.

But just to make it explicit, since Greg is on the security list,
Darrick's fix is commit 1fb254aa983b ("xfs: fix missing ILOCK unlock
when xfs_setattr_nonsize fails due to EDQUOT").

                Linus
