Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3CDE729DFB
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 09:59:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2AA4F8F8035
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 07:59:53 -0700 (PDT)
Received: from mail-lb0-f171.google.com (mail-lb0-f171.google.com
	[209.85.217.171]) by cuda.sgi.com with ESMTP id
	pUVrbBfgm3itP5mg (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 23 Aug 2013 07:59:51 -0700 (PDT)
Received: by mail-lb0-f171.google.com with SMTP id t13so555962lbd.2
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 07:59:50 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 23 Aug 2013 10:59:50 -0400
Message-ID: <CAGwuE-p8=UwpGUhgpqkWn4U4jU-KnfC3C19Kqqv7uYLJvubxgQ@mail.gmail.com>
Subject: Power loss and zero-length files
From: Robert Widmer <robertwidmer@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3433902616223815963=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3433902616223815963==
Content-Type: multipart/alternative; boundary=089e0160a24085971c04e49ea878

--089e0160a24085971c04e49ea878
Content-Type: text/plain; charset=ISO-8859-1

I had a script that updated several files on an XFS filesystem using "sed
-i", and someone decided to power cycle the box without a sync after
running the script, and found that all the files that were updated were now
zero-length.

Curious, I ran the following script to try and isolate the behavior:


#!/usr/bin/perl

my $dir = "/home/$ENV{USER}/XFSTest";
mkdir $dir;
chdir $dir;

my $filecount = 100;
my $tmpfile = 'file.tmp';

while (1) {
    for (my $i=0; $i<$filecount; $i++) {
my $filename = "file.$i";
open(OUT, ">", $tmpfile);
        print OUT "Time:".localtime."\n";
        close OUT;
rename $tmpfile, $filename;
    }
}


On the following release/kernels in a VM:

Fedora 16 w/kernel 3.1.0-7.fc16.x86_64
Fedora 16 w/kernel 3.6.11-4.fc16.x86_64
Fedora 19 w/kernel 3.10-7.200.fc19.x86_64
Ubuntu 13.04 w/kernel 3.8.0-19-generic


And after a power cycle, all the files are zero-length with no extents.

(CentOS 6.4 w/kernel 2.6.32-358.14.1.el6.centos.plus.x86_64 has the binary
NULLS)

Barriers are not disabled and drive cache:
[    2.145011] sd 2:0:0:0: [sda] Cache data unavailable
[    2.145013] sd 2:0:0:0: [sda] Assuming drive cache: write through


The closest thing I can find in the documentation is the XFS FAQ which
mentions "you are looking at an inode which was flushed out, but whose data
was not", which seems to indicate that the inode writes and data writes are
not done in order, but nothing explicitly documents this.

Is this expected behavior?

I've added a sync to the end of my script to try and ensure this does not
happen again, and losing some amount of data after a power loss is
expected, but it seems counter-intuitive that the inode/data writes are not
done in order and that rapid file changes can result in such a large number
of files being zero-length.

--089e0160a24085971c04e49ea878
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I had a script that updated several files on an XFS filesy=
stem using &quot;sed -i&quot;, and someone decided to power cycle the box w=
ithout a sync after running the script, and found that all the files that w=
ere updated were now zero-length.<div>
<br></div><div>Curious, I ran the following script to try and isolate the b=
ehavior:</div><div><br></div><div><div><br></div><div><div>#!/usr/bin/perl<=
/div><div><br></div><div>my $dir =3D &quot;/home/$ENV{USER}/XFSTest&quot;;<=
/div>
<div>mkdir $dir;</div><div>chdir $dir;</div><div><br></div><div>my $filecou=
nt =3D 100;</div><div>my $tmpfile =3D &#39;file.tmp&#39;;</div><div><br></d=
iv><div>while (1) {</div><div>=A0 =A0 for (my $i=3D0; $i&lt;$filecount; $i+=
+) {</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>my $filename =3D &q=
uot;file.$i&quot;;</div><div><span class=3D"" style=3D"white-space:pre">	</=
span>open(OUT, &quot;&gt;&quot;, $tmpfile);</div><div>=A0 =A0 =A0 =A0 print=
 OUT &quot;Time:&quot;.localtime.&quot;\n&quot;;</div>
<div>=A0 =A0 =A0 =A0 close OUT;</div><div><span class=3D"" style=3D"white-s=
pace:pre">	</span>rename $tmpfile, $filename;</div><div>=A0 =A0 }</div><div=
>}</div></div></div><div><br></div><div><br></div><div>On the following rel=
ease/kernels in a VM:</div>
<div><br></div><div>Fedora 16 w/kernel 3.1.0-7.fc16.x86_64</div><div>Fedora=
 16 w/kernel 3.6.11-4.fc16.x86_64</div><div>Fedora 19 w/kernel 3.10-7.200.f=
c19.x86_64</div><div>Ubuntu 13.04 w/kernel 3.8.0-19-generic</div><div><br>
</div><div><br></div><div>And after a power cycle, all the files are zero-l=
ength with no extents.</div><div><br></div><div>(CentOS 6.4 w/kernel 2.6.32=
-358.14.1.el6.centos.plus.x86_64 has the binary NULLS)</div><div><br></div>
<div>Barriers are not disabled and drive cache:</div><div>[ =A0 =A02.145011=
] sd 2:0:0:0: [sda] Cache data unavailable<br></div><div><div>[ =A0 =A02.14=
5013] sd 2:0:0:0: [sda] Assuming drive cache: write through</div></div><div=
><br>
</div><div><br></div><div>The closest thing I can find in the documentation=
 is the XFS FAQ which mentions &quot;<span style=3D"color:rgb(0,0,0);font-f=
amily:sans-serif;font-size:13px;line-height:19.046875px">you are looking at=
 an inode which was flushed out, but whose data was not</span>&quot;, which=
 seems to indicate that the inode writes and data writes are not done in or=
der, but nothing explicitly documents this.</div>
<div><br></div><div>Is this expected behavior?</div><div><br></div><div>I&#=
39;ve added a sync to the end of my script to try and ensure this does not =
happen again, and losing some amount of data after a power loss is expected=
, but it seems counter-intuitive that the inode/data writes are not done in=
 order and that rapid file changes can result in such a large number of fil=
es being zero-length.</div>
<div><br></div></div>

--089e0160a24085971c04e49ea878--


--===============3433902616223815963==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3433902616223815963==--
