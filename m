Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 17E147F5D
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 10:22:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CC4FB304043
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 08:22:01 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id nBjVlKmmEpP355j8 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Jun 2015 08:22:00 -0700 (PDT)
Date: Fri, 19 Jun 2015 08:21:59 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mkfs.xfs: always use underlying fs sector size when
	mkfs'ing a file
Message-ID: <20150619152159.GA3939@infradead.org>
References: <55820229.1010701@redhat.com>
	<14667996.16447259.1434625419793.JavaMail.zimbra@redhat.com>
	<20150619150904.GB22842@infradead.org>
	<55843276.5020804@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55843276.5020804@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>, Jan Tulak <jtulak@redhat.com>

On Fri, Jun 19, 2015 at 10:17:10AM -0500, Eric Sandeen wrote:
> though we also claim to nominally support building on osx, irix, etc,
> which doesn't have that library, right?

Debian supports it for kfreebsd and hurd, and
https://trac.macports.org/ticket/15546 suggest an older version did
build on OS X.  So I don't think it's a real problem even if IRIX
might require some minor porting efforts.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
