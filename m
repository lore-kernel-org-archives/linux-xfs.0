Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7E0o6Gw061996 for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 19:50:18 -0500
Received: from mail.jquigley.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A48983CB1F1
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 17:50:42 -0700 (PDT)
Received: from mail.jquigley.com (main.jquigley.com [67.23.32.156]) by
	cuda.sgi.com with ESMTP id Jg4k6PhyAeka0SsI for
	<xfs@oss.sgi.com>; Thu, 13 Aug 2009 17:50:42 -0700 (PDT)
Message-ID: <4A84B4DE.1090809@jquigley.com>
Date: Thu, 13 Aug 2009 19:50:38 -0500
From: John Quigley <jquigley@jquigley.com>
MIME-Version: 1.0
Subject: Re: XFS corruption with failover
References: <4A8474D2.7050508@jquigley.com>
	<20090813231739.5c7db91d@galadriel.home>
In-Reply-To: <20090813231739.5c7db91d@galadriel.home>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: XFS Development <xfs@oss.sgi.com>

Emmanuel Florac wrote:
> By killing abruptly the primary server while doing IO, you're probably
> pushing the envelope... You may have a somewhat better luck with a
> cluster fs, OCFS2 works very well for me usually (GFS is a complete
> PITA to setup).

Acknowledged; we've looked at GFS, and I've been meaning to read up on OCFS2.  For various reasons, particularly performance, ease of deployment and flexible growth, XFS has been the clear winner in our particular case (and our case is fairly unique, as our volume is backed by a distributed storage device).

> You can get it to flush extremely
> often by playing with  /proc/sys/vm/dirty_expire_centiseconds
> and /proc/sys/vm/dirty_writeback_centisecs, though. Safer settings
> generally imply terrible performance, though, you've been warned.

Okay, interesting, I wasn't aware of these and will look into it.

> Ah another thing may be some cache option in the iSCSI target. what
> target are you using?  

No caching target side - I can speak definitely on that because I wrote it (integrates with our data dispersal stack [1]).  Also, we're utilizing the same target when failing over; it's just the ISCSI initiator (aka, the NFS server) that is changing.

Thank you kindly for the quick response.

- John Quigley

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
