Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3DHdJoq251663 for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 12:39:19 -0500
Received: from mx.inode.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E6EDA2BCE59
	for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 10:41:13 -0700 (PDT)
Received: from mx.inode.at (mx21.lb01.inode.at [62.99.145.23]) by cuda.sgi.com
	with ESMTP id LqkcscEZ8VMRO6bt for <xfs@oss.sgi.com>;
	Tue, 13 Apr 2010 10:41:13 -0700 (PDT)
Subject: Re: XFS-filesystem corrupted by defragmentation
References: <4627460.211442.1271174930836.JavaMail.fmail@mwmweb047>
From: Bernhard Gschaider <Bernhard.Gschaider@ice-sf.at>
Date: Tue, 13 Apr 2010 19:41:10 +0200
In-Reply-To: <4627460.211442.1271174930836.JavaMail.fmail@mwmweb047>
	(Sebastian Brings's message of "Tue,
	13 Apr 2010 18:08:50 +0200 (CEST)")
Message-ID: <87ljcrjlmx.fsf@workstation006.office.ice-sf.at>
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
To: Sebastian Brings <Sebastian.Brings@web.de>
Cc: xfs@oss.sgi.com


This is the first of many apologies in this mail: I apologize to everyone
for using German in this list and to Sebastian for the silly pun
(which he probably heard many times before): "Herr Brings, Ihr Tipp bringts"

Sebastian is exactly right: I copy/pasted the device-name from the
output of df to use with xfs_db when I should have used the value from
the fstab. Everything is alright with the filesystem (except for the
guy handling it)

So I apologize to all those whose time I've wasted (and who were nice
enough to answer me)
I apologize for doubting the quality of the XFS-filesystem and tools
And last but not least I apologize for top-posting

Bernhard

>>>>> On Tue, 13 Apr 2010 18:08:50 +0200 (CEST)
>>>>> "SB" == Sebastian Brings <Sebastian.Brings@web.de> wrote:

    SB> could it be you specified the wrong device for xfs_db? The
    SB> xfs_info gives =/dev/VolGroup00/LogVol05 as metadata device,
    SB> but for xfs_db you used /dev/mapper/VolGroup00-LogVol04...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
