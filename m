Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6NGX52u211881 for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 11:33:05 -0500
Received: from ucsc.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 229F046D012
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 09:36:07 -0700 (PDT)
Received: from ucsc.edu (email-prod-out-1.ucsc.edu [128.114.129.85]) by
	cuda.sgi.com with ESMTP id QK7nc7wsJ7crNicJ for
	<xfs@oss.sgi.com>; Fri, 23 Jul 2010 09:36:07 -0700 (PDT)
Subject: Re: filesystem shrinks after using xfs_repair
Mime-Version: 1.0 (Apple Message framework v1081)
From: Eli Morris <ermorris@ucsc.edu>
In-Reply-To: <20100723122306.1b33aa82@harpe.intellique.com>
Date: Fri, 23 Jul 2010 09:36:00 -0700
Message-Id: <E84063EA-39F4-4B99-9F24-4D90EADB7C0D@ucsc.edu>
References: <DFB2DB04-A3BA-4272-A12A-4F28A7D51491@ucsc.edu>
	<20100712134743.624249b2@harpe.intellique.com>
	<274A8D0C-4C31-4FB9-AB2D-BA3C31D497E0@ucsc.edu>
	<20100723122306.1b33aa82@harpe.intellique.com>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

On Jul 23, 2010, at 3:23 AM, Emmanuel Florac wrote:

> Le Fri, 23 Jul 2010 01:30:40 -0700
> Eli Morris <ermorris@ucsc.edu> =E9crivait:
> =

>> I think the raid tech support and me found and corrected the hardware
>> problems associated with the RAID. I'm still having the same problem
>> though. I expanded the filesystem to use the space of the now
>> corrected RAID and that seems to work OK. I can write files to the
>> new space OK. But then, if I run xfs_repair on the volume, the newly
>> added space disappears and there are tons of error messages from
>> xfs_repair (listed below)
> =

> When you do the xfs_repair, did you check dmesg or /var/log/messages
> immediately thereafter? Just to get sure there isn't any intervening
> hard error.
> =

> -- =

> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                    |   Intellique
>                    |	<eflorac@intellique.com>
>                    |   +33 1 78 94 84 02
> ------------------------------------------------------------------------

Hi, =


No, I don't see any hardware errors after running xfs_repair.

thanks,

Eli

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
