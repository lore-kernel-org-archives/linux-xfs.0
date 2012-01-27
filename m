Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0RBeZ0q166743 for <xfs@oss.sgi.com>; Fri, 27 Jan 2012 05:40:35 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	7qvuQP5AOXHpDa5I (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 27 Jan 2012 03:40:34 -0800 (PST)
Date: Fri, 27 Jan 2012 06:40:32 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: reserved blocks pool default size
Message-ID: <20120127114032.GA32236@infradead.org>
References: <4F22843E.4050804@open-e.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F22843E.4050804@open-e.com>
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
To: ??ukasz Ole?? <lukasz.oles@open-e.com>
Cc: xfs@oss.sgi.com

On Fri, Jan 27, 2012 at 12:02:22PM +0100, ??ukasz Ole?? wrote:
> Hi,
> 
> I updated kernel from 2.6.27 to 2.6.35 and noticed that free size on
> my xfs volume changed. Before update there was 7MB free space, now
> there is none.
> 
> After some investigation I found that default size for reserved
> block pool changed [1].
> On this volume I have one very big file which is exported as iSCSI
> disk via SCST and one small configuration file. The big file size
> will never change. Small file size can change only by some KB.
> 
> With this assumptions, can I revert this change and set reserved
> blocks pool size to 1024 blocks?

If it worked fine for your workload before it should work fine with
newer kernels, too.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
