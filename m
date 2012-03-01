Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q21Kv7Tl182879 for <xfs@oss.sgi.com>; Thu, 1 Mar 2012 14:57:07 -0600
Received: from busoni.debian.org (busoni.debian.org [140.211.15.34]) by
	cuda.sgi.com with ESMTP id FwX7BnHHvDWtEjHr (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 01 Mar 2012 12:57:06 -0800 (PST)
Subject: Bug#661580: mkfs.xfs fails to detect correct sector size
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.661580.B661580.133063534927369@bugs.debian.org>
Message-ID: <4F4FE24C.6050304@sandeen.net>
Date: Thu, 01 Mar 2012 14:55:40 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
References: <20120301081409.3103.43155.reportbug@frosties.localnet>
	<20120301083345.GA24409@infradead.org>
In-Reply-To: <20120301083345.GA24409@infradead.org>
Reply-To: Eric Sandeen <sandeen@sandeen.net>, 661580@bugs.debian.org
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
To: Christoph Hellwig <hch@infradead.org>, 661580@bugs.debian.org
Cc: Goswin von Brederlow <goswin-v-b@web.de>

On 3/1/12 2:33 AM, Christoph Hellwig wrote:
> On Thu, Mar 01, 2012 at 09:14:09AM +0100, Goswin von Brederlow wrote:
>> And I can confirm that the sector size detection is still broken in
>> 3.1.7.
> 
> That's a known bug that Carlos wanted to look into.  If you really can't
> accept smaller I/O without major pain make sure to use a larger logical
> blocksize, which should be handled fine by everything.

Carlos is a bit busy right now, I'll send a patch shortly; want to whip
up an xfstest for this too.

-Eric


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
