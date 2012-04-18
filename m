Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3I2NCSo138157 for <xfs@oss.sgi.com>; Tue, 17 Apr 2012 21:23:12 -0500
Received: from mail-pz0-f46.google.com (mail-pz0-f46.google.com
	[209.85.210.46]) by cuda.sgi.com with ESMTP id MWNp3eizfGKLaCEu
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 17 Apr 2012 19:23:11 -0700 (PDT)
Received: by dadz9 with SMTP id z9so10764308dad.5
	for <xfs@oss.sgi.com>; Tue, 17 Apr 2012 19:23:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F7ECF97.6020601@hardwarefreak.com>
References: <CACwgYDPQBNa7z7WcyUjV2Rx8Qf47r7eaRCowNKxjLBz+fYcfvQ@mail.gmail.com>
	<4F77EA55.6090004@hardwarefreak.com>
	<CACwgYDMVHT5DFjJztX9JvsVQJ+uOjPrfcs4+0aGXotDvf6tymQ@mail.gmail.com>
	<CACwgYDMXF9WEgzW9vL_0=GdRc_t+67WAkRTKNoKOMEMCvjujVw@mail.gmail.com>
	<CALFpzo5aKM2y_stDR14PNYMHEcq5CEptuFiXrvcCpXTzSQmAxw@mail.gmail.com>
	<4F792154.5020006@hardwarefreak.com>
	<CACwgYDPsZSEhuqNP8YgAksEq9BB6YOS1Q8jGx2J7DCrrOh_JQw@mail.gmail.com>
	<CACwgYDOtCoVF-p+KKqPYxHhA4vWF78Ueecx9hcVWLoyxFWzV9Q@mail.gmail.com>
	<4F7E0842.6090004@hardwarefreak.com>
	<CACwgYDMEpFqJhtUGeRg4hvux3GigNRnA--V18DwdyUvJpY434w@mail.gmail.com>
	<CACwgYDPur_8sO-BhhP-ggEmPCGa5ddsCcmSDfCuhD9OgiwGRyw@mail.gmail.com>
	<CA+res+RR5iAZsEY8G21YkQn+p_8EYSFvu4+H1SK=HXshOcS-4g@mail.gmail.com>
	<CACwgYDN5ceD3ka-O9t1rGdj4tS=JpHVm_ZWetqZ7ZAOyEjqspA@mail.gmail.com>
	<CACwgYDOc2C=j1hrbtwTqOPr77wtfLvxow9xNeF+mGUakt1rHzQ@mail.gmail.com>
	<4F7EA6D4.804@hardwarefreak.com>
	<CACwgYDMXZ2O+7B163eg5h-D5sw9_0MRgu8BAahjgOr+td8cJtg@mail.gmail.com>
	<4F7ECF97.6020601@hardwarefreak.com>
Date: Wed, 18 Apr 2012 10:23:10 +0800
Message-ID: <CACwgYDORRvCT3zBfeKL99ebO2zWt0RJAVQyXu0Zawoz_r+8bHw@mail.gmail.com>
Subject: Re: RAID5 created by 8 disks works with xfs
From: daobang wang <wangdb1981@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: Marcus Sorensen <shadowsor@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, Jack Wang <jack.wang.usish@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi stan,

    So sorry to reply this so late, the original envrionment is not
exist now, i build a same one, please see the detail output.

1. uname -a
Linux nsspioneer 2.6.36.4-v64 #1 SMP Fri Apr 13 10:16:12 CST 2012
x86_64 x86_64 x86_64 GNU/Linux

2.xfs_info /dev/vg+vg00+20120418101725/lv+nxx+lv0000
meta-data=/dev/vg+vg00+20120418101725/lv+nxx+lv0000 isize=256
agcount=13, agsize=268435440 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=3418374144, imaxpct=5
         =                       sunit=16     swidth=128 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

3. the command "cat /etc/fstab | grep xfs" has no output, we did not
save it in fstab

4. mdadm -D /dev/md127
/dev/md127:
        Version : 1.2
  Creation Time : Wed Apr 18 10:02:26 2012
     Raid Level : raid5
     Array Size : 13673525376 (13040.09 GiB 14001.69 GB)
  Used Dev Size : 1953360768 (1862.87 GiB 2000.24 GB)
   Raid Devices : 8
  Total Devices : 8
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Wed Apr 18 10:12:22 2012
          State : online
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           Name : md+LD00+120418100226
           UUID : bbddf00e:779ca156:bb4f7d10:285e4fcf
         Events : 195

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync   /dev/sdb
       1       8       32        1      active sync   /dev/sdc
       2       8       48        2      active sync   /dev/sdd
       3       8       64        3      active sync   /dev/sde
       4       8       80        4      active sync   /dev/sdf
       5       8       96        5      active sync   /dev/sdg
       6       8      112        6      active sync   /dev/sdh
       8       8      128        7      active sync   /dev/sdi

On 4/6/12, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> On 4/6/2012 3:45 AM, daobang wang wrote:
>> Hi stan,
>>
>>     Thank you for your reply, the envrionment is the same that i
>> mentioned before,  [...]
>
> There's seems to be some kind of communication failure here.  I'll make
> this really simple.  Please fill in the blanks.
>
> $ uname -a
>
> $ xfs_info [device]
>
> $ cat /etc/fstab|grep xfs
>
> $ mdadm --detail /dev/mdX
>
>
> Thanks.
>
> --
> Stan
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
