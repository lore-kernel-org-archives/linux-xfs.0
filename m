Return-Path: <SRS0=f4r+=4K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD446C35671
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Feb 2020 19:49:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C026206EF
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Feb 2020 19:49:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="NoLB8KKM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgBVTt2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Feb 2020 14:49:28 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:36343 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgBVTt2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Feb 2020 14:49:28 -0500
Received: by mail-ed1-f68.google.com with SMTP id j17so6849360edp.3
        for <linux-xfs@vger.kernel.org>; Sat, 22 Feb 2020 11:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7JYLJKT/hQhs6KreC3CzVzSZgkLBmMBMygUpecQo/Ig=;
        b=NoLB8KKMnfnSgBN0x935CKSXlBQr+CiCZeKwwIJVLKyJ077BKO4XgTCvaNfiQZ8BG7
         g35Jwbxszi5+8QKJqrQp7SLcGgVpJWJ5J9aBjHlA/z3qh2K27R9ofVc3vRW7+atmQ6ZS
         CpFVNGnkbNFlcX17OT/7ygHmyXycCZutgIDdUL9FvoVyuK9jwdfYFrFSifOzWEztejtV
         LV0v4XspUiqX5OvVkccUoNzVwo1/iXOOWbEy39vdsWg2thZLR4z8zOuQH1VQCKHVyFym
         y03KuWfyp/7Y2GzhSlkW12tSPKel68J1O1yWrXn8DYhV2rGhgG/g65EjM8TJ8L7BUoFn
         T3cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7JYLJKT/hQhs6KreC3CzVzSZgkLBmMBMygUpecQo/Ig=;
        b=Z1HJGjIAMqKMnTnFvHT89tOjBve3EoXlzVa+3BYntk8lU5CBM8iOyoL02PEuGGleDJ
         +Gr2n9kK1kaCd9FZvistZLfQ2F1UBQMxPN5FIBgDqFKDSfB8chh4feQu4oJzpFinFVki
         pgipOG7yCeMHbhSqVpXOp3wPu/HPT1K+WpH2twffUOkPaSWSLog9sul8rA0lxeLeTxGR
         mNM3l03JcW97TjcE7QwbtVxs1kxwW2zWLV129yPoPFP0FdbcnQfKRd4DWfASbkVROIzp
         sQgWMReWqLRLY/YDVA12pvynSUrPNyPR651Q1j0Kxnm6myjJqbkyfgS71KCddlO6a4Jk
         Dhew==
X-Gm-Message-State: APjAAAXbBHqXVk9VFWf9dTYb8VVS2gPwMarVxhX1mHonNVufyifrHHIW
        hkzoF68cu/ckow5iL+hCrTP9nLieG4MxffQMO5FA
X-Google-Smtp-Source: APXvYqyAoIgaMVG07BP0crmGCNOJTZLLbPrr1b3JOXJUMDT67NRb2gouWu4bjjIeU0vNtjFgbsPywwmXYYf3zyzSxBs=
X-Received: by 2002:a17:906:22cf:: with SMTP id q15mr39636640eja.77.1582400966197;
 Sat, 22 Feb 2020 11:49:26 -0800 (PST)
MIME-Version: 1.0
References: <20200220153234.152426-1-richard_c_haines@btinternet.com>
 <20200220155731.GU9506@magnolia> <20200220155938.GA1306@infradead.org>
 <2862d0b2-e0a9-149d-16e5-22c3f5f82e9e@tycho.nsa.gov> <20200220160820.GA14640@infradead.org>
In-Reply-To: <20200220160820.GA14640@infradead.org>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sat, 22 Feb 2020 14:49:15 -0500
Message-ID: <CAHC9VhRXo=EZ4HbLa_W_waL4xtdE6M92em7aNh=wm_7hpozJ7g@mail.gmail.com>
Subject: Re: [PATCH 0/1] selinux: Add xfs quota command types
To:     Christoph Hellwig <hch@infradead.org>,
        Richard Haines <richard_c_haines@btinternet.com>
Cc:     Stephen Smalley <sds@tycho.nsa.gov>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 11:08 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Thu, Feb 20, 2020 at 11:06:10AM -0500, Stephen Smalley wrote:
> > > The dquot_* routines are not generic quota code, but a specific
> > > implementation used by most non-XFS file systems.  So if there is a bug
> > > it is that the security call is not in the generic dispatch code.
> >
> > Hmm...any reason the security hook call couldn't be taken to
> > quota_quotaon()?
>
> I haven't touched the quota code for a while, but yes, the existing
> calls should move to the quota_* routines in fs/quota/quota.c.  Note
> that you still need to add checks, e.g. for Q_XSETQLIM.

Who wanted to submit a patch for this?  Christoph were you planning on
fixing this?  If not, Richard, do you want to give it a try?

-- 
paul moore
www.paul-moore.com
