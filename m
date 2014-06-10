Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 643547F51
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2014 16:57:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DABA4AC008
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2014 14:57:36 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ZTc7zypnqcudgOIa for <xfs@oss.sgi.com>;
	Tue, 10 Jun 2014 14:57:34 -0700 (PDT)
Message-ID: <53977F50.3050607@sandeen.net>
Date: Tue, 10 Jun 2014 16:57:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [DISCUSS] Planning for new dev cycle (3.17)
References: <20140609223320.GE9508@dastard> <20140610060944.GG9508@dastard>
	<53971184.50008@sandeen.net>
In-Reply-To: <53971184.50008@sandeen.net>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 6/10/14, 9:09 AM, Eric Sandeen wrote:
> On 6/10/14, 1:09 AM, Dave Chinner wrote:
> 
>> There is a new version of this work (Eric's patches and the base
>> libxfs restructure) here:
>>
>> 	git://oss.sgi.com/xfs/xfs.git xfs-libxfs-restructure
>>
>> It's based on 3.15 with the current for-next branch merged into it
>> and then the changes done over the top, so it's about as up-to-date
>> as it can be. Comments welcome...
> 
> Comment 1: doesn't build ;)
> 
> 
> make[1]: *** No rule to make target `fs/xfs/xfs_dir2_readdir.o', needed by `fs/xfs/xfs.o'.  Stop.
> make[1]: *** Waiting for unfinished jobs....
>   CC [M]  fs/xfs/xfs_buf.o
> make: *** [_module_fs/xfs] Error 2
> 
> problems w/ xfs_rtbitmap.o as well, patch follows.
> 
> Comment 2: Coverity thinks this adds about 25 defects, I'll have to go
> look at why...

(whoops, I forgot to send this earlier)

I take that back, somehow it was still counting defects in the files that got moved.

At most it added one, but really this code is the same as upstream, so
it's probably just a coverity foible; the issue it finds seems real though,
I'll send a patch:

Error: FORWARD_NULL:
path:/mnt/test2/git/xfs/fs/xfs/libxfs/xfs_da_btree.c:2555:
cond_false: Condition "error", taking false branch
path:/mnt/test2/git/xfs/fs/xfs/libxfs/xfs_da_btree.c:2560:
if_end: End of if statement
path:/mnt/test2/git/xfs/fs/xfs/libxfs/xfs_da_btree.c:2564:
cond_false: Condition "bp", taking false branch
/mnt/test2/git/xfs/fs/xfs/libxfs/xfs_da_btree.c:2564:
var_compare_op: Comparing "bp" to null implies that "bp" might be null.
path:/mnt/test2/git/xfs/fs/xfs/libxfs/xfs_da_btree.c:2565:
cond_true: Condition "error", taking true branch
/mnt/test2/git/xfs/fs/xfs/libxfs/xfs_da_btree.c:2566:
var_deref_model: Passing null pointer "bp" to function "xfs_trans_brelse(xfs_trans_t *, xfs_buf_t *)", which dereferences it.
path:/mnt/test2/git/xfs/fs/xfs/xfs_trans_buf.c:443:2:
cond_true: Condition "tp == NULL", taking true branch
/mnt/test2/git/xfs/fs/xfs/xfs_trans_buf.c:444:3:
deref_parm: Directly dereferencing parameter "bp".

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
