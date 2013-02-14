Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9A7117FF2
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 02:21:53 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 81E0D8F8035
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 00:21:50 -0800 (PST)
Received: from srvmail.3sr-grenoble.fr (3sr-srvmail.ampere.inpg.fr
	[147.171.64.82]) by cuda.sgi.com with ESMTP id LBYFWHxwR8LheZNw
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 00:21:49 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by srvmail.3sr-grenoble.fr (Postfix) with SMTP id A000A28A0A9
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 09:21:48 +0100 (CET)
Message-ID: <511C9E9C.8080200@3sr-grenoble.fr>
Date: Thu, 14 Feb 2013 09:21:48 +0100
From: =?ISO-8859-1?Q?R=E9mi_Cailletaud?= <remi.cailletaud@3sr-grenoble.fr>
MIME-Version: 1.0
Subject: Re: problem after growing
References: <511BC78B.6070205@3sr-grenoble.fr> <511BCB41.4060804@sandeen.net>
	<511BCD11.20907@3sr-grenoble.fr> <511BCFB6.8000309@sandeen.net>
	<511BD0FB.2070401@3sr-grenoble.fr> <511BD2D1.9010906@sandeen.net>
	<511BD6ED.6030006@3sr-grenoble.fr>
	<511BEE8B.8000400@sandeen.net> <511BF3B6.9040502@sandeen.net>
	<511C07C6.9080003@sandeen.net>
In-Reply-To: <511C07C6.9080003@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Le 13/02/2013 22:38, Eric Sandeen a =E9crit :
> On 2/13/13 2:12 PM, Eric Sandeen wrote:
>> On 2/13/13 1:50 PM, Eric Sandeen wrote:
>>> On 2/13/13 12:09 PM, R=E9mi Cailletaud wrote:
>>>> Le 13/02/2013 18:52, Eric Sandeen a =E9crit :
>>> <snip>
>>>
>>>>> Did the filesystem grow actually work?
>>>>>
>>>>> # xfs_db -c "sb 0" -c "p" /dev/vg0/tomo-201111
>>>>> magicnum =3D 0x58465342
>>>>> blocksize =3D 4096
>>>>> dblocks =3D 10468982745
>>>>>
>>>>> That looks like it's (still?) a 38TiB/42TB filesystem, with:
>>>>>
>>>>> sectsize =3D 512
>>>>>
>>>>> 512 sectors.
>>>>>
>>>>> How big was it before you tried to grow it, and how much did you try =
to grow it by?  Maybe the size never changed.
>>>> Was 39, growing to 44. Testdisk says 48 TB / 44 TiB... There is some c=
hance that it was never really growed.
>>>>> At mount time it tries to set the sector size of the device; its' a h=
ard-4k device, so setting it to 512 fails.
>>>>>
>>>>> This may be as much of an LVM issue as anything; how do you get the L=
VM device back to something with 512-byte logical sectors?  I have no idea.=
..
>>>>>
>>>>> *if* the fs didn't actually grow, and if the new 4k-sector space is n=
ot used by the filesystem, and if you can somehow remove that new space fro=
m the device and set the LV back to 512 sectors, you might be in good shape.
>>>> I dont either know how to see nor set LV sector size.  It's 100% sure =
that anything was copied on 4k sector size, and pretty sure that the fs did=
 not really grow.
>>> I think the same blockdev command will tell you.
>>>
>>>
>>>>> Proceed with extreme caution here, I wouldn't start just trying rando=
m things unless you have some other way to get your data back (backups?).  =
I'd check with LVM folks as well, and maybe see if dchinner or the sgi folk=
s have other suggestions.
>>>> Sigh... No backup (44To is too large for us...) ! I'm running a testdi=
sk recover, but I'm not very confident about success...
>>>> Thanks to deeper investigate this...
>>>>> First let's find out if the filesystem actually thinks it's living on=
 the new space.
>>>> What is the way to make it talk about that ?
>>> well, you have 10468982745 4k blocks in your filesystem, so 42880953323=
520 bytes of xfs filesystem.
>>>
>>> Look at your lvm layout, does that extend into the new disk space or is=
 it confined to the original disk space?
Seems it does not : lvm map shows 48378494844928 bytes, 1304432738304 on =

the 4K device.

>> lvm folks I talk to say that if you remove the 4k device from the lvm vo=
lume it should switch back to 512 sectors.
>>
>> so if you can can convince yourself that 42880953323520 bytes does not c=
ross into the newly added disk space, just remove it again, and everything =
should be happy.
>>
>> Unless your rash decision to start running "testdisk" made things worse =
;)
> I tested this.  I had a PV on a normal 512 device, then used scsi_debug t=
o create a 4k device.
>
> I created an LV on the 512 device&  mounted it, then added the 4k device =
as you did.  growfs failed immediately, and the device won't remount due to=
 the sector size change.
>
> I verified that removing the 4k device from the LV changes the LV back to=
 a 512 sector size.
>
> However, I'm not 100% sure how to remove just the 4K PV; when I did it, I=
 did something wrong and it reduced the size of my LV to the point where it=
 corrupted the filesystem.  :)  Perhaps you are a better lvm admin than I a=
m.
How did you remove the pv ? I would tend to use vgreduce, but I'm a bit =

(a lot, in fact) scary about fs corruption. That's why I was wondering =

about pvmove'ing extents on a 512K device

r=E9mi

> But in any case - if you know how to safely remove ONLY the 4k device fro=
m the LV, you should be in good shape again.
>
> -Eric
>
>
>


-- =

R=E9mi Cailletaud - IE CNRS
3SR - Laboratoire Sols, Solides, Structures - Risques
BP53, 38041 Grenoble CEDEX 0
FRANCE
remi.cailletaud@3sr-grenoble.fr
T=E9l: +33 (0)4 76 82 52 78
Fax: +33 (0)4 76 82 70 43



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
