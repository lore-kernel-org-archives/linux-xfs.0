Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 61D887F9B
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 03:39:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5055E304039
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 01:39:09 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id JnrFWxs5omOEdLFf (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Aug 2015 01:39:07 -0700 (PDT)
Date: Tue, 4 Aug 2015 04:38:42 -0400 (EDT)
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <2026707053.2526927.1438677522777.JavaMail.zimbra@redhat.com>
In-Reply-To: <20150803221629.GT3902@dastard>
References: <1437397018-12864-1-git-send-email-jtulak@redhat.com>
	<1437397018-12864-2-git-send-email-jtulak@redhat.com>
	<20150802234250.GT16638@dastard>
	<1142980605.1953560.1438594488229.JavaMail.zimbra@redhat.com>
	<20150803221629.GT3902@dastard>
Subject: Re: [PATCH v2 1/4] xfsprogs: Prefix LIST_... macros to XFS_LIST_...
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com



----- Original Message -----
> From: "Dave Chinner" <david@fromorbit.com>

> > /usr/include/sys/queue.h:417:9: note: previous definition is here
> > #define LIST_HEAD(name, type)                                           \
> >         ^
> > (and the same for LIST_HEAD_INIT)
> > 
> > sys/queue.h is not linked directly, but from many system libraries.
> > A quick grep on /usr/include/ shows 24 header files including the queue,
> > sys/mount.h one of them. And I didn't found a way how to avoid it.
> 
> Ok, so 4.4BSD introduced these years ago. Now it rings a bell, but I
> can't find the relevant thread I'm thinking of (google has become
> almost useless as a mailing list search engine in recent times).
> 
> I suspect that we are going to need an
> 
> #undef LIST_HEAD
> 
> somewhere in include/libxfs.h, libxfs/libxfs_priv.h and/or
> include/list.h just to ensure we don't use the system definitions
> (with a large comment explaining it).
> 

Great! Putting it in libxfs/list.h seems to be enough. This header should be
included anywhere where our lists are used, so I think there should be no
risk of using the system definition anymore. I'm making an updated patch.

Thanks for pointing on #undef. I'm sure I must have heard of it before, 
but as I never used it... :-)

Cheers,
Jan

-- 
Jan Tulak
jtulak@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
