Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qARM8u4g096698 for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 16:08:56 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	UsiOKRBDatCS25AD (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 Nov 2012 14:11:13 -0800 (PST)
Date: Tue, 27 Nov 2012 17:11:11 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: test EROFS vs. EEXIST when creating on an RO
	filesystem
Message-ID: <20121127221111.GA13753@infradead.org>
References: <50B52DB7.3030506@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50B52DB7.3030506@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Nov 27, 2012 at 03:16:39PM -0600, Eric Sandeen wrote:
> TBH, I don't know if this is posix-specified, but I found out the
> hard way that when trying to re-create existing files on a readonly 
> filesystem, some apps expect/handle EEXIST, but fail on EROFS.
> 
> This will test mkdir, mknod, and symlinks for that behavior.

Just curious, which filesystem would fail this currently or did in the
past?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
