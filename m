Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:58770 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727726AbeJFVNm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 6 Oct 2018 17:13:42 -0400
Date: Sat, 6 Oct 2018 08:10:13 -0600
From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2 00/22] xfs-4.20: major documentation surgery
Message-ID: <20181006081013.2c8bb0b6@lwn.net>
In-Reply-To: <20181006132951.GA17023@bombadil.infradead.org>
References: <153862669110.26427.16504658853992750743.stgit@magnolia>
        <20181006005154.GM12041@dastard>
        <20181006132951.GA17023@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org

On Sat, 6 Oct 2018 06:29:51 -0700
Matthew Wilcox <willy@infradead.org> wrote:

> I had an informal chat with Bradley Kuhn at LinuxCon Japan about using
> CC-BY-SA-4.0 and he indicated that I was probably better off using the
> GPL-2(+) for documentation.  I've changed the XArray documentation from
> CC-BY-SA-4.0 to GPL-2+.

Would you consider doing the same for Documentation/core-api/idr.rst?
That's the only CC-SA SPDX tag in the kernel now, and it's a clear
example of just what I'm worried about: it pulls in a nice DOC section
from the code when you run Sphinx on it, so we're not just talking
function prototypes here.  I was likely to come knocking on your door
after my upcoming conversation anyway...:)

Thanks,

jon
