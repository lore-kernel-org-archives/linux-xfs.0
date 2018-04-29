Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41937 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752767AbeD2HDR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 29 Apr 2018 03:03:17 -0400
Date: Sun, 29 Apr 2018 07:03:15 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: LICENSES: Missing ISC text & possibly a category ("Not
 recommended" vs. "Preferred licenses")
Message-ID: <20180429070315.GC27875@wotan.suse.de>
References: <CACna6rz_Ms2Uv1P6E0gCGNsRwK4nm=PMAOaJ5Uk9aJxs2VSamQ@mail.gmail.com>
 <20180429052617.GC24294@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180429052617.GC24294@kroah.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, DOCUMENTATION <linux-doc@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Kate Stewart <kate@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Kate Stewart <kstewart@linuxfoundation.org>, Florian Fainelli <f.fainelli@gmail.com>

On Sun, Apr 29, 2018 at 07:26:17AM +0200, Greg Kroah-Hartman wrote:
> I see it is only used in a very small number of dts files.  Why not just
> use BSD-2-Clause instead?  What do you find in ISC that is not available
> to you with just BSD?

ISC license is a simplified version of the BSD license due to the Berne
convention. It was also used for wireless drivers to help the BSD community in
particular OpenBSD who had picked that license for new contributions claimed
simplification of the BSD-2-Clause. Because of this reason many BSD communities
feel super comfortable with picking up kernel code in Linux under this license.

Granted, I'm on no longer a fan of promoting permissive licenses as it didn't
buy us cross-collaboration at all. We tried.

But it would be unfair to advice against a license unless a reason is stated in
favor of another BSD license. Why is the ISC license worse than the
BSD-2-Clause?

  Luis
