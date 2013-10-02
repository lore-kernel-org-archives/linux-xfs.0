Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9018E7F59
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 23:17:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 723538F8040
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 21:17:38 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id zbIygzA1LbDSxcYt for <xfs@oss.sgi.com>;
	Tue, 01 Oct 2013 21:17:37 -0700 (PDT)
Message-ID: <524B9E5F.9090906@sandeen.net>
Date: Tue, 01 Oct 2013 23:17:35 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsrestore: fix multi stream support
References: <524AF8AE.5030300@sgi.com> <524B34D4.10807@sandeen.net>
	<524B4119.8020005@sgi.com> <524B4677.40200@sgi.com>
	<524B99AD.5000408@sandeen.net>
In-Reply-To: <524B99AD.5000408@sandeen.net>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 10/1/13 10:57 PM, Eric Sandeen wrote:

> #!/bin/bash
> 
> # paths to binaries under test
> DUMP=/mnt/test2/git/xfsdump/dump/xfsdump
> RESTORE=/mnt/test2/git/xfsdump/restore/xfsrestore
> 
> # what we'll create files in & dump
> DUMPDIR=/mnt/test
> # where we'll restore
> RESTOREDIR=/mnt/test2/restore
> 
> mkdir -p $DUMPDIR/dir
> mkdir -p $RESTOREDIR
> 
> clean () {
> 	rm -rf $DUMPDIR/dir/*
> 	rm -rf $RESTOREDIR/*x
> }
> 
> clean
> 
> xfs_io -f -c "pwrite 4k 4km" $DUMPDIR/dir/8ksparsefront

whoops typo, that should be "4k 4k" 

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
