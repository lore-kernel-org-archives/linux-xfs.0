Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2T8vpDJ218746 for <xfs@oss.sgi.com>; Tue, 29 Mar 2011 03:57:52 -0500
Received: from mail-qw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3BB23387C2F
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2011 02:01:01 -0700 (PDT)
Received: from mail-qw0-f53.google.com (mail-qw0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id XWAsFKSiEYYDzJEg
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2011 02:01:01 -0700 (PDT)
Received: by qwb7 with SMTP id 7so2393257qwb.26
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2011 02:01:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4D8A1594.5060505@redhat.com>
References: <AANLkTi=NKxmvJx_oEpdeMtfU9ePv4ofG5PjCuh23RJ+A@mail.gmail.com>
	<4D8A0A70.9030201@redhat.com>
	<AANLkTi=JvL6LoL=VOrHoiQKheqzDrVwOQtWAkumzaBk5@mail.gmail.com>
	<4D8A1594.5060505@redhat.com>
Date: Tue, 29 Mar 2011 11:01:01 +0200
Message-ID: <AANLkTik9irNe5QnNdKAsU88KyJ1bNHTNZBV4iYdzxUun@mail.gmail.com>
Subject: Re: xfstests: failure to umount ext4
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
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, XFS <xfs@oss.sgi.com>

On Wed, Mar 23, 2011 at 5:45 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 3/23/11 10:33 AM, Amir Goldstein wrote:
>> On Wed, Mar 23, 2011 at 4:57 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>>> On 3/23/11 9:36 AM, Amir Goldstein wrote:
>>>> On Wed, Mar 23, 2011 at 4:03 PM, Amir Goldstein <amir73il@gmail.com> w=
rote:
>>>>>
>>>>> I've been running xfstests on ext4 and I always get annoying failures=
 to umount:
>>>>>
>>>>> 213 8s ... 31s
>>>>> umount: /mnt/test/ext4: device is busy.
>>>>> =A0 =A0 =A0 =A0(In some cases useful info about processes that use
>>>>> =A0 =A0 =A0 =A0 the device is found by lsof(8) or fuser(1))
>>>>>
>>>>> post 198 mostly fails to umount as well.
>>>>> and post 124 always fails to umount.

USE_REMOUNT=3D1 fixes (bypasses) the problem for non scratch tests, so
I'm good with it for now :-)

Amir.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
