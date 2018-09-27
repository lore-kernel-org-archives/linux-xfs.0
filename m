Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:47734 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727270AbeI0VIo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Sep 2018 17:08:44 -0400
Date: Thu, 27 Sep 2018 08:50:05 -0600
From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFC PATCH 00/24] xfs-4.20: major documentation surgery
Message-ID: <20180927085005.21f7e34a@lwn.net>
In-Reply-To: <153799045443.31202.17537455000771265705.stgit@magnolia>
References: <153799045443.31202.17537455000771265705.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Wed, 26 Sep 2018 12:34:14 -0700
"Darrick J. Wong" <darrick.wong@oracle.com> wrote:

> This series converts the existing in-kernel xfs documentation to rst
> format, links it in with the rest of the kernel's rst documetation, and
> then begins pulling in the contents of the Data Structures & Algorithms
> book from the xfs-documentation git tree.  No changes are made to the
> text during the import process except to fix things that the conversion
> process (asciidoctor + pandoc) didn't do correctly.  The goal of this
> series is to tie together the XFS code with the on-disk format
> documentation for the features supported by the code.

Some overall comments:

 - I certainly approve of improving the documentation and bringing it into
   the docs tree - even if you don't CC the docs maintainer :)

 - When people do this work, I often end up asking them to think about who
   the audience is for the documentation.  Developers tend to want to
   group all of their docs together, but readers - the people the docs are
   for - tend to have different ideas.

   So, for example, the xfs.txt document converted in part 1 really, IMO,
   belongs in the admin guide - it's information for system
   administrators.  The data structures and algorithms stuff, instead, is
   aimed at developers.  I would really argue for separating the two.
   It's more work, but it's friendlier to our readers in the long term,
   and moves us away from our current pile of unorganized text.

 - CC-SA is a great license for documentation; I would rather use it for
   all kernel docs.  But I think we head into dangerous territory if we
   introduce non-GPL-compatible licenses into the kernel documentation.
   The docs pull a lot of text from the code itself, to the point that it's
   really hard to say that the processed docs are not a derived product of
   the kernel code itself.  Do we really want to create a situation where
   the output of "make *docs" can't be legally distributed?

   Hmm...it looks like we have exactly one document asserting CC-SA now,
   slipped in by Willy for 4.16.  If I'd noticed it, I would have
   complained at the time; maybe I'll do so now.  In any case, I think we
   need to be careful about adding more.

Thanks,

jon
