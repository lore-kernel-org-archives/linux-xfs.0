Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1364tXF124993 for <xfs@oss.sgi.com>; Thu, 3 Feb 2011 00:04:55 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3995A1BC85FF
	for <xfs@oss.sgi.com>; Wed,  2 Feb 2011 22:07:22 -0800 (PST)
Received: from mail.sandeen.net (64-131-28-21.usfamily.net [64.131.28.21]) by
	cuda.sgi.com with ESMTP id dy3g9mkJfwy2ccVy for
	<xfs@oss.sgi.com>; Wed, 02 Feb 2011 22:07:22 -0800 (PST)
Message-ID: <4D4A461A.2080503@sandeen.net>
Date: Thu, 03 Feb 2011 00:07:22 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: mkfs.xfs pagefault when removed storage during operation
References: <AANLkTi=wi_Fhr5v1J4wopvFTY=hC2EA_QmJu4Uc_XgGs@mail.gmail.com>	<4D4A2A9B.6090803@sandeen.net>
	<AANLkTi=aL89d3vUN2jq7w-_j7gcSrkiJk=fGyi4SJv5R@mail.gmail.com>
In-Reply-To: <AANLkTi=aL89d3vUN2jq7w-_j7gcSrkiJk=fGyi4SJv5R@mail.gmail.com>
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
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: xfs@oss.sgi.com

On 2/3/11 12:03 AM, Ajeet Yadav wrote:
> Sorry I do not agree, we have a bug so we cannot ignore it.
> Solving at first place can save a lot of time if same problem create a
> side effect that may sometime be very hard to catch.
> 
> Now lets consider the current problem
> 1. Its related to libxfs in xfsprogs, so its not mkfs issue anymore
> 2. If we come across any critical problem in libxfs we can cross
> verify kernel xfs implementation to find if there also a logical
> issue.
>     One learning and be used in other part.
> 3. Yes I agree that if mkfs.xfs fails we have to re-run it anyways,
> but then what is the difference between a novice code and professional
> product.
>      If you cscope libxfs_trans_read_buf() in xfsprogs, its caller
> always checks the return value, and its used extensively in xfsprogs.
> But this function always return 0. Infact there is no error handding
> at all, lets not consider EIO error only.
> 4. We are here in open community out of need, at the same time to make
> it better.
> 
> I was wondering why I am not getting any reply, I think mail subject
> was wrong......mkfs ;)

I may have jumped at that too quickly, yes ;)

> I will release the patch, please take out time to review it.

Well, that's fair enough, that's how it works - if it's important to you,
and you want to fix it, then you can!  And if properly done it gets
merged.

-Eric

> On Thu, Feb 3, 2011 at 1:10 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> On 2/1/11 5:06 AM, Ajeet Yadav wrote:
>>> We are testing mkfs.xfs and xfs_repair stability to look for crashes
>>> and other issues specially with removable devices.
>>> And unfortunately crashes does occur.
>>> Code inspection shows in most cases the caller does not handle
>>> libxfs_readbuf() for error cases i.e when return value = NULL.
>>>
>>> Now I need your suggestion.
>>> We should fix all such cases or the simplest way is to exit... if
>>> read() or write() fails with EIO errorno in libxfs_readbufr() and
>>> libxfs_writebufr().
>>
>> I see very little reason to gracefully handle all error cases
>> during mkfs. It would be prettier, yes, but if mkfs fails, with
>> or without an error, with or without a segfault, you have to
>> just start it over anyway, right?
>>
>> I think there are better places to focus effort.
>>
>> -Eric
>>
>>> Fortunately these function already support exit, if we use flag
>>> LIBXFS_EXIT_ON_FAILURE, LIBXFS_B_EXIT but they are used selectively.
>>>
>>> The current problem is related to function libxfs_trans_read_buf()
>>>
>>>        bp = libxfs_readbuf(dev, blkno, len, flags);
>>> #ifdef XACT_DEBUG
>>>         fprintf(stderr, "trans_read_buf buffer %p, transaction %p\n", bp, tp);
>>> #endif
>>>         xfs_buf_item_init(bp, tp->t_mountp);
>>>         bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
>>>         bip->bli_recur = 0;
>>>         xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
>>>
>>>         /* initialise b_fsprivate2 so we can find it incore */
>>>         XFS_BUF_SET_FSPRIVATE2(bp, tp);
>>>         *bpp = bp;
>>>         return 0;
>>>
>>> if  libxfs_readbuf() fails due to device removal or other error, bp = NULL.
>>> In function xfs_buf_item_init(bp, tp->t_mountp) as soon as bp is
>>> dereferenced occurs
>>>
>>> mkfs.xfs: unhandled page fault (11) at 0x00000070, code 0x017
>>>
>>> _______________________________________________
>>> xfs mailing list
>>> xfs@oss.sgi.com
>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>
>>
>>
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
