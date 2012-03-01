Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q218a6U1093993 for <xfs@oss.sgi.com>; Thu, 1 Mar 2012 02:36:06 -0600
Received: from busoni.debian.org (busoni.debian.org [140.211.15.34]) by
	cuda.sgi.com with ESMTP id alP21istvvAqv3tw (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 01 Mar 2012 00:36:05 -0800 (PST)
Subject: Bug#661580: mkfs.xfs fails to detect correct sector size
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.661580.B661580.133059082931306@bugs.debian.org>
Date: Thu, 1 Mar 2012 03:33:45 -0500
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20120301083345.GA24409@infradead.org>
References: <20120301081409.3103.43155.reportbug@frosties.localnet>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120301081409.3103.43155.reportbug@frosties.localnet>
Reply-To: Christoph Hellwig <hch@infradead.org>, 661580@bugs.debian.org
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
To: Goswin von Brederlow <goswin-v-b@web.de>, 661580@bugs.debian.org

On Thu, Mar 01, 2012 at 09:14:09AM +0100, Goswin von Brederlow wrote:
> And I can confirm that the sector size detection is still broken in
> 3.1.7.

That's a known bug that Carlos wanted to look into.  If you really can't
accept smaller I/O without major pain make sure to use a larger logical
blocksize, which should be handled fine by everything.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
