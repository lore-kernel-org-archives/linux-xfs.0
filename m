Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 216A17FCC
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 13:22:48 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 025E38F8049
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 11:22:44 -0800 (PST)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[194.177.153.153]) by cuda.sgi.com with ESMTP id
	F5oDVXRiOEcmSVPI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 Nov 2015 11:22:38 -0800 (PST)
Subject: Re: Is it possible to change sunit of log section post-mkfs
References: <5638A62D.1020802@dermichi.com>
	<20151103130246.GA24445@bfoster.bfoster>
From: Michael Weissenbacher <mw@dermichi.com>
Message-ID: <56390979.2090509@dermichi.com>
Date: Tue, 3 Nov 2015 20:22:33 +0100
MIME-Version: 1.0
In-Reply-To: <20151103130246.GA24445@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

Hi Brian!

On 2015-11-03 14:02, Brian Foster wrote:
> I don't believe there's any supported way to do this.
Well, at least i didn't miss anything in the documentation :-)

On 2015-11-03 14:02, Brian Foster wrote:
> Out of curiosity,
> I just tried an experiment to modify the superblock logsunit via xfs_db
> and run repair to zero the log. That seemed to work in terms of taking
> effect on the subsequent mount, but that's certainly not something I
> would suggest to do in production.
Ok, so it would definitely be too risky for a production system.

On 2015-11-03 14:02, Brian Foster wrote:
> Note that mkfs aligns the physical
> log based on the stripe unit as well, so it wouldn't really have the
> same effect anyways.
TBH, i didn't quite understand that part :-)
Are you saying, even if i would modify the log's sunit size using
xfs_db, it would still not be aligned correctly?

thanks,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
