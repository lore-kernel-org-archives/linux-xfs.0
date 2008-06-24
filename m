Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Jun 2008 00:05:34 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5O75Qaw024191
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 00:05:27 -0700
Received: from web34508.mail.mud.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 92EB61BA6EC0
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 00:06:25 -0700 (PDT)
Received: from web34508.mail.mud.yahoo.com (web34508.mail.mud.yahoo.com [66.163.178.174]) by cuda.sgi.com with SMTP id CESiumIiCgkosGRV for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 00:06:25 -0700 (PDT)
Date: Tue, 24 Jun 2008 00:06:25 -0700 (PDT)
From: Mark <musicman529@yahoo.com>
Reply-To: MusicMan529@yahoo.com
Subject: tests re-run with 1 CPU
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <504423.88343.qm@web34508.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi all,

After booting with "nosmp", I re-ran my tests. XFS is still the winner, but the degree of its benefit from SMP is clear. Without SMP, the benchmark ran slightly better with 5 threads (229 MB/sec under "noop"), although the difference between "noop" and "deadline" was very slim. With SMP, the benchmark ran noticeably better with 20 threads (378 vs. 404 MB/sec).

JFS took a small hit from the lack of SMP on 5 threads. Under 20 threads of load, it still suffered badly, stuck between 41.5 and 45.5 MB/sec throughput.

ext3 is seems less predictable. It benefits well from SMP, but high I/O load degrades it.

Mounting with "sync" showed a 21% degradation for XFS, but it still out-performed both JFS and ext3, with or without SMP. That is, JFS and ext3 lost nearly all SMP benefit with the "sync" mount option.

On my system, XFS is the clear winner. I intend to convert my root partition to XFS with an external journal soon, probably tomorrow night.

I am also considering posting my test observations to my website, with a story submission to LXer.com.

Again, I have saved output from all dbench runs, if anyone wishes to review them.

-- 
Mark

"What better place to find oneself than
 on the streets of one's home village?"
      --Capt. Jean-Luc Picard, "Family"
