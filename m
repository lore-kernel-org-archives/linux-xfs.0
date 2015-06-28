Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BED4329DFB
	for <xfs@oss.sgi.com>; Sun, 28 Jun 2015 13:45:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AE89B8F8033
	for <xfs@oss.sgi.com>; Sun, 28 Jun 2015 11:45:02 -0700 (PDT)
Received: from mail-wg0-f43.google.com (mail-wg0-f43.google.com
	[74.125.82.43]) by cuda.sgi.com with ESMTP id SMvnWtJ1MTAuevOH
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 28 Jun 2015 11:45:01 -0700 (PDT)
Received: by wgqq4 with SMTP id q4so124677998wgq.1
	for <xfs@oss.sgi.com>; Sun, 28 Jun 2015 11:45:00 -0700 (PDT)
MIME-Version: 1.0
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Sun, 28 Jun 2015 21:44:20 +0300
Message-ID: <CAGqmi75jFGjWvFFT5HTwyO1tv4-d4J=aVJ83L2zqNyWMDOz1RQ@mail.gmail.com>
Subject: Q: xfs_db: invalid numrecs (*) in bmapbtd block
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

Good time of day list,
i do regular check fragmentation on my servers and xfs_db show strange erros:

# xfs_db -c frag -r /dev/sdc1
invalid numrecs (51914) in bmapbtd block
invalid numrecs (2827) in bmapbtd block
invalid numrecs (65419) in bmapbtd block
invalid numrecs (9047) in bmapbtd block
invalid numrecs (26469) in bmapbtd block
invalid numrecs (17784) in bmapbtd block
invalid numrecs (17784) in bmapbtd block
invalid numrecs (13240) in bmapbtd block
invalid numrecs (60489) in bmapbtd block
invalid numrecs (23478) in bmapbtd block
invalid numrecs (24767) in bmapbtd block
invalid numrecs (33180) in bmapbtd block
invalid numrecs (25257) in bmapbtd block
invalid numrecs (20648) in bmapbtd block
invalid numrecs (23136) in bmapbtd block
invalid numrecs (25282) in bmapbtd block
invalid numrecs (24743) in bmapbtd block
invalid numrecs (56229) in bmapbtd block
invalid numrecs (42902) in bmapbtd block
invalid numrecs (12316) in bmapbtd block
invalid numrecs (1588) in bmapbtd block
invalid numrecs (7065) in bmapbtd block
invalid numrecs (65280) in bmapbtd block
invalid numrecs (3378) in bmapbtd block
invalid numrecs (61507) in bmapbtd block
invalid numrecs (56024) in bmapbtd block
invalid numrecs (25390) in bmapbtd block
invalid numrecs (25942) in bmapbtd block
invalid numrecs (12134) in bmapbtd block
invalid numrecs (26991) in bmapbtd block
invalid numrecs (43528) in bmapbtd block
invalid numrecs (10265) in bmapbtd block
invalid numrecs (44698) in bmapbtd block
invalid numrecs (15937) in bmapbtd block
actual 504454, ideal 126776, fragmentation factor 74.87%

I already google error, and can't find any answer or explanation what
is it, how danger it or something like.
It's a production servers with several TB of data and this output make
me unhappy. =.=
And i can't do fast stop it, unmount and check file system.
(this is nfs server for virtual machines images)

Thanks for any help, anyway.
-- 
Have a nice day,
Timofey.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
