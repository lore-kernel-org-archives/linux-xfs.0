Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C1AF27CA0
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2016 13:12:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 962C0304051
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2016 11:12:43 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ahrjQLOJhmLAr74N for <xfs@oss.sgi.com>;
	Fri, 10 Jun 2016 11:12:39 -0700 (PDT)
Subject: Re: [PATCH 0/4] xfs: online relabeling [RFC]
References: <c1922d3d-208c-3699-0a36-26108a4f44de@sandeen.net>
	<2305b486-f336-6d1e-9420-b69dc5bdc572@sandeen.net>
	<20160610121936.GC21568@bfoster.bfoster>
	<20160610164157.GA11810@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7bb93415-d08c-29e8-df68-1665d7f39581@sandeen.net>
Date: Fri, 10 Jun 2016 13:12:39 -0500
MIME-Version: 1.0
In-Reply-To: <20160610164157.GA11810@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com



On 6/10/16 11:41 AM, Darrick J. Wong wrote:
> On Fri, Jun 10, 2016 at 08:19:36AM -0400, Brian Foster wrote:
>> On Thu, Jun 09, 2016 at 11:51:12AM -0500, Eric Sandeen wrote:
>>>
>>>
>>> On 6/9/16 11:36 AM, Eric Sandeen wrote:
>>>> Ok, this more or less works; not really up to snuff
>>>> for submission or merging, just sketching it out, but some
>>>> questions first:
>>>>
>>>> 1) Is there really any point to this? :) We did have one
>>>>    request, and btrfs can do it ...
>>>>
>>
>> Seems reasonable to me. Any details on the use case for the request?
>>
>>>> 2) Is using m_growlock horrible?  growfs is the only other
>>>>    thing that writes all supers, so I grabbed it.  We don't
>>>>    want multiple relabels stepping on each other.
>>>>
>>>> 3) Is there some way to actually force the primary to disk?
>>>>    Right now the label change isn't actually visible on the
>>>>    primary until unmount, which defeats the purpose.  I'm not
>>>>    sure if there's a straightforward/safe way to make it
>>>>    visible...
>>>
>>
>>> Oh, sorry - I guess it is getting written out, but it's only
>>> available via an O_DIRECT read from userspace; it's not
>>> invalidating the cache.
>>>
>>> # io/xfs_io -c "label derp" /mnt/test
>>> label = "derp"
>>>
>>> # dd if=/dev/sdb2 bs=512 count=1 | hexdump -C
>>> ...
>>> 00000060  00 00 0a 00 b4 e5 02 00  02 00 00 08 66 6f 6f 00  |............foo.|
>>> ...
>>>
>>> # dd if=/dev/sdb2 iflag=direct bs=512 count=1 | hexdump -C
>>> ...
>>> 00000060  00 00 0a 00 b4 e5 02 00  02 00 00 08 64 65 72 70  |............derp|
>>> ...
>>>
>>> # dd if=/dev/sdb2 bs=512 count=1 | hexdump -C
>>> ...
>>> 00000060  00 00 0a 00 b4 e5 02 00  02 00 00 08 66 6f 6f 00  |............foo.|
>>> ...
>>>
>>> Guess I need to think about this some more.
>>>
>>
>> Isn't this to be expected? You're directly accessing the block device of
>> a mounted filesystem. I would think this is expected behavior, so long
>> as the set/get interfaces through the fs are consistent.
> 
> Trouble is, I bet blkid prints LABEL=foo here and not LABEL=derp as
> the admin is probably expecting.

exactly.

And FWIW, when btrfs does it, it *is* visible.

> /me wonders if invalidate_inode_pages2_range here would help?

Um, not sure.  Calling that against metadata from xfs feels a bit
bizarre...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
