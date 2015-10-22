Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 38B317F37
	for <xfs@oss.sgi.com>; Thu, 22 Oct 2015 13:23:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2B19C8F8033
	for <xfs@oss.sgi.com>; Thu, 22 Oct 2015 11:23:28 -0700 (PDT)
Received: from posta3.euchiamail.it (posta3.euchiamail.it [46.30.241.112]) by
	cuda.sgi.com with ESMTP id 64EFPfRYTYeFVA4H (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 22 Oct 2015 11:23:25 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by posta3.euchiamail.it (Postfix) with ESMTP id 41CA1234F2A
	for <xfs@oss.sgi.com>; Thu, 22 Oct 2015 20:23:24 +0200 (CEST)
Received: from posta3.euchiamail.it ([127.0.0.1])
	by localhost (sufferone.euchiamail.it [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id HoZyfPkU9Dn1 for <xfs@oss.sgi.com>;
	Thu, 22 Oct 2015 20:23:22 +0200 (CEST)
Received: from linux (2-227-160-98.ip186.fastwebnet.it [2.227.160.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by posta3.euchiamail.it (Postfix) with ESMTPSA id 4F8F122598E
	for <xfs@oss.sgi.com>; Thu, 22 Oct 2015 20:23:21 +0200 (CEST)
Date: Thu, 22 Oct 2015 20:23:24 +0200
From: "krautus@kr916.org" <krautus@kr916.org>
Subject: hdd + ssd
Message-ID: <20151022202324.5f00807f@linux>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

Hello I'm trying to understand why and how to add one or more SSD (as a cache drive / keeping xfs log)
to a traditional spinning xfs storage volume.
I mean: which data will go to the ssd ? Inodes and dentries will go to the ssd ?
Will the _read_ performance increase ?

In general I'm looking to increase (cache) the reading performance of folders with a lot of small files (emails),
for email servers.

Feel free to let me rtfm :)
I'd gladly study the documentation / articles / benchmarks but my google-fu isn't in best shape.

Thank you,
Mike
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
