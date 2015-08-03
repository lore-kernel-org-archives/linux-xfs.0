Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 84A9D7F6A
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 04:35:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 73D0E8F8066
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 02:35:22 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id srrORWElGlr8SMGI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 02:35:20 -0700 (PDT)
Date: Mon, 3 Aug 2015 05:34:48 -0400 (EDT)
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <1142980605.1953560.1438594488229.JavaMail.zimbra@redhat.com>
In-Reply-To: <20150802234250.GT16638@dastard>
References: <1437397018-12864-1-git-send-email-jtulak@redhat.com>
	<1437397018-12864-2-git-send-email-jtulak@redhat.com>
	<20150802234250.GT16638@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com



----- Original Message -----
> From: "Dave Chinner" <david@fromorbit.com>
> What macros, and how do we get them included in the build? I
> shouldn't need to go and use google to work out why a change is
> beign made....
> 
> > 
> > 
> > 
> 
> This is supposed to match what is required for libxfs/ so we don't
> have to modify the kernel code we bring across. Without knowing
> exactly how we are including conflicting definitions from the OS X
> include files, it's really hard to suggest other possible
> solutions...
> 

Ahh, sorry, I already wrote a reply to Chris, but it looks like 
I pressed "save" instead "send" - I found it in drafts and not 
in send emails. /shy

I will edit the commit message appropriately when resubmitting.

The conflicting macros are LIST_HEAD and LIST_HEAD_INIT.

Here is the reply I didn't sent:

----- Original Message -----
> From: "Christoph Hellwig" <hch@infradead.org>
> 
> Can you post the compiler warnings you see without this patch?
> 

Sure, these:

../include/xfs/list.h:32:9: warning: 'LIST_HEAD' macro redefined [-Wmacro-redefined]
#define LIST_HEAD(name) \
        ^
/usr/include/sys/queue.h:417:9: note: previous definition is here
#define LIST_HEAD(name, type)                                           \
        ^
(and the same for LIST_HEAD_INIT)

sys/queue.h is not linked directly, but from many system libraries. 
A quick grep on /usr/include/ shows 24 header files including the queue,
sys/mount.h one of them. And I didn't found a way how to avoid it.

If you have an idea what else to to with it, I'm happy to try it.

Cheers,
Jan

-- 
Jan Tulak
jtulak@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
