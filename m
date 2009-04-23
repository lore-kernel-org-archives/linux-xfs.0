Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3NCjUi6007434 for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 07:45:31 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2CD9A14430CE
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 05:48:19 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id Eg6HorZ9ekDsfgy4 for
	<xfs@oss.sgi.com>; Thu, 23 Apr 2009 05:48:19 -0700 (PDT)
Message-ID: <49F062E5.70800@sandeen.net>
Date: Thu, 23 Apr 2009 07:45:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: fsck.xfs proposed improvements
References: <mailman.0.1240318659.128675.xfs@oss.sgi.com>	<20090421142333.GA5197@fysh.org>
	<49EE441E.6040606@thebarn.com>	<20090422094527.GA16600@fysh.org>	<87ws9cnz14.fsf@basil.nowhere.org>
	<20090423084900.GB16600@fysh.org>
In-Reply-To: <20090423084900.GB16600@fysh.org>
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
To: Mike Ashton <mike@fysh.org>
Cc: Andi Kleen <andi@firstfloor.org>, xfs@oss.sgi.com

Mike Ashton wrote:
> On Wed, Apr 22, 2009 at 11:45:11PM +0200, Andi Kleen wrote:
>> Mike Ashton <mike@fysh.org> writes:
>>
>>> With badly behaved hardware,
>>> which seem prevalent, or any bugs which do get into xfs we could
>>> actually end up with xfs being less fault tolerant and less reliable
>>> in general use than other filesystems, which would be a bit of a
>>> shame.
>> Most Linux file systems are not very fault tolerant in this sense;
>> e.g. on ext3 you have have to press return and accept lots of scary
>> messages to get through fsck.
> 
> Perhaps, but anecdotally/subjectively I've never had a ext3 based
> system fail to boot because I turned it off and on again.  

<hand_wave> xfs log replay may be more sensitive... </hand_wave>

> I've had
> this happen with xfs root filesystems about 15 times over the past few
> years.  I'm getting to the point where I'm starting to question the
> wisdom of choosing xfs for my systems - whether it's actually mature
> enough for use in server environments - which given that it's the one
> which ought to be a total no-brainer in this respect, is a worry.

Server environments probably *normally* are in better shape for power
consistency, but still...

> I think even if I can't persuade you guys to make official
> improvements, I've got enough information to make ad-hoc improvements
> to my own systems, but I'm going to have a hard time on the advocacy
> front.  xfs rocks, but a system is only as good as its last power cut
> (or something).
> 
> I'm hopeful that my readonly/norecovery tuning idea might catch
> someone's imagination, but we'll have to see.

It certainly does sound like an interesting idea, but others' concerns
are relevant too.  The issues around how the root filesystem gets
mounted would need to be pretty clearly addressed.  Maybe you can spell
out your original proposal again, with updates to handle that issue?

(as an aside, there have been arguments in the past that readonly mounts
should not do recovery at all - i.e. "mount -o ro" doesn't just mean
that you can only read the filesystem, but that the mount will only ever
read the block device...)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
