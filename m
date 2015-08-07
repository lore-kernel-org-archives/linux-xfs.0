Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9C6657F59
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 07:25:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 28D31AC002
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 05:25:11 -0700 (PDT)
Received: from p-smtp-as-01.sunrise.ch (p-smtp-as-01.sunrise.ch
	[212.35.39.69]) by cuda.sgi.com with ESMTP id 1naUHqCRXc2ghi44
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 07 Aug 2015 05:25:09 -0700 (PDT)
Message-ID: <55C4A3A4.5000306@vollmann.ch>
Date: Fri, 07 Aug 2015 14:25:08 +0200
From: Detlef Vollmann <dv@vollmann.ch>
MIME-Version: 1.0
Subject: Cross-compiling xfsprogs 3.2.x
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
To: xfs@oss.sgi.com

Cross-compiling xfsprogs 3.2.4 gives an error:
./gen_crc32table: cannot execute binary file: Exec format error
This makes sense as a binary built for the target can't run on
the build host.
Working around that isn't hard, however there's no way to run
crc32selftest sensibly and I have no idea whether tables built
on a little-endian 64-bit host will run on a big-endian 32-bit...

Also, I get nervous if I see all the warnings like:
readdir.c:77:2: warning: format '%lx' expects argument of type 'long unsigned int', but argument 2 
has type '__off64_t' [-Wformat=]
   printf(" d_off: 0x%08lx", dirent->d_off);


Any ideas?
   Detlef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
