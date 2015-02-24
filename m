Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4AE197F3F
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 09:15:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3924A8F80C9
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 07:15:36 -0800 (PST)
Received: from darcachon.resolversystems.com (darcachon.resolversystems.com
	[80.68.93.186]) by cuda.sgi.com with ESMTP id sCffsxjDgJZHS5tV
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 24 Feb 2015 07:15:34 -0800 (PST)
Received: from host81-136-198-183.in-addr.btopenworld.com ([81.136.198.183]
	helo=[192.168.0.109]) by darcachon.resolversystems.com with esmtpsa
	(TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80)
	(envelope-from <harry@pythonanywhere.com>) id 1YQHCt-0007gw-Rq
	for xfs@oss.sgi.com; Tue, 24 Feb 2015 15:15:32 +0000
Message-ID: <54EC958E.2000001@pythonanywhere.com>
Date: Tue, 24 Feb 2015 15:15:26 +0000
From: Harry <harry@pythonanywhere.com>
MIME-Version: 1.0
Subject: trying to avoid a lengthy quotacheck by deleting all quota data
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi there,

We've got a moderately large disk (~2TB) into an inconsistent state, 
such that it's going to want a quotacheck the next time we mount it 
(it's currently mounted with quota accounting inactive).  Our tests 
suggest this is going to take several hours, and cause an outage we 
can't afford.

We're wondering whether there's a 'nuke the site from orbit' option that 
will let us avoid it.  The plan would be to:
- switch off quotas and delete them completely, using the commands:
   -- disable
   -- off
   -- remove
- remount the drive with -o prjquota, hoping that there will not be a 
quotacheck, because we've deleted all the old quota data
- run a script gradually restore all the quotas, one by one and in good 
time, from our own external backups (we've got the quotas in a database 
basically).

So the questions are:
- is there a way to remove all quota information from a mounted drive?
(the current mount status seems to be that it tried to mount it with -o 
prjquota but that quota accounting is *not* active)
- will it work and let us remount the drive with -o prjquota without 
causing a quotacheck?

Answers on a postcard, received with the utmost gratitude.

Rgds,
Harry + the PythonAnywhere team.

-- 
Harry Percival
Developer
harry@pythonanywhere.com

PythonAnywhere - a fully browser-based Python development and hosting environment
<http://www.pythonanywhere.com/>

PythonAnywhere LLP
17a Clerkenwell Road, London EC1M 5RD, UK
VAT No.: GB 893 5643 79
Registered in England and Wales as company number OC378414.
Registered address: 28 Ely Place, 3rd Floor, London EC1N 6TD, UK

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
