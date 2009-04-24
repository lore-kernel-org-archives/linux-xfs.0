Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3OHpcaN094051 for <xfs@oss.sgi.com>; Fri, 24 Apr 2009 12:51:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 049C31CE651F
	for <xfs@oss.sgi.com>; Fri, 24 Apr 2009 10:51:36 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id J01Jf8yAmpw3hsjn for
	<xfs@oss.sgi.com>; Fri, 24 Apr 2009 10:51:36 -0700 (PDT)
Date: Fri, 24 Apr 2009 13:51:35 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: fix 130, 132 for inifinitely-fast disks
Message-ID: <20090424175135.GA32198@infradead.org>
References: <49F0B379.2060309@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49F0B379.2060309@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Thu, Apr 23, 2009 at 01:29:13PM -0500, Eric Sandeen wrote:
> Due to the new quantum/holographic storage I'm testing, my 
> disks go infinitely fast, thereby breaking some filters:
> 
> -XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +3 KiB, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 
> I'm no regexp expert but I think the below change will fix it.

Looks good to me.  I used to see this too when running xfsqa under qemu
(with really fast disk (=host pagecache) and a really slow cpu..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
