Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p516bH6N097845 for <xfs@oss.sgi.com>; Wed, 1 Jun 2011 01:37:18 -0500
Received: from mail-wy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0CBD54930F1
	for <xfs@oss.sgi.com>; Tue, 31 May 2011 23:37:16 -0700 (PDT)
Received: from mail-wy0-f181.google.com (mail-wy0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id JcN9xn1U1NuGhMu9
	for <xfs@oss.sgi.com>; Tue, 31 May 2011 23:37:16 -0700 (PDT)
Received: by wyi11 with SMTP id 11so4477071wyi.26
	for <xfs@oss.sgi.com>; Tue, 31 May 2011 23:37:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DE5CF6C.4080707@redhat.com>
References: <BANLkTimBnAgiXZnvS56eAzEdJ=kw1zVGsg@mail.gmail.com>
	<4DE5C1FE.8080006@redhat.com>
	<BANLkTikfjitncM=zLpfTrfQkd8VfQAxbUA@mail.gmail.com>
	<4DE5CC8E.1090208@redhat.com> <4DE5CF6C.4080707@redhat.com>
Date: Wed, 1 Jun 2011 09:37:15 +0300
Message-ID: <BANLkTimoRUrY7xVnamBT=yFPzafhADA=tA@mail.gmail.com>
Subject: Re: [PATCH] xfstests: add support for ext4dev FSTYP
From: Amir Goldstein <amir73il@gmail.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Sergey Ivanov <sergey57@gmail.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, XFS <xfs@oss.sgi.com>

On Wed, Jun 1, 2011 at 8:34 AM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 6/1/11 12:22 AM, Eric Sandeen wrote:
>> On 5/31/11 11:56 PM, Amir Goldstein wrote:
>>> On Wed, Jun 1, 2011 at 7:37 AM, Eric Sandeen <sandeen@redhat.com> wrote:
>>>> On 5/31/11 10:13 PM, Amir Goldstein wrote:
>>>>> From: Amir Goldstein <amir73il@users.sf.net>
>>>>>
>>>>> blkid knows to identify the ext4dev FSTYP of a partition that was
>>>>> formatted with mkfs.ext4dev.
>>>>> quota tools and various util-linux utils are also aware of ext4dev,
>>>>> so ext4dev shares the same capabilities as ext4.
>>>>>
>>>>> While testing on Fedora 15, we encoutered a buggy fsck utility, which
>>>>> invokes fsck.ext4, even though it was called with -t ext4dev argument.
>>>>> In our setup fsck.ext4dev knows about new fs features that fsck.ext4
>>>>> doesn't know, so the generic_fs_check fails.
>>>>> Since we have no real use of the extra capabilities provided by fsck =
util,
>>>>> we decided to invoke fsck.$FSTYP directly to avoid this issue.
>>>>
>>>> Adding ext4dev to every case seems harmless enough. =A0TBH I thought I=
 had
>>>> it there already but I guess not.
>>>>
>>>> I'm less certain of the change from fsck -t $FSTYP to fsck.$FSTYP
>>>>
>>>> What issue are you avoiding? =A0wouldn't fsck -t ext4dev invoke fsck.e=
xt4dev anyway?
>>>>
>>>> It seems like it should be harmless, but I don't understand how it hel=
ps you.
>>>>
>>>
>>> As I wrote in the patch description, the fsck utility in Fedora 15 invo=
kes
>>> fsck.ext4 for some reason when calling fsck -t ext4dev.
>>
>> Oh, right.
>>
>>> this fails because fsck.ext4 doesn't know the snapshot feature.
>>> I didn't debug fsck utility for that. it seemed pointless.
>>
>> Did you file a bug with Fedora? =A0I'd rather fix the root cause than wo=
rk around it...
>> Feel free to cc: me on the bug.

No, I didn't file a bug.
In any case, it was Sergey, who tested and reported the problem on F15.

Would you agree to fix the problem in xfstests now, so that F15 users can
test ext4dev and fix the bug in fsck regardless?

>
> RHEL6 does the same; mkfs.ext4dev then fsck -t ext4dev invokes fsck.ext4;=
 but this
> is because blkid identifies it as ext4, not ext4dev, despite the test_fs =
flag being set.
>
> ISTR this is due to some tortured logic about when ext4dev isn't ext4dev,=
 but
> I don't remember the details... I don't know if this is the same situation
> you're seeing; just to double check - does blkid correctly identify it as=
 ext4dev
> on F15?


For me (on Ubuntu) blkid identifies ext4dev, but maybe the tortured logic
finds unknown features a justification for declaring ext4dev?
Segrey, can you answer the question for F15?
Did you set FSTYP to ext4dev manually or did blkid identified it for you?

>
> -Eric
>
>> -Eric
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
