Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7MAuuio049580 for <xfs@oss.sgi.com>; Mon, 22 Aug 2011 05:56:56 -0500
Received: from mail-qy0-f174.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C0AC9138A83D
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2011 03:59:29 -0700 (PDT)
Received: from mail-qy0-f174.google.com (mail-qy0-f174.google.com
	[209.85.216.174]) by cuda.sgi.com with ESMTP id
	raSH2ELIF5ldA01H for <xfs@oss.sgi.com>;
	Mon, 22 Aug 2011 03:59:29 -0700 (PDT)
Received: by qyk38 with SMTP id 38so1612222qyk.5
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2011 03:56:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E51F24F.1050503@oracle.com>
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
	<4E4F814B.5070202@gmail.com> <4E4F865B.2010608@gmail.com>
	<4E4FD48B.8030101@oracle.com> <4E4FE1B1.7010601@gmail.com>
	<4E51F24F.1050503@oracle.com>
Date: Mon, 22 Aug 2011 12:56:54 +0200
Message-ID: <CANGUGtCi85Sgrr5R0E8iuN75ubbMX9txZMwnsvp4Wv3Xh+938g@mail.gmail.com>
Subject: Re: [PATCH 1/4] fs: add SEEK_HOLE and SEEK_DATA flags
From: Marco Stornelli <marco.stornelli@gmail.com>
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
To: Sunil Mushran <sunil.mushran@oracle.com>
Cc: linux-kernel@vger.kernel.org, Josef Bacik <josef@redhat.com>, xfs@oss.sgi.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org

2011/8/22 Sunil Mushran <sunil.mushran@oracle.com>:
> On 08/20/2011 09:32 AM, Marco Stornelli wrote:
>>
>> Il 20/08/2011 17:36, Sunil Mushran ha scritto:
>>>
>>> On 08/20/2011 03:03 AM, Marco Stornelli wrote:
>>>>
>>>> Il 20/08/2011 11:41, Marco Stornelli ha scritto:
>>>>>
>>>>> Hi,
>>>>>
>>>>> Il 28/06/2011 17:33, Josef Bacik ha scritto:
>>>>>>
>>>>>> This just gets us ready to support the SEEK_HOLE and SEEK_DATA flags.
>>>>>> Turns out
>>>>>> using fiemap in things like cp cause more problems than it solves, so
>>>>>> lets try
>>>>>> and give userspace an interface that doesn't suck. We need to match
>>>>>> solaris
>>>>>> here, and the definitions are
>>>>>>
>>>>>> *o* If /whence/ is SEEK_HOLE, the offset of the start of the
>>>>>> next hole greater than or equal to the supplied offset
>>>>>> is returned. The definition of a hole is provided near
>>>>>> the end of the DESCRIPTION.
>>>>>>
>>>>>> *o* If /whence/ is SEEK_DATA, the file pointer is set to the
>>>>>> start of the next non-hole file region greater than or
>>>>>> equal to the supplied offset.
>>>>>>
>>>>>
>>>>> I'm implementing the SEEK_DATA/SEEK_HOLE management for pramfs and I'=
ve
>>>>> got some doubts about the right behavior:
>>>>>
>>>>> 1) when we use SEEK_DATA/SEEK_HOLE, the offset used in lseek means
>>>>> always the offset from the start of the file, right?
>>>>>
>>>>> 2) in case of a file with hole at the beginning and data at the end, =
if
>>>>> I do lseek(fd, 0, SEEK_HOLE) I should receive the end of the file
>>>>> because the idea is to search the *next* hole and we have always a
>>>>> virtual hole at the end of the file, right?
>>>>
>>>> Just to be precise about this question: the alternative here, it's to
>>>> return the same position because we are already in a hole.
>>>
>>> Yes, the offset is from the start of the file.
>>>
>>> And yes, same offset is ok. I think the word next should be
>>> dropped from the definition. It is misleading.
>>>
>>
>> Thank. Yes the word "next" is not very clear. I re-read the proposal for
>> the standard, actually it's seems to me that if we are in the last hole =
we
>> should return the file size, if we are not in the last hole than it's ok=
 the
>> same offset - "....except that
>> if offset falls beyond the last byte not within a hole, then the file
>> offset may be set to the file size instead".
>
> Any proposal that differentiates between holes is wrong. It should not
> matter where the hole is.
>
> Think of it from the usage-pov.
>
> doff =3D 0;
> while ((doff =3D lseek(SEEK_DATA, doff)) !=3D -ENXIO) {
> =A0 =A0hoff =3D lseek(SEEK_HOLE, doff);
> =A0 =A0read_offset =3D doff;
> =A0 =A0read_len =3D hoff -doff;
> =A0 =A0process();
> =A0 =A0doff =3D hoff;
> }
>
> The goal is to make this as efficient as follows. Treating the last
> hole differently adds more code for no benefit.
>
>

Mmmm.....It seems that Josef has to be clear in this point. However I
looked for the seek hole test in xfs test suite, but I didn't find
anything. Btrfs guys, how have you got tested the implementation? What
do you think about this corner case? Al, what do you think about it?

Marco

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
