Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n32F5ub6148752 for <xfs@oss.sgi.com>; Thu, 2 Apr 2009 10:06:06 -0500
Received: from mail-fx0-f177.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C03CE1C8F1DF
	for <xfs@oss.sgi.com>; Thu,  2 Apr 2009 08:05:11 -0700 (PDT)
Received: from mail-fx0-f177.google.com (mail-fx0-f177.google.com
	[209.85.220.177]) by cuda.sgi.com with ESMTP id
	RiXhZPx18PYg9fRc for <xfs@oss.sgi.com>;
	Thu, 02 Apr 2009 08:05:11 -0700 (PDT)
Received: by fxm25 with SMTP id 25so562238fxm.20
	for <xfs@oss.sgi.com>; Thu, 02 Apr 2009 08:05:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49D4CBA0.40408@sgi.com>
References: <49D4CBA0.40408@sgi.com>
Date: Thu, 2 Apr 2009 20:35:10 +0530
Message-ID: <bb33bcf20904020805i167ff3b9ld225444fa00fad4d@mail.gmail.com>
Subject: Re: [ANNOUNCE] Filesystem test tools open-sourced by SGI
From: Subrata Modak <tosubrata@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7626868529600633870=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Greg Banks <gnb@fmeh.org>
Cc: ltp-list <ltp-list@lists.sf.net>, NFS list <linux-nfs@vger.kernel.org>, XFS OSS list <xfs@oss.sgi.com>, Nate Straz <nate@refried.org>, Linux Filesystem list <linux-fsdevel@vger.kernel.org>, Subrata Modak <subrata@linux.vnet.ibm.com>

--===============7626868529600633870==
Content-Type: multipart/alternative; boundary=0016e652f9f4285b3a046693c233

--0016e652f9f4285b3a046693c233
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Greg,

On Thu, Apr 2, 2009 at 7:58 PM, Greg Banks <gnb@sgi.com> wrote:

> G'day,
>
> SGI is releasing to the Open Source community a number of internal
> SGI testing and debugging tools for NFS.  Some of these tools are
> also applicable to filesystems in general.
>
> These tools are being released under the GNU General Public License
> (GPL) version 2, in the hope that the Linux filesystem development
> community may find them useful.  They are provided as-is, without any
> support.  Please do not contact SGI for support on any of these tools.
>
> Some of these tools are unfinished.  Others rely on build
> infrastructure in internal SGI trees which cannot be released.
> The tools are provided as tarball snapshots of internal SGI source
> control trees; for a number of technical reasons it is not possible
> to provide access to those trees or to create external repositories.
>
> The tools are available for download now at
>
> http://oss.sgi.com/projects/nfs/testtools/


Since, these are released under GPL, i hope integrating them inside LTP (
http://ltp.sf.net) after proper analysis will not be an issue. Since, no
support for these tests will be available from SGI, i am hoping that having
them inside LTP will be beneficial and help these tests to evolve in the
long run.

Regards--
Subrata
(Happens to maintain LTP :-))


>
> A brief description of each tool follows.
>
> Checkstream
> -----------
>
> Simple data corruption testing utilities based on the concept of
> generating a stream of small self-contained records which can be
> decoded in a way which makes certain common data corruption modes
> automatically diagnosable.  Has been useful for automated testing of
> NFS, XFS, and CXFS in SGI.
>
> Weber
> -----
>
> Test load generator for NFS.  Uses multiple threads, multiple sockets
> and multiple IP addresses to simulate loads from many machines,
> thus enabling testing of NFS server setups with larger client counts
> than can be tested with physical infrastructure (or Virtual Machine
> clients).  Has been useful in automated NFS testing and as a pinpoint
> NFS load generator tool for performance development.
>
> NFS PMDA
> --------
>
> PCP Data Agent for extended NFS server statistics.  Exports to PCP
> the new statistics (measuring per-client and per-server performance)
> which are provided by SGI's EnhancedNFS kernel patches.
>
> Samba PMDA
> ----------
>
> PCP Data Agent for extended Samba server statistics.  Exports to
> PCP the additional statistics (measuring per-client and per-server
> performance) which are provided by SGI's patches to Samba.
>
> Ddnfs
> -----
>
> Filesystem load generation program designed to simulate the IO
> load placed on an XFS filesystem by the NFS server in response
> to certain NFS loads.  Intended for use in XFS automated testing,
> to test performance and correctness of certain XFS functionality
> not otherwise exercised by the existing XFS test suite, but never
> integrated into XFSQA.
>
> Pmapload
> --------
>
> Test suite for the portmap and rpcbind programs (which are
> NFS infrastructure components based on code open-sourced by Sun
> Microsystems and used by every Unix and Linux).  Developed by SGI to
> test changes imported into those programs from newer Sun source code
> during the NFS on IPv6 work for Irix several years ago.
>
> RPC Exerciser
> -------------
>
> Test suite for the userspace RPC infrastructure libraries, (which
> are NFS infrastructure components based on code open-sourced by Sun
> Microsystems and used by every Unix and Linux).  Developed by SGI to
> test changes imported into those libraries from newer Sun source code
> during the NFS on IPv6 work for Irix several years ago.
>
> Testfs
> ------
>
> Linux kernel module which provides an in-memory filesystem which
> forgets all data written to it.  Also can be configured to simulate
> timing behaviour on reads and writes.  This is useful for NFS
> performance testing without a fast disk subsystem.
>
> StReplay
> --------
>
> Program which reads the system call trace of another program (obtained
> using the widely available strace utility) and replays the IO pattern.
> This was intended to be used for automated NFS and XFS testing and
> for NFS and XFS problem diagnosis, but was never completed as the
> author transferred to another team.  Could be the basis for a very
> useful filesystem test tool.
>
>
> --
> Greg Banks, P.Engineer, SGI Australian Software Group.
> the brightly coloured sporks of revolution.
> I don't speak for SGI.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Regards & Thanks--
Subrata

--0016e652f9f4285b3a046693c233
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Greg,<br><br><div class=3D"gmail_quote">On Thu, Apr 2, 2009 at 7:58 PM, =
Greg Banks <span dir=3D"ltr">&lt;<a href=3D"mailto:gnb@sgi.com">gnb@sgi.com=
</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"border=
-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-lef=
t: 1ex;">
G&#39;day,<br>
<br>
SGI is releasing to the Open Source community a number of internal<br>
SGI testing and debugging tools for NFS. =C2=A0Some of these tools are<br>
also applicable to filesystems in general.<br>
<br>
These tools are being released under the GNU General Public License<br>
(GPL) version 2, in the hope that the Linux filesystem development<br>
community may find them useful. =C2=A0They are provided as-is, without any<=
br>
support. =C2=A0Please do not contact SGI for support on any of these tools.=
<br>
<br>
Some of these tools are unfinished. =C2=A0Others rely on build<br>
infrastructure in internal SGI trees which cannot be released.<br>
The tools are provided as tarball snapshots of internal SGI source<br>
control trees; for a number of technical reasons it is not possible<br>
to provide access to those trees or to create external repositories.<br>
<br>
The tools are available for download now at<br>
<br>
<a href=3D"http://oss.sgi.com/projects/nfs/testtools/" target=3D"_blank">ht=
tp://oss.sgi.com/projects/nfs/testtools/</a></blockquote><div><br>Since, th=
ese are released under GPL, i hope integrating them inside LTP (<a href=3D"=
http://ltp.sf.net">http://ltp.sf.net</a>) after proper analysis will not be=
 an issue. Since, no support for these tests will be available from SGI, i =
am hoping that having them inside LTP will be beneficial and help these tes=
ts to evolve in the long run.<br>
<br>Regards--<br>Subrata<br>(Happens to maintain LTP :-))<br><br></div><blo=
ckquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, 204,=
 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><br>
<br>
A brief description of each tool follows.<br>
<br>
Checkstream<br>
-----------<br>
<br>
Simple data corruption testing utilities based on the concept of<br>
generating a stream of small self-contained records which can be<br>
decoded in a way which makes certain common data corruption modes<br>
automatically diagnosable. =C2=A0Has been useful for automated testing of<b=
r>
NFS, XFS, and CXFS in SGI.<br>
<br>
Weber<br>
-----<br>
<br>
Test load generator for NFS. =C2=A0Uses multiple threads, multiple sockets<=
br>
and multiple IP addresses to simulate loads from many machines,<br>
thus enabling testing of NFS server setups with larger client counts<br>
than can be tested with physical infrastructure (or Virtual Machine<br>
clients). =C2=A0Has been useful in automated NFS testing and as a pinpoint<=
br>
NFS load generator tool for performance development.<br>
<br>
NFS PMDA<br>
--------<br>
<br>
PCP Data Agent for extended NFS server statistics. =C2=A0Exports to PCP<br>
the new statistics (measuring per-client and per-server performance)<br>
which are provided by SGI&#39;s EnhancedNFS kernel patches.<br>
<br>
Samba PMDA<br>
----------<br>
<br>
PCP Data Agent for extended Samba server statistics. =C2=A0Exports to<br>
PCP the additional statistics (measuring per-client and per-server<br>
performance) which are provided by SGI&#39;s patches to Samba.<br>
<br>
Ddnfs<br>
-----<br>
<br>
Filesystem load generation program designed to simulate the IO<br>
load placed on an XFS filesystem by the NFS server in response<br>
to certain NFS loads. =C2=A0Intended for use in XFS automated testing,<br>
to test performance and correctness of certain XFS functionality<br>
not otherwise exercised by the existing XFS test suite, but never<br>
integrated into XFSQA.<br>
<br>
Pmapload<br>
--------<br>
<br>
Test suite for the portmap and rpcbind programs (which are<br>
NFS infrastructure components based on code open-sourced by Sun<br>
Microsystems and used by every Unix and Linux). =C2=A0Developed by SGI to<b=
r>
test changes imported into those programs from newer Sun source code<br>
during the NFS on IPv6 work for Irix several years ago.<br>
<br>
RPC Exerciser<br>
-------------<br>
<br>
Test suite for the userspace RPC infrastructure libraries, (which<br>
are NFS infrastructure components based on code open-sourced by Sun<br>
Microsystems and used by every Unix and Linux). =C2=A0Developed by SGI to<b=
r>
test changes imported into those libraries from newer Sun source code<br>
during the NFS on IPv6 work for Irix several years ago.<br>
<br>
Testfs<br>
------<br>
<br>
Linux kernel module which provides an in-memory filesystem which<br>
forgets all data written to it. =C2=A0Also can be configured to simulate<br=
>
timing behaviour on reads and writes. =C2=A0This is useful for NFS<br>
performance testing without a fast disk subsystem.<br>
<br>
StReplay<br>
--------<br>
<br>
Program which reads the system call trace of another program (obtained<br>
using the widely available strace utility) and replays the IO pattern.<br>
This was intended to be used for automated NFS and XFS testing and<br>
for NFS and XFS problem diagnosis, but was never completed as the<br>
author transferred to another team. =C2=A0Could be the basis for a very<br>
useful filesystem test tool.<br>
<br>
<br>
--<br>
Greg Banks, P.Engineer, SGI Australian Software Group.<br>
the brightly coloured sporks of revolution.<br>
I don&#39;t speak for SGI.<br>
<font color=3D"#888888"><br>
--<br>
To unsubscribe from this list: send the line &quot;unsubscribe linux-kernel=
&quot; in<br>
the body of a message to <a href=3D"mailto:majordomo@vger.kernel.org">major=
domo@vger.kernel.org</a><br>
More majordomo info at =C2=A0<a href=3D"http://vger.kernel.org/majordomo-in=
fo.html" target=3D"_blank">http://vger.kernel.org/majordomo-info.html</a><b=
r>
Please read the FAQ at =C2=A0<a href=3D"http://www.tux.org/lkml/" target=3D=
"_blank">http://www.tux.org/lkml/</a><br>
</font></blockquote></div><br><br clear=3D"all"><br>-- <br>Regards &amp; Th=
anks--<br>Subrata<br>

--0016e652f9f4285b3a046693c233--


--===============7626868529600633870==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7626868529600633870==--
