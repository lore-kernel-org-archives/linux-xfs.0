Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n09LrhQv026226 for <xfs@oss.sgi.com>; Fri, 9 Jan 2009 15:53:44 -0600
Message-ID: <a4423d670901091353s7ff12207gcb38eb093d77d401@mail.gmail.com>
Date: Sat, 10 Jan 2009 00:53:42 +0300
From: "Alexander Beregalov" <a.beregalov@gmail.com>
Subject: Re: [xfs-masters] 2.6.29-rc: kernel BUG at fs/xfs/support/debug.c:108
In-Reply-To: <20090109053858.GP9448@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
References: <20090109044121.GA31280@orion> <20090109053858.GP9448@disturbed>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Dave Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com, kernel-testers@vger.kernel.org

2009/1/9 Dave Chinner <david@fromorbit.com>:
> On Fri, Jan 09, 2009 at 07:41:21AM +0300, Alexander Beregalov wrote:
> Looks like the same btree corruption problem as this:
>
> http://oss.sgi.com/archives/xfs/2009-01/msg00118.html
>
> We're working to find the cause right now, but I find it interesting
> that you are running a CONFIG_XFS_DEBUG=y kernel and the first
> point that something is found wrong is the same place that the
> above non-debug case is detecting corruption.
>
> Can you reproduce it/have a reproducable test case?
Yes, it is easy reproducible for me, it happens every time I run
`rtorrent` during few minutes after boot.
I will try to provide simpler testcase.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
