Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44310 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbfG0AYn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jul 2019 20:24:43 -0400
Received: by mail-pf1-f193.google.com with SMTP id t16so25208371pfe.11
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jul 2019 17:24:43 -0700 (PDT)
Date: Sat, 27 Jul 2019 00:24:39 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: Unmountable XFS file system after runnig stress-ng
Message-ID: <20190727002439.GS30113@42.do-not-panic.com>
References: <b92674c4-488e-15ec-2052-eb69e4f80b7e@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b92674c4-488e-15ec-2052-eb69e4f80b7e@molgen.mpg.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 25, 2019 at 07:21:43PM +0200, Paul Menzel wrote:
> Dear Linux folks,

Hey Paul, thanks for reporting this!

> With Linux 4.19.57

v4.19.57 lacks a series of fixes I posted a few days ago.
They were merged on v4.19.61. You can try that. If that fails
another small series of fixes were posted recently which are
not merged yet ons table v4.19.y, but you can use this git
branch:

https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-stable.git/log/?h=20190726-linux-xfs-4.19.y-v1

> I ran `sudo ./stress-ng -a 10` [1], and it looks like the
> file system got corrupted.

Which version of  stress-ng did you use?

Can you try also on the latest Linus' tree?
If brave enough, you can try the xfs for-next branch
as well:

https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/log/?h=for-next

If the issue is still creeping up on the above stable kernels
can you create a bug entry on bugzilla.kernel.org to track this?

  Luis
