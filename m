Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:46316 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730978AbfFGSeW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Jun 2019 14:34:22 -0400
Date: Fri, 7 Jun 2019 11:34:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] Documentation: xfs: Fix typo
Message-ID: <20190607183410.GF1871505@magnolia>
References: <20190509030549.2253-1-ruansy.fnst@cn.fujitsu.com>
 <20190607114415.32cb32dd@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190607114415.32cb32dd@lwn.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jonathan Corbet <corbet@lwn.net>
Cc: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, Jun 07, 2019 at 11:44:15AM -0600, Jonathan Corbet wrote:
> On Thu, 9 May 2019 11:05:49 +0800
> Shiyang Ruan <ruansy.fnst@cn.fujitsu.com> wrote:
> 
> > In "Y+P" of this line, there are two non-ASCII characters(0xd9 0x8d)
> > following behind the 'Y'.  Shown as a small '=' under the '+' in VIM
> > and a '賺' in webpage[1].
> > 
> > I think it's a mistake and remove these strange characters.
> > 
> > [1]: https://www.kernel.org/doc/Documentation/filesystems/xfs-delayed-logging-design.txt
> > 
> > Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
> > ---
> >  Documentation/filesystems/xfs-delayed-logging-design.txt | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/filesystems/xfs-delayed-logging-design.txt b/Documentation/filesystems/xfs-delayed-logging-design.txt
> > index 2ce36439c09f..9a6dd289b17b 100644
> > --- a/Documentation/filesystems/xfs-delayed-logging-design.txt
> > +++ b/Documentation/filesystems/xfs-delayed-logging-design.txt
> > @@ -34,7 +34,7 @@ transaction:
> >  	   D			A+B+C+D		X+n+m+o
> >  	    <object written to disk>
> >  	   E			   E		   Y (> X+n+m+o)
> > -	   F			  E+F		  Yٍ+p
> > +	   F			  E+F		  Y+p
> 
> OK, that does look funky, applied.
> 
> This patch probably should have been copied to the XFS list (added), even
> though get_maintainer.pl doesn't know that.

Yeah, it's "Y+p" not "Y<weird plusequals thing>p" in the xfs
documentation repo:

https://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git/tree/design/XFS_Filesystem_Structure/delayed_logging.asciidoc

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

I doubt the value of maintaining duplicate copies of this document in
the kernel and the xfs documentation repo, and since the xfs docs and
kernel licences aren't compatible maybe we should withdraw one...

...but since Dave is the author I'm gonna punt to him.  IMHO either we
should claim responsibility for those files in MAINTAINERS or drop them.
:)

Thanks for the heads-up,
--D

> Thanks,
> 
> jon
