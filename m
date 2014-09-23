Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 44B3229DF9
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 12:25:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 226098F8052
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 10:25:34 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id aJxQaOYC7vlXRpbu for <xfs@oss.sgi.com>;
	Tue, 23 Sep 2014 10:25:32 -0700 (PDT)
Message-ID: <5421AD0F.4040109@sandeen.net>
Date: Tue, 23 Sep 2014 12:25:35 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: compiling xfs-progs 3.2.x
References: <20140923184149.05a57dba@harpe.intellique.com>
In-Reply-To: <20140923184149.05a57dba@harpe.intellique.com>
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
To: Emmanuel Florac <eflorac@intellique.com>, xfs@oss.sgi.com

On 9/23/14 11:41 AM, Emmanuel Florac wrote:
> 
> Hi list,
> xfs-progs 3.1.x compile easily, however I can't get around compiling
> 3.2.x (debian 7.6) :
> 
>  ./configure
> ./configure: line 2098: AC_PROG_LIBTOOL: command not found
> ./configure: line 2204: syntax error near unexpected token `xfsprogs'
> ./configure: line 2204: `AC_PACKAGE_GLOBALS(xfsprogs)'
> 
> Any hint on where to start would be appreciated. Libtool version is the
> same as testing and unstable (2.4.2).
> 
> Thanks,
> 

I'm not at all autoconf savvy, so just guessing here.

there were very few changes to configure.ac since v3.1.11:


diff --git a/configure.ac b/configure.ac
index b968977..ae17c68 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,4 +1,4 @@
-AC_INIT([xfsprogs], [3.1.11])
+AC_INIT([xfsprogs], [3.2.0-alpha2])
 AC_PREREQ(2.50)
 AC_CONFIG_AUX_DIR([.])
 AC_CONFIG_MACRO_DIR([m4])
@@ -112,12 +112,14 @@ AC_HAVE_FIEMAP
 AC_HAVE_PREADV
 AC_HAVE_SYNC_FILE_RANGE
 AC_HAVE_BLKID_TOPO($enable_blkid)
+AC_HAVE_READDIR
 
 AC_CHECK_SIZEOF([long])
 AC_CHECK_SIZEOF([char *])
 AC_TYPE_PSINT
 AC_TYPE_PSUNSIGNED
 AC_TYPE_U32
+AC_TYPE_UMODE_T
 AC_MANUAL_FORMAT
 
 AC_CONFIG_FILES([include/builddefs])


if you do a make realclean & re-make, does it help?  (if you check out v3.1.11 and do the same, does it still build?)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
