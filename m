Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBDHmgvY011017 for <xfs@oss.sgi.com>; Sat, 13 Dec 2008 11:48:42 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D09C3172B973
	for <xfs@oss.sgi.com>; Sat, 13 Dec 2008 09:48:41 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id nWsS2t7j8KNCcSfn for <xfs@oss.sgi.com>;
	Sat, 13 Dec 2008 09:48:41 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id CF80EA9C9C3
	for <xfs@oss.sgi.com>; Sat, 13 Dec 2008 11:48:07 -0600 (CST)
Message-ID: <4943F558.4070701@sandeen.net>
Date: Sat, 13 Dec 2008 11:48:08 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix corruption case for block size < page size
References: <49435F35.40109@sandeen.net>
In-Reply-To: <49435F35.40109@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:

> Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c
> +++ xfs/fs/xfs/linux-2.6/xfs_aops.c
> @@ -1042,6 +1042,13 @@ xfs_page_state_convert(
>  			continue;
>  		}
>  
> +		/* This means its a hole (discard_buffer leaves uptodate set) */
>   
I've offended cw's sense of grammar, and I did cringe when I removed
the apostrophe in the name of an 80char line, so how about this :)

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c
@@ -1042,6 +1042,13 @@ xfs_page_state_convert(
 			continue;
 		}
 
+		/* It's a hole. (discard_buffer leaves uptodate set) */
+		if (!buffer_dirty(bh) && !buffer_mapped(bh) &&
+		    buffer_uptodate(bh)) {
+			iomap_valid = 0;
+			continue;
+		}
+
 		if (iomap_valid)
 			iomap_valid = xfs_iomap_valid(&iomap, offset);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
