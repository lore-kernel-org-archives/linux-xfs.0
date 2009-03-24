Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2OLoAlO047868
	for <linux-xfs@oss.sgi.com>; Tue, 24 Mar 2009 16:50:20 -0500
Received: from fmmailgate02.web.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 81CF21C69A6F
	for <linux-xfs@oss.sgi.com>; Tue, 24 Mar 2009 14:49:20 -0700 (PDT)
Received: from fmmailgate02.web.de (fmmailgate02.web.de [217.72.192.227]) by
	cuda.sgi.com with ESMTP id iRJf3NESOmraa8wW for
	<linux-xfs@oss.sgi.com>; Tue, 24 Mar 2009 14:49:20 -0700 (PDT)
From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: How to configure 36 disks ?
References: <174852.24274.qm@web51309.mail.re2.yahoo.com>
Date: Tue, 24 Mar 2009 20:38:35 +0100
In-Reply-To: <174852.24274.qm@web51309.mail.re2.yahoo.com> (Jon Hardcastle's
	message of "Mon, 23 Mar 2009 09:02:14 -0700 (PDT)")
Message-ID: <87hc1iemo4.fsf@frosties.localdomain>
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
To: Jon@eHardcastle.com
Cc: linux-aio@kvack.org, Linux RAID Mailing List <linux-raid@vger.kernel.org>, linux-xfs@oss.sgi.com, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Raz <raziebe@gmail.com>, linux-fsdevel@vger.kernel.org, Bill Davidsen <davidsen@tmr.com>

Jon Hardcastle <jd_hardcastle@yahoo.com> writes:

> I'd like to understand how you even go attaching that many devices to a system.. I am 'comparatively' new to this.. and have a 6 raid5 system.. not enterprise.. and i have slammed into case/power/sat slot issues already. What sort of hardware must one use to grow to a 36 array system!

Well, lets see.

Put 3 dual channel SAS controler in the box giving you 6 external SAS
connectors. Buy 6 48x disk enclosures and connect them. Configure them
all as JBOD and you get your 288 disks.

MfG
        Goswin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
