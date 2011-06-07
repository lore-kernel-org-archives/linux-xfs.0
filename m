Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p573qqZW001949 for <xfs@oss.sgi.com>; Mon, 6 Jun 2011 22:52:53 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C428EF67ED5
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2011 20:52:49 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id KskKiXHFSCVFIaqx
	for <xfs@oss.sgi.com>; Mon, 06 Jun 2011 20:52:49 -0700 (PDT)
Received: by bwg12 with SMTP id 12so4317713bwg.26
	for <xfs@oss.sgi.com>; Mon, 06 Jun 2011 20:52:49 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 6 Jun 2011 22:52:48 -0500
Message-ID: <BANLkTi=40mmE+DCbLcSWBwNQtWpP=N=tXw@mail.gmail.com>
Subject: Defragging XFS File Systems
From: Kenneth Emerson <kenneth.emerson@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0212371922797608943=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0212371922797608943==
Content-Type: multipart/alternative; boundary=001636c599114ce14a04a5172759

--001636c599114ce14a04a5172759
Content-Type: text/plain; charset=ISO-8859-1

I hadn't given much thought to fragmentation of my TV recordings volume
(XFS) until reading through some MythTV-users threads recently that
mentioned how fragmented an XFS file system could become.  After running
xfs_db, I found out that my fs appeared to be quite bad:

$ sudo xfs_db -c frag -r /dev/mapper/appl_vg-appl_lv
 actual 1138668, ideal 11023, fragmentation factor 99.03%

I then ran xfs_fsr with all defaults (ran for two hours) and then re-ran
xfs_db and got the following results:

$ sudo xfs_db -c frag -r /dev/mapper/appl_vg-appl_lv
invalid numrecs (27111) in bmapbtd block
invalid numrecs (4716) in bmapbtd block
invalid numrecs (58978) in bmapbtd block
actual 1034793, ideal 11024, fragmentation factor 98.93%

The fragmentation level was reduced, but I was concerned about the error
messages.  Before I go any further, am I corrupting my file system with the
defragging or are these "invalid numrecs" messages unimportant?

Google didn't offer much help.

Regards,

Ken E.

--001636c599114ce14a04a5172759
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I hadn&#39;t given much thought to fragmentation of my TV recordings volume=
=20
(XFS) until reading through some MythTV-users threads recently that mention=
ed=20
how fragmented an XFS file system could become. =A0After running xfs_db, I
 found out that my fs appeared to be quite bad:<div>
<br></div><div><div>$ sudo xfs_db -c frag -r /dev/mapper/appl_vg-appl_lv</d=
iv><div>=A0actual 1138668, ideal 11023, fragmentation factor 99.03%</div></=
div><div><br></div><div>I then ran xfs_fsr with all defaults (ran for two h=
ours) and then re-ran xfs_db and got the following results:</div>



<div><br></div><div><div>$ sudo xfs_db -c frag -r /dev/mapper/appl_vg-appl_=
lv</div><div>invalid numrecs (27111) in bmapbtd block</div><div>invalid num=
recs (4716) in bmapbtd block</div><div>invalid numrecs (58978) in bmapbtd b=
lock</div>



<div>actual 1034793, ideal 11024, fragmentation factor 98.93%</div></div><d=
iv><br></div><div>The
 fragmentation level was reduced, but I was concerned about the error=20
messages. =A0Before I go any further, am I corrupting my file system with=
=20
the defragging or are these &quot;invalid numrecs&quot; messages unimportan=
t?</div>
<div><br></div><div>Google didn&#39;t offer much help.</div><div><br></div>=
<div>Regards,</div><div><br></div><div>Ken E.</div>

--001636c599114ce14a04a5172759--


--===============0212371922797608943==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0212371922797608943==--
