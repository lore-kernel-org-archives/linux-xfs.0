Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5570C801B
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 12:35:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1E83130404E
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 10:35:01 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 2kgXezRqRVwr67Oa for <xfs@oss.sgi.com>;
	Thu, 14 Feb 2013 10:35:00 -0800 (PST)
Message-ID: <511D2E53.3070403@sandeen.net>
Date: Thu, 14 Feb 2013 12:34:59 -0600
From: Eric Sandeen <sandeen@sandeen.net>
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
	<511D12D5.8020203@3sr-grenoble.fr>
In-Reply-To: <511D12D5.8020203@3sr-grenoble.fr>
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

On 2/14/13 10:37 AM, R=E9mi Cailletaud wrote:
> Le 14/02/2013 16:03, Eric Sandeen a =E9crit :


<big snip>

>>> after adding the 4K device, growfs fail, and partition wont remount. I =
tried a vgcfgrestore and vgreduce, but it does not mount : same error...
>>> XFS (dm-5): device supports 4096 byte sectors (not 512)
>> In that case I think you must not have actually (completely?) removed th=
e 4k device.
> =

> That's it! After vgchange-ing un/available, lv mounts !
> =

> Following steps reproduce the "bug", considering we already have one pv o=
n /dev/sdc (512 sectors device) :
> =

> - create a virtual 4k scsi device and create a pv on it :
> # modprobe scsi_debug sector_size=3D4096 dev_size_mb=3D256
> # pvcreate /dev/sdd
> =

> - create a vg with both pv, and create an lv on sdc (I specified exact ex=
tents count of sdc) :
> # vgcreate vgtest  /dev/sdc /dev/sdd
> # lvcreate -n lvtest -l 3759 vgtest
> =

> - mkfs, mount :
> # mkfs.xfs /dev/vgtest/lvtest
> # mount /dev/vgtest/lvtest /mnt/tmp
> =

> - the bad thing : lvextend and growfs (should not lvm or xfs check this s=
ector size stuff ?):

xfs does check, to some degree:

> # lvextend -l+40 /dev/vgtest/lvtest
> # xfs_growfs /mnt/tmp
> (fail with xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed)

^^^ see?  ;)  It could maybe be more explicit, but xfs is already in troubl=
e by this point (before growfs, it still won't be remountable).  There is n=
o opportunity for xfs to catch this damage before it's done.

Yes, I think lvm should check before allowing the change.

> =

> - the scary part :
> # umount /mnt/tmp
> # mount /dev/vgtest/lvtest /mnt/tmp
> mount: function not implemented
> # tail -1 /var/log/messages
> Feb 14 16:41:52 hamaika kernel: [  481.055422] XFS (dm-5): device support=
s 4096 byte sectors (not 512)
> =

> - the huge relief (restoring *before* lvextend) :
> # vgcfgrestore -f /etc/lvm/archive/vgtest_00029-84595486.vg vgtest
> # vgchange -a n vgtest
> # vgchange -a y vgtest
> # mount /dev/vgtest/lvtest /mnt/tmp
> =

> yippee, my datas are back !!

cool.

> =

> Should I submit a bug report ? On LVM, XFS, both ?

I don't know what xfs could have done here.  Even if you didn't growfs, by =
the time you did lvextend xfs wouldn't have been able to remount.  I think =
it's up to lvm to protect the user from this, personally, so a bug report t=
here seems warranted.

> However, a great thanks for your help... I learned some stuff about lvm a=
nd xfs today ;)

You're welcome, very glad you got it back.
Thank my employer Red Hat for paying me to work on this stuff, too ;)

-Eric

> Cheers,
> =

> r=E9mi
> =

>>
>> I think you'll need to seek help from LVM people in order to proceed... =
 I'm sure it's possible to safely and completely remove the newly added spa=
ce, but I don't know how.
>>
>> -Eric
>>
>>
> =

> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
