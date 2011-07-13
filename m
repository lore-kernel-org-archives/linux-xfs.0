Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6DCDOUi082701 for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 07:13:26 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E07252922C
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 05:13:20 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	xxMjBQ4gUpDoFSqD for <xfs@oss.sgi.com>;
	Wed, 13 Jul 2011 05:13:20 -0700 (PDT)
Date: Wed, 13 Jul 2011 08:13:20 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] Fix the ltp Makefile to allow for installation of
	all non-c (scripts) files
Message-ID: <20110713121320.GA28126@infradead.org>
References: <CAP57jx5TWxwaDhp6yY+b_tBb8_WTBaRPDCfdQ3pV4Bs-S869QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAP57jx5TWxwaDhp6yY+b_tBb8_WTBaRPDCfdQ3pV4Bs-S869QQ@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: alal@google.com
Cc: xfs@oss.sgi.com

On Fri, Jul 01, 2011 at 01:52:43PM -0700, Akshay Lal wrote:
> Current the Makefile only builds the .c files and installs
> them in the $INSTALL path. However, the ltp directory contains a shell script,
> which doen't get copied over (installed) when a "make install"is invoked.
> 
> This behaviour causes test 080 to fail since it requires rwtest.sh to be
> present in the ltp/ directory.
> 
> Tested: Updated the Makefile and ran a static build script & test
> 080.

Thanks, applied.  (after fixing up mailer induced whitespace issues)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
