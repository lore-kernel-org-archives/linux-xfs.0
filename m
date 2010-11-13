Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAD9RG8B229293 for <xfs@oss.sgi.com>; Sat, 13 Nov 2010 03:27:17 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 164AC13B6F9C
	for <xfs@oss.sgi.com>; Sat, 13 Nov 2010 01:28:46 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id u1znSXECPbQXant0
	for <xfs@oss.sgi.com>; Sat, 13 Nov 2010 01:28:46 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 20AB16C116
	for <xfs@oss.sgi.com>; Sat, 13 Nov 2010 03:28:46 -0600 (CST)
Message-ID: <4CDE5A4D.9090905@hardwarefreak.com>
Date: Sat, 13 Nov 2010 03:28:45 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs_repair of critical volume
References: <75C248E3-2C99-426E-AE7D-9EC543726796@ucsc.edu>	<4CCD3CE6.8060407@hardwarefreak.com>	<864DA9C9-B4A4-4B6B-A901-A457E2B9F5A5@ucsc.edu>	<201011121422.28993@zmi.at>
	<4CDDBC5C.7020708@hardwarefreak.com>
	<20101113091938.1d0553a8@galadriel.home>
In-Reply-To: <20101113091938.1d0553a8@galadriel.home>
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

Emmanuel Florac put forth on 11/13/2010 2:19 AM:
> Le Fri, 12 Nov 2010 16:14:52 -0600 vous =E9criviez:
> =

>> This isn't "robustness" Michael.  If anything it's a serious problem.
> =

> I beg to disagree. Would it be better if instead of still having some
> of the data, everything was lost? At what level of accidental
> destruction do you think that the whole data set should be made
> unavailable? 10%? 5? 1? =


You've missed the point of this sub thread discussion, or I did.  He
stated that having the metadata show the files still exist is a positive
thing.  The files are gone.  I stated that this discrepancy is not good
thing.

I believe you are confused, thinking this micro discussion is dealing
with the OP's overall situation.  It is not.  It is dealing strictly
with the issue of the lost set of disks, the files that were on them,
and the fact the metadata says they still exist.  I believe this is due
to the fact that he hasn't run a destructive xfs_repair yet, which I'm
guessing will remove those orphaned metadata entries.

Again, I'm pretty sure you misunderstood exactly what we were talking
about, or I misunderstood what he was talking about, heck, maybe both.
I absolutely was not stating anything akin to throwing the baby out with
the bath water.

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
