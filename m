Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5ALXmgM011757 for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 16:33:48 -0500
Received: from e8.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C0FB14B7A97
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 14:33:47 -0700 (PDT)
Received: from e8.ny.us.ibm.com (e8.ny.us.ibm.com [32.97.182.138]) by
	cuda.sgi.com with ESMTP id g41FIhz424xsIPT7 for
	<xfs@oss.sgi.com>; Fri, 10 Jun 2011 14:33:47 -0700 (PDT)
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e8.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5ALMY5Y000981
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 17:22:34 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5ALXkxF1445998
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 17:33:46 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p5ALXjFu019598 for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 18:33:46 -0300
Subject: Re: Failure of xfstests test case 202
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20110610211911.GA11509@infradead.org>
References: <1307738387.7661.450.camel@chandra-lucid.beaverton.ibm.com>
	<20110610211911.GA11509@infradead.org>
Date: Fri, 10 Jun 2011 14:33:44 -0700
Message-ID: <1307741624.7661.453.camel@chandra-lucid.beaverton.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: XFS Mailing List <xfs@oss.sgi.com>


On Fri, 2011-06-10 at 17:19 -0400, Christoph Hellwig wrote:
> On Fri, Jun 10, 2011 at 01:39:47PM -0700, Chandra Seetharaman wrote:
> > Hi all,
> > 
> > Test case 202 tries to create a single AG filesystem and runs xfs_repair
> > on it expecting it to fail.
> > 
> > But, when I run the test with a filesystem that is bigger than 1TB it
> > fails (not pleasantly) since the max AG size is 1TB.
> > 
> > I am thinking of the following solution, please let me know if there is
> > any other elegant fix.
> 
> What about:
> 
> #
> # The AG size is limited to 1TB (or even less with historic xfsprogs),
> # so chose a small enough filesystem to make sure we can actually create
> # a single AG filesystem.
> #
> _scratch_mkfs_sized `expr 1024 \* 1024 \* 1024`
> 
> instead?

Good point. Here is a solution based on your suggestion, but not using
_scratch_mkfs_sized (sincein the current context we need it to take
extra option, whereas _scratch_mkfs_sized takes fixed options).

What do you think ?

----------------
diff --git a/202 b/202
index cbdcb57..b982956 100755
--- a/202
+++ b/202
@@ -41,11 +41,18 @@ _supported_os Linux
 
 _require_scratch
 
+#
+# The AG size is limited to 1TB (or even less with historic xfsprogs),
+# so chose a small enough filesystem to make sure we can actually create
+# a single AG filesystem.
+#
 echo "== Creating single-AG filesystem =="
-_scratch_mkfs_xfs -d agcount=1 >/dev/null 2>&1
+_scratch_mkfs_xfs -d agcount=1 -d size=$((1024*1024*1024)) >/dev/null 2>&1 \
+ || _fail "!!! failed to make filesystem with single AG"
 
 echo "== Trying to repair it (should fail) =="
-_scratch_xfs_repair
+_scratch_xfs_repair \
+ && _fail "!!! xfs_repair of single AG filesystem succeeded. Expected to fail."
 
 echo "== Trying to repair it with -o force_geometry =="
 _scratch_xfs_repair -o force_geometry 2>&1 | _filter_repair
-----------------------
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
