Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 455937CA3
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 08:29:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A5A89AC001
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 06:29:34 -0700 (PDT)
Received: from hotel311.server4you.de (hotel311.server4you.de [85.25.146.15])
	by cuda.sgi.com with ESMTP id 3qSXBs4Z9c2jXGuG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 02 Jun 2016 06:29:31 -0700 (PDT)
Subject: Re: Internal error xfs_trans_cancel
References: <ab487269-a423-e3dc-6f59-3dda004960c3@monom.org>
	<20160601071047.GJ12670@dastard>
	<e80cee4f-1789-5418-ffa8-7551138bda0a@monom.org>
	<0644b434-6cea-4188-9702-469c26d191b8@monom.org>
	<20160602002653.GL12670@dastard>
	<af997005-e144-5509-885c-a688562ea3ec@monom.org>
	<20160602063539.GM12670@dastard>
From: Daniel Wagner <wagi@monom.org>
Message-ID: <a933729c-afa8-3cc1-6fe4-5f49b9629326@monom.org>
Date: Thu, 2 Jun 2016 15:29:29 +0200
MIME-Version: 1.0
In-Reply-To: <20160602063539.GM12670@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

> Hmmm, Ok. I've been running the lockperf test and kernel builds all
> day on a filesystem that is identical in shape and size to yours
> (i.e. xfs_info output is the same) but I haven't reproduced it yet.

I don't know if that is important: I run the lockperf test and after
they have finished I do a kernel build.

> Is it possible to get a metadump image of your filesystem to see if
> I can reproduce it on that?

Sure, see private mail.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
