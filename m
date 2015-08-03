Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 24F9929DF6
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 17:16:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E99BA8F8035
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 15:16:50 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	U9K9o8eBQG0anbHZ for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 15:16:44 -0700 (PDT)
Date: Tue, 4 Aug 2015 08:16:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 1/4] xfsprogs: Prefix LIST_... macros to XFS_LIST_...
Message-ID: <20150803221629.GT3902@dastard>
References: <1437397018-12864-1-git-send-email-jtulak@redhat.com>
	<1437397018-12864-2-git-send-email-jtulak@redhat.com>
	<20150802234250.GT16638@dastard>
	<1142980605.1953560.1438594488229.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1142980605.1953560.1438594488229.JavaMail.zimbra@redhat.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Aug 03, 2015 at 05:34:48AM -0400, Jan Tulak wrote:
> > From: "Dave Chinner" <david@fromorbit.com>
> > What macros, and how do we get them included in the build? I
> > shouldn't need to go and use google to work out why a change is
> > beign made....
> > 
> > This is supposed to match what is required for libxfs/ so we don't
> > have to modify the kernel code we bring across. Without knowing
> > exactly how we are including conflicting definitions from the OS X
> > include files, it's really hard to suggest other possible
> > solutions...
> > 
> 
> Ahh, sorry, I already wrote a reply to Chris, but it looks like 
> I pressed "save" instead "send" - I found it in drafts and not 
> in send emails. /shy

No worries, we all do silly things like that from time to time,
myself included.

> Sure, these:
> 
> ../include/xfs/list.h:32:9: warning: 'LIST_HEAD' macro redefined [-Wmacro-redefined]
> #define LIST_HEAD(name) \
>         ^
> /usr/include/sys/queue.h:417:9: note: previous definition is here
> #define LIST_HEAD(name, type)                                           \
>         ^
> (and the same for LIST_HEAD_INIT)
> 
> sys/queue.h is not linked directly, but from many system libraries. 
> A quick grep on /usr/include/ shows 24 header files including the queue,
> sys/mount.h one of them. And I didn't found a way how to avoid it.

Ok, so 4.4BSD introduced these years ago. Now it rings a bell, but I
can't find the relevant thread I'm thinking of (google has become
almost useless as a mailing list search engine in recent times).

I suspect that we are going to need an

#undef LIST_HEAD

somewhere in include/libxfs.h, libxfs/libxfs_priv.h and/or
include/list.h just to ensure we don't use the system definitions
(with a large comment explaining it).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
