Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728124AbfGPROF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 16 Jul 2019 13:14:05 -0400
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A948206C2
        for <linux-xfs@vger.kernel.org>; Tue, 16 Jul 2019 17:14:04 +0000 (UTC)
Received: by mail-vs1-f43.google.com with SMTP id h28so14424490vsl.12
        for <linux-xfs@vger.kernel.org>; Tue, 16 Jul 2019 10:14:04 -0700 (PDT)
MIME-Version: 1.0
References: <a665a93a-0bf8-aedb-2ba3-d4b2fb672970@linux.alibaba.com>
 <20190627155455.GA30113@42.do-not-panic.com> <CAOQ4uxgqgDAdKZDYwmf0M35M3D6Ctn25-VVj3wu5XSj_4c-WdA@mail.gmail.com>
 <20190627213520.GG19023@42.do-not-panic.com> <CAOQ4uxht-inVEjRWXtkbRPXTA9DvRNTLSPNEZ0Eh=nUhEhNO-A@mail.gmail.com>
 <20190628215051.GE30113@42.do-not-panic.com> <CAOQ4uxgU_Ad50ZJLhmfY0mGHWutNXJU1DhEkA++-Jak2PgkUcA@mail.gmail.com>
 <20190702193449.GQ19023@42.do-not-panic.com>
In-Reply-To: <20190702193449.GQ19023@42.do-not-panic.com>
From: Luis Chamberlain <mcgrof@kernel.org>
Date: Tue, 16 Jul 2019 10:13:49 -0700
Message-ID: <CAB=NE6Vtu0rKx8=ChrHE4W8o42xP5=b7Xz3q=5fmaa1MNAH9=A@mail.gmail.com>
Subject: Re: [backport request][stable] xfs: xfstests generic/538 failed on xfs
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Alvin Zheng <Alvin@linux.alibaba.com>, gregkh <gregkh@linuxfoundation.org>, linux-xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>, "joseph.qi" <joseph.qi@linux.alibaba.com>, caspar <caspar@linux.alibaba.com>, Sasha Levin <sashal@kernel.org>

On Tue, Jul 2, 2019 at 12:34 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> On Sat, Jun 29, 2019 at 10:41:35AM +0300, Amir Goldstein wrote:
> that'd be great. How long does your full run take?
>
> Not long, its just I wanted to also add xunit processing support onto
> oscheck as well. I'll start on that now, hopefully it'll all be done
> and tested by end of next week.

I'm now at a point where oscheck .. is looking sharp, and has xunit
processing and even an automatic way to expand our expunge list.... :)

So it will be super easy for me to test this now, in about two days
max I should have results.

  Luis
