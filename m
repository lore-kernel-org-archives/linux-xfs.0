Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D91787CA0
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 13:20:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9ED238F8035
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 11:20:04 -0700 (PDT)
Received: from mx6-phx2.redhat.com (mx6-phx2.redhat.com [209.132.183.39]) by
	cuda.sgi.com with ESMTP id OkEL7jyhfNw113O2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 May 2016 11:20:02 -0700 (PDT)
Date: Thu, 26 May 2016 14:19:57 -0400 (EDT)
From: Bob Peterson <rpeterso@redhat.com>
Message-ID: <1391795572.11287486.1464286797723.JavaMail.zimbra@redhat.com>
In-Reply-To: <20160524131058.GA21094@lst.de>
References: <1462783638-4968-1-git-send-email-hch@lst.de>
	<1462783638-4968-10-git-send-email-hch@lst.de>
	<1651455378.10041082.1464034166002.JavaMail.zimbra@redhat.com>
	<20160524131058.GA21094@lst.de>
Subject: Re: [PATCH 09/15] fs: iomap based fiemap implementation
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, vishal l verma <vishal.l.verma@intel.com>, xfs@oss.sgi.com

----- Original Message -----
| On Mon, May 23, 2016 at 04:09:26PM -0400, Bob Peterson wrote:
| > I've been looking at this again. Where are the calls to the fs-specific
| > bits
| > for fiemap?
| 
| In the iomap_ops structure passed to iomap_fiemap.
| 
| > It looks like iomap_fiemap calls iomap_apply, which calls
| > iomap_fiemap_actor, but that doesn't call any ops->iomap_get_iomap or
| > similar.
| > It calls the iomap_begin (which BTW has a comment that says "Execute a
| > iomap
| > write" which is probably wrong and should be more generic, as for cases
| > like
| > fiemap) and it calls iomap_end. But it never calls an fs-specific actor
| > anywhere. Am I missing something? My earlier version passed in the actor
| > function, as per Dave Chinner's request, but yours doesn't.
| 
| The iomap_begin callback is where you do the mapping.  the iomap_end
| callback does any required cleanup, which in case of GFS2 probably
| would be dropping the cluster lock protecting the mapping.
| 

Okay, got it. So a couple things:

1. I verified that the vfs bits of the patch set work properly for GFS2
   using a modified iomap-based fiemap. And it's fast.
2. I'm not sure I like the fact that instead of begin->main->end it is
   essentially begin->end with begin doing all the work. It works, and
   it's better than we have today. But I'd prefer either renaming the
   first function from "iomap_begin" to something that indicates it's
   more than just a precursor to the actual function? Or else split it
   into begin->main->end? I was kinda hoping to pass in the iomap_actor
   somehow. It's not a tragic loss, but the way I've got the gfs2
   function coded, the begin function does: locking plus the main
   functionality, and all the fiemap_end function basically does is unlock.
3. I had to do something like this to get "make menuconfig" to work:
index 276fcfb..daa129c 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -11,7 +11,7 @@ config DCACHE_WORD_ACCESS
 if BLOCK
 
 config FS_IOMAP
-	bool
+	bool "File IOMAP Support"

4. I don't suppose you could split this patch set up so that the vfs
   bits are independent, so someone like Al Viro could grab them
   rather than getting pulled along size the xfs-specific bits?
   (Which is essentially what I've done for GFS2; I did not drag in
   all the xfs bits).

Regards,

Bob Peterson
Red Hat File Systems

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
