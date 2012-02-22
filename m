Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1M3Iw9t240365 for <xfs@oss.sgi.com>; Tue, 21 Feb 2012 21:18:59 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id kA4Z5RQ1MwoSBD7l for <xfs@oss.sgi.com>;
	Tue, 21 Feb 2012 19:18:56 -0800 (PST)
Message-ID: <4F445E9F.5030003@sandeen.net>
Date: Tue, 21 Feb 2012 21:18:55 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS, empty files after a crash
References: <4F4387A7.2070009@gmail.com>
	<20291.50554.414722.399249@tree.ty.sabi.co.UK>
In-Reply-To: <20291.50554.414722.399249@tree.ty.sabi.co.UK>
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
To: Peter Grandi <pg_xf2@xf2.for.sabi.co.UK>
Cc: Linux fs XFS <xfs@oss.sgi.com>

On 2/21/12 10:25 AM, Peter Grandi wrote:
>> Hi, After a crash, a lot of files on a xfs file system report
>> an empty size with "ls -a" but not with "du". [ ... ]
> 
> It is a FAQ:
> 
>   http://xfs.org/index.php/XFS_FAQ#Q:_Why_do_I_see_binary_NULLS_in_some_files_after_recovery_when_I_unplugged_the_power.3F
> 
> Usually it is a good idea to do a web search before reporting a
> problem.

He seems to be reporting a different problem.

In the FAQ case above, one would get a file but "it has is a size but no extents " - i.e. ls -l would show 1M, but du would show 0, and no extents are allocated.

In this case, he has no size, blocks are reported used, but no extents are allocated.  That actually seems like a new/odd case.

>> Is there a way to copy back the used blocks to recover the
>> files ?
> 
> No, because your applications told XFS that the content of those
> blocks could be thrown away in case of crash.

> It is your responsibility to ensure that your applications use
> 'fsync' or at least 'fsyncdata' when data should be stored
> permanently before a crash occurs.

I'd agree that there is likely nothing to recover; there are no extents allocated.  I'm not sure why du is reporting space used though.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
