Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pATJXfcW093907 for <xfs@oss.sgi.com>; Tue, 29 Nov 2011 13:33:42 -0600
Received: from crunch.scalableinformatics.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4179028611D
	for <xfs@oss.sgi.com>; Tue, 29 Nov 2011 11:33:41 -0800 (PST)
Received: from crunch.scalableinformatics.com
	(173-10-54-97-Michigan.hfc.comcastbusiness.net [173.10.54.97])
	by cuda.sgi.com with ESMTP id GeJRRNZIVOFFLgfP for
	<xfs@oss.sgi.com>; Tue, 29 Nov 2011 11:33:41 -0800 (PST)
Received: from crunch.scalableinformatics.com (localhost [127.0.0.1])
	by crunch.scalableinformatics.com (Postfix) with ESMTP id 2823685E86E5
	for <xfs@oss.sgi.com>; Tue, 29 Nov 2011 14:33:40 -0500 (EST)
Received: from [192.168.1.171] (metal.scalableinformatics.com [192.168.1.171])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by crunch.scalableinformatics.com (Postfix) with ESMTPSA id
	1D74D85E0351
	for <xfs@oss.sgi.com>; Tue, 29 Nov 2011 14:33:40 -0500 (EST)
Message-ID: <4ED53394.2010100@scalableinformatics.com>
Date: Tue, 29 Nov 2011 14:33:40 -0500
From: Joe Landman <landman@scalableinformatics.com>
MIME-Version: 1.0
Subject: Re: sync() in 2.6.38.5
References: <CAOO4vO6sSFBxXXK1z018=ekEZpcpnZ5NT_xe3d503NjN3aHF5A@mail.gmail.com>
In-Reply-To: <CAOO4vO6sSFBxXXK1z018=ekEZpcpnZ5NT_xe3d503NjN3aHF5A@mail.gmail.com>
Reply-To: landman@scalableinformatics.com
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
To: xfs@oss.sgi.com

On 11/29/2011 02:17 PM, Paul Anderson wrote:
> Hi all,
>
> 2.6.38.5 (x64 intel, in todays case a 40TiByte SAN volume) appears to
> have a bug whereby not all active metadata will be flushed even on a
> quiescent machine (one that has nonetheless in the past been under
> very high load).
>
> We have tried several variations of clean shutdowns, combined with for
> example the "echo 3>/proc/sys/vm/drop_caches" trick to no avail - we
> still get lost files (well, 0 length files).
>
> We have several big servers scheduled to go down shortly, and I was
> wondering if there are other ideas besides just coping all recent data
> to another server.

Set your vm dirty time to small values.  1 second (100 centiseconds) or 
so, among other things.  You can also force the mount to be synchronous 
(kills performance though).

Try

	mount -o remount,sync /mountpoint
	# not sure if this works with xfs though ...

	sysctl -w vm.dirty_writeback_centisecs=100
	sysctl -w vm.dirty_expire_centisecs=100
	sysctl -w vm.dirty_ratio=1



-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
