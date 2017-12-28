Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:32877 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753719AbdL1Pde (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Dec 2017 10:33:34 -0500
Message-Id: <20171228152710.891701433@linutronix.de>
Date: Thu, 28 Dec 2017 16:27:10 +0100
From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch V5 00/11] LICENSES: Add documentation and initial License files
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Heiko Carstens <heiko.carstens@de.ibm.com>

This is the 5th version of the licensing rules documentation.

Changes since v4:

 - Made use of boilerplate consistently

 - Fixed the 'braces' inconsistency spotted by Heiko
 
 - Picked up Reviewed-by tags

Delta patch vs. V4 below.

Thanks to everyone who provided input!

Thanks,

        tglx

8<---------------
--- a/Documentation/process/license-rules.rst
+++ b/Documentation/process/license-rules.rst
@@ -34,8 +34,8 @@ into any source files which create an ex
 kernel, the exception must be documented by a special license expression.
 
 The common way of expressing the license of a source file is to add the
-matching boiler plate text into the top comment of the file.  Due to
-formatting, typos etc. these "boiler plates" are hard to validate for
+matching boilerplate text into the top comment of the file.  Due to
+formatting, typos etc. these "boilerplates" are hard to validate for
 tools which are used in the context of license compliance.
 
 An alternative to boilerplate text is the use of Software Package Data
@@ -89,9 +89,11 @@ License identifier syntax
 3. Syntax:
 
    A <SPDX License Expression> is either an SPDX short form license
-   identifier found on the SPDX License List, or when multiple licenses
-   apply, an expression consisting of keywords "AND", "OR", and "WITH"
-   separating SPDX short form license identifiers surrounded by "(", ")".
+   identifier found on the SPDX License List, or the combination of two
+   SPDX short form license identifiers separated by "WITH" when a license
+   exception applies. When multiple licenses apply, an expression consists
+   of keywords "AND", "OR" separating sub-expressions and surrounded by
+   "(", ")" .
 
    License identifiers for licenses like [L]GPL with the 'or later' option
    are constructed by using a "+" for indicating the 'or later' option.::
@@ -102,13 +104,13 @@ License identifier syntax
    WITH should be used when there is a modifier to a license needed.
    For example, the linux kernel UAPI files use the expression::
 
-      // SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note)
-      // SPDX-License-Identifier: (GPL-2.0+ WITH Linux-syscall-note)
+      // SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
+      // SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note
 
    Other examples using WITH exceptions found in the kernel are::
 
-      // SPDX-License-Identifier: (GPL-2.0 WITH mif-exception)
-      // SPDX-License-Identifier: (GPL-2.0+ WITH GCC-exception-2.0)
+      // SPDX-License-Identifier: GPL-2.0 WITH mif-exception
+      // SPDX-License-Identifier: GPL-2.0+ WITH GCC-exception-2.0
 
    Exceptions can only be used with particular License identifiers. The
    valid License identifiers are listed in the tags of the exception text
@@ -119,28 +121,28 @@ License identifier syntax
    to be selected.  For example, some dtsi files are available under dual
    licenses::
 
-      // SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
+      // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 
    Examples from the kernel for license expressions in dual licensed files::
 
-      // SPDX-License-Identifier: (GPL-2.0 OR MIT)
-      // SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
-      // SPDX-License-Identifier: (GPL-2.0 OR Apache-2.0)
-      // SPDX-License-Identifier: (GPL-2.0 OR MPL-1.1)
-      // SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR MIT)
-      // SPDX-License-Identifier: ((GPL-1.0+ OR BSD-3-Clause) OR OpenSSL)
+      // SPDX-License-Identifier: GPL-2.0 OR MIT
+      // SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+      // SPDX-License-Identifier: GPL-2.0 OR Apache-2.0
+      // SPDX-License-Identifier: GPL-2.0 OR MPL-1.1
+      // SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR MIT
+      // SPDX-License-Identifier: GPL-1.0+ OR BSD-3-Clause OR OpenSSL
 
    AND should be used if the file has multiple licenses whose terms all
    apply to use the file. For example, if code is inherited from another
    project and permission has been given to put it in the kernel, but the
    original license terms need to remain in effect::
 
-      // SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) AND MIT)
+      // SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) AND MIT
 
    Another other example where both sets of license terms need to be
    adhered to is::
 
-      // SPDX-License-Identifier: (GPL-1.0+ AND LGPL-2.1+)
+      // SPDX-License-Identifier: GPL-1.0+ AND LGPL-2.1+
 
 License identifiers
 -------------------


