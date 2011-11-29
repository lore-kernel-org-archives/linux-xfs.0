Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pATHFwxZ080148 for <xfs@oss.sgi.com>; Tue, 29 Nov 2011 11:15:58 -0600
Received: from acsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A31EE4FBC26
	for <xfs@oss.sgi.com>; Tue, 29 Nov 2011 09:15:57 -0800 (PST)
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id 0di2GOh2TxE5F292 for
	<xfs@oss.sgi.com>; Tue, 29 Nov 2011 09:15:57 -0800 (PST)
Subject: Re: [PATCH] libxfs: Get Physical Sector Size instead of Logical
	Sector size
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <1322162451-17036-1-git-send-email-cmaiolino@redhat.com>
	<20111124195042.GA3671@andromeda.usersys.redhat.com>
	<20111127010643.GU2386@dastard> <4ED2C233.8010104@sandeen.net>
	<20111127235051.GX2386@dastard> <yq1vcq4grgi.fsf@sermon.lab.mkp.net>
	<4ED3B2BC.1060609@sandeen.net>
Date: Tue, 29 Nov 2011 12:15:41 -0500
In-Reply-To: <4ED3B2BC.1060609@sandeen.net> (Eric Sandeen's message of "Mon,
	28 Nov 2011 10:11:40 -0600")
Message-ID: <yq1r50qhmte.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, xfs@oss.sgi.com

>>>>> "Eric" == Eric Sandeen <sandeen@sandeen.net> writes:

Eric> It seems that we should be checking for any alignment offsets in
Eric> libxfs then, too; if there IS an offset, then perhaps 4k is the
Eric> wrong answer, (perhaps there is no right answer) but if there is
Eric> NO offset, 4k should be the right choice, yes?

In most cases the partitioning/DM tools should give you a 0 offset. But
it would a good idea to at least print a warning if lbs != pbs and
offset > 0.


Eric> And if the drive is broken then c'est la vie?

Yes :)


FWIW, the reason 4KB lbs drives are having a revival in the is that
there is not a lot of confidence in 512e for the enterprise. Many
vendors won't support them in servers due to correctness concerns and
lack of performance predictability.

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
