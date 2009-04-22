Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3M2H1Y2165048 for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 21:17:02 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6DC8022E711
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 19:16:57 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id Ep2fLvo3rqDpRIbj for
	<xfs@oss.sgi.com>; Tue, 21 Apr 2009 19:16:57 -0700 (PDT)
Message-ID: <49EE7E17.8050006@sandeen.net>
Date: Tue, 21 Apr 2009 21:16:55 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Oops at xfs_bmbt_get_startoff in SLES 10 2.6.16
References: <64323.24.80.224.145.1236883814.squirrel@squirrel.kevinjamieson.com>	<49B9611F.5040009@sandeen.net>	<58707.24.80.224.145.1236899620.squirrel@squirrel.kevinjamieson.com>
	<53630.24.80.224.145.1240361692.squirrel@squirrel.kevinjamieson.com>
In-Reply-To: <53630.24.80.224.145.1240361692.squirrel@squirrel.kevinjamieson.com>
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
To: kevin@kevinjamieson.com
Cc: xfs@oss.sgi.com

Kevin Jamieson wrote:
> On Thu, March 12, 2009 4:13 pm, Kevin Jamieson wrote:
>> On Thu, March 12, 2009 12:23 pm, Eric Sandeen wrote:
>>
>>> For SLES that usually is the best route...
>>>
>>> However, http://oss.sgi.com/archives/xfs/2009-02/msg00220.html looks
>>> applicable... don't think it ever got merged though.
>>>
>>> perhaps you could test it?
>> Thanks, Eric. I will test Lachlan's patch on our system.
> 
> To follow this up, since applying the patch from the above thread there
> have been no re-occurrences of the issue on our test servers over the past
> month.

And you hit it pretty reliably before, right?  Sounds like we need to
give that a pretty strong eyeball and get it merged, perhaps.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
