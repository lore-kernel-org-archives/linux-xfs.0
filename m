Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4JHuJeV145584 for <xfs@oss.sgi.com>; Wed, 19 May 2010 12:56:20 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6C5A99E8A93
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 10:59:47 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id nuGaUtCEF3myRaRH
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 10:59:47 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 035056C24C
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 12:58:37 -0500 (CDT)
Message-ID: <4BF42725.8060903@hardwarefreak.com>
Date: Wed, 19 May 2010 13:00:05 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: noatime,nodiratime?
References: <4BF3F212.5030600@hardwarefreak.com>
	<87mxvveqyq.fsf@petole.demisel.net>
In-Reply-To: <87mxvveqyq.fsf@petole.demisel.net>
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

Nicolas KOWALSKI put forth on 5/19/2010 12:33 PM:
> Stan Hoeppner <stan@hardwarefreak.com> writes:
>> Need a little education here.  I have a general understanding of what the
>> inode access timestamps "are" but I have no idea what, if any, applications
>> make use of these access times.  I see posts all over Google land saying to
>> use "noatime,nodiratime,logbufs=8" for XFS mount options to increase
>> performance.
> 
> BTW, about the mount options for XFS, is there a way to check for the
> default values (things like logbsize, logbufs, something else)?
> 
> I used to have noatime,logbufs=8,logbsize=256k on my fileserver, not
> sure if these are still necessary.

Yes, the defaults for each parameter are in your mount man page.
logbsize=256K is higher than the default, which is 32K for any system with
over 32MB RAM.  logbufs=8 will be the default if your blocksize is 64K.  If
your blocksize is 4K you'll get logbufs=2 by default.  This is all in the
XFS section of man mount.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
