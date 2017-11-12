Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59351 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750846AbdKLTfB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Nov 2017 14:35:01 -0500
Message-Id: <20171112192142.525567667@linutronix.de>
Date: Sun, 12 Nov 2017 20:18:22 +0100
From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 1/7] Documentation: Add license-rules.rst to describe how to
 properly identify file licenses
References: <20171112191821.240484206@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=Documentation_Add_license-rules.rst_to_describe_how_to_properly_identify_file_licenses.patch
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kate@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Kate Stewart <kstewart@linuxfoundation.org>

Add a file to the Documentation directory to describe how file licenses
should be described in all kernel files, using the SPDX identifier, as well
as where all licenses should be in the kernel source tree for people to
refer to (LICENSES/).

Thanks to Kate, Philippe and Greg for review and editing!

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Greg KH <gregkh@linuxfoundation.org>
Reviewed-by: Kate Stewart <kstewart@linuxfoundation.org>
Reviewed-by: Philippe Ombredanne <pombredanne@nexb.com>

---
 Documentation/index.rst         |   12 +
 Documentation/license-rules.rst |  310 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 322 insertions(+)
 create mode 100644 Documentation/license-rules.rst

--- a/Documentation/index.rst
+++ b/Documentation/index.rst
@@ -13,6 +13,18 @@ documents into a coherent whole.  Please
 documentation are welcome; join the linux-doc list at vger.kernel.org if
 you want to help out.
 
+Licensing documentation
+-----------------------
+
+The following describes the license of the Linux kernel source code
+(GPLv2), how to properly mark the license of individual files in the source
+tree, as well as links to the full license text.
+
+.. toctree::
+   :maxdepth: 2
+
+   license-rules.rst
+
 User-oriented documentation
 ---------------------------
 
--- /dev/null
+++ b/Documentation/license-rules.rst
@@ -0,0 +1,310 @@
+Linux kernel licensing rules
+============================
+
+The Linux Kernel is provided under the terms of the GNU General Public
+License version 2 only (GPL-2.0), as published by the Free Software
+Foundation, and provided in the COPYING file.  This documentation file is
+not meant to replace the COPYING file, but provides a description of how
+each source file should be annotated to make the licensing it is governed
+under clear and unambiguous.
+
+The license in the COPYING file applies to the kernel source as a whole,
+though individual source files can have a different license which is
+required to be compatible with the GPL-2.0:
+
+::
+
+    GPL-1.0+  :  GNU General Public License v1.0 or later
+    GPL-2.0+  :  GNU General Public License v2.0 or later
+    LGPL-2.0  :  GNU Library General Public License v2 only
+    LGPL-2.0+ :  GNU Library General Public License v2 or later
+    LGPL-2.1  :  GNU Lesser General Public License v2.1 only
+    LGPL-2.1+ :  GNU Lesser General Public License v2.1 or later
+
+Aside from that, individual files can be provided under a dual license,
+i.e. one of the compatible GPL variants and alternatively under a
+permissive license like BSD, MIT etc.
+
+The Userspace API (UAPI) header files, which describe the interface of user
+space programs to the kernel are a special case.  According to the note
+in the kernel COPYING file the syscall interface is a clear boundary,
+which does not extend the GPL requirements to any software which uses
+them to communicate with the kernel.  Because the UAPI headers must be
+includable into any source files which create an executable running on
+the Linux kernel, the exception must be documented by a special license
+expression.
+
+The common way of expressing the license of a source file is to add the
+matching boiler plate text into the top comment of the file.  Due to
+formatting, typos etc.  These "boiler plates" are hard to validate for
+tools, which are used in the context of license compliance.
+
+To avoid license inconsistencies and to help tooling it is required to
+add a Software Package Data Exchange (SPDX) license identifier to each
+source file.  SPDX license identifiers are machine parsable and precise
+shorthands for the license under which the content of the file is
+contributed under.  SPDX license identifiers are managed by the SPDX
+Workgroup at the Linux Foundation and have been agreed on by partners
+throughout the industry, tool vendors, and legal teams.  For further
+information see https://spdx.org/
+
+The Linux kernel requires the precise SPDX identifier in all source files.
+The valid identifiers used in the kernel are described in the section
+`License identifiers`_ bottom of this file and have been retrieved from the
+official SPDX license list at https://spdx.org/licenses/
+
+License identifier syntax
+-------------------------
+
+The SPDX license identifier in kernel files shall be added at the first
+possible line in a file which can contain a comment.  For the majority
+of files this is the first line, except for scripts which require the
+'#!PATH_TO_INTERPRETER' in the first line.  For those scripts the SPDX
+identifier goes into the second line.
+
+The SPDX license identifier is added in form of a comment.  The comment
+style depends on the file type:
+
+::
+
+    C source:   // SPDX-License-Identifier: <SPDX License Expression>
+    C header:   /* SPDX-License-Identifier: <SPDX License Expression> */
+    ASM:        /* SPDX-License-Identifier: <SPDX License Expression> */
+    scripts:    # SPDX-License-Identifier: <SPDX License Expression>
+
+If a specific tool cannot handle the standard comment style, then the
+appropriate comment mechanism which the tool accepts shall be used.
+
+An <SPDX License Expression> is either an SPDX short form license
+identifier found on the SPDX License List, or when multiple licenses
+apply, an expression consisting of keywords "AND", "OR", and "WITH"
+separating SPDX short form license identifiers surrounded by "(", ")".
+
+License identifiers for licenses like [L]GPL with the 'or later' option
+are constructed by using a "+" for indicating the 'or later' option.
+
+::
+
+   // SPDX-License-Identifier: GPL-2.0+
+   // SPDX-License-Identifier: LGPL-2.1+
+
+WITH should be used when there is a modifier to a license needed.
+For example, the linux kernel UAPI files use the expression:
+
+::
+
+    // SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note)
+    // SPDX-License-Identifier: (GPL-2.0+ WITH Linux-syscall-note)
+
+Other examples using WITH exceptions found in the kernel are:
+
+::
+
+    (GPL-2.0 WITH mif-exception)
+    (GPL-2.0+ WITH GCC-exception-2.0)
+
+OR should be used if the file is dual licensed and only one license is
+to be selected.  For example, some dtsi files are available under dual
+licenses:
+
+::
+
+    // SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
+
+Examples from the kernel for license expressions in dual licensed files:
+
+::
+
+    (GPL-2.0 OR MIT)
+    (GPL-2.0 OR BSD-2-Clause)
+    (GPL-2.0 OR Apache-2.0)
+    (GPL-2.0 OR MPL-1.1)
+    ((GPL-2.0 WITH Linux-syscall-note) OR MIT)
+    ((GPL-1.0+ OR BSD-3-Clause) OR OpenSSL)
+
+AND should be used if the file has multiple licenses whose terms all apply
+to use the file. For example, if code is inherited from another project
+and permission has been given to put it in the kernel, but the original
+license terms need to remain in effect:
+
+::
+
+    // SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) AND MIT)
+
+Another example where both sets of license terms need to be
+adhered to is:
+
+::
+
+    (GPL-1.0+ AND LGPL-2.1+)
+
+License identifiers
+-------------------
+
+The licenses currently used, as well as the licenses for code added to the
+kernel can be broken down into:
+
+1) Preferred licenses:
+
+Whenever possible these licenses should be used as they are known to be
+fully compatible and widely used.  These licenses are available from the
+directory:
+
+::
+
+   LICENSES/preferred/
+
+in the kernel source tree. The files in this directory contain
+
+ - the proper syntax of the SPDX License identifier
+ - the proper syntax for possible License options, e.g. 'or later'
+ - reference(s) to the original license text
+ - reference to the SPDX page
+ - the full license text
+
+The file names are identical to the SPDX license identifier which shall be
+used for the license in source files.
+
+Examples:
+
+::
+
+   LICENSES/preferred/GPL-2.0
+
+	contains the GPL version 2 license text and the required references
+
+::
+
+   LICENSES/preferred/MIT
+
+	contains the MIT license text and the required references
+
+File format examples:
+
+::
+
+   SPDX-License-Identifier: GPL-2.0  // GPLv2 only
+   SPDX-License-Identifier: GPL-2.0+ // GPLv2 or later
+   LICENSE-URL: http://www.gnu.org/licenses/old-licenses/gpl-2.0-standalone.html
+   LICENSE-URL: http://www.opensource.org/licenses/GPL-2.0
+   SPDX-URL: https://spdx.org/licenses/GPL-2.0.html
+
+   Full license text
+
+::
+
+   SPDX-License-Identifier: MIT
+   LICENSE-URL: http://www.opensource.org/licenses/MIT
+   SPDX-URL: https://spdx.org/licenses/MIT.html
+
+   Full license text
+
+2) Not recommended licenses.
+
+These licenses should only be used for existing code or for importing
+code from a different project.  These licenses are available from the
+directory:
+
+::
+
+   LICENSES/other/
+
+in the kernel source tree. The files in this directory contain:
+
+ - the proper syntax of the SPDX License identifier
+ - reference(s) to the original license text
+ - reference to the SPDX page
+ - the full license text
+
+license text, a reference to the origin and the SPDX page.  The file
+names are identical to the SPDX license identifier which shall be used
+for the license in source files.
+
+Examples:
+
+::
+
+   LICENSES/other/ISC
+
+	contains the Internet Systems Consortium license text and the
+	required references
+
+::
+
+   LICENSES/other/ZLib
+
+	contains the ZLIB license text and the required references
+
+File format example:
+
+::
+
+   SPDX-License-Identifier: ISC
+   LICENSE-URL:	http://www.isc.org/software/license
+   LICENSE-URL: http://www.opensource.org/licenses/ISC
+   SPDX-URL: https://spdx.org/licenses/ISC.html
+
+   Full license text
+
+3) Exceptions:
+
+Some licenses can be amended with exceptions which grant certain rights
+which the original license does not.  These exceptions are available
+from the directory:
+
+::
+
+   LICENSES/exceptions/
+
+in the kernel source tree.  The files in this directory contain the full
+exception text, a reference to the origin and the SPDX page.  Further
+the file contains the SPDX identifier(s) of the license(s) to which the
+exception applies, so it can be verified that an exception is valid with
+the license to which the SPDX identifier expression refers.  The file
+names are identical to the SPDX license exception identifier which
+shall be used for the license in source files.
+
+Examples:
+
+::
+
+   LICENSES/exceptions/Linux-syscall-note
+
+	contains the Linux syscall exception as documented in the COPYING
+	file of the Linux kernel, which is used for UAPI header files.
+	e.g. /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+
+::
+
+   LICENSES/exceptions/GCC-exception-2.0
+
+	contains the GCC 'linking exception' which allows to link any
+	binary independent of its license against the compiled version of a
+	file marked with this exception. This is required for creating
+	runnable executables from source code which is not compatible with
+	the GPL.
+
+File format examples:
+
+::
+
+   SPDX-Exception-Identifier: Linux-syscall-note
+   LICENSE-URL: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/COPYING
+   SPDX-URL: https://spdx.org/licenses/Linux-syscall-note.html
+   SPDX-LICENSES: GPL-2.0, GPL-2.0+, GPL-1.0+, LGPL-2.0, LGPL-2.0+, LGPL-2.1, LGPL-2.1+
+
+    Full exception text
+
+::
+
+   SPDX-Exception-Identifier: GCC-exception-2.0
+   LICENSE-URL:
+   SPDX-URL: https://spdx.org/licenses/GCC-exception-2.0.html
+   SPDX-LICENSES: GPL-2.0, GPL-2.0+
+
+    Full exception text
+
+SPDX license identifiers and exceptions must have a corresponding file in
+the LICENSING subdirectories. This is required to allow tool verification
+(e.g. checkpatch.pl) and to have the licenses ready to read and extract
+right from the source, which is recommended by various FOSS organizations.


