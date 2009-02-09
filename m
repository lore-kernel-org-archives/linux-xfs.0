Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n193HMkI215452
	for <linux-xfs@oss.sgi.com>; Sun, 8 Feb 2009 21:17:23 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 93EE518F222E
	for <linux-xfs@oss.sgi.com>; Sun,  8 Feb 2009 19:16:45 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id kCCdCsJZnxjCZgDN for <linux-xfs@oss.sgi.com>;
	Sun, 08 Feb 2009 19:16:45 -0800 (PST)
Message-ID: <498F9AC2.2020703@sandeen.net>
Date: Sun, 08 Feb 2009 20:53:54 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS kernel BUG at fs/buffer.c:470! with 2.6.28.4
References: <1234011974.7435.11.camel@champagne.cantina>	<20090208222859.GA2532@infradead.org>	<1234132752.12370.0.camel@champagne.cantina>	<20090208224249.GA11931@infradead.org>
	<1234133120.12370.7.camel@champagne.cantina>
	<498F9A53.3090409@sandeen.net>
In-Reply-To: <498F9A53.3090409@sandeen.net>
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
To: Alessandro Bono <alessandro.bono@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@oss.sgi.com>, linux-kernel <linux-kernel@vger.kernel.org>

Eric Sandeen wrote:
> Alessandro Bono wrote:

..

>> sure, attached
> 
> Well, that seems to not be from the kernel you were running; there is no
> BUG() on line 470:
> 
> $ cat -n buffer.c | grep -8 "   470"
>    462				       bdevname(bh->b_bdev, b));
>    463			}
>    464			set_bit(AS_EIO, &page->mapping->flags);
>    465			set_buffer_write_io_error(bh);
>    466			clear_buffer_uptodate(bh);
>    467			SetPageError(page);
>    468		}
>    469	
>    470		first = page_buffers(page);

oh, oops :)  it's probably this BUG():

#define page_buffers(page)                                      \
        ({                                                      \
                BUG_ON(!PagePrivate(page));                     \


-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
