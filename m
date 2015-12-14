Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9202C29DF6
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 17:32:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2E455AC002
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 15:32:14 -0800 (PST)
Received: from mail-lb0-f178.google.com (mail-lb0-f178.google.com
	[209.85.217.178]) by cuda.sgi.com with ESMTP id
	4f9AFuNDlW9m9JYl (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Dec 2015 15:32:11 -0800 (PST)
Received: by lbpu9 with SMTP id u9so110000910lbp.2
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 15:32:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151208064410.GD19802@dastard>
References: <1447856269-7872-1-git-send-email-agruenba@redhat.com>
	<1447856269-7872-6-git-send-email-agruenba@redhat.com>
	<20151123230847.GH26718@dastard>
	<CAHc6FU4BDRqTM6dMONtyb98YqHSVp5M=GYnJ+k7EQRVNPvrQNA@mail.gmail.com>
	<20151207211156.GD26718@dastard>
	<CAHc6FU4X+7rPtR8LE9W4HZv2UGsZ-+1zHSq5X5sFgVQmL5mCqQ@mail.gmail.com>
	<20151208064410.GD19802@dastard>
Date: Tue, 15 Dec 2015 00:32:10 +0100
Message-ID: <CAHc6FU5Y91VYLpEbG5zFEwDs+CwWpafJMj4XMRKZgeaUY2m6zA@mail.gmail.com>
Subject: Re: [XFSTESTS 5/6] Add richacl tests
From: Andreas Gruenbacher <agruenba@redhat.com>
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
Cc: XFS Developers <xfs@oss.sgi.com>

On Tue, Dec 8, 2015 at 7:44 AM, Dave Chinner <david@fromorbit.com> wrote:
> So you have to mkfs the filesytem, then mount it, then you can run
> getfattr to check if richacls are supported. Yet mkfs can fail, the
> mount can fail, and neither of them are going to give you nice
> "richacls not supported" errors. See xfs/191, again.

Okay, if the richacl tests should run on a scratch filesystem, then we
can obviously test if a richacl filesystem can be created and mounted
and we won't have to test if the mounted filesystem supports richacls.
It then also makes sense to run all of the richacl tests at once, on
the same scratch file system, similar to xfs/191.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
