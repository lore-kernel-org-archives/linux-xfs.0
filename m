Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p75Lgutj134790 for <xfs@oss.sgi.com>; Fri, 5 Aug 2011 16:42:56 -0500
Received: from mail-wy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A48041884980
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2011 14:42:54 -0700 (PDT)
Received: from mail-wy0-f181.google.com (mail-wy0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id xgcZJidbwGrkNyHf
	for <xfs@oss.sgi.com>; Fri, 05 Aug 2011 14:42:54 -0700 (PDT)
Received: by wyh22 with SMTP id 22so2471862wyh.26
	for <xfs@oss.sgi.com>; Fri, 05 Aug 2011 14:42:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGpXXZKUmrWoj1F3PjwE2Yq0oYx2_0JLX3x_kxRBBA-Uk4h4OQ@mail.gmail.com>
References: <4E3BA2F7.4080500@oracle.com>
	<CAOQ4uxjVPJmXAFDmWM4K6n5b36PutV1JOkRMzLqeipZkY8AhAg@mail.gmail.com>
	<CAGpXXZKUmrWoj1F3PjwE2Yq0oYx2_0JLX3x_kxRBBA-Uk4h4OQ@mail.gmail.com>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Fri, 5 Aug 2011 17:42:24 -0400
Message-ID: <CAGpXXZJRiLX4ykUuneK7jaQrXjuP_STVxvG-MROnM02TLuCDjA@mail.gmail.com>
Subject: Re: [PATCH] snapshot, defragment and raid test cases for btrfs
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
To: Amir Goldstein <amir73il@gmail.com>
Cc: Anand Jain <Anand.Jain@oracle.com>, xfs@oss.sgi.com, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Aditya Dani <aditya.dani@gmail.com>, Chris Mason <chris.mason@oracle.com>

On Fri, Aug 5, 2011 at 11:40 AM, Greg Freemyer <greg.freemyer@gmail.com> wr=
ote:
> On Fri, Aug 5, 2011 at 9:53 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Hi Anand,
>>
>> Can you please post the patch in the body of the message so we can
>> comment on it inline.
>>
>> Aditya is also working on a btrfs snapshots xfstest (currently named
>> 257) as part of
>> his Google summer of code project.
>>
>> It would be great if you guys can cooperate your efforts.
>>
>> BTW, while running Aditya's test, Greg has stumbled upon a btrfs OOPS.
>> Greg can provide more details about it.
>>
>> Cheers,
>> Amir.
>>
>> On Fri, Aug 5, 2011 at 10:59 AM, Anand Jain <Anand.Jain@oracle.com> wrot=
e:
>>>
>>> Hi,
>>>
>>> =A0Attached is the patch for the xfstests, which adds snapshot,
>>> =A0defragment and volume management test cases for the btrfs
>>> =A0(257, 258 and 259 respectively).
>>>
>>> =A0This introduces a new user variable 'DISK_POOL' which should
>>> =A0be set to disks for the raid tests.
>>>
>>> =A0An example of usage of these tests is as below.
>>> ------------
>>> [root@localhost xfstests]# cat local.config
>>> TEST_DEV=3D"/dev/sdd"
>>> TEST_DIR=3D/btrfs
>>> SCRATCH_DEV=3D"/dev/sde"
>>> SCRATCH_MNT=3D/btrfs1
>>> DISK_POOL=3D"/dev/sdf /dev/sdg"
>>> [root@localhost xfstests]#
>>>
>>> [root@localhost xfstests]# ./check 257 258 259
>>> FSTYP -- btrfs
>>> PLATFORM -- Linux/i686 localhost 3.0.0-rc6+
>>> MKFS_OPTIONS -- /dev/sde
>>> MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:nfs_t:s0 /dev/sde /btrf=
s1
>>>
>>> 257 8s
>>> 258 3s
>>> 259 33s
>>> Ran: 257 258 259
>>> Passed all 3 tests
>>> ----------------
>>>
>>> =A0Thank you.
>>>
>>> Anand
>>>
>
> Anand,
>
> I've only reproduced the oops in 2.6.39 and older using openSUSE 11.4 use=
rspace.
>
> I have not tried with 3.0 or newer nor with newer userspace, so it may
> or may not have been fixed.
>
> It happened with a openSUSE kernel, so I put it in their bugzilla.
>
> https://bugzilla.novell.com/show_bug.cgi?id=3D705039

I just tested with kernel 3.0 and the oops is gone.

I closed that bugzilla as resolved.

Greg

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
