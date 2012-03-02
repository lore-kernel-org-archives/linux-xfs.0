Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q22DClxw060703 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 07:12:47 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ygpWqhlxKGj3p6YG (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 02 Mar 2012 05:12:41 -0800 (PST)
Date: Fri, 2 Mar 2012 08:12:40 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: fsync, rename, O_ATOMIC/O_PONIES
Message-ID: <20120302131240.GA14186@infradead.org>
References: <4F50BF89.7020909@xwis.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F50BF89.7020909@xwis.net>
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
To: Olaf van der Spek <olaf@xwis.net>
Cc: xfs@oss.sgi.com

> I'd like to ask:
> - Is there a tool to log all unsafe operations?

What is an unsafe operation?  Anything that's dumb and might lose data?

The possibilities are sheer endless.

> - What is the *right* way to update a file?

 fd = open(tmpfile, ...);
 write(fd, ...);  // or any other update
 fdatasync(fd);
 rename(tmpfile, realfile);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
