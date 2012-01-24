Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0OHj3IW059202 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 11:45:04 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Z2SUgmD7LQ4b2Jho (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jan 2012 09:45:02 -0800 (PST)
Date: Tue, 24 Jan 2012 12:45:00 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: mount other filesystems with selinux context
	as well
Message-ID: <20120124174500.GB9853@infradead.org>
References: <4ECD3262.105@redhat.com> <20111128110228.GC13766@infradead.org>
	<4F1862FC.1050401@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F1862FC.1050401@sandeen.net>
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
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Thu, Jan 19, 2012 at 12:37:48PM -0600, Eric Sandeen wrote:
> > shouldn't the "export SELINUX_MOUNT_OPTIONS" simply move to common code?
> 
> I wasn't sure if nfs would grok it.

I don't think it does - selinux needs special handling for filesystems
that do not support xattrs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
