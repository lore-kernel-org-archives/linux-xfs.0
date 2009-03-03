Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n23H3FMk024446 for <xfs@oss.sgi.com>; Tue, 3 Mar 2009 11:03:16 -0600
Date: Tue, 3 Mar 2009 12:02:48 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: next-20090220: XFS: inconsistent lock state
Message-ID: <20090303170248.GA7036@infradead.org>
References: <a4423d670902200952v5dc2fd91w3b54ab1db51a7fe2@mail.gmail.com>
	<20090224200740.GA9266@infradead.org> <49AD5401.30803@sandeen.net>
	<A277CB1C-4258-42EC-B1D9-F5CAAB962B42@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <A277CB1C-4258-42EC-B1D9-F5CAAB962B42@sgi.com>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, Alexander Beregalov <a.beregalov@gmail.com>

On Tue, Mar 03, 2009 at 10:57:07AM -0600, Felix Blyakher wrote:
> 	if (lock_flags) {
> 		if (!xfs_ilock_nowait(ip, lock_flags)) {
> 			ASSERT(0);
> 			error = EAGAIN;
> 			goto out_destroy;
> 		}
> 	}
> 				
> Or just keep the BUG(); , as it shouldn't happen (we hope).

Ok, let's keep the BUG for now and I'll throw in your error undwinding
fix.  Will resend the series for 2.6.29 patches after QAing them.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
