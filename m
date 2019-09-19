Return-Path: <SRS0=IJtx=XO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72AF4C3A5A6
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 17:41:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AFEC21A49
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 17:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568914915;
	bh=NlZteMVPAdJn2snK+8djGo5hS4QnBdcun4uuWQujV3w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=dYsUql1DVIBSwy2HZwZMERRu/BqQyeR7IBbuV29qVlb+c63w5HnqGZ+3GCD6Mz21i
	 cgiO6OBQQgsmtGdR9TCInyckQk79R2CiZ/CyxD9g1OE0vXYr0ORvDTOYziImceuOGk
	 9q39pmDDXQhnz4sKLEPj3JzInIctwE7XMJg9GrvY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390943AbfISRly (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Sep 2019 13:41:54 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44815 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388416AbfISRly (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Sep 2019 13:41:54 -0400
Received: by mail-lj1-f196.google.com with SMTP id m13so4415227ljj.11
        for <linux-xfs@vger.kernel.org>; Thu, 19 Sep 2019 10:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FiZz07Z/205AAVNujcqJzuj2VRlA1gVyITjZ2X3S9P0=;
        b=LUgHYlFO2ivHWXkjIMWHXKro3f62RmlbsjtZDM3aN1lBnbF/0enyMjBYRqw1bvQU+o
         WjuX6sn56vnQRYqFCSVxl5+izbPmn5JthFgQ1CVdOhSEm0KaDtohrjU8sSopQtoAQ4n6
         i+xMWyf0WARK8PenV7l026IzYlve6DXyQGV3s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FiZz07Z/205AAVNujcqJzuj2VRlA1gVyITjZ2X3S9P0=;
        b=sBY6N5ejVW3Zm8WMpUw/s+Czy5tsrfK3pydIxnOVuQkrDJzSxZguTvueUTIHAWd8HD
         3pFyHiWkHd8cGHx65b2UPEkBB4tKTZGUVGoc+23EAjM4dQ2Fi4776kWh9EUA5Iu4X0kq
         XaB9IOv39xjnIBf67UGlG3qzeb+nNEiirnyoUXR1S4L76nWOrXljL8a3XBSfm8uzMlu5
         a+AWNPYe3URjrvt6AawhdxgZ2hVLYSsfGSsFGtaPMzlzTEdGhSLFWqP0m6cRevWb4qm/
         LjKMDO/2kGr9RvjB+pRy0VDpON2F+0oSWQ4tFa7AoTqHvdYEUmSt1UTJxmMKd4KbLVEG
         V1SQ==
X-Gm-Message-State: APjAAAVpDdJyiOTGgNrIvHt/fu3y+5bRzsKP7pGOyPNgnO8SEMQ3I1Pc
        4B5VRnyCQMtzw0gu0UndX0UPyd2KOKw=
X-Google-Smtp-Source: APXvYqwue+7kttVmsr/d+JRbo3+nUS2yOhGnx0pbiYcuh1I737q6+XqYmdJVGjUwLEltx7gHsHK1tg==
X-Received: by 2002:a2e:87cb:: with SMTP id v11mr6068159ljj.31.1568914911832;
        Thu, 19 Sep 2019 10:41:51 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id w17sm1702098lfl.43.2019.09.19.10.41.50
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Sep 2019 10:41:50 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id r22so3014999lfm.1
        for <linux-xfs@vger.kernel.org>; Thu, 19 Sep 2019 10:41:50 -0700 (PDT)
X-Received: by 2002:ac2:50cb:: with SMTP id h11mr5665094lfm.170.1568914909864;
 Thu, 19 Sep 2019 10:41:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190917152140.GU2229799@magnolia> <CAHk-=wj9Zjb=NENJ6SViNiYiYi4LFX9WYqskZh4E_OzjijK1VA@mail.gmail.com>
 <20190919034502.GJ2229799@magnolia> <CAHk-=wgFRM=z6WS-QLThxL2T1AaoCQeZSoHzj8ak35uSePQVbA@mail.gmail.com>
 <20190919170711.GA9065@lst.de>
In-Reply-To: <20190919170711.GA9065@lst.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 19 Sep 2019 10:41:33 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgK7+TtDRbSAmcM5ihBDxF4eCg7zAXDkrNm7DOg+RtzyA@mail.gmail.com>
Message-ID: <CAHk-=wgK7+TtDRbSAmcM5ihBDxF4eCg7zAXDkrNm7DOg+RtzyA@mail.gmail.com>
Subject: Re: [GIT PULL] iomap: new code for 5.4
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Bob Peterson <rpeterso@redhat.com>,
        cluster-devel <cluster-devel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 19, 2019 at 10:07 AM Christoph Hellwig <hch@lst.de> wrote:
>
> I personally surived with it, but really hated writing the open coded
> list_for_each_entry + list_del or while list_first_entry_or_null +
> =E2=94=90ist_del when I could have a nice primitive for it.  I finally de=
cided
> to just add that helper..

You realize that the list helper is even mis-named?

Generally a "pop()" should pop the last entry, not the first one. Or
course, which one is last and which one is first is entirely up to you
since you can add at the tail or the beginning. So even the name is
ambiguous.

So I really think the whole thing was badly implemented (and yes, part
of that was the whole implementation thing).

Doing list_del() by hand also means that you can actually decide if
you want list_del_init() or not. So it's

But again - keep that helper if you want it. Just don't put a badly
implemented and badly named "helper" it in a global header file that
_everybody_ has to look at.

                   Linus
