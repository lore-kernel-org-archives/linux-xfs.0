Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9DNVt42160330 for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 18:31:59 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3CB6911A0C6B
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 16:33:26 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id wdAG98Fl9o3Kwcs7 for
	<xfs@oss.sgi.com>; Tue, 13 Oct 2009 16:33:26 -0700 (PDT)
Date: Tue, 13 Oct 2009 19:33:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Wrapped journal record corruption on read at recovery - patch
	attached (was Re: XFS corruption with failover)
Message-ID: <20091013233324.GA28942@infradead.org>
References: <mailman.0.1255458988.141519.xfs@oss.sgi.com>
	<alpine.DEB.2.00.0910131342440.11546@andydesk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910131342440.11546@andydesk>
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
To: Andy Poling <andy@realbig.com>
Cc: John Quigley <jquigley@cleversafe.com>, xfs@oss.sgi.com

Thanks Andy,

after starting over the code for over half an hour I think both
your analysis and the patch are correct.

-				bufaddr = XFS_BUF_PTR(hbp);
+				if (offset)
+					bufaddr = offset;
+				else
+					bufaddr = XFS_BUF_PTR(hbp);

However the way this is written is a bit confusing.  Probably less
confusing than some of the surrounding code,  but it adds up.

We calculate the offset for one case above, and then after we're done
with the reading that never touches offset we calculate it if we don't
have it.

So this at very least needs a big comment describing it, or even better
moving up the xlog_align call so that we can simply always use
offset directly, which could also get rid of the now superflous bufaddr
variable by always using offset.

Exactly the same also applies for the second use.

Anyway, thanks a lot again and if you can fix this up I'd welcome it,
otherwise I'll do it once I get some time.

I suspect we might even be able to come up with a small enough testcase
for this for xfsqa, we just need to make sure logs are aligned and then
find a good enough heuristic to reproduce log wrapping.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
