Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p58KqVSe117323 for <xfs@oss.sgi.com>; Wed, 8 Jun 2011 15:52:32 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 154514AC833
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2011 13:52:30 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id B0px8F7EHAVDdcRP for <xfs@oss.sgi.com>;
	Wed, 08 Jun 2011 13:52:30 -0700 (PDT)
Message-ID: <4DEFE10E.1070509@sandeen.net>
Date: Wed, 08 Jun 2011 15:52:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Small files perform much faster on newly formatted fs?
References: <20110607163742.GH28625@pyre.virge.net> <201106080911.11286@zmi.at>
	<20110608122638.GQ28625@pyre.virge.net>
In-Reply-To: <20110608122638.GQ28625@pyre.virge.net>
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
To: Norbert Veber <nveber@pyre.virge.net>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

On 6/8/11 7:26 AM, Norbert Veber wrote:
> On Wed, Jun 08, 2011 at 09:11:10AM +0200, Michael Monnerie wrote:
>> On Dienstag, 7. Juni 2011 Norbert Veber wrote:
>>> 20 seconds vs 3+ minutes?!  The only difference I can see is
>>> lazy-count=1 and a larger agcount.  Sunit and swidth were also set
>>> automatically by mkfs this time.
>>
>> Then retry mounting the old fs with sunit= and swidth= parameters. Are 
>> they on the same disks? What are your disks (number, kind)?
> 
> Yes its already mounted this way as I mentioned in my original message:
> /dev/mapper/vg0-shared on /shared type xfs (rw,noatime,sunit=128,swidth=256)
> 
> Both filesystems are on the same MD raid 5 which consists of 3 1 tb WD
> Black hard drive.

The 2 filesystems are at different locations on the disks, so that will make
some difference.

It's probably also possible that your old log is not stripe-aligned.

Not sure what else it might be ...  You did get the units right on your
stripe specification at mount-time, good job! ;)

-Eric


> Thanks,
> 
> Norbert
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
