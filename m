Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ECD898013
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 10:37:50 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A567E8F8066
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 08:37:47 -0800 (PST)
Received: from srvmail.3sr-grenoble.fr (3sr-srvmail.ampere.inpg.fr
	[147.171.64.82]) by cuda.sgi.com with ESMTP id x2O4BFbncVENBOgT
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 08:37:42 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by srvmail.3sr-grenoble.fr (Postfix) with SMTP id AEC5D1D6003
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 17:37:41 +0100 (CET)
Message-ID: <511D12D5.8020203@3sr-grenoble.fr>
Date: Thu, 14 Feb 2013 17:37:41 +0100
From: =?ISO-8859-1?Q?R=E9mi_Cailletaud?= <remi.cailletaud@3sr-grenoble.fr>
MIME-Version: 1.0
Subject: Re: problem after growing
References: <511BC78B.6070205@3sr-grenoble.fr> <511BCB41.4060804@sandeen.net>
	<511BCD11.20907@3sr-grenoble.fr> <511BCFB6.8000309@sandeen.net>
	<511BD0FB.2070401@3sr-grenoble.fr> <511BD2D1.9010906@sandeen.net>
	<511BD6ED.6030006@3sr-grenoble.fr>
	<511BEE8B.8000400@sandeen.net> <511BF3B6.9040502@sandeen.net>
	<511C07C6.9080003@sandeen.net> <511C9E9C.8080200@3sr-grenoble.fr>
	<511CB0C3.9090507@3sr-grenoble.fr>
	<511CFC06.2030103@3sr-grenoble.fr> <511CFCBD.504@sandeen.net>
In-Reply-To: <511CFCBD.504@sandeen.net>
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

Le 14/02/2013 16:03, Eric Sandeen a =E9crit :
> On 2/14/13 9:00 AM, R=E9mi Cailletaud wrote:
>> Le 14/02/2013 10:39, R=E9mi Cailletaud a =E9crit :
>>> Le 14/02/2013 09:21, R=E9mi Cailletaud a =E9crit :
>>>> Le 13/02/2013 22:38, Eric Sandeen a =E9crit :
>>>>> On 2/13/13 2:12 PM, Eric Sandeen wrote:
>>>>>> On 2/13/13 1:50 PM, Eric Sandeen wrote:
>>>>>>> On 2/13/13 12:09 PM, R=E9mi Cailletaud wrote:
>>>>>>>> Le 13/02/2013 18:52, Eric Sandeen a =E9crit :
>>>>>>> <snip>
>>>>>>>
>>>>>>>>> Did the filesystem grow actually work?
>>>>>>>>>
>>>>>>>>> # xfs_db -c "sb 0" -c "p" /dev/vg0/tomo-201111
>>>>>>>>> magicnum =3D 0x58465342
>>>>>>>>> blocksize =3D 4096
>>>>>>>>> dblocks =3D 10468982745
>>>>>>>>>
>>>>>>>>> That looks like it's (still?) a 38TiB/42TB filesystem, with:
>>>>>>>>>
>>>>>>>>> sectsize =3D 512
>>>>>>>>>
>>>>>>>>> 512 sectors.
>>>>>>>>>
>>>>>>>>> How big was it before you tried to grow it, and how much did you =
try to grow it by?  Maybe the size never changed.
>>>>>>>> Was 39, growing to 44. Testdisk says 48 TB / 44 TiB... There is so=
me chance that it was never really growed.
>>>>>>>>> At mount time it tries to set the sector size of the device; its'=
 a hard-4k device, so setting it to 512 fails.
>>>>>>>>>
>>>>>>>>> This may be as much of an LVM issue as anything; how do you get t=
he LVM device back to something with 512-byte logical sectors?  I have no i=
dea...
>>>>>>>>>
>>>>>>>>> *if* the fs didn't actually grow, and if the new 4k-sector space =
is not used by the filesystem, and if you can somehow remove that new space=
 from the device and set the LV back to 512 sectors, you might be in good s=
hape.
>>>>>>>> I dont either know how to see nor set LV sector size.  It's 100% s=
ure that anything was copied on 4k sector size, and pretty sure that the fs=
 did not really grow.
>>>>>>> I think the same blockdev command will tell you.
>>>>>>>
>>>>>>>
>>>>>>>>> Proceed with extreme caution here, I wouldn't start just trying r=
andom things unless you have some other way to get your data back (backups?=
).  I'd check with LVM folks as well, and maybe see if dchinner or the sgi =
folks have other suggestions.
>>>>>>>> Sigh... No backup (44To is too large for us...) ! I'm running a te=
stdisk recover, but I'm not very confident about success...
>>>>>>>> Thanks to deeper investigate this...
>>>>>>>>> First let's find out if the filesystem actually thinks it's livin=
g on the new space.
>>>>>>>> What is the way to make it talk about that ?
>>>>>>> well, you have 10468982745 4k blocks in your filesystem, so 4288095=
3323520 bytes of xfs filesystem.
>>>>>>>
>>>>>>> Look at your lvm layout, does that extend into the new disk space o=
r is it confined to the original disk space?
>>>> Seems it does not : lvm map shows 48378494844928 bytes, 1304432738304 =
on the 4K device.
>>>>
>>>>>> lvm folks I talk to say that if you remove the 4k device from the lv=
m volume it should switch back to 512 sectors.
>>>>>>
>>>>>> so if you can can convince yourself that 42880953323520 bytes does n=
ot cross into the newly added disk space, just remove it again, and everyth=
ing should be happy.
>>>>>>
>>>>>> Unless your rash decision to start running "testdisk" made things wo=
rse ;)
>>>>> I tested this.  I had a PV on a normal 512 device, then used scsi_deb=
ug to create a 4k device.
>>>>>
>>>>> I created an LV on the 512 device&   mounted it, then added the 4k de=
vice as you did.  growfs failed immediately, and the device won't remount d=
ue to the sector size change.
>>>>>
>>>>> I verified that removing the 4k device from the LV changes the LV bac=
k to a 512 sector size.
>>>>>
>>>>> However, I'm not 100% sure how to remove just the 4K PV; when I did i=
t, I did something wrong and it reduced the size of my LV to the point wher=
e it corrupted the filesystem.  :)  Perhaps you are a better lvm admin than=
 I am.
>>>> How did you remove the pv ? I would tend to use vgreduce, but I'm a bi=
t (a lot, in fact) scary about fs corruption. That's why I was wondering ab=
out pvmove'ing extents on a 512K device
>>> Or may a vgcfgrestore be safer ? Should I ask lvm folks ?
>> I tried a test as you suggest using scsi_debug.
>>
>> 2 PV, one 512 and one 4096 bytes sector.
>>
>> after adding the 4K device, growfs fail, and partition wont remount. I t=
ried a vgcfgrestore and vgreduce, but it does not mount : same error...
>> XFS (dm-5): device supports 4096 byte sectors (not 512)
> In that case I think you must not have actually (completely?) removed the=
 4k device.

That's it! After vgchange-ing un/available, lv mounts !

Following steps reproduce the "bug", considering we already have one pv =

on /dev/sdc (512 sectors device) :

- create a virtual 4k scsi device and create a pv on it :
# modprobe scsi_debug sector_size=3D4096 dev_size_mb=3D256
# pvcreate /dev/sdd

- create a vg with both pv, and create an lv on sdc (I specified exact =

extents count of sdc) :
# vgcreate vgtest  /dev/sdc /dev/sdd
# lvcreate -n lvtest -l 3759 vgtest

- mkfs, mount :
# mkfs.xfs /dev/vgtest/lvtest
# mount /dev/vgtest/lvtest /mnt/tmp

- the bad thing : lvextend and growfs (should not lvm or xfs check this =

sector size stuff ?):
# lvextend -l+40 /dev/vgtest/lvtest
# xfs_growfs /mnt/tmp
(fail with xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed)

- the scary part :
# umount /mnt/tmp
# mount /dev/vgtest/lvtest /mnt/tmp
mount: function not implemented
# tail -1 /var/log/messages
Feb 14 16:41:52 hamaika kernel: [  481.055422] XFS (dm-5): device =

supports 4096 byte sectors (not 512)

- the huge relief (restoring *before* lvextend) :
# vgcfgrestore -f /etc/lvm/archive/vgtest_00029-84595486.vg vgtest
# vgchange -a n vgtest
# vgchange -a y vgtest
# mount /dev/vgtest/lvtest /mnt/tmp

yippee, my datas are back !!


Should I submit a bug report ? On LVM, XFS, both ?

However, a great thanks for your help... I learned some stuff about lvm =

and xfs today ;)
Cheers,

r=E9mi

>
> I think you'll need to seek help from LVM people in order to proceed...  =
I'm sure it's possible to safely and completely remove the newly added spac=
e, but I don't know how.
>
> -Eric
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
