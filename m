Return-Path: <SRS0=lWMA=WT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BD04C3A5A2
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 19:26:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49D5621874
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 19:26:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tmOM2tOk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389673AbfHWT0P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Aug 2019 15:26:15 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:37082 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728512AbfHWT0P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Aug 2019 15:26:15 -0400
Received: by mail-ed1-f65.google.com with SMTP id f22so15034283edt.4
        for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2019 12:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NgFjG8BTZ8UR4Sa2/DkETP1nv+76CDLYBFAP1SID9uM=;
        b=tmOM2tOksxpAVKIiHK0NTW6m3RorUOZQra5a9QGGCGsZSDEXSgVqSuhSQHFT6TsyCC
         lGKz/EQ3Pa56/54iIzfaN5WeTxLXunIm3pxtnX09OMLEd3c6QOoDVprqVlArGvmUv3/g
         gm6IBYkD9h7VSY2VgjARvR8DQsd6rlj3uFMSOENxus0LqVYXCmYcE+j7S/FWyI5WUSyB
         /4HAWsMcu0eHkC6mV65EIw6r0pBJStq7tIEihxXUmzPXDvcI+bGjBhARR3hCXQiN1Xsj
         LphZnSJuxaDw4Dmcqe0jIxRZE2mGTOnvOiQrcmajv712mHEtlIRqV7XbY9Hg3hv3z3ek
         VIww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=NgFjG8BTZ8UR4Sa2/DkETP1nv+76CDLYBFAP1SID9uM=;
        b=YG0Smu/bYqZIyz53xpz9BGVN7CZVCt+ZfrzwpxQ57YVfhl4HQL5VKLmwLU8i7EjMsL
         4q4pPCBW7ikU78/+RlfBxVCuPdoJapv82n19kVZe1kr252RHtPDMdwvIuurh0GwCsgTz
         fiIx87a8gGvuFRofLpnVxu/UF8YgqQb6+B9yoNTXMpZ8sTcpVYnvos5GD8NQvKsjeyNG
         VM9hEHEt6z2Ghy/n0R8U2Y7T/qy869zzYVTRNtsKPMeIwIOKBaRnddM8ET6AveilO3nT
         Oki4aQimng57U3hLxJDGuaJikCU0HUjmrrzKZZOVpvPvmfXM8Mz3rtRZKe37WNrjgsfD
         wYvA==
X-Gm-Message-State: APjAAAVqf2JgSqUyauhb1Eky1PxWSIPf8lj65nIJnd0gx02PtHt8Q0I4
        gRWuhfY80R62SJhTYLZBYnw=
X-Google-Smtp-Source: APXvYqxTq9UiroTaHf4hJKTzz/LNKzIkpQQCuI8gew8MwO4L4EqT2P42e/2QDqt33cIhvQIOM2NN6g==
X-Received: by 2002:a17:906:852:: with SMTP id f18mr5857893ejd.18.1566588373866;
        Fri, 23 Aug 2019 12:26:13 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id t24sm681164eds.45.2019.08.23.12.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2019 12:26:12 -0700 (PDT)
Date:   Fri, 23 Aug 2019 21:26:12 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Security Officers <security@kernel.org>,
        Debian Security Team <team@security.debian.org>,
        benjamin.moody@gmail.com, Ben Hutchings <benh@debian.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix missing ILOCK unlock when xfs_setattr_nonsize
 fails due to EDQUOT
Message-ID: <20190823192612.GB8736@eldamar.local>
References: <20190823035528.GH1037422@magnolia>
 <CAHk-=wiE1zyj89=gpoCn8L0hy8WpS68s+13GOsHQ5Eq3DPWqEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiE1zyj89=gpoCn8L0hy8WpS68s+13GOsHQ5Eq3DPWqEw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

On Fri, Aug 23, 2019 at 09:28:42AM -0700, Linus Torvalds wrote:
> On Thu, Aug 22, 2019 at 8:55 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > ...which is clearly caused by xfs_setattr_nonsize failing to unlock the
> > ILOCK after the xfs_qm_vop_chown_reserve call fails.  Add the missing
> > unlock.
> 
> Thanks for the quick fix.
> 
> I assume there's no real embargo on this, and we can just add it asap
> to the xfs tree and mark it for stable, rather than do anything
> outside the usual development path?
> 
> The security list rules do allow for a 5-working-day delay, but this
> being "just" a local DoS thing I expect nobody really will argue for
> it.
> 
> Anybody?

Agreed, there is no real embargo on this, it is public anyway on the
xfs list and actually we just wanted to be on the safe side by asking
or bringing it to security@k.o.

Thanks for the quick fix.

Regards,
Salvatore
