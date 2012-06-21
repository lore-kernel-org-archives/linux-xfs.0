Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5LHB5TY100946 for <xfs@oss.sgi.com>; Thu, 21 Jun 2012 12:11:05 -0500
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id nJvgIdjkZ94aGTiV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 21 Jun 2012 10:11:04 -0700 (PDT)
Received: from telerig.nabble.com ([192.168.236.162])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>) id 1ShkuN-0004dG-MP
	for xfs@oss.sgi.com; Thu, 21 Jun 2012 10:11:03 -0700
Message-ID: <34049926.post@talk.nabble.com>
Date: Thu, 21 Jun 2012 10:11:03 -0700 (PDT)
From: pkamala <priya.kamala@perpetual-data.com>
Subject: Re: Possible memory allocation deadlock - kernel 3.2.1
In-Reply-To: <20120621161728.GD2503@sgi.com>
MIME-Version: 1.0
References: <34049469.post@talk.nabble.com> <20120621161728.GD2503@sgi.com>
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


Hi Ben,

Thanks for the quick response. Yes, this does look like the problem I'm
seeing. slabtop shows xfs_inode using 1683004K Cache Size just before I lose
connection to the server. I'll check out the patches.

Regards,
Priya
-- 
View this message in context: http://old.nabble.com/Possible-memory-allocation-deadlock---kernel-3.2.1-tp34049469p34049926.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
