Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0F1V5PZ053812 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 19:31:06 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3BFB715F8FC
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 17:32:01 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id YjOK68pMAjenjG13 for
	<xfs@oss.sgi.com>; Thu, 14 Jan 2010 17:32:01 -0800 (PST)
Message-ID: <4B4FC591.4050104@sandeen.net>
Date: Thu, 14 Jan 2010 19:32:01 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: usage of xfsctrl for embedded development / uuid question
References: <17182907.184441263481368019.JavaMail.www@wsfrf1112>
	<20100115002938.GC17483@discord.disaster>
In-Reply-To: <20100115002938.GC17483@discord.disaster>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, paul.chavent@fnac.net

Dave Chinner wrote:
> [Please wrap you emails at 72 columns]


>> (3) regeneration of configure
>>
>>     The regeneration of configure fails whith this message
>>
>>     # rm configure
>>     # make configure
>>     [...]
>>     autoconf
>>     configure.in:101: error: possibly undefined macro: AC_HAVE_BLKID_TOPO
>>       If this token and others are legitimate, please use m4_pattern_allow.
>>       See the Autoconf documentation.
> 
> 'make distclean' is the correct way to remove the configuration and
> rebuild it. That should make the problem go away.

This is also a bug thanks to yours truly in the latest release,
Christoph sent a patch to fix it:

[PATCH] xfsprogs: add package_blkid.m4 to the distributed files

-Eric
 
> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
