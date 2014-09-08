Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1D5667F4E
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 03:36:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 84E0BAC006
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 01:36:00 -0700 (PDT)
Received: from mail-ph.de-nserver.de (mail-ph.de-nserver.de [85.158.179.214])
	by cuda.sgi.com with ESMTP id 8nsJXNHI6YEaFaRR (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 08 Sep 2014 01:35:58 -0700 (PDT)
Message-ID: <540D6A6C.9090801@profihost.ag>
Date: Mon, 08 Sep 2014 10:35:56 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: Is XFS suitable for 350 million files on 20TB storage?
References: <540986B1.4080306@profihost.ag>
	<20140905123058.GA29710@bfoster.bfoster>
	<5409AF40.10801@profihost.ag> <20140905230528.GO20473@dastard>
	<540AB933.4030707@profihost.ag>
	<20140906150412.GB23506@bfoster.bfoster>
	<20140906225654.GB9955@dastard>
In-Reply-To: <20140906225654.GB9955@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Thanks,

upgraded to 3.16.2 and xfsprogs 3.2.1. Let's see how it behaves with finobt.

Greets,
Stefan


Am 07.09.2014 um 00:56 schrieb Dave Chinner:
> On Sat, Sep 06, 2014 at 11:04:13AM -0400, Brian Foster wrote:
>> On Sat, Sep 06, 2014 at 09:35:15AM +0200, Stefan Priebe wrote:
>>> Hi Dave,
>>>
>>> Am 06.09.2014 01:05, schrieb Dave Chinner:
>>>> On Fri, Sep 05, 2014 at 02:40:32PM +0200, Stefan Priebe - Profihost AG wrote:
>>>>>
>>>>> Am 05.09.2014 um 14:30 schrieb Brian Foster:
>>>>>> On Fri, Sep 05, 2014 at 11:47:29AM +0200, Stefan Priebe - Profihost AG wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> i have a backup system running 20TB of storage having 350 million files.
>>>>>>> This was working fine for month.
>>>>>>>
>>>>>>> But now the free space is so heavily fragmented that i only see the
>>>>>>> kworker with 4x 100% CPU and write speed beeing very slow. 15TB of the
>>>>>>> 20TB are in use.
>>>>
>>>> What does perf tell you about the CPU being burnt? (i.e run perf top
>>>> for 10-20s while that CPU burn is happening and paste the top 10 CPU
>>>> consuming functions).
>>>
>>> here we go:
>>>  15,79%  [kernel]            [k] xfs_inobt_get_rec
>>>  14,57%  [kernel]            [k] xfs_btree_get_rec
>>>  10,37%  [kernel]            [k] xfs_btree_increment
>>>   7,20%  [kernel]            [k] xfs_btree_get_block
>>>   6,13%  [kernel]            [k] xfs_btree_rec_offset
>>>   4,90%  [kernel]            [k] xfs_dialloc_ag
>>>   3,53%  [kernel]            [k] xfs_btree_readahead
>>>   2,87%  [kernel]            [k] xfs_btree_rec_addr
>>>   2,80%  [kernel]            [k] _xfs_buf_find
>>>   1,94%  [kernel]            [k] intel_idle
>>>   1,49%  [kernel]            [k] _raw_spin_lock
>>>   1,13%  [kernel]            [k] copy_pte_range
>>>   1,10%  [kernel]            [k] unmap_single_vma
>>>
>>
>> The top 6 or so items look related to inode allocation, so that probably
>> confirms the primary bottleneck as searching around for free inodes out
>> of the existing inode chunks, precisely what the finobt is intended to
>> resolve. That was introduced in 3.16 kernels, so unfortunately it is not
>> available in 3.10.
> 
> *nod*
> 
> Again, the only workaround for this on a non-finobt fs is to greatly
> increase the number of AGs so there's less records in each btree to
> search.
> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
