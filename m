Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qARMH1bP098129 for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 16:17:01 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	3yYQBH6XJni42lEY (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 Nov 2012 14:19:17 -0800 (PST)
Date: Tue, 27 Nov 2012 17:19:16 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: test EROFS vs. EEXIST when creating on an RO
	filesystem
Message-ID: <20121127221916.GA18665@infradead.org>
References: <50B52DB7.3030506@redhat.com>
	<20121127221111.GA13753@infradead.org>
	<50B53AEA.3080102@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50B53AEA.3080102@redhat.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Tue, Nov 27, 2012 at 04:12:58PM -0600, Eric Sandeen wrote:
> No single filesystem, really - 
> 
> I temporarily broke the VFS in a rhel backport.  ;)  But it seems like
> the kind of thing that could be missed in the future, so figured it was
> worth a quick test.

That's what I wonder about, I was pretty sure we'd normmally do these
checks in the VFS, and I haven't seen any reason changes from you in
the area.

I'm fine with adding this test, btw.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
