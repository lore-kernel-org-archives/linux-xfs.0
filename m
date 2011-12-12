Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBCDvgog101164 for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 07:57:43 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1B9A22B58E8
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 05:57:41 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	CnxNxGAD4ujSU2tH for <xfs@oss.sgi.com>;
	Mon, 12 Dec 2011 05:57:41 -0800 (PST)
Date: Mon, 12 Dec 2011 08:57:37 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Bad performance with XFS + 2.6.38 / 2.6.39
Message-ID: <20111212135737.GA16264@infradead.org>
References: <CACaf2aYZ=k=x8sPFJs4f-4vQxs+qNyoO1EUi8X=iBjWjRhy99Q@mail.gmail.com>
	<20111211233929.GI14273@dastard>
	<CACaf2aYTsxOBXEJEbQu7gwAminBc3R2usDHvypJW0AqOfnz0Pg@mail.gmail.com>
	<20111212010053.GM14273@dastard>
	<CACaf2ab-YjXAFm767MmRU5iuOmvkqQW3ZTfQewD5SGvF-opgYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACaf2ab-YjXAFm767MmRU5iuOmvkqQW3ZTfQewD5SGvF-opgYQ@mail.gmail.com>
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
To: Xupeng Yun <xupeng@xupeng.me>
Cc: XFS group <xfs@oss.sgi.com>

On Mon, Dec 12, 2011 at 10:00:18AM +0800, Xupeng Yun wrote:
> On Mon, Dec 12, 2011 at 09:00, Dave Chinner <david@fromorbit.com> wrote:
> 
> > Oh, of course, now I remember what the problem is - it's a locking
> > issue that was fixed in 3.0.11, 3.1.5 and 3.2-rc1.
> >
> 
> Got it, thanks.

Btw, I'd recommend to stay on Linux 3.0-stable instead of 2.6.38 or
2.6.39 as it will actively get all bugfixes backported for a while.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
