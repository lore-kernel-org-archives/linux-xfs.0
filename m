Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7E167S5063009 for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 20:06:18 -0500
Received: from mail.jquigley.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4878D1B69441
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 18:06:52 -0700 (PDT)
Received: from mail.jquigley.com (main.jquigley.com [67.23.32.156]) by
	cuda.sgi.com with ESMTP id V0dZrCjnynyf2hgb for
	<xfs@oss.sgi.com>; Thu, 13 Aug 2009 18:06:52 -0700 (PDT)
Received: from [10.1.1.11] (OSH-NAT-213-122.onshore.net [66.146.213.122])
	(Authenticated sender: jquigley@mail.jquigley.com)
	by mail.jquigley.com (Postfix) with ESMTPSA id 7F102204116
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2009 01:06:19 +0000 (UTC)
Message-ID: <4A84B88A.4070701@jquigley.com>
Date: Thu, 13 Aug 2009 20:06:18 -0500
From: John Quigley <jquigley@jquigley.com>
MIME-Version: 1.0
Subject: Re: XFS corruption with failover
References: <4A8474D2.7050508@jquigley.com>	<E037F1E5-2CC8-4F6E-92ED-AFE7BE6EBD1B@sgi.com>
	<4A84B050.4020500@sandeen.net>
In-Reply-To: <4A84B050.4020500@sandeen.net>
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
To: XFS Development <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Are you sure?
> 
>                 if (ohead->oh_clientid != XFS_TRANSACTION &&
>                     ohead->oh_clientid != XFS_LOG) {
>                         xlog_warn(
>                 "XFS: xlog_recover_process_data: bad clientid");
>                         ASSERT(0);
>                         return (XFS_ERROR(EIO));
>                 }
> 
> so it does say EIO but that seems to me to be the wrong error; loks more
> like a bad log to me.

Hey Eric:

That would certainly be consistent with our experience, as the only way we're able to bring the file system back online is by zeroing the log.

> It does make me wonder if there's any sort of per-initiator caching on
> the iscsi target or something.  </handwave>

There isn't, as mentioned above, though we have several intermediate layers between the file system and iSCSI initiator, including multipath and LVM, both of which I was initially suspicious of.  In testing with a similar scenario but in a more isolate fashion without those two intermediates, the behavior was still present.  Also, just to clarify the topology:

                  /-----[Failover Secondary]------\
                 /                                 \
 NFS Client ----/                                   \-----[ISCSI Target]----[Distributed Storage]
                \                                   /
                 \                                 /
                  \-----[Failover Primary]--------/

Those two failover machines, Primary and Secondary, act as the NFS server, the XFS mountpoint and ISCSI initiator.  Only one failover machine is logged into the ISCSI target/has XFS mounted.

Thanks very much for your cycles on this guys.

- John Quigley

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
