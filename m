Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39342 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726585AbfBDS1T (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Feb 2019 13:27:19 -0500
Subject: Re: [PATCH 1/8] xfs_scrub_all: walk the lsblk device/fs hierarchy
 correctly
References: <154524776457.28646.3004453037075812416.stgit@magnolia>
 <154524777080.28646.13859873012142786308.stgit@magnolia>
 <d4cd6eba-2767-9fea-ea98-2416fe5c2ba4@sandeen.net>
 <20190204181649.GX5761@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <edca5db4-2e33-0fcc-0779-1c863543b5a5@sandeen.net>
Date: Mon, 4 Feb 2019 12:27:18 -0600
MIME-Version: 1.0
In-Reply-To: <20190204181649.GX5761@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org



On 2/4/19 12:16 PM, Darrick J. Wong wrote:
> On Mon, Feb 04, 2019 at 12:08:49PM -0600, Eric Sandeen wrote:
>> On 12/19/18 1:29 PM, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>>
>>> Back when I was designing xfs_scrub_all, I naïvely assumed that the
>>> emitted output would always list physical storage before the virtual
>>> devices stacked atop it.  However, this is not actually true when one
>>> omits the "NAME" column, which is crucial to forcing the output (json or
>>> otherwise) to capture the block device hierarchy.  If the assumption is
>>> violated, the program crashes with a python exception.
>>
>> Is this a quirk or a documented feature of lsblk?
> 
> Not a documented feature, but seems to be a fairly common behavioral
> quirk?

bleah.  Sounds fragile.  :(

Let me check with kzak on this.  If your patch improves it for now, super,
but I don't want to leave a little time bomb here.

>>> -	cmd=['lsblk', '-o', 'KNAME,TYPE,FSTYPE,MOUNTPOINT', '-J']
>>> +	cmd=['lsblk', '-o', 'NAME,KNAME,TYPE,FSTYPE,MOUNTPOINT', '-J']
>>
>> sorry for the ridonculously late review, and although '-J" isn't added
>> new in this patch, FYI at least RHEL7 does not allow it:
>>
>> # lsblk -o KNAME -J
>> lsblk: invalid option -- 'J'
>>
>> ... thoughts?  Probably should be handled gracefully at least?
> 
> lsblk returns 1 for unrecognized arguments, so xfs_scrub_all will bail
> if lsblk barfs.  Not sure if we want to divert lsblk's stderr to
> /dev/null or just let it spray out sloppily like we do now?
> 
> (Practically speaking I suspect that distros will pick up the util-linux
> release that has json support before they pick up XFS kernel scrub...
> but I should at least make sure that's really true.)

Yeah I'd expect that as well, just wondered how much of a landmine it
might be, I guess.

-Eric

> --D
> 
>> -Eric
>>
>>>  	result = subprocess.Popen(cmd, stdout=subprocess.PIPE)
>>>  	result.wait()
>>>  	if result.returncode != 0:
>>> @@ -38,18 +50,12 @@ def find_mounts():
>>>  	sarray = [x.decode(sys.stdout.encoding) for x in result.stdout.readlines()]
>>>  	output = ' '.join(sarray)
>>>  	bdevdata = json.loads(output)
>>> +
>>>  	# The lsblk output had better be in disks-then-partitions order
>>>  	for bdev in bdevdata['blockdevices']:
>>> -		if bdev['type'] in ('disk', 'loop'):
>>> -			lastdisk = bdev['kname']
>>> -		if bdev['fstype'] == 'xfs':
>>> -			mnt = bdev['mountpoint']
>>> -			if mnt is None:
>>> -				continue
>>> -			if mnt in fs:
>>> -				fs[mnt].add(lastdisk)
>>> -			else:
>>> -				fs[mnt] = set([lastdisk])
>>> +		lastdisk = bdev['kname']
>>> +		find_xfs_mounts(bdev, fs, lastdisk)
>>> +
>>>  	return fs
>>>  
>>>  def kill_systemd(unit, proc):
>>>
> 
