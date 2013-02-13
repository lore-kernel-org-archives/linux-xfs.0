Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 57BB57FCB
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 14:12:43 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 123F78F8059
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 12:12:39 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 6zKsctIsKbKgWdtW for <xfs@oss.sgi.com>;
	Wed, 13 Feb 2013 12:12:39 -0800 (PST)
Message-ID: <511BF3B6.9040502@sandeen.net>
Date: Wed, 13 Feb 2013 14:12:38 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: problem after growing
References: <511BC78B.6070205@3sr-grenoble.fr> <511BCB41.4060804@sandeen.net>
	<511BCD11.20907@3sr-grenoble.fr> <511BCFB6.8000309@sandeen.net>
	<511BD0FB.2070401@3sr-grenoble.fr> <511BD2D1.9010906@sandeen.net>
	<511BD6ED.6030006@3sr-grenoble.fr> <511BEE8B.8000400@sandeen.net>
In-Reply-To: <511BEE8B.8000400@sandeen.net>
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

On 2/13/13 1:50 PM, Eric Sandeen wrote:
> On 2/13/13 12:09 PM, R=E9mi Cailletaud wrote:
>> Le 13/02/2013 18:52, Eric Sandeen a =E9crit :
> =

> <snip>
> =

>>> Did the filesystem grow actually work?
>>>
>>> # xfs_db -c "sb 0" -c "p" /dev/vg0/tomo-201111
>>> magicnum =3D 0x58465342
>>> blocksize =3D 4096
>>> dblocks =3D 10468982745
>>>
>>> That looks like it's (still?) a 38TiB/42TB filesystem, with:
>>>
>>> sectsize =3D 512
>>>
>>> 512 sectors.
>>>
>>> How big was it before you tried to grow it, and how much did you try to=
 grow it by?  Maybe the size never changed.
>>
>> Was 39, growing to 44. Testdisk says 48 TB / 44 TiB... There is some cha=
nce that it was never really growed.
>>> At mount time it tries to set the sector size of the device; its' a har=
d-4k device, so setting it to 512 fails.
>>>
>>> This may be as much of an LVM issue as anything; how do you get the LVM=
 device back to something with 512-byte logical sectors?  I have no idea...
>>>
>>> *if* the fs didn't actually grow, and if the new 4k-sector space is not=
 used by the filesystem, and if you can somehow remove that new space from =
the device and set the LV back to 512 sectors, you might be in good shape.
>> I dont either know how to see nor set LV sector size.  It's 100% sure th=
at anything was copied on 4k sector size, and pretty sure that the fs did n=
ot really grow.
> =

> I think the same blockdev command will tell you.
> =

>  =

>>> Proceed with extreme caution here, I wouldn't start just trying random =
things unless you have some other way to get your data back (backups?).  I'=
d check with LVM folks as well, and maybe see if dchinner or the sgi folks =
have other suggestions.
>> Sigh... No backup (44To is too large for us...) ! I'm running a testdisk=
 recover, but I'm not very confident about success...
>> Thanks to deeper investigate this...
>>> First let's find out if the filesystem actually thinks it's living on t=
he new space.
>> What is the way to make it talk about that ?
> =

> well, you have 10468982745 4k blocks in your filesystem, so 4288095332352=
0 bytes of xfs filesystem.
> =

> Look at your lvm layout, does that extend into the new disk space or is i=
t confined to the original disk space?

lvm folks I talk to say that if you remove the 4k device from the lvm volum=
e it should switch back to 512 sectors.

so if you can can convince yourself that 42880953323520 bytes does not cros=
s into the newly added disk space, just remove it again, and everything sho=
uld be happy.

Unless your rash decision to start running "testdisk" made things worse ;)

-Eric

> -Eric
> =

>> Thanks again for your help !
>>
>> r=E9mi
>>
>>> -Eric
>>>
>>>> r=E9mi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
