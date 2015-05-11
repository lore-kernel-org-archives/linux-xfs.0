Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1003129DFB
	for <xfs@oss.sgi.com>; Mon, 11 May 2015 16:07:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 06B508F8049
	for <xfs@oss.sgi.com>; Mon, 11 May 2015 14:07:42 -0700 (PDT)
Received: from mail-wg0-f43.google.com (mail-wg0-f43.google.com
	[74.125.82.43]) by cuda.sgi.com with ESMTP id TSQjqKjZ2wizcGPv
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 May 2015 14:07:40 -0700 (PDT)
Received: by wgbhc8 with SMTP id hc8so41855358wgb.2
	for <xfs@oss.sgi.com>; Mon, 11 May 2015 14:07:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABppvi63mY=-UFEyupF2-TQux+arOaCy+B-rtckvZziuachCbA@mail.gmail.com>
References: <CABppvi55C+vE7Ei8u=_ntC_heDQb4HwUcKom-_9hGkunk84Sfw@mail.gmail.com>
	<20150423224324.GM15810@dastard>
	<CABppvi7+Mu78FAM75YvJvekX2CHtKk4yeMrU7j35fvvWRb923Q@mail.gmail.com>
	<20150424061554.GN15810@dastard>
	<CABppvi6N6McmfLgAPcP9cxXxPrBMaD81UyeiVHWOaxrJisSN=g@mail.gmail.com>
	<20150429013024.GU15810@dastard>
	<CABppvi63mY=-UFEyupF2-TQux+arOaCy+B-rtckvZziuachCbA@mail.gmail.com>
Date: Mon, 11 May 2015 14:07:39 -0700
Message-ID: <CABppvi4CA_FOuJz8zrr=gNguzKKrQqG5Q30gfP9YMf1KSCM8jQ@mail.gmail.com>
Subject: Re: Inode and dentry cache behavior
From: Shrinand Javadekar <shrinand@maginatics.com>
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
Cc: xfs@oss.sgi.com

In case you're curious, the solutions to this problem are being
discussed at [1] on the Swift side.

O_TMPFILE and linkat() aren't available in all kernels (and python)
and therefore not a viable option right away. Among few others, one of
the proposals is to shard the tmp directory into say 256 dirs and
create these files inside those dirs. That way files won't get created
in a single AG. Are there any other problems if this is done?

[1] https://bugs.launchpad.net/swift/+bug/1450656

On Wed, Apr 29, 2015 at 10:46 AM, Shrinand Javadekar
<shrinand@maginatics.com> wrote:
> Awesome!! Thanks Dave!
>
> On Tue, Apr 28, 2015 at 6:30 PM, Dave Chinner <david@fromorbit.com> wrote:
>> On Tue, Apr 28, 2015 at 05:17:14PM -0700, Shrinand Javadekar wrote:
>>> I will look at the hardware. But, I think, there's also a possible
>>> software problem here.
>>>
>>> If you look at the sequence of events, first a tmp file is created in
>>> <mount-point>/tmp/tmp_blah. After a few writes, this file is renamed
>>> to a different path in the filesystem.
>>>
>>> rename(<mount-point>/tmp/tmp_blah,
>>> <mount-point>/objects/1004/eef/deadbeef/foo.data).
>>>
>>> The "tmp" directory above is created only once. Temp files get created
>>> inside it and then get renamed. We wondered if this causes disk layout
>>> issues resulting in slower performance. And then, we stumbled upon
>>> this[1]. Someone complaining about the exact same problem.
>>
>> That's pretty braindead behaviour. That will screw performance and
>> locality on any filesystem you do that on, not to mention age it
>> extremely quickly.
>>
>> In the case of XFS, it forces allocation of all the inodes in one
>> AG, rather than allowing XFs to distribute and balance inode
>> allocation around the filesystem and keeping good
>> directory/inode/data locality for all your data.
>>
>> Best way to do this is to create your tmp files using O_TMPFILE,
>> with the source directory being the destination directory and then
>> use linkat() rather than rename to make them visible in the
>> directory.
>>
>>> One quick way to validate this was to delete the "tmp" directory
>>> periodically and see what numbers we get. And they do. With 15 runs of
>>> writing 80K objects in each run, our performance was dropping from
>>> ~100MB/s to 30MB/s. With deleting the tmp directory after each run, we
>>> saw the performance only drop from ~100MB/s to 80MB/s.
>>>
>>>  The explanation in the link below says that when xfs does not find
>>> free extents in an existing allocation group, it frees up the extents
>>> by copying data from existing extents to their target allocation group
>>> (which happens because of renames). Is that explanation still valid?
>>
>> No, it wasn't correct even back then.  XFS does not move data around
>> once it has been allocated and is on disk. Indeed, rename() does not
>> move data, it only modifies directory entries.
>>
>> The problem is that the locality of a new inode is determined by the
>> parent inode, and so if all new inodes are created in the same
>> directory, then they are all created in the same AG. If you have
>> millions of inodes, then you have a btree will millions on inodes in
>> it in one AG, and pretty much none in any other AG. Hence inode
>> allocation, which has to search for free inodes in a btree
>> containing millions of records, can be extremely IO and CPU
>> intensive and therefore slow. And the larger the number of inodes,
>> the slower it will go....
>>
>> Cheers,
>>
>> Dave.
>> --
>> Dave Chinner
>> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
