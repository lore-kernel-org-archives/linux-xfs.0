Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0ED268017
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 11:25:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CA15930404E
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 09:25:22 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lxxUEHEohlhG0X9o for
	<xfs@oss.sgi.com>; Thu, 14 Feb 2013 09:25:22 -0800 (PST)
Message-ID: <511D1DF5.2060802@redhat.com>
Date: Thu, 14 Feb 2013 11:25:09 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_mkfs: wipe old signatures from the device
References: <1360667215-14701-1-git-send-email-lczerner@redhat.com>
	<20130212202753.GC26694@dastard>
	<20130213080154.GC18597@x2.net.home>
	<alpine.LFD.2.00.1302131127070.2315@(none)>
	<20130213121655.GA7799@x2.net.home>
	<20130213221720.GH26694@dastard>
	<982B8DBB-3FBA-4213-BC92-848A64C60110@colorremedies.com>
	<alpine.LFD.2.00.1302140929570.2315@(none)>
In-Reply-To: <alpine.LFD.2.00.1302140929570.2315@(none)>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Cc: xfs@oss.sgi.com, Karel Zak <kzak@redhat.com>, Zach Brown <zabrown@redhat.com>, Chris Murphy <lists@colorremedies.com>, linux-btrfs@vger.kernel.org

On 2/14/13 2:36 AM, Luk=E1=A8 Czerner wrote:
> On Thu, 14 Feb 2013, Chris Murphy wrote:
> =

>> Date: Thu, 14 Feb 2013 00:29:59 -0700
>> From: Chris Murphy <lists@colorremedies.com>
>> To: Dave Chinner <david@fromorbit.com>
>> Cc: Karel Zak <kzak@redhat.com>, Luk=E1=A8 Czerner <lczerner@redhat.com>,
>>     xfs@oss.sgi.com, sandeen@redhat.com, Zach Brown <zabrown@redhat.com>,
>>     linux-btrfs@vger.kernel.org
>> Subject: Re: [PATCH] xfs_mkfs: wipe old signatures from the device
>>
>>
>> On Feb 13, 2013, at 3:17 PM, Dave Chinner <david@fromorbit.com> wrote:
>>> it is the responsibility of filesystem
>>> tools to behave sanely, not for the rest of the world to have to
>>> work around the dangerous behaviour of a specific filesystems'
>>> toolset.
>>
>> I appreciate this, and in particular that mkfs.xfs doesn't nerf a file s=
ystem without the use of -f; even an existing XFS file system. Considering =
most data loss is user induced, I'd appreciate it if other file systems's t=
ools weren't so easily made belligerent by (hopefully temporarily) confused=
 apes wearing pants.
>>
>> Chris Murphy
> =

> I would not be so optimistic about it. The reason being that there
> are almost _always_ old file system signatures on the device. So I
> think that it got to the point where users will usually use mkfs.xfs
> -f all the time. =


I know I do ;)  But as Dave points out, fs developers are odd ducks.

> And even if they did not and they would use a wrong
> device they would probably get the same warning even for the device
> they wanted to use in the first place.

I was thinking, as annoying as it might be, requiring the user to
use "-f $OLD_FS_TYPE" might require a bit more positive action
and cognition on the admin's part.

OTOH, that could get annoying, and break old scripts.  :)

-Eric

> So even thoug it might help in some cases I do not think that we
> should go and change all file systems to do that as well, it would
> not be very useful anyway.
> =

> -Lukas
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
