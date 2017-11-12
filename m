Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59349 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750802AbdKLTfB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Nov 2017 14:35:01 -0500
Message-Id: <20171112191821.240484206@linutronix.de>
Date: Sun, 12 Nov 2017 20:18:21 +0100
From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 0/7] LICENSES: Add documentation and initial License files
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kate@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org

Folks!

First of all I want to apologize for the suboptimal process which brought
this initial SPDX annotation into the kernel. We surely should have posted
exactly this patch series first, but we were too focused on the actual
annotation and analysis work, which took place in the last 10 months. As is
happens often with work which occupies one on the 'technical' level
completely, documentation is the last thing to think of.

We got the message and worked on documentation and procedure in the last
couple of days and I seriously hope, that this can clarify the situation.

If we made any mistakes in the annotation process, please let us know as
soon as possible and we correct it, or send a patch to that effect.

I've seen a complaint that we didn't respect the intent of the developer
for a particular file, but this is exactly the problem we have to
address. A file without any reference does not give any hint on the intent
and by default all files contributed to a project without a license
reference fall under the license which covers the project itself. Sorry, we
really tried our best to deduce it.

A few people asked for the metadate which we used. It's available from

  https://tglx.de:~/tglx/spdx/spdx-inital.tar.xz

along with a GPG signature for the decompressed tarball itself:

  https://tglx.de:~/tglx/spdx/spdx-inital.tar.sig

The tarball contains the CSV files and the script which were used to apply
the annotations. The CSV table columns are:

 NR, filename, ScanCode Scan, Windriver-Scan, Concluded License

The 'Concluded License' column is what got associated in the end. All of
these have been manually audited several times by looking at the files,
context and history and rescanning with Philippes ScanCode tools.

We are going to upload the full kernel metadata, which is useful for the
outstanding annotation work next week, as we need to align the data with
the actually applied ones in the tarball. The data in the tarball is a
subset of the full list and was scrutinized again before applying by manual
inspection and Philippe doing scan comparisons. There were a few correction
to make, which did not make it back into the complete list yet.

If you want to create your own scan data, the ScanCode tool can be found
here:

 https://github.com/nexB/scancode-toolkit.git

It's python based and simple to install and use. Philippe is willing to
help if there are questions or issues.

The Windriver Scan is based on Fossology which can be found here:

 https://www.fossology.org

You might want to use the online demo version of fossology as it is a bit
tedious to install. We used a scan from Windriver because that contains
aside of the pure scan based data manual corrections. Such manual
corrections are valuable metadata, which is certainly available inside the
companies behind fossology, but those have not published them so far.


Aside of the process discussion, there were quite some complaints about the
comment/tag format and placement. In the first versions we placed the tag
inside the top comment, but the final decision was made by Linus and that's
how it ended up the way it is and in which way it is documented now.

The following patches contain the full documentation how the SPDX tagging
of files should work and an initial import of actual license texts.

Thanks,

	Thomas

