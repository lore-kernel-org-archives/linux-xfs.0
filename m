Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q24HDoVt008623 for <xfs@oss.sgi.com>; Sun, 4 Mar 2012 11:13:50 -0600
Received: from xwis.net (xwis.net [88.198.24.17]) by cuda.sgi.com with ESMTP
	id NKxSBp3m6jAaTykS (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 04 Mar 2012 09:13:47 -0800 (PST)
Message-ID: <4F53A2FF.3000305@xwis.net>
Date: Sun, 04 Mar 2012 18:14:39 +0100
From: Olaf van der Spek <olaf@xwis.net>
MIME-Version: 1.0
Subject: Re: fsync, rename, O_ATOMIC/O_PONIES
References: <4F50BF89.7020909@xwis.net> <20120302131240.GA14186@infradead.org>
In-Reply-To: <20120302131240.GA14186@infradead.org>
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
Cc: xfs@oss.sgi.com

On 2-3-2012 14:12, Christoph Hellwig wrote:
>> I'd like to ask:
>> - Is there a tool to log all unsafe operations?
>
> What is an unsafe operation?  Anything that's dumb and might lose data?

For example

> The possibilities are sheer endless.

And?

>> - What is the *right* way to update a file?
>
>   fd = open(tmpfile, ...);
>   write(fd, ...);  // or any other update
>   fdatasync(fd);
>   rename(tmpfile, realfile);

Argh, come on.
That's not real and it's not complete. tmpfile is undefined, errors 
aren't handled and you have lots of unlisted assumptions or regressions.

Olaf

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
