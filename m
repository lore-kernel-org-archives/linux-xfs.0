Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3E5457F74
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 07:05:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1D054304048
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 05:05:50 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ojfVEsE8GLVV9OH2 for <xfs@oss.sgi.com>;
	Tue, 12 Mar 2013 05:05:49 -0700 (PDT)
Date: Tue, 12 Mar 2013 23:05:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ASSERT failure] transaction reservations changes bad?
Message-ID: <20130312120545.GO21651@dastard>
References: <20130312062001.GJ21651@dastard> <20130312062531.GK21651@dastard>
	<513EE274.6090808@oracle.com> <20130312103138.GN21651@dastard>
	<513F0C07.1060000@oracle.com> <513F17F3.1010204@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <513F17F3.1010204@oracle.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: xfs@oss.sgi.com

On Tue, Mar 12, 2013 at 07:56:35PM +0800, Jeff Liu wrote:
> More info, 3.7.0 is the oldest kernel on my environment, I ran into the
> same problem.

Thanks for following up so quickly, Jeff. So the problem is that a
new test is tripping over a bug that has been around for a while,
not that it is a new regression.

OK, so I'll expunge that from my testing for the moment as I don't
ahve time to dig in and find out what the cause is right now. If
anyone else wants to.... :)

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
