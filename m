Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8F2F07F8C
	for <linux-xfs@oss.sgi.com>; Tue, 12 Feb 2013 16:21:57 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7C24D304043
	for <linux-xfs@oss.sgi.com>; Tue, 12 Feb 2013 14:21:54 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	GLDg22XiFzPXAHe8 for <linux-xfs@oss.sgi.com>;
	Tue, 12 Feb 2013 14:21:53 -0800 (PST)
Date: Wed, 13 Feb 2013 09:21:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Hung in D state during fclose
Message-ID: <20130212222150.GE26694@dastard>
References: <loom.20130212T071115-446@post.gmane.org>
	<20130212065545.GC10731@dastard>
	<3542214BE3A3EF419F236DFE0F878BC90512DC@BL2PRD0310MB374.namprd03.prod.outlook.com>
	<20130212102014.GA26694@dastard>
	<3542214BE3A3EF419F236DFE0F878BC90517D2@BL2PRD0310MB374.namprd03.prod.outlook.com>
	<20130212202246.GB26694@dastard>
	<3542214BE3A3EF419F236DFE0F878BC905190D@BL2PRD0310MB374.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3542214BE3A3EF419F236DFE0F878BC905190D@BL2PRD0310MB374.namprd03.prod.outlook.com>
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
To: "Cheung, Norman" <Norman.Cheung@kla-tencor.com>
Cc: "linux-xfs@oss.sgi.com" <linux-xfs@oss.sgi.com>

On Tue, Feb 12, 2013 at 09:06:03PM +0000, Cheung, Norman wrote:
> [NLC] Only 2 threads in D state.  I  need to wait for the next
> hang to take another stack trace.  Is there any workaround I can
> reduce the frequencies of this hang.  What about reducing the
> xfssyncd_centisecs? Or other knobs?

You need to isolate the cause of the hang before changing anything.
Twiddling random knobs won't improve the situation. Understand the
problem first, then take appropriate action.

> [NLC]  2 RAID controllers in the system, it hung from disks on
> both of them.  One is SuperMicro 2208 and the other is LSI
> 9265-8I.  I think both use the same chipset.

Does the filesystem that hangs always belong to the same controller?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
