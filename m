Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1E2EsCS092456 for <xfs@oss.sgi.com>; Sun, 13 Feb 2011 20:14:54 -0600
Received: from cpoproxy2-pub.bluehost.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id B75D81AC6E5B
	for <xfs@oss.sgi.com>; Sun, 13 Feb 2011 18:17:31 -0800 (PST)
Received: from cpoproxy2-pub.bluehost.com (cpoproxy2-pub.bluehost.com
	[67.222.39.38]) by cuda.sgi.com with SMTP id Ilh3IQWPncoesWgN
	for <xfs@oss.sgi.com>; Sun, 13 Feb 2011 18:17:31 -0800 (PST)
Message-ID: <4D5890B6.2090105@tao.ma>
Date: Mon, 14 Feb 2011 10:17:26 +0800
From: Tao Ma <tm@tao.ma>
MIME-Version: 1.0
Subject: Re: XFS status update for January 2011
References: <20110213184219.GA22792@infradead.org>
In-Reply-To: <20110213184219.GA22792@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Christoph,
On 02/14/2011 02:42 AM, Christoph Hellwig wrote:
> On the 4th of January we saw the release of Linux 2.6.37, which contains a
> large XFS update:
>
>      67 files changed, 1424 insertions(+), 1524 deletions(-)
>
> User visible changes are the new XFS_IOC_ZERO_RANGE ioctl which allows
> to convert already allocated space into unwritten extents that return
> zeros on a read,
>    
would you mind describing some scenario that this ioctl can be used. I am
just wondering whether ocfs2 can implement it as well.

Regards,
Tao

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
