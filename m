Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7U1Np9M253744 for <xfs@oss.sgi.com>; Sat, 29 Aug 2009 20:24:01 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 148DE1583F3D
	for <xfs@oss.sgi.com>; Sat, 29 Aug 2009 18:24:43 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id zmVf6e7ulCMUm83b for
	<xfs@oss.sgi.com>; Sat, 29 Aug 2009 18:24:43 -0700 (PDT)
Message-ID: <4A99D4DF.50003@sandeen.net>
Date: Sat, 29 Aug 2009 18:24:47 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs data loss
References: <B9A7B002C7FAFC469D4229539E909760308DA651DE@DU-EXC-MAIL.empa.emp-eaw.ch>	<4A975A35.3060809@sandeen.net>	<B9A7B002C7FAFC469D4229539E909760308DA65345@DU-EXC-MAIL.empa.emp-eaw.ch>	<4A981133.6060009@sandeen.net>
	<B9A7B002C7FAFC469D4229539E909760308DA65408@DU-EXC-MAIL.empa.emp-eaw.ch>
In-Reply-To: <B9A7B002C7FAFC469D4229539E909760308DA65408@DU-EXC-MAIL.empa.emp-eaw.ch>
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
To: "Passerone, Daniele" <Daniele.Passerone@empa.ch>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Passerone, Daniele wrote:
> I would like to ask mr. Peter Grandi, whether it is really necessary
> to delivery ist vaste knowledge in such a harsh way. Is this the
> habit of this mailing list?

Not generally.

> Apart from that, thank you for you help. I understand that RAID5 is
> not the ideal solution for that system, and I admit that in the
> urgence of solving the /md4 problem I miswrote the problem of /md6,
> which of course was "erased" and not "repaired".
> 
> But apart from that, it is not as easy to backup 20 TB, so we decided
> to set it as data storage leaving the responsibilty of the backup to
> our users. I do not consider it completely absurd.

I think others have pointed out, though, that you start -increasing- the 
risk of failure at a certain point...

> Moreover, when a raid loses 2 devices, and the devices are still ok,
> it is possible to reassemble the raid by assuming the devices clean.
> 
> This is not the case for /Raid/md4, where apparently all devices are
> there.

This all seems most likely to be a raid failure problem, but it's hard 
to know.  I can't imagine why you're getting suddenly-disappearing 
directories without a reboot or even a single error message; I just 
don't know what to make of that.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
