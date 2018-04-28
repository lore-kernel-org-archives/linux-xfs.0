Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:44780 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751151AbeD1VZU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 28 Apr 2018 17:25:20 -0400
MIME-Version: 1.0
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Sat, 28 Apr 2018 23:25:17 +0200
Message-ID: <CACna6rz_Ms2Uv1P6E0gCGNsRwK4nm=PMAOaJ5Uk9aJxs2VSamQ@mail.gmail.com>
Subject: LICENSES: Missing ISC text & possibly a category ("Not recommended"
 vs. "Preferred licenses")
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, DOCUMENTATION <linux-doc@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Kate Stewart <kate@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Kate Stewart <kstewart@linuxfoundation.org>, Florian Fainelli <f.fainelli@gmail.com>

Hi,

Due to some maintainers *preferring* BSD-compatible license for DTS
files [0], I was writing mine using ISC. I had no very special reason
for it: I was choosing between BSD-2-Clause, MIT and ISC. I've chosen
ISC as I read about its "removal of language deemed unnecessary".

I took a moment to look at the new SPDX thing and noticed that:
1) File license-rules.rst provides "LICENSES/other/ISC" as an example
2) License file LICENSES/other/ISC doesn't exist
3) ISC is listed as an *example* under the "Not recommended licenses"

First of all, as ISC is used by some files in the Linux kernel, I
think it's worth adding to the LICENSE/*/ISC.

Secondly, it isn't 100% clear to me if ISC is preferred or not
recommended. File license-rules.rst suggests the later by listing it
as an example for "Not recommended". It's just an example though, so
I'm not 100% sure without seeing it in either: "preferred" or "other"
directories. Also if anyone finds it "Not recommended", can we get a
short explanation why is it so, please?

[0] https://lkml.org/lkml/2016/5/4/707

--=20
Rafa=C5=82
