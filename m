Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAE3RE5c102348 for <xfs@oss.sgi.com>; Sat, 13 Nov 2010 21:27:15 -0600
Received: from ucsc.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A69E7178CCF
	for <xfs@oss.sgi.com>; Sat, 13 Nov 2010 19:28:44 -0800 (PST)
Received: from ucsc.edu (email-prod-out-1.ucsc.edu [128.114.129.85]) by
	cuda.sgi.com with ESMTP id pftjp6HcEmds2Nh7 for
	<xfs@oss.sgi.com>; Sat, 13 Nov 2010 19:28:44 -0800 (PST)
Received: from [128.114.125.121] (HELO ucsc.edu)
	by email-prod-out-1.ucsc.edu (CommuniGate Pro SMTP 5.2.13)
	with ESMTPS id 26578487 for xfs@oss.sgi.com;
	Sat, 13 Nov 2010 19:28:43 -0800
Received: from [71.198.233.81] (account ermorris@ucsc.edu HELO [10.0.1.4])
	by email-prod-fe-2.ucsc.edu (CommuniGate Pro SMTP 5.2.13)
	with ESMTPSA id 401741862 for xfs@oss.sgi.com;
	Sat, 13 Nov 2010 19:28:30 -0800
Mime-Version: 1.0 (Apple Message framework v1082)
Subject: Re: xfs Digest, Vol 27, Issue 39
From: Eli Morris <ermorris@ucsc.edu>
In-Reply-To: <mailman.1.1289671202.29335.xfs@oss.sgi.com>
Date: Sat, 13 Nov 2010 19:28:30 -0800
Message-Id: <61D1606F-A16A-4B50-B166-A86B9698DA3D@ucsc.edu>
References: <mailman.1.1289671202.29335.xfs@oss.sgi.com>
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
To: xfs@oss.sgi.com

> 
> 
> Message: 1
> Date: Sat, 13 Nov 2010 09:19:38 +0100
> From: Emmanuel Florac <eflorac@intellique.com>
> Subject: Re: xfs_repair of critical volume
> To: Stan Hoeppner <stan@hardwarefreak.com>
> Cc: xfs@oss.sgi.com
> Message-ID: <20101113091938.1d0553a8@galadriel.home>
> Content-Type: text/plain; charset=ISO-8859-1
> 
> Le Fri, 12 Nov 2010 16:14:52 -0600 vous ?criviez:
> 
>> This isn't "robustness" Michael.  If anything it's a serious problem.
> 
> I beg to disagree. Would it be better if instead of still having some
> of the data, everything was lost? At what level of accidental
> destruction do you think that the whole data set should be made
> unavailable? 10%? 5? 1? 
> 
> -- 
> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                    |   Intellique
>                    |	<eflorac@intellique.com>
>                    |   +33 1 78 94 84 02
> ------------------------------------------------------------------------
> 
> 
> 
> ------------------------------
> 
> Message: 2
> Date: Sat, 13 Nov 2010 03:28:45 -0600
> From: Stan Hoeppner <stan@hardwarefreak.com>
> Subject: Re: xfs_repair of critical volume
> To: xfs@oss.sgi.com
> Message-ID: <4CDE5A4D.9090905@hardwarefreak.com>
> Content-Type: text/plain; charset=ISO-8859-1
> 
> Emmanuel Florac put forth on 11/13/2010 2:19 AM:
>> Le Fri, 12 Nov 2010 16:14:52 -0600 vous ?criviez:
>> 
>>> This isn't "robustness" Michael.  If anything it's a serious problem.
>> 
>> I beg to disagree. Would it be better if instead of still having some
>> of the data, everything was lost? At what level of accidental
>> destruction do you think that the whole data set should be made
>> unavailable? 10%? 5? 1? 
> 
> You've missed the point of this sub thread discussion, or I did.  He
> stated that having the metadata show the files still exist is a positive
> thing.  The files are gone.  I stated that this discrepancy is not good
> thing.
> 
> I believe you are confused, thinking this micro discussion is dealing
> with the OP's overall situation.  It is not.  It is dealing strictly
> with the issue of the lost set of disks, the files that were on them,
> and the fact the metadata says they still exist.  I believe this is due
> to the fact that he hasn't run a destructive xfs_repair yet, which I'm
> guessing will remove those orphaned metadata entries.
> 
> Again, I'm pretty sure you misunderstood exactly what we were talking
> about, or I misunderstood what he was talking about, heck, maybe both.
> I absolutely was not stating anything akin to throwing the baby out with
> the bath water.
> 
> -- 
> Stan


Hi,

Just to clarify, I have run the destructive xfs_repair command a few times. I still have the same thing going on where the filesystem says the files are there when clearly they aren't. 


thanks,

Eli

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
