Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0ABBF7F6A
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 08:34:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DF09D8F8068
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 06:34:13 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id P8wBYCjudfPvAC2G for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 06:34:09 -0700 (PDT)
Message-ID: <542C02D1.3090809@sandeen.net>
Date: Wed, 01 Oct 2014 08:34:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfstests test xfs/030 failure
References: <20141001094539.GD17405@quack.suse.cz>
In-Reply-To: <20141001094539.GD17405@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On 10/1/14 4:45 AM, Jan Kara wrote:
>   Hello,
> 
>   I'm getting failure for text xfs/030 like:
> xfs/030 9s ... - output mismatch (see /var/lib/xfstests/results//xfs/030.out.bad)
>     --- tests/xfs/030.out       2014-09-30 19:36:53.000000000 +0200
>     +++ /var/lib/xfstests/results//xfs/030.out.bad      2014-09-30 22:11:38.000000000 +0200
>     @@ -39,8 +39,8 @@
>              - traversal finished ...
>              - moving disconnected inodes to lost+found ...
>      Phase 7 - verify and correct link counts...
>     -Note - stripe unit (0) and width (0) fields have been reset.
>     -Please set with mount -o sunit=<value>,swidth=<value>
>     +Note - stripe unit (0) and width (0) were copied from a backup superblock.
>     +Please reset with mount -o sunit=<value>,swidth=<value> if necessary
>     ...
>     (Run 'diff -u tests/xfs/030.out /var/lib/xfstests/results//xfs/030.out.bad'  to see the entire diff)
> 
>   Now obviously this is because I run xfsprogs 3.2.1 but xfstests have
> message from older version of xfsprogs. What is a standard solution for
> this? If I just replace the messages, then people with older xfsprogs will
> see failures. So some kind of a filter?
> 
> 								Honza
> 


Hi Jan, this should fix it, are you up to date?
(Sorry to all involved for changing this output w/o fixing the tests myself
at the same time...)

commit f007c2b465e331317e91b5125e8da04826e57c82
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Sep 8 20:48:59 2014 +1000

    filter: update xfs_repair filter for new sunit/swidth warning
    
    New xfs_repair programs have a different sunit/swidth warning that
    is triggering failures such as:
    
        -Note - stripe unit (0) and width (0) fields have been reset.
        -Please set with mount -o sunit=<value>,swidth=<value>
        +Note - stripe unit (0) and width (0) were copied from a backup superblock.
        +Please reset with mount -o sunit=<value>,swidth=<value> if necessary
    
    Update the filter to catch both cases and output the old message so
    tests pass again.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>


-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
