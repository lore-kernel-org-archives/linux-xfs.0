Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D1D7429DFD
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 09:24:43 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B365B8F8050
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 07:24:43 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id gsIuCsw0tMf73SGY (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Jan 2016 07:24:41 -0800 (PST)
Subject: Re: [resend PATCH 1/3] block, fs: reliably communicate bdev
	end-of-life
References: <20160104181220.24118.96661.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20160104182005.24118.50361.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20160109075414.GA5008@ZenIV.linux.org.uk>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <5693C935.3060701@suse.de>
Date: Mon, 11 Jan 2016 16:24:37 +0100
MIME-Version: 1.0
In-Reply-To: <20160109075414.GA5008@ZenIV.linux.org.uk>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Al Viro <viro@ZenIV.linux.org.uk>, Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@fb.com>, linux-nvdimm@ml01.01.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>

On 01/09/2016 08:54 AM, Al Viro wrote:
> On Mon, Jan 04, 2016 at 10:20:05AM -0800, Dan Williams wrote:
>> Historically we have waited for filesystem specific heuristics to
>> attempt to guess when a block device is gone.  Sometimes this works, but
>> in other cases the system can hang waiting for the fs to trigger its
>> shutdown protocol.
>>
>> The initial motivation for this investigation was to prevent DAX
>> mappings (direct mmap access to persistent memory) from leaking past the
>> lifetime of the hosting block device.  However, Dave points out that
>> these shutdown operations are needed in other scenarios.  Quoting Dave:
>>
>>      For example, if we detect a free space corruption during allocation,
>>      it is not safe to trust *any active mapping* because we can't trust
>>      that we having handed out the same block to multiple owners. Hence
>>      on such a filesystem shutdown, we have to prevent any new DAX
>>      mapping from occurring and invalidate all existing mappings as we
>>      cannot allow userspace to modify any data or metadata until we've
>>      resolved the corruption situation.
>>
>> The current block device shutdown sequence of del_gendisk +
>> blk_cleanup_queue is problematic.  We want to tell the fs after
>> blk_cleanup_queue that there is no possibility of recovery, but by that
>> time we have deleted partitions and lost the ability to find all the
>> super-blocks on a block device.
>>
>> Introduce del_gendisk_queue to trigger ->quiesce() and ->bdi_gone()
>> notifications to all the filesystems hosted on the disk.  Where
>> ->quiesce() are 'shutdown' operations while the bdev may still be alive,
>> and ->bdi_gone() is a set of actions to take after the backing device
>> is known to be permanently dead.
>
> 	Would you mind explaining what the hell is _the_ backing device
> of a filesystem?  What does that translate into in case of e.g. btrfs
> spanning several disks?  Or ext4 with journal on a different device, for
> that matter?
>
> 	If anything, I would argue that filesystem is out of place here -
> general situation is "IO on X may require IO on device Y and X needs to do
> something when Y goes away".  Consider e.g. /dev/loop backed by a device
> that went away.  Or by a file on fs that has run down the curtain and joi=
ned
> the bleedin choir invisible.  With another fs partially hosted by that
> loopback device.  Or by RAID0 containing said device.
>
> 	You are given Y and attempt to locate the affected X.  _Then_
> you assume that X is a filesystem and has "something to be done" independ=
ent
> from the role Y played for it, so you can pick that action from superblock
> method.
>
> 	IMO you are placing the burden in the wrong place.  _Recepient_
> knows what it depends upon and what should be done for each source of
> trouble.  So make it recepient's responsibility to request notifications.
> At which point the superblock method goes away, along with the requirement
> to handle all sources of trouble the same way, etc.
>
> 	What's more, things like RAID5 (also interested in knowing when
> a component has been ripped out) might or might not decide to propagate
> the event further - after all, that's exactly the point of redundancy.
>
> 	I'd look into something along the lines of notifier chain per
> gendisk, with potential victims registering a callback when they decide
> that from now on such and such device might screw them over...

Fully support this. I was planning on something similar to transport =

device changes (resizing, topology change etc).

And it might even be an idea to convert the block device events to a =

notifier chain, too.

Dan, can you keep me in the loop here?
Thanks.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
