Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3FHZcKj081548 for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 12:35:39 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CBAFE50E4B0
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 10:39:02 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 5ETyUx4myOpJHBjI for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2011 10:39:02 -0700 (PDT)
Date: Fri, 15 Apr 2011 13:39:02 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs build warning
Message-ID: <20110415173902.GA27378@infradead.org>
References: <4DA876C2.8050606@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DA876C2.8050606@oracle.com>
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
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Apr 15, 2011 at 09:48:02AM -0700, Randy Dunlap wrote:
> on i386, when CONFIG_LBDAF is not enabled:
> 
> fs/xfs/linux-2.6/./xfs_trace.h:1354: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t'

This should fix it:

Index: linux-2.6/fs/xfs/linux-2.6/xfs_trace.h
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_trace.h	2011-04-15 19:29:11.569340965 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_trace.h	2011-04-15 19:30:09.679026159 +0200
@@ -1418,7 +1418,7 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
 		  __entry->wasfromfl,
 		  __entry->isfl,
 		  __entry->userdata,
-		  __entry->firstblock)
+		  (unsigned long long)__entry->firstblock)
 )
 
 #define DEFINE_ALLOC_EVENT(name) \

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
