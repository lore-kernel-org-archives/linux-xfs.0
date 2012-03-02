Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q22EqwWO083548 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 08:52:58 -0600
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id Dif6gZf1iE9tAuPq for
	<xfs@oss.sgi.com>; Fri, 02 Mar 2012 06:52:57 -0800 (PST)
Date: Fri, 2 Mar 2012 14:52:58 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: [XFS] xfs_repair time how long it takes??
Message-ID: <20120302145258.GB12059@nsrc.org>
References: <CABF-5WptGU3vmScFcpHVstd2UZfCAqiY4dGvL=_1+feFvYuS6g@mail.gmail.com>
	<20120302140145.GA11911@nsrc.org>
	<37B5727D-1E3B-4A96-BF7F-4CA6DAF9B63C@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <37B5727D-1E3B-4A96-BF7F-4CA6DAF9B63C@gmail.com>
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
To: Ryan <ryanlee.lahk@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Mar 02, 2012 at 11:26:30PM +0900, Ryan wrote:
> How about the dirty log. I use the xfs_repair because the dirty log must be removed when i mount HDD.

Google for "xfs dirty log" and I get this as the second hit:

http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/6/html/Storage_Administration_Guide/xfsrepair.html

What it says is the exact opposite of what you said above:

- the dirty log is automatically dealt with when you mount the filesystem
- xfs_repair will refuse to run if a dirty log is present

So running xfs_repair on boot is actually a bad idea.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
