Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 693AD7F37
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 03:37:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 567168F8037
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 01:37:05 -0700 (PDT)
Received: from mail-ie0-f182.google.com (mail-ie0-f182.google.com
	[209.85.223.182]) by cuda.sgi.com with ESMTP id
	j0eJlVXePjOOpeks (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 01:37:04 -0700 (PDT)
Received: by mail-ie0-f182.google.com with SMTP id a14so8644537iee.13
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 01:37:04 -0700 (PDT)
Message-ID: <5195EC13.2060502@gmail.com>
Date: Fri, 17 May 2013 04:36:35 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 7/8] xfs: Add xfs_log_rlimit.[c|h]
References: <5195C279.3060502@oracle.com>
In-Reply-To: <5195C279.3060502@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 05/17/2013 01:39 AM, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
>
> Add source files for xfs_log_rlimit.[c|h].
> The new source would be used for the log space validation.

Update:  To build the kernel, I'm getting by on a sysadmin hack that 
looks like this:

--- linux/fs/xfs/xfs_log_rlimit.c.orig	2013-05-17 03:36:28.983493357 -0400
+++ linux/fs/xfs/xfs_log_rlimit.c	2013-05-17 04:21:07.090661828 -0400
@@ -127,8 +127,10 @@
  	 * Also, the log size should be a multiple of the log stripe unit, round
  	 * it up to lsunit boundary if lsunit is specified.
  	 */
-	minlblks = lsunit ? (roundup(BTOBB(maxlres), lsunit) + 2 * lsunit) * 2 :
-			    BTOBB(maxlres) * 2;
+	minlblks = lsunit ?
+		(roundup((const int)(BTOBB(maxlres)), lsunit) +
+		2 * lsunit) * 2 :
+			BTOBB(maxlres) * 2;

  	if (log->l_logBBsize < minlblks) {
  		xfs_crit(mp,

However, that makes no sense.  There is a roundup in <linux/kernel.h> 
that goes like this:

/* The `const' in roundup() prevents gcc-3.3 from calling __divdi3 */
#define roundup(x, y) (                                 \
{                                                       \
         const typeof(y) __y = y;                        \
         (((x) + (__y - 1)) / __y) * __y;                \
}                                                       \
)

Okay, so that gave me the inspiration to cast the type so gcc-4.8.0 
wouldn't call __divdi3.  But why did this make a difference?

Disclaimer:  I'm not a C macro guru, so I don't know which random 
sequence of punctuation keys would make roundup() happy.

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
