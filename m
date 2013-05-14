Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 89C4C7F37
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 06:11:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 77BA730404E
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 04:11:07 -0700 (PDT)
Received: from mail-we0-f174.google.com (mail-we0-f174.google.com
	[74.125.82.174]) by cuda.sgi.com with ESMTP id Gv4mRwELIC3te1k6
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 14 May 2013 04:11:03 -0700 (PDT)
Received: by mail-we0-f174.google.com with SMTP id x53so329543wes.33
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 04:11:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130514004751.GQ32675@dastard>
References: <CAHBw7oSxcTYEEFzzhpZfH_EshyYXOsRBpf=S+bLEgCyQZkLFsA@mail.gmail.com>
	<20130514004751.GQ32675@dastard>
Date: Tue, 14 May 2013 13:11:02 +0200
Message-ID: <CAAxjCEy_LW7r4Sp+a5DRYcQBZ7cxGi+6bwYnzQ_cRWG74kCo3g@mail.gmail.com>
Subject: Re: xfs - high CPU usage when removing files
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
To: Linux fs XFS <xfs@oss.sgi.com>
Cc: Radoslaw Garbacz <radoslaw.garbacz@xtremedatainc.com>

>> I noticed a high CPU usage when removing files from XFS partition on Linux,
>> CentOS (always close to 100%).
>> Is it a known issue, or is it more likely to be attributed to my testing
>> methodology ('time' command)?
>
> If you are removing extremely fragmented files, then 100% CPU will
> be seen.  If you are removing tens of thousands of small files, then
> 100% CPU will be seen,
>
> IOWs, if there's enough work to be done, removing files will use all
> the available CPU. There's no problem with that.

Also, removing huge files which are completely in cache (recently
written, for example) will use considerable CPU time.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
