Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2026F7CBE
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 12:24:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E2DA78F8033
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 10:24:20 -0700 (PDT)
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158]) by
	cuda.sgi.com with ESMTP id vjpdjBvVdHd5HDVn (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Apr 2013 10:24:20 -0700 (PDT)
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 26 Apr 2013 11:24:18 -0600
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id BD9323E4003F
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 11:24:00 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r3QHOBvN098612 for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 11:24:12 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r3QHOAMk001006
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 11:24:10 -0600
Received: from [9.41.106.170] (chandra-dt.austin.ibm.com [9.41.106.170])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	r3QHOAVO000950 for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 11:24:10 -0600
Subject: xfs module insert fails with "xfs: Unknown symbol
	exportfs_decode_fh (err 0)"
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 26 Apr 2013 12:24:09 -0500
Message-ID: <1366997050.4098.14.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: XFS mailing list <xfs@oss.sgi.com>

Hello,

When I tried to insert xfs module in my test machine it failed with 

	xfs: Unknown symbol exportfs_decode_fh (err 0).

Found out that I did not have CONFIG_EXPORTFS enabled in my kernel
config. 

All .*by_handle code in XFS is open coded. Wondering if they should be
under #ifdef CONFIG_EXPORTFS ?

I can create a patch, but wanted to find out if it is indeed needed :)

Regards,

Chandra




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
