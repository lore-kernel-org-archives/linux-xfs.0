Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p36HGlg2045468 for <xfs@oss.sgi.com>; Wed, 6 Apr 2011 12:16:47 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B340515B6391
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2011 10:20:02 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id x9257iKPGTZUd2Qo
	for <xfs@oss.sgi.com>; Wed, 06 Apr 2011 10:20:02 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id F3EF66C143
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2011 12:19:59 -0500 (CDT)
Message-ID: <4D9CA0BF.9010706@hardwarefreak.com>
Date: Wed, 06 Apr 2011 12:19:59 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: SL's kickstart corrupting XFS by "repairing" GPT labels?
References: <4D9C3E14.6030009@fzu.cz> <20110406114146.GF31057@dastard>
In-Reply-To: <20110406114146.GF31057@dastard>
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
To: xfs@oss.sgi.com

Dave Chinner put forth on 4/6/2011 6:41 AM:
> On Wed, Apr 06, 2011 at 12:19:00PM +0200, Jan Kundr=E1t wrote:

>> zerombr yes
>> clearpart --all --initlabel
>> part swap --size=3D1024 --asprimary
>> part / --fstype ext3 --size=3D0 --grow --asprimary
> =

> There your problem - hello random crap....

Yep, most likely.

> Given the nature of the problem, I have to assume you aren't using
> FC zoning to prevent hosts from seeing disks that don't belong to
> them?

Switch soft zoning isn't even required to avoid this kind of mess.  The
Nexsan arrays (as with many/most others) have built in LUN security,
allowing you to unmask a LUN to only specific WWNs of specific HBAs.
With Nexsan products, by default, no LUNs are unmasked after creating a
virtual disk and assigning a LUN to it.  One must then manually unmask a
LUN to one or more HBA WWNs.

Their are basically only 3 scenarios when you would assign more than one
HBA WWN to a given LUN:

1.  multi-pathing between two (or more) FC ports on one host
2.  shared disk cluster filesystem such as CXFS, GFS2, or OCFS.
3.  passive fail over high availability

Some folks assign "everything to everything" on their FC SAN for various
not so well considered reasons, without realizing the consequences.

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
