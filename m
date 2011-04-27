Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3RH7YUH223706 for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 12:07:36 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BC7AF4196B5
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 10:11:07 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id DNF2bQCz83BWeQYH for
	<xfs@oss.sgi.com>; Wed, 27 Apr 2011 10:11:07 -0700 (PDT)
Date: Wed, 27 Apr 2011 13:11:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstests 013 - 2.6.35.11 - hang
Message-ID: <20110427171107.GA29196@infradead.org>
References: <BANLkTimAXUtO=oxmLUaHLaRBnGafGP-9kg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTimAXUtO=oxmLUaHLaRBnGafGP-9kg@mail.gmail.com>
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
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 27, 2011 at 12:47:57PM +0530, Ajeet Yadav wrote:
> I have downloaded xfstests-fa83948599dd10078a62acab8b0c1f93c82ad807.tar.gz
> Build and run xfstests on MIPS target. This is my first try with
> xfstests but report is not good.

> --- 001.out     Thu Jan  1 00:07:48 1970
> +++ 001.out.bad Thu Jan  1 00:59:07 1970
> @@ -1,9 +1,77 @@
>  QA output created by 001
>  cleanup
>  setup ....................................
> -iter 1 chain ... check ....................................
> -iter 2 chain ... check ....................................
> -iter 3 chain ... check ....................................
> -iter 4 chain ... check ....................................
> -iter 5 chain ... check ....................................
> -cleanup
> +iter 1 chain ... check
> +Error: corruption for small ...

001 tests trivial fail copies, and if these already fail you're
most likely having cache coherency issues.  What mips platform
is this, and do you use any non-mainline patches?

Does 001 also fail for say ext2 and ext3?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
