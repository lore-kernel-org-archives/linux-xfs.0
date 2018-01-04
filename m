Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:40704 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752544AbeADUur (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jan 2018 15:50:47 -0500
Received: by mail-wr0-f193.google.com with SMTP id p17so2659125wre.7
        for <linux-xfs@vger.kernel.org>; Thu, 04 Jan 2018 12:50:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b353bb05-e9ea-86b7-7f34-c4c0f6b308fb@fsfe.org>
References: <20171228152710.891701433@linutronix.de> <20171228153308.366509938@linutronix.de>
 <b353bb05-e9ea-86b7-7f34-c4c0f6b308fb@fsfe.org>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Thu, 4 Jan 2018 21:50:05 +0100
Message-ID: <CAOFm3uHr8Vi5dG054qzPmvkD1=urZy+u2pr0sRruBBXgRunkeA@mail.gmail.com>
Subject: Re: [patch V5 02/11] LICENSES: Add the GPL 2.0 license
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carmen Bianca Bakker <carmenbianca@fsfe.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, xfs <linux-xfs@vger.kernel.org>, Charlemagne Lasse <charlemagnelasse@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Heiko Carstens <heiko.carstens@de.ibm.com>

Carmen,

On Thu, Jan 4, 2018 at 5:25 PM, Carmen Bianca Bakker
<carmenbianca@fsfe.org> wrote:
> Hi all,
>
> Since December, `GPL-2.0` is no longer the correct identifier for the
> licence.  The American FSF has been in talks with the SPDX Workgroup to
> change it to `GPL-2.0-only`.
>
> See the rationale here:
>
> https://www.gnu.org/licenses/identify-licenses-clearly.html
>
> See the new canonical licence list here:
>
> https://spdx.org/licenses/
>
> This change is valid for all GPL licences.  Similarly, `GPL-2.0+` has
> been changed to `GPL-2.0-or-later`.

This is exactly to insulate against these kinds of changes that this
doc patch exists in the first place and documents what things mean for
the kernel.

> I believe that this patch should be changed to reflect that.  The
> identifiers used in this patch are still valid, but deprecated.

Kernel-wise I do not think we can be assume that changes such as these
could be implemented right away so there is no need to change the doc
at this stage.
For now the kernel doc is the reference and nothing else. So this
patch should NOT be changed IMHO at least not now.
Eventually this could happen in the future, but not out of order with
actual patches to update the code and tooling and certainly not now.

-- 
Cordially
Philippe Ombredanne
