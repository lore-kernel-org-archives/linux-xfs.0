Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DBD327CA0
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2016 13:19:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8349D304032
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2016 11:19:52 -0700 (PDT)
Received: from mailuogwhop.emc.com (mailuogwhop.emc.com [168.159.213.141]) by
	cuda.sgi.com with ESMTP id XzUQhmZQmVlZQimF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 22 Jul 2016 11:19:49 -0700 (PDT)
Received: from maildlpprd05.lss.emc.com (maildlpprd05.lss.emc.com
	[10.253.24.37])
	by mailuogwprd04.lss.emc.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.0)
	with ESMTP id u6MIJlOP002280
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2016 14:19:47 -0400
Received: from mailusrhubprd53.lss.emc.com (mailusrhubprd53.lss.emc.com
	[10.106.48.18]) by maildlpprd05.lss.emc.com (RSA Interceptor)
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2016 14:18:32 -0400
Received: from MXHUB226.corp.emc.com (MXHUB226.corp.emc.com [10.253.68.96])
	by mailusrhubprd53.lss.emc.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.0)
	with ESMTP id u6MIJSwq017526
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2016 14:19:29 -0400
From: "Stockley, Jonathan" <jonathan.stockley@emc.com>
Subject: XFS Metadata corruption detected at xfs_attr3_leaf_write_verify
Date: Fri, 22 Jul 2016 18:19:25 +0000
Message-ID: <D3B7B1BB.74FB%jonathan.stockley@emc.com>
Content-Language: en-US
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4636423085344978467=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============4636423085344978467==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_D3B7B1BB74FBjonathanstockleyemccom_"

--_000_D3B7B1BB74FBjonathanstockleyemccom_
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

Hi,
I just ran into this error while testing an OpenStack SWIFT deployment.

[130004.933449] XFS (loop1): Metadata corruption detected at xfs_attr3_leaf=
_write_verify+0xe5/0x100 [xfs], block 0x468d0c8
[130004.936209] XFS (loop1): Unmount and run xfs_repair
[130004.937477] XFS (loop1): First 64 bytes of corrupted metadata buffer:
[130004.939113] ffff880111ddd000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00=
 00 00  ................
[130004.941242] ffff880111ddd010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00=
 00 00  ..... ..........
[130004.943327] ffff880111ddd020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00=
 00 00  ................
[130004.945393] ffff880111ddd030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00=
 00 00  ................
[130004.947565] XFS (loop1): xfs_do_force_shutdown(0x8) called from line 12=
49 of file /build/linux-lts-vivid-vt3Z1H/linux-lts-vivid-3.19.0/fs/xfs/xfs_=
buf.c.  Return address =3D 0xffffffffc0752c92
[130004.951692] XFS (loop1): Corruption of in-memory data detected.  Shutti=
ng down filesystem

Environment information:
Ubuntu Server 14.04 LTS
$ uname -a
Linux 3e2116e0-b4e8-4666-be70-5ddf9c9d9d2b 3.19.0-49-generic #55~14.04.1hf1=
533043v20160201b1-Ubuntu SMP Mon Feb 1 20:41:00 UT x86_64 x86_64 x86_64 GNU=
/Linux

I am able to reproduce the problem as follows:

  *   created a VM based SWIFT cluster
One HAProxy load balancing across two SWIFT Proxy vms accessing five SWIFT =
storage nodes, although it could probably be simplified to one proxy and 1 =
storage node.
  *   Using ssbench<https://github.com/swiftstack/ssbench> with the followi=
ng scenario file:
{
  "name": "file upload only=94,
  "sizes": [{
    "name": "files=94,
    "size_min": 100000,
    "size_max": 100000
  }],
  "initial_files": {
    "files": 1
  },
  "container_count":10,
  "operation_count": 10000,
  "crud_profile": [50, 50, 0, 0],
  "user_count": 50
}
  *   Run ssbench-master with following command line:
./ssbench-env/bin/ssbench-master run-scenario -f scenario1.json -A "http://=
aa.bb.cc.dd:8080/auth/v1.0" -U =93acct:user" -K key --workers 10 --delete-a=
fter 36000 -r 18000

Replace aa.bb.cc.dd with either IP of HAProxy or SWIFT Proxy. Replace acct:=
user with SWIFT account and username. Replace key with user=92s key (passwo=
rd). The test will run for 5 hours and objects will expire after 10 hours, =
but the test deletes all objects at the end of the run.

In my two test runs the XFS failure occurred around 9 hours after the test =
was started.

It looks like I can reproduce the problem, albeit over an extended period o=
f time.
What can I do to gather more info? Any debug options I can enable that migh=
t help?

Regards,
Jo Stockley.


--_000_D3B7B1BB74FBjonathanstockleyemccom_
Content-Type: text/html; charset="Windows-1252"
Content-ID: <3AC69A9BBBCAF041BE3808EBC570C030@mail.corp.emc.com>
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3DWindows-1=
252">
</head>
<body style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-lin=
e-break: after-white-space; color: rgb(0, 0, 0); font-size: 14px; font-fami=
ly: Calibri, sans-serif;">
<div>Hi,</div>
<div>I just ran into this error while testing an OpenStack SWIFT deployment=
.</div>
<div><br>
</div>
<div>
<div>[130004.933449] XFS (loop1): Metadata corruption detected at xfs_attr3=
_leaf_write_verify&#43;0xe5/0x100 [xfs], block 0x468d0c8</div>
<div>[130004.936209] XFS (loop1): Unmount and run xfs_repair</div>
<div>[130004.937477] XFS (loop1): First 64 bytes of corrupted metadata buff=
er:</div>
<div>[130004.939113] ffff880111ddd000: 00 00 00 00 00 00 00 00 fb ee 00 00 =
00 00 00 00 &nbsp;................</div>
<div>[130004.941242] ffff880111ddd010: 10 00 00 00 00 20 0f e0 00 00 00 00 =
00 00 00 00 &nbsp;..... ..........</div>
<div>[130004.943327] ffff880111ddd020: 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 &nbsp;................</div>
<div>[130004.945393] ffff880111ddd030: 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 &nbsp;................</div>
<div>[130004.947565] XFS (loop1): xfs_do_force_shutdown(0x8) called from li=
ne 1249 of file /build/linux-lts-vivid-vt3Z1H/linux-lts-vivid-3.19.0/fs/xfs=
/xfs_buf.c. &nbsp;Return address =3D 0xffffffffc0752c92</div>
<div>[130004.951692] XFS (loop1): Corruption of in-memory data detected. &n=
bsp;Shutting down filesystem</div>
</div>
<div><br>
</div>
<div>Environment information:</div>
<div>
<div>Ubuntu Server 14.04 LTS</div>
<div>$ uname -a</div>
<div>Linux 3e2116e0-b4e8-4666-be70-5ddf9c9d9d2b 3.19.0-49-generic #55~14.04=
.1hf1533043v20160201b1-Ubuntu SMP Mon Feb 1 20:41:00 UT x86_64 x86_64 x86_6=
4 GNU/Linux</div>
</div>
<div><br>
</div>
<div>I am able to reproduce the problem as follows:</div>
<ul>
<li>created a VM based SWIFT cluster<br>
One HAProxy load balancing across two SWIFT Proxy vms accessing five SWIFT =
storage nodes, although it could probably be simplified to one proxy and 1 =
storage node.</li><li>Using <a href=3D"https://github.com/swiftstack/ssbenc=
h">ssbench</a>&nbsp;with the following scenario file:<br>
{<br>
&nbsp; &quot;name&quot;: &quot;file upload only=94,<br>
&nbsp; &quot;sizes&quot;: [{<br>
&nbsp; &nbsp; &quot;name&quot;: &quot;files=94,<br>
&nbsp; &nbsp; &quot;size_min&quot;: 100000,<br>
&nbsp; &nbsp; &quot;size_max&quot;: 100000<br>
&nbsp; }],<br>
&nbsp; &quot;initial_files&quot;: {<br>
&nbsp; &nbsp; &quot;files&quot;: 1<br>
&nbsp; },<br>
&nbsp; &quot;container_count&quot;:10,<br>
&nbsp; &quot;operation_count&quot;: 10000,<br>
&nbsp; &quot;crud_profile&quot;: [50, 50, 0, 0],<br>
&nbsp; &quot;user_count&quot;: 50<br>
}</li><li>Run ssbench-master with following command line:<br>
./ssbench-env/bin/ssbench-master run-scenario -f scenario1.json -A &quot;ht=
tp://aa.bb.cc.dd:8080/auth/v1.0&quot; -U =93acct:user&quot; -K key --worker=
s 10 --delete-after 36000 -r 18000</li></ul>
<div><br>
</div>
<div>Replace aa.bb.cc.dd with either IP of HAProxy or SWIFT Proxy. Replace =
acct:user with SWIFT account and username. Replace key with user=92s key (p=
assword). The test will run for 5 hours and objects will expire after 10 ho=
urs, but the test deletes all objects
 at the end of the run.</div>
<div><br>
</div>
<div>In my two test runs the XFS failure occurred around 9 hours after the =
test was started.</div>
<div><br>
</div>
<div>It looks like I can reproduce the problem, albeit over an extended per=
iod of time.&nbsp;</div>
<div>What can I do to gather more info? Any debug options I can enable that=
 might help?</div>
<div><br>
</div>
<div>Regards,</div>
<div>Jo Stockley.</div>
<div><br>
</div>
</body>
</html>

--_000_D3B7B1BB74FBjonathanstockleyemccom_--


--===============4636423085344978467==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4636423085344978467==--
