Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C00C27CDC
	for <xfs@oss.sgi.com>; Sat,  9 Jul 2016 06:14:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 29F2AAC003
	for <xfs@oss.sgi.com>; Sat,  9 Jul 2016 04:14:45 -0700 (PDT)
Received: from mail-oi0-f51.google.com (mail-oi0-f51.google.com
	[209.85.218.51]) by cuda.sgi.com with ESMTP id 2azTtI5t1PVT8smh
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 09 Jul 2016 04:14:38 -0700 (PDT)
Received: by mail-oi0-f51.google.com with SMTP id r2so91484810oih.2
	for <xfs@oss.sgi.com>; Sat, 09 Jul 2016 04:14:38 -0700 (PDT)
MIME-Version: 1.0
From: Marcin Sura <mailing-lists@sura.pl>
Date: Sat, 9 Jul 2016 13:14:37 +0200
Message-ID: <CACNifpXnSMcm6EfSjqLFPXXfqv7XWd4Yu_=UhqTcdn6-o+49Yw@mail.gmail.com>
Subject: xfs + 100TB+ storage + lots of small files + NFS
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1817865374023151998=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1817865374023151998==
Content-Type: multipart/alternative; boundary=001a113db552567e540537320636

--001a113db552567e540537320636
Content-Type: text/plain; charset=UTF-8

Hi,

Friend of mine asked me about evaluation of XFS for their purposes.
Currently I don't have physical access to their system, but here are the
info I've got so far:

SAN:
- physical storage is from FSC array, thin provisioned raid 6 volume,
- volumes are 100TB+ in size
- there are SSD disks in the array, which potentially can be used for
journal
- storage is connected to the host via 10GbE iSCSI

Host:
- They are using CentOS 6.5, with stock kernel 2.6.32-*
- System uses all default values, no optimization has beed done
- OS installed on SSD
- Don't know exact details of CPU, but I assume some recent multicore CPU
- Don't know amount of RAM installed, I assume 32GB+

NFS:
- they are exporting filesystem via NFS to 10-20 clients (services), some
VMs, some bare metal
- clients are connected via 1GbE or 10GbE links

Workload:
- they are storing tens or hundreds of millions of small files
- files are not in single directory
- files are undek 1K, usually 200 - 500 bytes
- I assume, that some NFS clients constantly write files
- some NFS clients initiates massive reads, millions of random files
- those reads are on demand, but during peak hours there can be many of
such requests

So far they were using Ext4, after some basic test they observed 40%
improvement in application counters. But I'm afraid that those tests were
done in environment not even close to the production (not so big size of
filesystem, not so much files).

I want to ask you what would be best mkfs.xfs settings for such setup.

I assume, that they should use inode64 mount option for such large
filesystem with that amount of files, but I'm a bit worried about
compatibility with NFS (default shipped with CentOS 6.5). I think inode32
is totally out of scope here.

Any other hints for setting this stuff up?
Probably some recent OS/kernel would also help a lot, right?

Also, do you know any benchmark which can be used to simulate such
workload? I've googled a lot, but there is quite short list of
multi-threaded, small files oriented benchmarks. To be honest, I've found
only https://github.com/bengland2/smallfile to be close to what I need. Any
other alternatives?

BR
Marcin

--001a113db552567e540537320636
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>Friend of mine asked me about evalu=
ation of XFS for their purposes. Currently I don&#39;t have physical access=
 to their system, but here are the info I&#39;ve got so far:</div><div><br>=
</div><div>SAN:</div><div>- physical storage is from FSC array, thin provis=
ioned raid 6 volume,=C2=A0</div><div>- volumes are 100TB+ in size<br></div>=
<div>- there are SSD disks in the array, which potentially can be used for =
journal</div><div>- storage is connected to the host via 10GbE iSCSI</div><=
div><br></div><div>Host:</div><div>- They are using CentOS 6.5, with stock =
kernel 2.6.32-*</div><div>- System uses all default values, no optimization=
 has beed done</div><div>- OS installed on SSD</div><div>- Don&#39;t know e=
xact details of CPU, but I assume some recent multicore CPU</div><div>- Don=
&#39;t know amount of RAM installed, I assume 32GB+</div><div><br></div><di=
v>NFS:</div><div>- they are exporting filesystem via NFS to 10-20 clients (=
services), some VMs, some bare metal</div><div>- clients are connected via =
1GbE or 10GbE links</div><div><br></div><div>Workload:</div><div>- they are=
 storing=C2=A0tens or hundreds of millions of small files</div><div>- files=
 are not in single directory</div><div>- files are undek 1K, usually 200 - =
500 bytes</div><div>- I assume, that some NFS clients constantly write file=
s</div><div>- some NFS clients initiates massive reads, millions of random =
files</div><div>- those reads are on demand, but during peak hours there ca=
n be many of such requests</div><div><br></div><div>So far they were using =
Ext4, after some basic test they observed 40% improvement in application co=
unters. But I&#39;m afraid that those tests were done in environment not ev=
en close to the production (not so big size of filesystem, not so much file=
s).</div><div><br></div><div>I want to ask you what would be best mkfs.xfs =
settings for such setup.<br></div><div><br></div><div>I assume, that they s=
hould use inode64 mount option for such large filesystem with that amount o=
f files, but I&#39;m a bit worried about compatibility with NFS (default sh=
ipped with CentOS 6.5). I think inode32 is totally out of scope here.</div>=
<div><br></div><div>Any other hints for setting this stuff up?</div><div>Pr=
obably some recent OS/kernel would also help a lot, right?<br></div><div><b=
r></div><div>Also, do you know any benchmark which can be used to simulate =
such workload? I&#39;ve googled a lot, but there is quite short list of mul=
ti-threaded, small files oriented benchmarks. To be honest, I&#39;ve found =
only=C2=A0<a href=3D"https://github.com/bengland2/smallfile">https://github=
.com/bengland2/smallfile</a> to be close to what I need. Any other alternat=
ives?</div><div><br></div><div>BR</div><div>Marcin</div><div><br></div><div=
><br></div><div><br></div><div><br></div></div>

--001a113db552567e540537320636--


--===============1817865374023151998==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1817865374023151998==--
