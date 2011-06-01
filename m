Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p515MRlI095506 for <xfs@oss.sgi.com>; Wed, 1 Jun 2011 00:22:28 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A53B6492B1E
	for <xfs@oss.sgi.com>; Tue, 31 May 2011 22:22:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kVRRCPemrI4HV4Jr for
	<xfs@oss.sgi.com>; Tue, 31 May 2011 22:22:26 -0700 (PDT)
Message-ID: <4DE5CC8E.1090208@redhat.com>
Date: Wed, 01 Jun 2011 00:22:22 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add support for ext4dev FSTYP
References: <BANLkTimBnAgiXZnvS56eAzEdJ=kw1zVGsg@mail.gmail.com>	<4DE5C1FE.8080006@redhat.com>
	<BANLkTikfjitncM=zLpfTrfQkd8VfQAxbUA@mail.gmail.com>
In-Reply-To: <BANLkTikfjitncM=zLpfTrfQkd8VfQAxbUA@mail.gmail.com>
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
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Sergey Ivanov <sergey57@gmail.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, XFS <xfs@oss.sgi.com>

On 5/31/11 11:56 PM, Amir Goldstein wrote:
> On Wed, Jun 1, 2011 at 7:37 AM, Eric Sandeen <sandeen@redhat.com> wrote:
>> On 5/31/11 10:13 PM, Amir Goldstein wrote:
>>> From: Amir Goldstein <amir73il@users.sf.net>
>>>
>>> blkid knows to identify the ext4dev FSTYP of a partition that was
>>> formatted with mkfs.ext4dev.
>>> quota tools and various util-linux utils are also aware of ext4dev,
>>> so ext4dev shares the same capabilities as ext4.
>>>
>>> While testing on Fedora 15, we encoutered a buggy fsck utility, which
>>> invokes fsck.ext4, even though it was called with -t ext4dev argument.
>>> In our setup fsck.ext4dev knows about new fs features that fsck.ext4
>>> doesn't know, so the generic_fs_check fails.
>>> Since we have no real use of the extra capabilities provided by fsck util,
>>> we decided to invoke fsck.$FSTYP directly to avoid this issue.
>>
>> Adding ext4dev to every case seems harmless enough.  TBH I thought I had
>> it there already but I guess not.
>>
>> I'm less certain of the change from fsck -t $FSTYP to fsck.$FSTYP
>>
>> What issue are you avoiding?  wouldn't fsck -t ext4dev invoke fsck.ext4dev anyway?
>>
>> It seems like it should be harmless, but I don't understand how it helps you.
>>
> 
> As I wrote in the patch description, the fsck utility in Fedora 15 invokes
> fsck.ext4 for some reason when calling fsck -t ext4dev.

Oh, right.

> this fails because fsck.ext4 doesn't know the snapshot feature.
> I didn't debug fsck utility for that. it seemed pointless.

Did you file a bug with Fedora?  I'd rather fix the root cause than work around it...
Feel free to cc: me on the bug.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
