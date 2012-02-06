Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q16IfQ33156267 for <xfs@oss.sgi.com>; Mon, 6 Feb 2012 12:41:27 -0600
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id NMqAIedVI3WI1WKo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 Feb 2012 10:41:25 -0800 (PST)
Message-ID: <4F301E8B.7050909@oracle.com>
Date: Mon, 06 Feb 2012 10:40:11 -0800
From: Sunil Mushran <sunil.mushran@oracle.com>
MIME-Version: 1.0
Subject: Re: sparsify - utility to punch out blocks of 0s in a file
References: <4F2D8F30.3090802@redhat.com>
In-Reply-To: <4F2D8F30.3090802@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, ocfs2-devel@oss.oracle.com, xfs-oss <xfs@oss.sgi.com>

On 02/04/2012 12:04 PM, Eric Sandeen wrote:
> Now that ext4, xfs,&  ocfs2 can support punch hole, a tool to
> "re-sparsify" a file by punching out ranges of 0s might be in order.
>
> I whipped this up fast, it probably has bugs&  off-by-ones but thought
> I'd send it out.  It's not terribly efficient doing 4k reads by default
> I suppose.
>
> I'll see if util-linux wants it after it gets beat into shape.
> (or did a tool like this already exist and I missed it?)
>
> (Another mode which does a file copy, possibly from stdin
> might be good, like e2fsprogs/contrib/make-sparse.c ?  Although
> that can be hacked up with cp already).
>
> It works like this:
>
> [root@inode sparsify]# ./sparsify  -h
> Usage: sparsify [-m min hole size] [-o offset] [-l length] filename


So I have a similar tool queued up in ocfs2-tools. Named puncher.
http://oss.oracle.com/git/?p=ocfs2-tools.git;a=shortlog;h=puncher

I'll pull it out if we get something in util-linux. But maybe you can 
extract something useful from it.

Like.... maybe doing dry-run as default. It is an inplace modification
after all. Also using a large hole size as default (1MB). Over using 
hole punching will negatively affect read performance. We should make 
the sane choice for the user.

On a related note, it may make sense for ext4 to populate the cluster 
size (bigalloc) in stat.st_blksize.

2 cents...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
