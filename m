Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5A3F87FB2
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 11:52:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C24EEAC003
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 09:52:19 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id QatsFeCOcWIU9Po3 for <xfs@oss.sgi.com>;
	Wed, 13 Feb 2013 09:52:18 -0800 (PST)
Message-ID: <511BD2D1.9010906@sandeen.net>
Date: Wed, 13 Feb 2013 11:52:17 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: problem after growing
References: <511BC78B.6070205@3sr-grenoble.fr> <511BCB41.4060804@sandeen.net>
	<511BCD11.20907@3sr-grenoble.fr> <511BCFB6.8000309@sandeen.net>
	<511BD0FB.2070401@3sr-grenoble.fr>
In-Reply-To: <511BD0FB.2070401@3sr-grenoble.fr>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: =?ISO-8859-1?Q?R=E9mi_Cailletaud?= <remi.cailletaud@3sr-grenoble.fr>
Cc: xfs-oss <xfs@oss.sgi.com>

On 2/13/13 11:44 AM, R=E9mi Cailletaud wrote:
> Le 13/02/2013 18:39, Eric Sandeen a =E9crit :
>> On 2/13/13 11:27 AM, R=E9mi Cailletaud wrote:
>>> Le 13/02/2013 18:20, Eric Sandeen a =E9crit :
>>>> On 2/13/13 11:04 AM, R=E9mi Cailletaud wrote:
>>>>> Hi,
>>>>>
>>>>> I face a strange and scary issue. I just grow a xfs filesystem (44To)=
, and no way to mount it anymore :
>>>>> XFS: device supports only 4096 byte sectors (not 512)
>>>> Did you expand an LV made of 512-sector physical devices by adding 4k-=
sector physical devices?
>>> The three devices are ARECA 1880 card, but the last one was added later=
, and I never check for sector physical configuration on card configuration.
>>> But yes, running fdisk, it seems that sda and sdb are 512, and sdc is 4=
k... :(
>>>
>>>> that's probably not something we anticipate or check for....
>>>>
>>>> What sector size(s) are the actual lowest level disks under all the lv=
m pieces?
>> (re-cc'ing xfs list)
>>
>>> What command to run to get this info ?
>> IIRC,
>>
>> # blockdev --getpbsz --getss  /dev/sda
>>
>> to print the physical&  logical sector size
>>
>> You can also look at i.e.:
>> /sys/block/sda/queue/hw_sector_size
>> /sys/block/sda/queue/physical_block_size
>> /sys/block/sda/queue/logical_block_size
> ouch... nice guess :
> #  blockdev --getpbsz --getss  /dev/sda
> 512
> 512
> #  blockdev --getpbsz --getss  /dev/sdb
> 512
> 512
> #  blockdev --getpbsz --getss  /dev/sdc
> 4096
> 4096
> =

> =

>> I wonder what the recovery steps would be here.  I wouldn't do anything =
yet; I wish you hadn't already cleared the log, but oh well.
> =

> I tried a xfs_repair -L (as mentionned by xfs_check), but it early failed=
 as show on my first post...

Ah, right.

>> So you grew it, that all worked ok, you were able to copy new data into =
the new space, you unmounted it, but now it won't mount, correct?
> I never was able to copy data to new space. I had an input/output error j=
ust after growing.
> may pmove-ing extents on 4k device on a 512k device be a solution ?

Did the filesystem grow actually work?

# xfs_db -c "sb 0" -c "p" /dev/vg0/tomo-201111
magicnum =3D 0x58465342
blocksize =3D 4096
dblocks =3D 10468982745 =


That looks like it's (still?) a 38TiB/42TB filesystem, with:

sectsize =3D 512 =


512 sectors.

How big was it before you tried to grow it, and how much did you try to gro=
w it by?  Maybe the size never changed.

At mount time it tries to set the sector size of the device; its' a hard-4k=
 device, so setting it to 512 fails.

This may be as much of an LVM issue as anything; how do you get the LVM dev=
ice back to something with 512-byte logical sectors?  I have no idea...

*if* the fs didn't actually grow, and if the new 4k-sector space is not use=
d by the filesystem, and if you can somehow remove that new space from the =
device and set the LV back to 512 sectors, you might be in good shape.

Proceed with extreme caution here, I wouldn't start just trying random thin=
gs unless you have some other way to get your data back (backups?).  I'd ch=
eck with LVM folks as well, and maybe see if dchinner or the sgi folks have=
 other suggestions.

First let's find out if the filesystem actually thinks it's living on the n=
ew space.

-Eric

> r=E9mi


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
