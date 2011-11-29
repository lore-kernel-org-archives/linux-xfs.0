Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pATHcZwi082649 for <xfs@oss.sgi.com>; Tue, 29 Nov 2011 11:38:35 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AE1B819EA66F
	for <xfs@oss.sgi.com>; Tue, 29 Nov 2011 09:38:34 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id nsi1eO1y1eThC6Jf for <xfs@oss.sgi.com>;
	Tue, 29 Nov 2011 09:38:34 -0800 (PST)
Message-ID: <4ED51899.7000706@sandeen.net>
Date: Tue, 29 Nov 2011 11:38:33 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] libxfs: Get Physical Sector Size instead of Logical Sector
	size
References: <1322162451-17036-1-git-send-email-cmaiolino@redhat.com>
	<20111124195042.GA3671@andromeda.usersys.redhat.com>
	<20111127010643.GU2386@dastard> <4ED2C233.8010104@sandeen.net>
	<20111127235051.GX2386@dastard>
	<yq1vcq4grgi.fsf@sermon.lab.mkp.net> <4ED3B2BC.1060609@sandeen.net>
	<yq1r50qhmte.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1r50qhmte.fsf@sermon.lab.mkp.net>
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
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

On 11/29/11 11:15 AM, Martin K. Petersen wrote:
>>>>>> "Eric" == Eric Sandeen <sandeen@sandeen.net> writes:
> 
> Eric> It seems that we should be checking for any alignment offsets in
> Eric> libxfs then, too; if there IS an offset, then perhaps 4k is the
> Eric> wrong answer, (perhaps there is no right answer) but if there is
> Eric> NO offset, 4k should be the right choice, yes?
> 
> In most cases the partitioning/DM tools should give you a 0 offset. But
> it would a good idea to at least print a warning if lbs != pbs and
> offset > 0.

Right, Dave's concern was for when the partitioning tools didn't do the
job, we don't want to break fs consistency guarantees...

Dave, does checking for an offset before choosing 4k sectors seem
sufficient to you?

> 
> Eric> And if the drive is broken then c'est la vie?
> 
> Yes :)
> 
> 
> FWIW, the reason 4KB lbs drives are having a revival in the is that
> there is not a lot of confidence in 512e for the enterprise. Many
> vendors won't support them in servers due to correctness concerns and
> lack of performance predictability.

Imagine.  :)

-Eric


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
