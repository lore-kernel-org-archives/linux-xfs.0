Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q362XMll118918 for <xfs@oss.sgi.com>; Thu, 5 Apr 2012 21:33:22 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id sN8nL8e4BOvGRXXq
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 Apr 2012 19:33:21 -0700 (PDT)
Received: by pbcuo1 with SMTP id uo1so2455618pbc.26
	for <xfs@oss.sgi.com>; Thu, 05 Apr 2012 19:33:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACwgYDMEpFqJhtUGeRg4hvux3GigNRnA--V18DwdyUvJpY434w@mail.gmail.com>
References: <CACwgYDPQBNa7z7WcyUjV2Rx8Qf47r7eaRCowNKxjLBz+fYcfvQ@mail.gmail.com>
	<CADNH=7H_rgiY4fkB0SHo0yPhSBib7Gq-E_fu18yuJx=enn-eGg@mail.gmail.com>
	<4F776492.4070600@hardwarefreak.com>
	<CACwgYDOSrEYUps2VLpFSZ-irH7Mn_-BWrOYYDgXS=ULrmVuEPw@mail.gmail.com>
	<4F77D0B2.8000809@hardwarefreak.com>
	<CACwgYDMx6nQF-OwYj-BA+sZivUK=kmv2tPukgf5JGwA1vMTGrA@mail.gmail.com>
	<4F77EA55.6090004@hardwarefreak.com>
	<CACwgYDMVHT5DFjJztX9JvsVQJ+uOjPrfcs4+0aGXotDvf6tymQ@mail.gmail.com>
	<CACwgYDMXF9WEgzW9vL_0=GdRc_t+67WAkRTKNoKOMEMCvjujVw@mail.gmail.com>
	<CALFpzo5aKM2y_stDR14PNYMHEcq5CEptuFiXrvcCpXTzSQmAxw@mail.gmail.com>
	<4F792154.5020006@hardwarefreak.com>
	<CACwgYDPsZSEhuqNP8YgAksEq9BB6YOS1Q8jGx2J7DCrrOh_JQw@mail.gmail.com>
	<CACwgYDOtCoVF-p+KKqPYxHhA4vWF78Ueecx9hcVWLoyxFWzV9Q@mail.gmail.com>
	<4F7E0842.6090004@hardwarefreak.com>
	<CACwgYDMEpFqJhtUGeRg4hvux3GigNRnA--V18DwdyUvJpY434w@mail.gmail.com>
Date: Fri, 6 Apr 2012 10:33:21 +0800
Message-ID: <CACwgYDPur_8sO-BhhP-ggEmPCGa5ddsCcmSDfCuhD9OgiwGRyw@mail.gmail.com>
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
Cc: Marcus Sorensen <shadowsor@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

There is another issue, i updated xfsprog from 2.10.1 to 3.1.5, and
found i could not make the xfs filesystem when the logical volume size
large than 8TB with command mkfs.xfs -f -i size=512
/dev/vg+vg00+20120406101850/lv+nxx+lv0000, this command seems hang, it
did not return for a long time, is there any parameter i should
adjust?

Thank you very much

Best Regards,
Daobang Wang.

On 4/6/12, daobang wang <wangdb1981@gmail.com> wrote:
> Hi All,
>
>     I have found the solution, i updated the xfsprogs from 2.10.1 to
> 3.1.5, and could repair it, Thanks.
>
> Best Wishes,
> Daobang Wang.
>
> On 4/6/12, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> On 4/5/2012 1:48 AM, daobang wang wrote:
>>> Hi stan,
>>>
>>>      I duplicated the input/output error issue, about the detail
>>> operations and logs, please see the attachments, Is there any way to
>>> fix this? thanks!
>>>
>>> Best Regards,
>>> Daobang Wang.
>>
>>
>> These fiilesystem issues have nothing to do with linux-raid.  I'm
>> copying the XFS mailing list which is where this discussion should be
>> taking place from this point forward.  Please reply-to-all, and paste
>> the output you previously attached, but inline this time.
>>
>> Also, since the XFS folks are unfamiliar with what you're doing up to
>> this point, please provide a basic description of your hardware/storage
>> setup, kernel version, mdraid configuration, xfs_info output as well as
>> your fstab XFS mount options, and a description of your workload.
>>
>> My best guess at this point as to the du and ls errors is that your
>> application is not behaving properly, or you're still running with XFS
>> barriers disabled, which, I say _loudly_ for the 2nd time, you should
>> NOT do in the absence of BBWC, which you stated you do not have.
>>
>> --
>> Stan
>>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
