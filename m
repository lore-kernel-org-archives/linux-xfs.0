Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51118 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752499AbdLEGuT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Dec 2017 01:50:19 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vB56mYfQ060477
        for <linux-xfs@vger.kernel.org>; Tue, 5 Dec 2017 01:50:18 -0500
Received: from e06smtp12.uk.ibm.com (e06smtp12.uk.ibm.com [195.75.94.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2enkugdtgy-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 05 Dec 2017 01:50:18 -0500
Received: from localhost
        by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
        Tue, 5 Dec 2017 06:50:10 -0000
Date: Tue, 5 Dec 2017 07:50:03 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch V4 01/11] Documentation: Add license-rules.rst to
 describe how to properly identify file licenses
References: <20171204211927.673291734@linutronix.de>
 <20171204212120.484179273@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171204212120.484179273@linutronix.de>
Message-Id: <20171205065003.GB7782@osiris>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

On Mon, Dec 04, 2017 at 10:19:28PM +0100, Thomas Gleixner wrote:
> +3. Syntax:
> +
> +   A <SPDX License Expression> is either an SPDX short form license
> +   identifier found on the SPDX License List, or when multiple licenses
> +   apply, an expression consisting of keywords "AND", "OR", and "WITH"
> +   separating SPDX short form license identifiers surrounded by "(", ")".

Here it is stated that SPDX identifiers using the keyword WITH must be
surrounded by braces.

> +      // SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note)
> +      // SPDX-License-Identifier: (GPL-2.0+ WITH Linux-syscall-note)

Just like this example.

> +   File format examples::
> +
> +      SPDX-Exception-Identifier: Linux-syscall-note
> +      SPDX-URL: https://spdx.org/licenses/Linux-syscall-note.html
> +      SPDX-Licenses: GPL-2.0, GPL-2.0+, GPL-1.0+, LGPL-2.0, LGPL-2.0+, LGPL-2.1, LGPL-2.1+
> +      Usage-Guidance:
> +        This exception is used together with one of the above SPDX-Licenses
> +	to mark user-space API (uapi) header files so they can be included
> +	into non GPL compliant user-space application code.
> +        To use this exception add it with the keyword WITH to one of the
> +	identifiers in the SPDX-Licenses tag:
> +	  SPDX-License-Identifier: <SPDX-License> WITH Linux-syscall-note

But here it comes without braces.

> +      Exception-Text:
> +        Full exception text
> +
> +   ::
> +
> +      SPDX-Exception-Identifier: GCC-exception-2.0
> +      SPDX-URL: https://spdx.org/licenses/GCC-exception-2.0.html
> +      SPDX-Licenses: GPL-2.0, GPL-2.0+
> +      Usage-Guidance:
> +        The "GCC Runtime Library exception 2.0" is used together with one
> +	of the above SPDX-Licenses for code imported from the GCC runtime
> +	library.
> +        To use this exception add it with the keyword WITH to one of the
> +	identifiers in the SPDX-Licenses tag:
> +	  SPDX-License-Identifier: <SPDX-License> WITH GCC-exception-2.0

Here as well.

The whole kernel now got SPDX-License-Identifiers that look like this:

SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note

So this looks inconsistent to me, or did I miss something?

