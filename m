Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q368j7RW159190 for <xfs@oss.sgi.com>; Fri, 6 Apr 2012 03:45:08 -0500
Received: from mail-pz0-f46.google.com (mail-pz0-f46.google.com
	[209.85.210.46]) by cuda.sgi.com with ESMTP id 9JISmG33HVQxICLY
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 06 Apr 2012 01:45:06 -0700 (PDT)
Received: by dadz9 with SMTP id z9so3342600dad.5
	for <xfs@oss.sgi.com>; Fri, 06 Apr 2012 01:45:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F7EA6D4.804@hardwarefreak.com>
References: <CACwgYDPQBNa7z7WcyUjV2Rx8Qf47r7eaRCowNKxjLBz+fYcfvQ@mail.gmail.com>
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
	<CACwgYDN5ceD3ka-O9t1rGdj4tS=JpHVm_ZWetqZ7ZAOyEjqspA@mail.gmail.com>
	<CACwgYDOc2C=j1hrbtwTqOPr77wtfLvxow9xNeF+mGUakt1rHzQ@mail.gmail.com>
	<4F7EA6D4.804@hardwarefreak.com>
Date: Fri, 6 Apr 2012 16:45:06 +0800
Message-ID: <CACwgYDMXZ2O+7B163eg5h-D5sw9_0MRgu8BAahjgOr+td8cJtg@mail.gmail.com>
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

    Thank you for your reply, the envrionment is the same that i
mentioned before,  the user allows the cache data to miss, so i did
not disable the barriers, they just demands that the filesystem should
be repaired after system restarted. We did not deal with the fstab
now, it is the next step work.

    And about the mkfs.xfs slow issue, we found the logsize is too
large, it caused making the xfs filesystem slowly.

    Thanks again.

Have a good day.
Daobang Wang.

On 4/6/12, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> On 4/6/2012 1:49 AM, daobang wang wrote:
>> I did more tests, and found the mkfs.xfs did not hang.
>>
>> I tried to make the xfs on 7TB logical volume, both 2.10.1 and 3.1.5
>> mkfs.xfs -f dev will work well, less than one minute.
>>
>> But when i tried to make xfs on 8TB logical volume, 2.10.1 works well,
>> less than 1 minute, but 3.1.5 needs 5 minutes.
>
> Once you provide the information I requested I'd be glad to help you
> further.  Without that information I'm wasting my time.
>
> --
> Stan
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
