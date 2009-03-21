Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2LK8OxY011514 for <xfs@oss.sgi.com>; Sat, 21 Mar 2009 15:08:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED6631B4AD2
	for <xfs@oss.sgi.com>; Sat, 21 Mar 2009 13:08:06 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id P4QdTcW8d99wscD7 for
	<xfs@oss.sgi.com>; Sat, 21 Mar 2009 13:08:06 -0700 (PDT)
Date: Sat, 21 Mar 2009 16:08:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] xfs: kill ino64 mount option
Message-ID: <20090321200806.GA15245@infradead.org>
References: <20090318094119.561416000@bombadil.infradead.org>
	<20090318094132.076764000@bombadil.infradead.org>
	<49C4650B.4040509@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49C4650B.4040509@sandeen.net>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Mar 20, 2009 at 10:54:51PM -0500, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> 
> > The ino64 mount option adds a fixed offset to 32bit inode numbers
> > to bring them into the 64bit range.  There's no need for this kind
> > of debug tool given that it's easy to produce real 64bit inode numbers
> > for testing.
> 
> hm, easy how?

Actually test with a large enough device and let them spread evenly
over the AGs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
