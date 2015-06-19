Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AF55E7F5D
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 10:24:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 49B24AC001
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 08:24:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vrflxggOHs496Pb7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Jun 2015 08:24:45 -0700 (PDT)
Message-ID: <5584343A.3040008@redhat.com>
Date: Fri, 19 Jun 2015 10:24:42 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] mkfs.xfs: always use underlying fs sector size when
	mkfs'ing a file
References: <55820229.1010701@redhat.com>
	<14667996.16447259.1434625419793.JavaMail.zimbra@redhat.com>
	<20150619150904.GB22842@infradead.org>
	<55843276.5020804@redhat.com> <20150619152159.GA3939@infradead.org>
In-Reply-To: <20150619152159.GA3939@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>, Jan Tulak <jtulak@redhat.com>

On 6/19/15 10:21 AM, Christoph Hellwig wrote:
> On Fri, Jun 19, 2015 at 10:17:10AM -0500, Eric Sandeen wrote:
>> though we also claim to nominally support building on osx, irix, etc,
>> which doesn't have that library, right?
> 
> Debian supports it for kfreebsd and hurd, and
> https://trac.macports.org/ticket/15546 suggest an older version did
> build on OS X.  So I don't think it's a real problem even if IRIX
> might require some minor porting efforts.
> 

Ok.  And honestly, building xfsprogs on OSX seems like nothing
more than a curiosity ...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
