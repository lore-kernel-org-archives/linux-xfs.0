Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3JLbsLt010729 for <xfs@oss.sgi.com>; Sun, 19 Apr 2009 16:37:55 -0500
Date: Sun, 19 Apr 2009 17:37:48 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: add more checks to superblock validation
Message-ID: <20090419213748.GA10191@infradead.org>
References: <1240002765-20279-1-git-send-email-felixb@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1240002765-20279-1-git-send-email-felixb@sgi.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Apr 17, 2009 at 04:12:45PM -0500, Felix Blyakher wrote:
> From: Olaf Weber <olaf@sgi.com>
> 
> There had been reports where xfs filesystem was randomly
> corrupted with fsfuzzer, and xfs failed to handle it
> gracefully. This patch fixes couple of reported problem
> by providing additional checks in the superblock
> validation routine.

Looks good.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
