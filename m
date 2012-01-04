Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q04GrnM0159262 for <xfs@oss.sgi.com>; Wed, 4 Jan 2012 10:53:49 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	tW1urTNteapk2vJE for <xfs@oss.sgi.com>;
	Wed, 04 Jan 2012 08:53:48 -0800 (PST)
Date: Wed, 4 Jan 2012 11:53:41 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests/071 FAIL with pwrite64: Invalid argument
Message-ID: <20120104165341.GA21075@infradead.org>
References: <4EDD8F16.4050402@cn.fujitsu.com> <20111206110533.GD28326@dastard>
	<4EDF2133.7030702@cn.fujitsu.com> <20111207100748.GB14273@dastard>
	<4EE02022.5000403@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4EE02022.5000403@cn.fujitsu.com>
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
To: Peng Haitao <penght@cn.fujitsu.com>
Cc: hch@infradead.org, xfs@oss.sgi.com

On Thu, Dec 08, 2011 at 10:25:38AM +0800, Peng Haitao wrote:
> 
> Dave Chinner said the following on 2011-12-7 18:07:
> > 
> > I think you misunderstand what I was saying - I was not suggesting
> > removing the error messages at all, just filtering them with sed to
> > ensure the output is always constant for the error different
> > messages different platforms dump out.
> > 
> 
> Thanks for your reply.
> Sorry for misunderstanding your comments.
> 
> I make a new patch, please review, thanks.

This still fails in my 32-bit test VM:

--- 071.out	2009-05-10 16:48:46.000000000 +0000
+++ 071.out.bad	2012-01-04 16:47:05.000000000 +0000
@@ -40,14 +40,14 @@
 
  
 Writing 512 bytes, offset is +0 (direct=false)
-pwrite64: File too large
+wrote 512/512 bytes at offset <OFFSET>
 Reading 512 bytes (direct=false)
-read 0/512 bytes at offset <OFFSET>
+read 512/512 bytes at offset <OFFSET>

and so on

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
