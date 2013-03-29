Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 022AB7F8B
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 22:30:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E439A8F8033
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 20:30:04 -0700 (PDT)
Received: from mail-lb0-f178.google.com (mail-lb0-f178.google.com
	[209.85.217.178]) by cuda.sgi.com with ESMTP id
	oImBKMeyjRs3wCSy (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Mar 2013 20:30:03 -0700 (PDT)
Received: by mail-lb0-f178.google.com with SMTP id q13so26145lbi.23
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 20:30:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5154E6AC.9020402@hardwarefreak.com>
References: <CAJoqCq9WhFi8yZnTjh_dJmOte4TWpKg3qsQLpVsZ45M8XoWiaA@mail.gmail.com>
	<51549F09.1090109@hardwarefreak.com>
	<20130328214550.GA3771@pirx.askja.de>
	<5154E6AC.9020402@hardwarefreak.com>
Date: Thu, 28 Mar 2013 23:30:01 -0400
Message-ID: <CAJoqCq_afu4d++fgkGGMDC55pcz62V3qyai906ihQ2d=eiyhhQ@mail.gmail.com>
Subject: Re: Help with XFS in VMs on VMFS
From: Jan Perci <jperci@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1473362040796897983=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1473362040796897983==
Content-Type: multipart/alternative; boundary=e0cb4efe33dee2e6de04d907e285

--e0cb4efe33dee2e6de04d907e285
Content-Type: text/plain; charset=ISO-8859-1

Thank you for your responses.  Since this list is for XFS, I do not wish to
go off topic too far into VM's.  But I will provide more context.

A key factor is the need for >2TB file systems that can be snapshot and
reverted quickly.  We have other FC arrays attached to compute nodes
without this requirement, and they have XFS directly on the FC logical
volumes made accessible to native nodes and VM nodes via RDM.

Our FC arrays do not have native snapshot features, so we must use a
software layer whether that is Linux LVM, ESXi, or something else.  And
because of our unique usage patterns and constraints, we have settled on
VMware over other virtualization technologies.  We are using ESXi (free
version) but can upgrade to ESX if necessary.  However, the upgrade
wouldn't fix the 2TB snapshot limit.

We are certainly not in the true HPC realm, but we do have about 20
physical compute nodes that do both random and sequential I/O.  An example
query might identify a 10-500GB data set comprised of 100-500KB files.
 Some work sets are processor bound with disk I/O accounting for less than
5%.  However, others are spending about 50% on disk I/O, so improving
performance would be helpful - again in the context of the snapshot
requirement.

Point well understood about the risks of striping multiple 2TB VMDK files
together.  But because of the constraints, it's either 2TB VMDK's or 2TB
RDM's in virtual compatibility mode, and they both seem about equally
risky.  Do you have better suggestions?

Back to XFS, in this context, is there any benefit in tuning some
parameters to get better performance, or will it all just be overshadowed
by poor performance of the VMDKs that tuning isn't worthwhile?

Jan.


On Thu, Mar 28, 2013 at 8:56 PM, Stan Hoeppner <stan@hardwarefreak.com>wrote:

> On 3/28/2013 4:45 PM, Ralf Gross wrote:
> > Stan Hoeppner schrieb:
>
> > Snapshots are possible with RDM in virtual compatibily mode, not
> > physical mode (> 2 TB).
>
> So 2TB is the kicker here.  I haven't used ESX since 3.x, and none of
> our RDMs back then were close to 2TB.  IIRC our largest was 500GB.
>
> >> VMFS volumes are not intended for high performance IO.  Unless things
> >> have changed recently, VMware has always recommended housing only OS
> >> images and the like in VMDKs, not user data.  They've always recommended
> >> using RDMs for everything else.  IIRC VMDKs have a huge block (sector)
> >> size, something like 1MB.  That's going to make XFS alignment difficult,
> >> if not impossible.
> >
> > I can't remember that I've every found this recommendation on a vmware
> > page.
> >
> > http://blogs.vmware.com/vsphere/2013/01/vsphere-5-1-vmdk-versus-rdm.html
>
> If you drill down through that you find this:
> http://www.vmware.com/files/pdf/performance_char_vmfs_rdm.pdf
>
> RDMs have better large sequential performance, and lower CPU burn than
> VMDKs.  The OP mentioned "compute node" in his post, which suggests an
> HPC application workload, which suggests large sequential IO.
>
> Also note that VMware is Microsoft centric so they always run their
> tests using an MS Server guest.  Also note they always test with tiny
> volumes, in this case 20GB.  NTFS isn't going to have any trouble at
> this size, but at say 20TB it probably will and these published results
> would likely be quite different at that scale.  XFS performance
> characteristics on a 2TB or 20TB or ?? TB volume will likely be
> substantially different than NTFS.  Their tests show 5-8% lower CPU burn
> for RDM vs VMDK.  Not a huge difference, but again they're testing only
> 20GB.
>
> >> I cannot stress emphatically enough that you should not stitch 2TB VMDKs
> >> together and use them in the manner you described.  This is a recipe for
> >> disaster.  Find another solution.
> >
> > I'm seeing more and more requests for VMs with large disks lately in my
> > env. Right now the max. is ~2 TB. I'm also thinking about where to go,
> >  > 2 TB ist only possible with pRDMs which can't be snapshotted. You
> > have to use the snapshot features of your storage array.
>
> And more and more folks are using midrange FC/iSCSI arrays that don't
> have snapshot features, others are using DAS with RAID HBAs, in both
> cases forcing them to rely on ESX snapshots.  Sounds like VMware needs
> to bump this artificial 2TB limit quite a bit higher.
>
> --
> Stan
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

--e0cb4efe33dee2e6de04d907e285
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Thank you for your responses. =A0Since this list is for XFS, I do not wish =
to go off topic too far into VM&#39;s. =A0But I will provide more context.<=
div><br></div><div>A key factor is the need for &gt;2TB file systems that c=
an be snapshot and reverted quickly. =A0We have other FC arrays attached to=
 compute nodes without this requirement, and they have XFS directly on the =
FC logical volumes made accessible to native nodes and VM nodes via RDM.</d=
iv>
<div><br></div><div>Our FC arrays do not have native snapshot features, so =
we must use a software layer whether that is Linux LVM, ESXi, or something =
else. =A0And because of our unique usage patterns and constraints, we have =
settled on VMware over other virtualization technologies. =A0We are using E=
SXi (free version) but can upgrade to ESX if necessary. =A0However, the upg=
rade wouldn&#39;t fix the 2TB snapshot limit.</div>
<div><br></div><div>We are certainly not in the true HPC realm, but we do h=
ave about 20 physical compute nodes that do both random and sequential I/O.=
 =A0An example query might identify a 10-500GB data set comprised of 100-50=
0KB files. =A0Some work sets are processor bound with disk I/O accounting f=
or less than 5%. =A0However, others are spending about 50% on disk I/O, so =
improving performance would be helpful - again in the context of the snapsh=
ot requirement.</div>
<div><br></div><div>Point well understood about the risks of striping multi=
ple 2TB VMDK files together. =A0But because of the constraints, it&#39;s ei=
ther 2TB VMDK&#39;s or 2TB RDM&#39;s in virtual compatibility mode, and the=
y both seem about equally risky. =A0Do you have better suggestions?</div>
<div><br></div><div>Back to XFS, in this context, is there any benefit in t=
uning some parameters to get better performance, or will it all just be ove=
rshadowed by poor performance of the VMDKs that tuning isn&#39;t worthwhile=
?</div>
<div><br></div><div>Jan.</div><div><br></div><div><br></div><div><div class=
=3D"gmail_quote">On Thu, Mar 28, 2013 at 8:56 PM, Stan Hoeppner <span dir=
=3D"ltr">&lt;<a href=3D"mailto:stan@hardwarefreak.com" target=3D"_blank">st=
an@hardwarefreak.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">On 3/28/2013 4:45 PM, Ralf Gross wrote:<br>
&gt; Stan Hoeppner schrieb:<br>
<div class=3D"im"><br>
&gt; Snapshots are possible with RDM in virtual compatibily mode, not<br>
&gt; physical mode (&gt; 2 TB).<br>
<br>
</div>So 2TB is the kicker here. =A0I haven&#39;t used ESX since 3.x, and n=
one of<br>
our RDMs back then were close to 2TB. =A0IIRC our largest was 500GB.<br>
<div class=3D"im"><br>
&gt;&gt; VMFS volumes are not intended for high performance IO. =A0Unless t=
hings<br>
&gt;&gt; have changed recently, VMware has always recommended housing only =
OS<br>
&gt;&gt; images and the like in VMDKs, not user data. =A0They&#39;ve always=
 recommended<br>
&gt;&gt; using RDMs for everything else. =A0IIRC VMDKs have a huge block (s=
ector)<br>
&gt;&gt; size, something like 1MB. =A0That&#39;s going to make XFS alignmen=
t difficult,<br>
&gt;&gt; if not impossible.<br>
&gt;<br>
&gt; I can&#39;t remember that I&#39;ve every found this recommendation on =
a vmware<br>
&gt; page.<br>
&gt;<br>
&gt; <a href=3D"http://blogs.vmware.com/vsphere/2013/01/vsphere-5-1-vmdk-ve=
rsus-rdm.html" target=3D"_blank">http://blogs.vmware.com/vsphere/2013/01/vs=
phere-5-1-vmdk-versus-rdm.html</a><br>
<br>
</div>If you drill down through that you find this:<br>
<a href=3D"http://www.vmware.com/files/pdf/performance_char_vmfs_rdm.pdf" t=
arget=3D"_blank">http://www.vmware.com/files/pdf/performance_char_vmfs_rdm.=
pdf</a><br>
<br>
RDMs have better large sequential performance, and lower CPU burn than<br>
VMDKs. =A0The OP mentioned &quot;compute node&quot; in his post, which sugg=
ests an<br>
HPC application workload, which suggests large sequential IO.<br>
<br>
Also note that VMware is Microsoft centric so they always run their<br>
tests using an MS Server guest. =A0Also note they always test with tiny<br>
volumes, in this case 20GB. =A0NTFS isn&#39;t going to have any trouble at<=
br>
this size, but at say 20TB it probably will and these published results<br>
would likely be quite different at that scale. =A0XFS performance<br>
characteristics on a 2TB or 20TB or ?? TB volume will likely be<br>
substantially different than NTFS. =A0Their tests show 5-8% lower CPU burn<=
br>
for RDM vs VMDK. =A0Not a huge difference, but again they&#39;re testing on=
ly<br>
20GB.<br>
<div class=3D"im"><br>
&gt;&gt; I cannot stress emphatically enough that you should not stitch 2TB=
 VMDKs<br>
&gt;&gt; together and use them in the manner you described. =A0This is a re=
cipe for<br>
&gt;&gt; disaster. =A0Find another solution.<br>
&gt;<br>
&gt; I&#39;m seeing more and more requests for VMs with large disks lately =
in my<br>
&gt; env. Right now the max. is ~2 TB. I&#39;m also thinking about where to=
 go,<br>
&gt; =A0&gt; 2 TB ist only possible with pRDMs which can&#39;t be snapshott=
ed. You<br>
&gt; have to use the snapshot features of your storage array.<br>
<br>
</div>And more and more folks are using midrange FC/iSCSI arrays that don&#=
39;t<br>
have snapshot features, others are using DAS with RAID HBAs, in both<br>
cases forcing them to rely on ESX snapshots. =A0Sounds like VMware needs<br=
>
to bump this artificial 2TB limit quite a bit higher.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
Stan<br>
</font></span><div class=3D"HOEnZb"><div class=3D"h5"><br>
_______________________________________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">http:=
//oss.sgi.com/mailman/listinfo/xfs</a><br>
</div></div></blockquote></div><br></div>

--e0cb4efe33dee2e6de04d907e285--


--===============1473362040796897983==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1473362040796897983==--
