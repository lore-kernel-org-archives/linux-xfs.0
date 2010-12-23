Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBNLGVZI250834 for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 15:16:32 -0600
Received: from passage.avira.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56A6E147E9AF
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 13:18:29 -0800 (PST)
Received: from passage.avira.com (passage.avira.com [89.238.222.20]) by
	cuda.sgi.com with ESMTP id R6YjUHWHRaC0jQ05 for
	<xfs@oss.sgi.com>; Thu, 23 Dec 2010 13:18:29 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by passage.avira.com (Postfix/AVIRA) with ESMTP id 2740C1249F9
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 23:18:28 +0200 (EET)
Received: from naliboat.bu.avira.com (dasapass.avira.com [89.238.222.18])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "mail.bu.avira.com",
	Issuer "Avira Intermediate Certificate Authority 2010-2020" (not
	verified))
	by passage.avira.com (Postfix/AVIRA) with ESMTPS id 18B1B1249F9
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 23:18:28 +0200 (EET)
Date: Thu, 23 Dec 2010 23:16:50 +0200
From: Petre Rodan <petre.rodan@simplex.ro>
Subject: Re: xfssyncd and disk spin down
Message-ID: <20101223211650.GA19694@peter.simplex.ro>
References: <20101223165532.GA23813@peter.simplex.ro>
	<4D13A30A.3090600@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D13A30A.3090600@hardwarefreak.com>
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


Hello,

On Thu, Dec 23, 2010 at 01:29:14PM -0600, Stan Hoeppner wrote:
> Petre Rodan put forth on 12/23/2010 10:55 AM:
> 
> > this hard drive has exceeded it's 300k load/unload maximum from the specs in only 140 days, which means it was woken up every 30s or so. not willingly.
> 
> Contact WD and request a warranty replacement for the drive due to
> exceeding the spec'd cycle max in less than 6 months.  They may not
> honor your request.  Whether they do or not, I'd replace the drive as
> the mechanism obviously has too much wear on it already, and within one
> year of use will have well over double the spec'd cycles.  If you
> replace it with another 20EARS, replace the firmware immediately as
> mentioned below to decrease the load/unload rate.  (It would be nice if
> they offered the ability to disable the sleep mode totally, but then it
> wouldn't be "green" pfft).

thanks for your input. I did run wdidle3 on that drive two days ago stopping the nonsense.

but my original mail had a different target really. I have to recognize that I don't know much about the inner-workings of a filesystem, but I find it odd that once there is no input from the outside, a process keeps writing to the drive indefinitely. in my very narrow thinking the fact that these writes dissapear after a remount would prove their redundance.

to wrap it up, I see no logic to the above and this is why I ask the list to tell me if this is 

 a. something that can easily be fixed via an option I failed to find
 b. a critical part of xfs's internals that cannot be 'disabled' (with a short explanation)
 c. simply a bug

with the little side-story with the WD 20EARS i was just portraying where this default behaviour can get to. 
I don't usually read marketing material, but WD acknowledges that their green drives are wrecked in Linux and they simply encourage customers to change their OS. I just have to ask why have we got to get to this point.

the drive I was trying to get into standby in the first half of my mail is a different one, an enterprise ST31000340NS placed on an otherwise low power ProLiant MicroServer. Having 8W*12h*30 = 2880 Wh less to pay per hdd per month would be easily achievable if the standby mode would be reached when possible.

cheers,
peter

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
