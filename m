Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB53Mapc029093 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 21:22:36 -0600
Message-ID: <49389E8F.5000301@sgi.com>
Date: Fri, 05 Dec 2008 14:22:55 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Use the incore inode size in xfs_file_readdir()
References: <49377FBC.5020501@sgi.com> <20081204070827.GB29531@infradead.org>
In-Reply-To: <20081204070827.GB29531@infradead.org>
Reply-To: lachlan@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Thu, Dec 04, 2008 at 05:59:08PM +1100, Lachlan McIlroy wrote:
>> We should be using the incore inode size here not the linux inode
>> size.  The incore inode size is always up to date for directories
>> whereas the linux inode size is not updated for directories.
>>
>> We've hit assertions in xfs_bmap() and traced it back to the linux
>> inode size being zero here but the incore size being correct.
> 
> Heh. Looks good, but you can still call ->readdir with a 0 inode size,
> so you might want to check for that (actualyl I think other pathes
> are goign to take care of it, but..)

What if we remove bufsize and pass PAGE_SIZE into xfs_readdir()?
No need to worry about a 0 inode size.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
