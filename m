Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4A177Od241774 for <xfs@oss.sgi.com>; Sun, 9 May 2010 20:07:08 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BFC8D325836
	for <xfs@oss.sgi.com>; Sun,  9 May 2010 18:09:19 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id MgM5jsxlbWQGmSON for
	<xfs@oss.sgi.com>; Sun, 09 May 2010 18:09:19 -0700 (PDT)
Message-ID: <4BE75CBC.2000600@sandeen.net>
Date: Sun, 09 May 2010 20:09:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: failed to read root inode
References: <4BE55A63.8070203@purplehaze.ch>	<4BE5EB5D.5020702@hardwarefreak.com>	<20100509152818.7481c1e1@galadriel.home>
	<4BE6CC83.5070305@hardwarefreak.com>
In-Reply-To: <4BE6CC83.5070305@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

Stan Hoeppner wrote:
> Emmanuel Florac put forth on 5/9/2010 8:28 AM:
>> Le Sat, 08 May 2010 17:53:17 -0500 vous =E9criviez:
>>
>>> Why did the "crash" of a single disk in a hardware RAID6 cause a
>>> kernel freeze?  What is your definition of "disk crash"?  A single
>>> physical disk failure should not have caused this under any
>>> circumstances.  The RAID card should have handled a single disk
>>> failure transparently.
>> The RAID array may go west if the disk isn't properly set up,
>> particularly if it's a desktop-class drive. =

> =

> By design, a RAID6 pack should be able to handle two simultaneous drive
> failures before the array goes offline.  According to the OP's post he lo=
st
> one drive.  Unless it's a really crappy RAID card or if he's using a bunch
> of dissimilar drives causing problems with the entire array, he shouldn't
> have had a problem.
> =

> This is why I'm digging for more information.  The information he present=
ed
> here doesn't really make any sense.  One physical disk failure _shouldn't_
> have caused the problems he's experiencing.  I don't think we got the full
> story.

I tend to agree, something is missing here, which means my suggestions
for repair will be unlikely to be terribly successful; I think more is wrong
than we know...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
