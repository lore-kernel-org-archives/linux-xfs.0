Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o232752R031976 for <xfs@oss.sgi.com>; Tue, 2 Mar 2010 20:07:05 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 88AA51D09AC2
	for <xfs@oss.sgi.com>; Tue,  2 Mar 2010 18:08:32 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id FDMNO9K8df1pQvJJ for
	<xfs@oss.sgi.com>; Tue, 02 Mar 2010 18:08:32 -0800 (PST)
Message-ID: <4B8DC49F.70103@sandeen.net>
Date: Tue, 02 Mar 2010 20:08:31 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Stalled xfs_repair on 100TB filesystem
References: <DD534F7C25BFA14FB18E6D603135D7EA0A11E82ECB@sbapexch05>	<4B8DAECA.50701@hardwarefreak.com>
	<4B8DB0ED.5040109@sandeen.net>
	<DD534F7C25BFA14FB18E6D603135D7EA0A11F91318@sbapexch05>
In-Reply-To: <DD534F7C25BFA14FB18E6D603135D7EA0A11F91318@sbapexch05>
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
To: Jason Vagalatos <Jason.Vagalatos@citrixonline.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Jason Vagalatos wrote:
> We are running xfs_repair v2.9.4.  Will just the -P flag suffice for
> this version?  What is the best way to calculate the bhash size value
> needed if we need to use that option too?

Good, that explains it then; the fix went in after that.

I think -P will suffice.

As for the bhash size ... really not sure.  Doubling it from the default 
is probably sufficient but I haven't really investigated it.

-Eric

> Thanks,
> 
> Jason Vagalatos
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
