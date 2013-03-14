Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B19B77F89
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 13:07:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8EE8A8F8049
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 11:07:27 -0700 (PDT)
Received: from mail-wi0-f170.google.com (mail-wi0-f170.google.com
	[209.85.212.170]) by cuda.sgi.com with ESMTP id
	6LDEtr3uga6m7DUK (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 Mar 2013 11:07:26 -0700 (PDT)
Received: by mail-wi0-f170.google.com with SMTP id hm11so4481824wib.5
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 11:07:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5141E5CF.10101@binghamton.edu>
References: <5140C147.7070205@binghamton.edu>
	<514113C6.9090602@hardwarefreak.com>
	<514153ED.3000405@binghamton.edu>
	<5141C1FC.4060209@hardwarefreak.com>
	<5141C8C1.2080903@hardwarefreak.com>
	<5141E5CF.10101@binghamton.edu>
Date: Thu, 14 Mar 2013 19:07:25 +0100
Message-ID: <CAAxjCEyfSE11SQZQZ8qk01DvZc-9vth4UyvwcdV9TPExcoHPtQ@mail.gmail.com>
Subject: Re: xfs_fsr, sunit, and swidth
From: Stefan Ring <stefanrin@gmail.com>
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
To: Dave Hall <kdhall@binghamton.edu>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

> Lastly, I will mention that I see almost 0% wa when watching top.

I notice that XFS in general will report less % wa than ext4, although
it exercises the disks a bit more when traversing a large directory
tree, for example. But with 64 cores, you will see at most 1.5% in top
anyway, if one process is doing nothing but waiting on the disk.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
