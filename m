Return-Path: <SRS0=G8Dq=WV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4198FC3A5A1
	for <linux-xfs@archiver.kernel.org>; Sun, 25 Aug 2019 15:45:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EE3E2080C
	for <linux-xfs@archiver.kernel.org>; Sun, 25 Aug 2019 15:45:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LdJd/uuT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbfHYPp2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 25 Aug 2019 11:45:28 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39660 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727212AbfHYPp2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Aug 2019 11:45:28 -0400
Received: by mail-ed1-f68.google.com with SMTP id g8so22674685edm.6
        for <linux-xfs@vger.kernel.org>; Sun, 25 Aug 2019 08:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bro+ksg87GjE743Sk4hI2sqbhTzVYXTqEW+hu6C/k00=;
        b=LdJd/uuT3nd8Ljt6jKRRP1rCgf/ioblGb3ly6wZm39BLPifalaVBxGaf/fjR/N30ep
         3j4B18L7RU3DN+TyV7jsht/TG255JZmW+bjyxpl9t8g005jR0ectdWFNBoaMhnw1PZ/f
         V//MwicXbuWKwb1ID7G9SaPWpC0rycKprj03cu4BKTU6Y47di77VTaDlYWr27zbbj1TP
         FNUzxhFcy4g8tRVHza1f5QcKy4mLIxeEtoygEnInJFSQJ9QlwgoCTIVO0cpa3RLXLHMz
         tSVIzA+faRGuzn+V2nePkJsKAFjEq7uWfdpk7E2QC8chfwiMb/atg2FH376QB1Lif92T
         9UHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=bro+ksg87GjE743Sk4hI2sqbhTzVYXTqEW+hu6C/k00=;
        b=C4GAQWJW0gLLJfRFpxasbAeVL6PQ2sljcWV3zZfJnRoZZviB1E5bJpuCTozT3E0PlA
         KvH1EcInLoeM0DhckRka5ircytsOk/cD2C+Owodt2DirnQUMX0yXR0JhHEZkRm4e4yG6
         Z2JyY7nT0HEeYsXVJAUpiqaEfdQweDWRlQ5Wei/GJUi40hqCjJlYABujjgtMGBfeSQSi
         axuvzg05OzHRCCXtALugIZ9r7RH0UACJy/McinRXrEuTWuWVG80E2KSTXspGbreQbZn3
         GkcAGJ7+x1to93E9b3G6Mm8gv61eSDA/qnDZuoc2d1QGCZowioO8lM6+LE7j0PcxV3PT
         q52Q==
X-Gm-Message-State: APjAAAVQU3I90Ng1RaHyZFAgwRE7fO7fp1abEGTxOMm3xVSWGq0bAroc
        cAkjn3/Pp99vAd3Q91AsyTxDRBujaQI=
X-Google-Smtp-Source: APXvYqwhvuaRNP/U1ryw90Ga0iYxzzBLNAMnMhtlW6NmuLPN/t2NnRW6BbHTkTGcj+bv348/iImVxw==
X-Received: by 2002:a17:906:454d:: with SMTP id s13mr12628472ejq.159.1566747926735;
        Sun, 25 Aug 2019 08:45:26 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id p8sm2372513ejn.25.2019.08.25.08.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2019 08:45:25 -0700 (PDT)
Date:   Sun, 25 Aug 2019 17:45:25 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Greg KH <greg@kroah.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Security Officers <security@kernel.org>,
        Debian Security Team <team@security.debian.org>,
        benjamin.moody@gmail.com, Ben Hutchings <benh@debian.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix missing ILOCK unlock when xfs_setattr_nonsize
 fails due to EDQUOT
Message-ID: <20190825154525.GC14904@eldamar.local>
References: <20190823035528.GH1037422@magnolia>
 <20190823192433.GA8736@eldamar.local>
 <CAHk-=wj2hX9Qohd8OFxjsOZEzhp4WwjDvvh3_jRw600xf=KhVw@mail.gmail.com>
 <20190825031318.GB2590@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190825031318.GB2590@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Greg,

On Sun, Aug 25, 2019 at 05:13:18AM +0200, Greg KH wrote:
> On Sat, Aug 24, 2019 at 11:44:44AM -0700, Linus Torvalds wrote:
> > On Fri, Aug 23, 2019 at 12:24 PM Salvatore Bonaccorso <carnil@debian.org> wrote:
> > >
> > > Confirmed the fix work.
> > >
> > > Feel free to add a Tested-by if wanted.
> > >
> > > Can this be backported to the relevant stable versions as well?
> > 
> > It's out there in my tree now. It's not explicitly marked for stable
> > per se, but it does have the "Fixes:" tag which should mean that Greg
> > and Sasha will pick it up automatically.
> > 
> > But just to make it explicit, since Greg is on the security list,
> > Darrick's fix is commit 1fb254aa983b ("xfs: fix missing ILOCK unlock
> > when xfs_setattr_nonsize fails due to EDQUOT").
> 
> Thanks, I'll pick this up.
> 
> Note, "Fixes:" will never guarantee that a patch ends up in a stable
> release.  Sasha's scripts usually do a good job of catching a lot of
> them a week or so after-the-fact, but they are not guaranteed to do so.
> A CC: stable@ will always be caught by me, and I try to ensure that
> anything goes across the security@k.o list also gets picked up.

Thank you.

FTR, for those interested in tracking this fix for the DoS potential
as vulnerability, MITRE has assigned CVE-2019-15538 for this issue.

Regards,
Salvatore
