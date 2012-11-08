Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA8KxbP8022503 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 14:59:37 -0600
Message-ID: <509C1DA7.5090902@sgi.com>
Date: Thu, 08 Nov 2012 15:01:27 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] fiemap: add freespace mapping to FS_IOC_FIEMAP
References: <1350537079-16246-1-git-send-email-david@fromorbit.com>
	<1350537079-16246-2-git-send-email-david@fromorbit.com>
	<509BE2E9.1070702@sgi.com> <20121108205648.GO6434@dastard>
In-Reply-To: <20121108205648.GO6434@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On 11/08/12 14:56, Dave Chinner wrote:
> On Thu, Nov 08, 2012 at 10:50:49AM -0600, Mark Tinguely wrote:
>> On 10/18/12 00:11, Dave Chinner wrote:
>>> From: Dave Chinner<dchinner@redhat.com>
>>>
>>> fiemap is used to map extents of used space on files. it's just an
>>> array of extents, though, so there's no reason it can only index
>>> *used*  space.
>>>
>>> Ther eis need for getting freespace layout information into
>>> userspace. For example, defragmentation programs would find it
>>> useful to be able to map the free space in the filesystem to
>>> work out where it is best to move data to defragment it.
>>> Alternatively, knowing where free space is enables us to identify
>>> extents that need to be moved to defragment free space.
>>>
>>> Hence, extend fiemap with the FIEMAP_FLAG_FREESPACE to indicate that
>>> the caller wants to map free space in the range fm_start bytes from
>>> the start of the filesystem for fm_length bytes.
>>>
>>> Because XFS can report extents in size order without needing to
>>> sort, and this information is useful to xfs_fsr, also add
>>> FIEMAP_FLAG_FREESPACE_SIZE to tell the filesystem to return a
>>> freespace map ordered by extent size rather than offset. If there
>>> are multiple extents of the same size, then they are ordered by
>>> offset.
>>>
>>> Signed-off-by: Dave Chinner<dchinner@redhat.com>
>>> ---
>>
>> ...
>>
>>>   --------------
>>> diff --git a/include/linux/fiemap.h b/include/linux/fiemap.h
>>> index d830747..f4fbb9f 100644
>>> --- a/include/linux/fiemap.h
>>> +++ b/include/linux/fiemap.h
>>
>>    include/uabi/linux/fiemap.h
>>            ^^^^
>> other than that, it looks good.
>
> include/uapi/ actaully, but that change was made after I posted the
> patches so there's no surprise that It didn't apply.
>
> As it is, this needs to be redone into an FS_IOC_FIEMAPFS ioctl in
> response to other reviews. I've already done that work (a week ago),
> I just haven't fully tested it yet so I haven't reported it...
>
> Cheers,
>
> Dave.

Okay. Thank-you for the update.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
