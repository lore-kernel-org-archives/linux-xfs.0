Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 943A87F37
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 14:17:15 -0500 (CDT)
Received: from eagdhcp-232-136.americas.sgi.com
	(eagdhcp-232-136.americas.sgi.com [128.162.232.136])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 732EE304075
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 12:17:15 -0700 (PDT)
Message-ID: <51B0E03B.3010303@sgi.com>
Date: Thu, 06 Jun 2013 14:17:15 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/1] xfs: xfs_inactive fails to cleanup symlinks with
	attributes
References: <20130606161032.753011157@sgi.com>
In-Reply-To: <20130606161032.753011157@sgi.com>
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

On 06/06/13 11:10, Mark Tinguely wrote:
> Found this bug testing extended attributes.
>
> # make a big symbolic link that is in the inode core and mostly fills it.
> # CRC enabled filesystem will use a 68 byte smaller link in the test.
>
> ln -s 1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/0123456/a a
>
> # the extended attribute will bump the symbolic link to a remote extent
> # I think only one of these attribute is needed, but they are so fun...
> attr  -Rs 1234567890ad a<  /dev/null
> attr  -Rs 1234567890ae a<  /dev/null
> attr  -Rs 1234567890af a<  /dev/null
>

oops. the following steps are also needed - I took them out because I
thought they were unecessary:

# remove the attributes:
attr  -Rr 1234567890ad a
attr  -Rr 1234567890ae a
attr  -Rr 1234567890af a

now we will assert

> # the following remove will assert a debug kernel:
> #  XFS: Assertion failed: ip->i_d.di_nextents == 0, file: fs/xfs/xfs_inode.c, line: 2036
>
> rm a
>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
