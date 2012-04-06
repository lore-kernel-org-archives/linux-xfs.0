Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q366jk4m138435 for <xfs@oss.sgi.com>; Fri, 6 Apr 2012 01:45:47 -0500
Received: from mail-pz0-f46.google.com (mail-pz0-f46.google.com
	[209.85.210.46]) by cuda.sgi.com with ESMTP id Vy2i6hZAEE99rcAD
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 Apr 2012 23:45:45 -0700 (PDT)
Received: by dadz9 with SMTP id z9so3226727dad.5
	for <xfs@oss.sgi.com>; Thu, 05 Apr 2012 23:45:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+res+RR5iAZsEY8G21YkQn+p_8EYSFvu4+H1SK=HXshOcS-4g@mail.gmail.com>
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
	<CACwgYDPur_8sO-BhhP-ggEmPCGa5ddsCcmSDfCuhD9OgiwGRyw@mail.gmail.com>
	<CA+res+RR5iAZsEY8G21YkQn+p_8EYSFvu4+H1SK=HXshOcS-4g@mail.gmail.com>
Date: Fri, 6 Apr 2012 14:45:44 +0800
Message-ID: <CACwgYDN5ceD3ka-O9t1rGdj4tS=JpHVm_ZWetqZ7ZAOyEjqspA@mail.gmail.com>
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jack Wang <jack.wang.usish@gmail.com>
Cc: Marcus Sorensen <shadowsor@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, stan@hardwarefreak.com, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Jacky,

     Yes, the environment is like your description, i will try with
your suggestion. thanks a lot.

On 4/6/12, Jack Wang <jack.wang.usish@gmail.com> wrote:
> using bigger inode size or inode64 does help?
>
> So your environment is NVR software running in Linux ,100+ D1 streamer
> directly write to filesystem on top of 16 SATA disks (with raid5 and
> vg)?
>
> 2012/4/6 daobang wang <wangdb1981@gmail.com>:
>> There is another issue, i updated xfsprog from 2.10.1 to 3.1.5, and
>> found i could not make the xfs filesystem when the logical volume size
>> large than 8TB with command mkfs.xfs -f -i size=3D512
>> /dev/vg+vg00+20120406101850/lv+nxx+lv0000, this command seems hang, it
>> did not return for a long time, is there any parameter i should
>> adjust?
>>
>> Thank you very much
>>
>> Best Regards,
>> Daobang Wang.
>>
>> On 4/6/12, daobang wang <wangdb1981@gmail.com> wrote:
>>> Hi All,
>>>
>>> =A0 =A0 I have found the solution, i updated the xfsprogs from 2.10.1 to
>>> 3.1.5, and could repair it, Thanks.
>>>
>>> Best Wishes,
>>> Daobang Wang.
>>>
>>> On 4/6/12, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>>>> On 4/5/2012 1:48 AM, daobang wang wrote:
>>>>> Hi stan,
>>>>>
>>>>> =A0 =A0 =A0I duplicated the input/output error issue, about the detail
>>>>> operations and logs, please see the attachments, Is there any way to
>>>>> fix this? thanks!
>>>>>
>>>>> Best Regards,
>>>>> Daobang Wang.
>>>>
>>>>
>>>> These fiilesystem issues have nothing to do with linux-raid. =A0I'm
>>>> copying the XFS mailing list which is where this discussion should be
>>>> taking place from this point forward. =A0Please reply-to-all, and paste
>>>> the output you previously attached, but inline this time.
>>>>
>>>> Also, since the XFS folks are unfamiliar with what you're doing up to
>>>> this point, please provide a basic description of your hardware/storage
>>>> setup, kernel version, mdraid configuration, xfs_info output as well as
>>>> your fstab XFS mount options, and a description of your workload.
>>>>
>>>> My best guess at this point as to the du and ls errors is that your
>>>> application is not behaving properly, or you're still running with XFS
>>>> barriers disabled, which, I say _loudly_ for the 2nd time, you should
>>>> NOT do in the absence of BBWC, which you stated you do not have.
>>>>
>>>> --
>>>> Stan
>>>>
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
