Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 34B3E29E24
	for <xfs@oss.sgi.com>; Fri,  5 Apr 2013 12:28:10 -0500 (CDT)
Message-ID: <515F09BD.606@sgi.com>
Date: Fri, 5 Apr 2013 12:28:29 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: Check concurrently of readdir and read on the
	same directory fd
References: <515BC786.3070102@gmail.com>
In-Reply-To: <515BC786.3070102@gmail.com>
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
To: Zhao Hongjiang <zhaohongjiang37@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

Zhao,

Thanks for submitting this test.

Only two minor errors that will be corrected at commit time.

1. The new script used generate this test produces errors.
   No need to resubmit, this has already been fixed by
   commit 8575764a "xfstests: fix common source file path"

      QA output created by 310
     +./tests/generic/310: line 43: ./common.rc: No such file or directory
     +./tests/generic/310: line 44: ./common.filter: No such file or 
directory
     +./tests/generic/310: line 47: _supported_fs: command not found
     +./tests/generic/310: line 48: _supported_os: command not found

2. Whitespace errors
   Warning: trailing whitespace in line 18 of src/t_readdir_2.c
   Warning: trailing whitespace in lines 18,28 of src/t_readdir_1.c

   space before tab in indent. tests/generic/310
                                 	perror("Seek failed!");
warning: 1 line adds whitespace errors.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
