Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0D38QTi108153 for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 21:08:26 -0600
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0B5AA1C49B55
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 19:09:20 -0800 (PST)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id 3wNo2oUgFnic6u5S for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2010 19:09:20 -0800 (PST)
Date: Wed, 13 Jan 2010 14:09:14 +1100 (EST)
From: Nathan Scott <nscott@aconex.com>
Message-ID: <643097034.1721341263352154340.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <2097834991.1721031263351861134.JavaMail.root@mail-au.aconex.com>
Subject: Re: [TuxOnIce-devel] Latest updates.
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
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: TuxOnIce Devel List <tuxonice-devel@lists.tuxonice.net>, xfs@oss.sgi.com


----- "Martin Steigerwald" <Martin@lichtvoll.de> wrote:

> Please keep CC to TuxOnIce devel list.
> 
> 
> Hi!
> 
> Nigel, who develops the alternative TuxOnIce hibernation / snapshot 
> infrastructure, implemented checking last mount time of filesystem as
> a 
> safety feature for Ext 2, 3 and 4.
> 
> He would like this also for XFS. Does XFS record the last mount time 
> somewhere?

Nope.

> If not, could this be added?

Anythings possible ... its a relatively trivial change, and there's room
in the superblock.  Could probably even be done without a superblock version
bump - if you were prepared to live with the possibility of finding zero in
the ondisk location & dealing with it appropriately (i.e. last mount time
unknown).

Guess you'd have to convince the XFS folks doing most of the work these
days, but really it'd be quite trivial to implement.  xfs_mount_log_sb()
would be the place to start looking...

cheers.

-- 
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
