Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A929F7F37
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 19:52:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 46991AC002
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 17:52:53 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id aqxlgxj14MDT6kaX for <xfs@oss.sgi.com>;
	Mon, 22 Apr 2013 17:52:52 -0700 (PDT)
Message-ID: <5175DB63.6030501@sandeen.net>
Date: Mon, 22 Apr 2013 19:52:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_iunlink_remove: xfs_inotobp() returned error 22 -- debugging
References: <516C89DF.4070904@redhat.com> <517596BA.3060408@sandeen.net>
	<20130423000835.GL30622@dastard>
In-Reply-To: <20130423000835.GL30622@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, yongtaofu@gmail.com, xfs@oss.sgi.com

On 4/22/13 7:08 PM, Dave Chinner wrote:
> On Mon, Apr 22, 2013 at 02:59:54PM -0500, Eric Sandeen wrote:
>> On 4/15/13 6:14 PM, Brian Foster wrote:
>>> Hi,
>>>
>>> Thanks for the data in the previous thread:
>>>
>>> http://oss.sgi.com/archives/xfs/2013-04/msg00327.html
>>>
>>> I'm spinning off a new thread specifically for this because the original
>>> thread is already too large and scattered to track. As Eric stated,
>>> please try to keep data contained in as few messages as possible.
>>>
>>
>> Well, it's always simple in the end.  It just took a lot of debugging
>> to figure out what was happening - we do appreciate your help with that!
>>
>> We were able to create a local reproducer, and it looks like
>> this patch fixes things:
>>
>> commit aae8a97d3ec30788790d1720b71d76fd8eb44b73
>> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>> Date:   Sat Jan 29 18:43:27 2011 +0530
>>
>>     fs: Don't allow to create hardlink for deleted file
> 
> Good find Eric - great work on the reproducer script.
> 
> FWIW, can you confirm that a debug kernel assert fails
> with a non-zero link count in xfs_bumplink() with your test case?
> 
> int
> xfs_bumplink(
>         xfs_trans_t *tp,
>         xfs_inode_t *ip)
> {
>         xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
> 
>>>>>>   ASSERT(ip->i_d.di_nlink > 0);

Yep, it does, I put a printk in there when I was testing
and it fired.

Guess we should have tested a debug xfs right off the bat ;)

>         ip->i_d.di_nlink++;
>         inc_nlink(VFS_I(ip));
> 
> If it does, we should consider this a in-memory corruption case and
> return and trigger a shutdown here....

I suppose that makes sense, it'd be a much less cryptic failure for
something that will fail soon anyway.

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
