Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 10 Nov 2006 23:07:50 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAB77gaG002105
	for <xfs@oss.sgi.com>; Fri, 10 Nov 2006 23:07:43 -0800
Received: from smtp.osdl.org (smtp.osdl.org [65.172.181.4])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 91981D1CB31C
	for <xfs@oss.sgi.com>; Fri, 10 Nov 2006 22:53:01 -0800 (PST)
Date: Fri, 10 Nov 2006 22:52:57 -0800
From: Andrew Morton <akpm@osdl.org>
Subject: Re: XFS filesystem performance drop in kernels 2.6.16+
Message-Id: <20061110225257.63f91851.akpm@osdl.org>
In-Reply-To: <bde600590611100516u7b8ca1bfs74d3cc8b78eb3520@mail.gmail.com>
References: <bde600590611090930g3ab97aq3c76d7bca4ec267f@mail.gmail.com>
	<4553F3C6.2030807@sandeen.net>
	<Pine.LNX.4.61.0611101259490.6068@yvahk01.tjqt.qr>
	<bde600590611100516u7b8ca1bfs74d3cc8b78eb3520@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Igor A. Valcov" <viaprog@gmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, 10 Nov 2006 16:16:27 +0300
"Igor A. Valcov" <viaprog@gmail.com> wrote:

> Below is a simplified version of the test program,

Boy, I hope not.  The results of this test program are of very little interest.

>     for (i = 0; i < 262144; i++) {
>         /* Write data to a big file */
>         write (nFiles [0], buf, __BYTES);
> 
>         /* Write data to small files */
>         for (f = 1; f < __FILES; f++)
>             write (nFiles [f], &f, sizeof (f));
>     }

This sits in a loop doing write(fd, buf, 4).  This is wildly inefficient -
you'd get a 10x throughput benefit and maybe 100x reduction in CPU cost
simply by switching to fwrite().

I suspect something went wrong here.
