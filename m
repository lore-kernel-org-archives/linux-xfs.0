Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4729029DF8
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 14:49:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 228F08F8040
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 12:49:31 -0700 (PDT)
Received: from mail-ob0-f173.google.com (mail-ob0-f173.google.com
	[209.85.214.173]) by cuda.sgi.com with ESMTP id
	QGSWAOIFHbTTSI6l (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 05 May 2014 12:49:25 -0700 (PDT)
Received: by mail-ob0-f173.google.com with SMTP id wm4so5698738obc.4
	for <xfs@oss.sgi.com>; Mon, 05 May 2014 12:49:25 -0700 (PDT)
MIME-Version: 1.0
From: Andrey Korolyov <andrey@xdel.ru>
Date: Mon, 5 May 2014 23:49:05 +0400
Message-ID: <CABYiri9j=2ipPhvRtn1g=omEDpTz5VD8O0fPWrBGCm=UsgNavw@mail.gmail.com>
Subject: Fatigue for XFS
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
To: "ceph-users@lists.ceph.com" <ceph-users@lists.ceph.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hello,

We are currently exploring issue which can be related to Ceph itself
or to the XFS - any help is very appreciated.

First, the picture: relatively old cluster w/ two years uptime and ten
months after fs recreation on every OSD, one of daemons started to
flap approximately once per day for couple of weeks, with no external
reason (bandwidth/IOPS/host issues). It looks almost the same every
time - OSD suddenly stop serving requests for a short period, gets
kicked out by peers report, then returns in a couple of seconds. Of
course, small but sensitive amount of requests are delayed by 15-30
seconds twice, which is bad for us. The only thing which correlates
with this kick is a peak of I/O, not too large, even not consuming all
underlying disk utilization, but alone in the cluster and clearly
visible. Also there are at least two occasions *without* correlated
iowait peak.

I have two versions - we`re touching some sector on disk which is
about to be marked as dead but not displayed in SMART statistics or (I
believe so) some kind of XFS fatigue, which can be more likely in this
case, since near-bad sector should be touched more frequently and
related impact could leave traces in dmesg/SMART from my experience. I
would like to ask if anyone has a simular experience before or can
suggest to poke existing file system in some way. If no suggestion
appear, I`ll probably reformat disk and, if problem will remain after
refill, replace it, but I think less destructive actions can be done
before.

XFS is running on 3.10 with almost default create and mount options,
ceph version is the latest cuttlefish (this rack should be upgraded, I
know).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
